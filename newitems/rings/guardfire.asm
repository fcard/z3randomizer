; Guard/Fire Rings

; Called after a SBC
; Optimized for different values
macro BranchIfGreaterOrEqual(minimum, address)
    if <minimum> == 0
        BNE <address>
    elseif <minimum> == 1
        BEQ ?less
        BPL <address>
        ?less:
    else
        BCC ?less
        CMP #<minimum> : BCS <address>
        ?less:
    endif
endmacro

; Apply damage reduction without scaling
; address        = contains the damage value
; value          = damage reduction (constant)
; endpoint       = where to branch to at the end
; branchendpoint = if we should branch to the endpoint (bool)
macro _DamageReduction(address, value, endpoint, branchendpoint)
    LDA <address> : SEC : SBC #<value>
    %BranchIfGreaterOrEqual(!MinimumDamage, <endpoint>)
    LDA #!MinimumDamage
    if <branchendpoint> != 0
        BRA <endpoint>
    endif
endmacro


; Apply damage reduction
; address  = contains the damage value
; value    = damage reduction (constant)
; endpoint = where all branches should end at
macro DamageReduction(address, value, endpoint)
    if !GuardRingDiminishingEffect != 0
        LDA $7EF35B : BEQ ?greenMail ; Check current mail
            CMP #$01 : BNE ?redMail
            ;?blueMail:
                %_DamageReduction(<address>, <value>-1, <endpoint>, 1)
            ?redMail:
                %_DamageReduction(<address>, <value>-2, <endpoint>, 1)
            ?greenMail:
                %_DamageReduction(<address>, <value>, <endpoint>, 0)
    else
        %_DamageReduction(<address>, <value>, <endpoint>, 0)
    endif
endmacro

; Called before damage is subtracted from Link's health
; Input: $00 (damage value)
; Output: $00 (damage value with reduction)
RingDamageReduction:
    ; Bomb Damage / Fire Ring
    LDA !BombDamage : BEQ +
        LDA #0 : STA !BombDamage
        LDA !FireRingFlag : BEQ .damageTypesHandled
            LDA #0 : STA $00
            BRA .done

    ; Fire Damage / Fire/Flame Ring
    + LDA !FireDamage : BEQ +
        LDA #0 : STA !FireDamage
        LDA !FireRingFlag : BEQ .damageTypesHandled
        CMP #1 : BNE .flameRing
        ;.fireRing
            LDA $00 : LSR : STA $00
            BRA .damageTypesHandled
        .flameRing
            STZ $00
            BRA .done

    ; Spike Floor Damage / Iron Boots
    + LDA !SpikeDamage : BEQ .damageTypesHandled
      LDA #0 : STA !SpikeDamage

    .damageTypesHandled

    LDA !GuardRingFlag : BEQ .done
        CMP #$01 : BNE .diamondRing
        ;.guardRing
            %DamageReduction($00, 2, .setAddress)
            BRA .setAddress
        .diamondRing
            %DamageReduction($00, 4, .setAddress)
    .setAddress
        STA $00
    .done
RTL

; called when Link's bomb damages him
BombDamage:
    LDA #1 : STA !BombDamage
    LDA $7EF35B : TAY
    LDA $980B, Y : STA $0373
RTL

; Used by Trinexx's and some of Ganon's fire
GarnishFireDamage:
    PHB : PHK : PLB
    LDA #1 : STA !GarnishFire ; flag for Garnish_CheckPLayerCollision
    LDA .chr_indices, X : TAX         ; thing we wrote over
    LDA .chr, X : INY : STA ($90), Y  ; ^
    LDA.b #$22 : ORA .properties, X   ; ^
    PLB ; new
    PLX                                     ; thing we wrote over
    JSL Garnish_SetOamPropsAndLargeSizeLong ; ^
JML Garnish_CheckPlayerCollision            ; ^
;---------------------------------------------------
; Tables we had to move to make the above code work
;---------------------------------------------------
    .chr
        db $AC, $AE, $66, $66, $8E, $A0, $A2

    .properties
        db $01, $41, $01, $41, $00, $00, $00

    .chr_indices
        db 7, 6, 5, 4, 5, 4, 5, 4
        db 5, 4, 5, 4, 5, 4, 5, 4
        db 5, 4, 5, 4, 5, 4, 5, 4
        db 5, 4, 5, 4, 5, 4, 5, 4
;---------------------------------------------------

; called when "garnish" objects hit Link,
; like Aghanim's lightning trail or Trinexx's fire
GarnishOnCollision:
    LDA !GarnishFire : BEQ +
        LDA #1 : STA !FireDamage
    +
    LDA #$10 : STA $46 ; thing we wrote over
RTL

; When most things hit link
GeneralDamage:
    PHA

    ; Set Elemental Damage flags
        LDA.l !SpriteProp, X : AND #$01 : BEQ .notFire
            LDA #1 : STA !FireDamage
        .notFire

        LDA.l !SpriteProp, X : AND #$02 : BEQ .notBomb
            LDA #1 : STA !BombDamage
        .notBomb
    ;---

    PLA
    JSL.l LoadModifiedArmorLevel
RTL

; Unused
SpikeDamage:
    LDA #1 : STA !SpikeDamage
    LDA $7EF35B : TAY
    ;LDA $????, Y : STA $0373
RTL

