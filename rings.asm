; Data
RingsEnabled:
    db 01 ; 00 - Rings disabled, 01 - Rings Enabled

; Helper Variables
!UpdateRingGraphics = $7FFFFF
!RButtonHeld = $7FFFFE
!WhichMenu = $7FFFFD
!UpdateMenuRingGraphics = $7FFFFC
!BombDamage = $7FFFFB
!FireDamage = $7FFFFA
!SpikeDamage = $7FFFF9

; Ring Flags
!RupeeRingFlag = $7F6600
!GravityRingFlag = $7F6601
!FireRingFlag = $7F6602
!LightRingFlag = $7F6603
!PowerRingFlag = $7F6604
!GuardRingFlag = $7F6605

; Moved InitHdmaSettings here so we have space in Bank 00

Mirror_InitHdmaSettingsAux:
    STZ $9B
    REP #$20
    STZ $06A0 : STZ $06AC : STZ $06AA : STZ $06AE : STZ $06B0

    LDA.w #$0008 : STA $06B4
                   STA $06B6

    LDA.w #$0015 : STA $06B2
    LDA.w #$FFC0 : STA $06A6
    LDA.w #$0040 : STA $06A8
    LDA.w #$FE00 : STA $06A2
    LDA.w #$0200 : STA $06A4

    STZ $06AC : STZ $06AE

    LDA.w #$0F42 : STA $4370
    LDA.w #$0D42 : STA $4360

    LDX.b #$3E

    LDA $E2

.init_hdma_table

    STA $1B00, X : STA $1B40, X : STA $1B80, X : STA $1BC0, X
    STA $1C00, X : STA $1C40, X : STA $1C80, X

    DEX #2 : BPL .init_hdma_table

    SEP #$20

    LDA.b #$C0 : STA $9B
RTL

; Hook into the NMI function to move Ring sprites to VRAM

ExtraMenuNMIUpdate:
    SEP #$20
    LDA $4212 : AND #%00000001 : BNE ExtraMenuNMIUpdate
    LDA $4218 : AND #$10 : STA !RButtonHeld

    LDA.b #$80 : STA $2115

    LDA.l !UpdateMenuRingGraphics : BEQ +
        JSR LoadExtraMenuGfx
        LDA #$00 : STA.l !UpdateMenuRingGraphics
    +

    REP #$10
RTL

; Decompression and Transfer to VRAM

DecompExtraMenuGfx:
    STZ $00
    LDA #$40 : STA $01
    LDA #$7F : STA $02 : STA $05
    LDA #$31 : STA $CA
    LDA #$F0 : STA $C9
    LDA #$00 : STA $C8
    JSL DecompGfx

    SEP #$20
    LDA.b #$01 : STA.l !UpdateMenuRingGraphics
RTS

macro GfxTransfer(sourcemath, source, sourcebank, size, target)
    REP #$20
    ; Setup DMA Transfer
    if <sourcemath> == 0
       LDA #(<source>) : STA $4302
    else
        <source> : STA $4302
    endif
    LDA.w #(<size>) : STA $4305
    LDA.w #(<target>) : STA $2116

    SEP #$20
    LDA.b #(<sourcebank>) : STA $4304
    LDA.b #$80 : STA $2115
    LDA.b #$01 : STA $4300
    LDA.b #$18 : STA $4301

    ; Start
    LDA.b #$01 : STA $420b
endmacro

LoadExtraMenuGfx:
    %GfxTransfer(0, $4000, $7F, $0400, $F800/2)
RTS

; Ring Drawing Macros

function ring_sprx(id) = $02*(id%4)
function ring_spry(id) = $20*(id/4)
function ring_locx(lc) = ($08*(lc%4))+($08*(lc/4))
function ring_locy(lc) = $C0*(lc/4)


macro _DrawRing(lc,id,palette)
    REP #$20
    !RingSprite   = $0088+ring_sprx(<id>)+ring_spry(<id>)
    !RingPalette  = $2100+(<palette>*$0400)
    !RingLocation = $15C8+ring_locx(<lc>)+ring_locy(<lc>)
    LDA #(!RingPalette+!RingSprite+0)   : STA !RingLocation
    LDA #(!RingPalette+!RingSprite+1)   : STA !RingLocation+2
    LDA #(!RingPalette+!RingSprite+$10) : STA !RingLocation+$40
    LDA #(!RingPalette+!RingSprite+$11) : STA !RingLocation+$42
    SEP #$20
endmacro

macro DrawRing(flag,lc,id,palette)
    if <flag> == !FireRingFlag || <flag> == !PowerRingFlag || <flag> == !GuardRingFlag
    ; Progressive Ring
        LDA.l <flag> : CMP.b #$01 : BNE +
            %_DrawRing(<lc>, 2, <palette>)
        + LDA.l <flag> : CMP.b #$02 : BNE +
            %_DrawRing(<lc>, <id>, <palette>)
        +
    else
    ; Non-Progressive Ring
        LDA.l <flag> : BEQ +
            %_DrawRing(<lc>, <id>, <palette>)
        +
    endif
endmacro

macro RemoveRing(lc)
    !RingLocation = $15C8+ring_locx(<lc>)+ring_locy(<lc>)
    LDA #$24F5 : STA !RingLocation
    LDA #$24F5 : STA !RingLocation+2
    LDA #$24F5 : STA !RingLocation+$40
    LDA #$24F5 : STA !RingLocation+$42
endmacro

; Menu Drawing

RestoreNormalMenuAux:
    LDA !WhichMenu : CMP #02 : BEQ +
        JSL DrawMoonPearl
        JSL DrawProgressIcons
    +
RTL

DrawLowerItemBox:
    JSL DrawAbilityText
    LDA.l RingsEnabled : BEQ +
        JSR DecompExtraMenuGfx
        LDA !RButtonHeld : BEQ +
        JSR DrawRingBox
        JSR DrawRingIcons
        RTL
    +
    LDA #$01 : STA !WhichMenu
    JSL DrawAbilityIcons
    JSL DrawMoonPearl
    JSL DrawProgressIcons
    LDA.l RingsEnabled : BEQ ++
       JSR DrawRingSwitchText
    ++
RTL

DrawRingSwitchText:
    !RingSwitchText = $2580
    !RingSwitchTextLoc = $0016D8

    REP #$20

    LDA.w #(!RingSwitchText+0) : STA.l !RingSwitchTextLoc+$0
    LDA.w #(!RingSwitchText+1) : STA.l !RingSwitchTextLoc+$2
    LDA.w #(!RingSwitchText+2) : STA.l !RingSwitchTextLoc+$4
    LDA.w #(!RingSwitchText+3) : STA.l !RingSwitchTextLoc+$6
    LDA.w #(!RingSwitchText+4) : STA.l !RingSwitchTextLoc+$8
    LDA.w #(!RingSwitchText+5) : STA.l !RingSwitchTextLoc+$A
    LDA.w #(!RingSwitchText+6) : STA.l !RingSwitchTextLoc+$C

    LDA.w #(!RingSwitchText+$10) : STA.l !RingSwitchTextLoc+$40
    LDA.w #(!RingSwitchText+$11) : STA.l !RingSwitchTextLoc+$42
    LDA.w #(!RingSwitchText+$12) : STA.l !RingSwitchTextLoc+$44
    LDA.w #(!RingSwitchText+$13) : STA.l !RingSwitchTextLoc+$46
    LDA.w #(!RingSwitchText+$14) : STA.l !RingSwitchTextLoc+$48
    LDA.w #(!RingSwitchText+$15) : STA.l !RingSwitchTextLoc+$4A
    LDA.w #(!RingSwitchText+$16) : STA.l !RingSwitchTextLoc+$4C

    SEP #$20
RTS

DrawAbilitiesBox:
    LDA #$01 : STA !WhichMenu
    REP #$30

    .drawCorners
        LDA.w #$24FB : STA $1542
        ORA.w #$8000 : STA $1742
        ORA.w #$4000 : STA $1766
        EOR.w #$8000 : STA $1566

    CLC
    LDX.w #$0000
    LDY.w #$0006

    .drawVerticalEdges
        LDA.w #$24FC : STA $1582, X
        ORA.w #$4000 : STA $15A6, X

        TXA : ADC.w #$0040 : TAX

        DEY : BPL .drawVerticalEdges

    LDX.w #$0000
    LDY.w #$0010

    .drawHorizontalEdges
        LDA.w #$24F9 : STA $1544, X
        ORA.w #$8000 : STA $1744, X

        INX #2

        DEY : BPL .drawHorizontalEdges

        ; Draw 'A' button icon
        LDA.w #$A4F0 : STA $1584
        LDA.w #$24F2 : STA $15C4
        LDA.w #$2482 : STA $1546
        LDA.w #$2483 : STA $1548


    LDX #$0000
    ;.removeRings
        %RemoveRing(0)
        %RemoveRing(1)
        %RemoveRing(2)
        %RemoveRing(3)
        %RemoveRing(4)
        %RemoveRing(5)
        %RemoveRing(6)

    SEP #$30
    LDA.l RingsEnabled : BEQ .end
       JSR DrawRingSwitchText
    .end
RTS

DrawRingBox:
    LDA #$02 : STA !WhichMenu
    REP #$30

    .drawCorners
        LDA.w #$28FB : STA $1542
        ORA.w #$8000 : STA $1742
        ORA.w #$4000 : STA $1766
        EOR.w #$8000 : STA $1566

    CLC
    LDX.w #$0000
    LDY.w #$0006

    .drawVerticalEdges
        LDA.w #$28FC : STA $1582, X
        ORA.w #$4000 : STA $15A6, X
        TXA : ADC.w #$0040 : TAX

        DEY : BPL .drawVerticalEdges

    LDX.w #$0000
    LDY.w #$0010

    .drawHorizontalEdges
        LDA.w #$28F9 : STA $1544, X
        ORA.w #$8000 : STA $1744, X

        INX #2

        DEY : BPL .drawHorizontalEdges

    ; Remove 'A' button icon
    LDA.w #$24F5 : STA $1584
    LDA.w #$24F5 : STA $15C4

    ; Remove ring switch text
    LDA.w #$24F5 : STA $16D8
    LDA.w #$24F5 : STA $16DA
    LDA.w #$24F5 : STA $16DC
    LDA.w #$24F5 : STA $16DE
    LDA.w #$24F5 : STA $16E0
    LDA.w #$24F5 : STA $16E2
    LDA.w #$24F5 : STA $16E4

    LDA.w #$24F5 : STA $1718
    LDA.w #$24F5 : STA $171A
    LDA.w #$24F5 : STA $171C
    LDA.w #$24F5 : STA $171E
    LDA.w #$24F5 : STA $1720
    LDA.w #$24F5 : STA $1722
    LDA.w #$24F5 : STA $1724

    SEP #$30
RTS

DrawRingIcons:
    %DrawRing(!RupeeRingFlag,   0, 0, 3)
    %DrawRing(!GravityRingFlag, 1, 1, 3)
    %DrawRing(!FireRingFlag,    2, 3, 1)
    %DrawRing(!LightRingFlag,   3, 4, 2)
    %DrawRing(!PowerRingFlag,   4, 5, 7)
    %DrawRing(!GuardRingFlag,   5, 6, 3)
RTS

; Handling Menu Input

HandleRingMenuToggle:
    LDA !RButtonHeld : BEQ .RNotHeld
        LDA !WhichMenu : CMP #01 : BNE .afterRingMenu
            JSR DrawRingBox
            JSR DrawRingIcons
            LDA.b #$01 : STA $17
            LDA.b #$22 : STA $0116
            BRA .afterRingMenu
    .RNotHeld
        LDA !WhichMenu : CMP #02 : BNE .afterRingMenu
            JSR DrawAbilitiesBox
            LDA.b #$01 : STA $17
            LDA.b #$22 : STA $0116
    .afterRingMenu
RTS

; No Items
NoEquip:
    JSR HandleRingMenuToggle

    LDA $F4 : BEQ .noButtonPress

    LDA.b #$05 : STA $0200

    RTL
    .noButtonPress
RTL

; Has Items
MenuLoop:
    JSR HandleRingMenuToggle
    INC $0207
    LDA $F0 : BEQ ++
        PHA : LDA $F4 : AND.b #$10 : BEQ +
            LDA #$00 : STA !WhichMenu
        +
        PLA
    ++
RTL

; Ring Functionality

; Rupee Ring

; Add collected rupees to the total amount, handle Rupee Charm
AddCollectedRupees:
   ; Input:  A register = amount to add
   ; Output: A register = total rupees
   PHA
   LDA !RupeeRingFlag : BEQ + ; check if we have the rupee ring
       PLA : ASL ; if we have it, double rupee amount
       ADC $7EF360 ; Add amount to current rupee count
       RTL
   +
   PLA
   ADC $7EF360 ; Add amount to current rupee count
RTL ; following code will sta $7EF360

; Add rupees from chests to the total amount, handle Rupee Charm
AddChestRupees:
    ; Input: $00 = amount to add
    ; Output: A register = total rupees
    LDA !RupeeRingFlag : BEQ + ; check if we have the rupee charm
        LDA $07EF360
        CLC
        ADC $00
        ADC $00
        RTL
    +
    LDA $07EF360
    CLC
    ADC $00
RTL

; Gravity Ring

DoPitDamage:
    LDA !GravityRingFlag : BEQ + ; check if we have the gravity ring
        RTL ; if we have it, don't do anything
    +
    JSL.l OHKOTimer ; otherwise, call damage routines
    LDA $7EF36D : SBC #8 ; and reduce health by one heart (8 health)
    ADC !GuardRingFlag   ; calculate guard ring reduction
    ADC !GuardRingFlag   ; (it's double the current ring)
    STA $7EF36D

    CMP.b #$A8 : BCC .notDead ; for overflowed numbers, set health to 0
        LDA.b #$00 : STA $7EF36D
    .notDead
RTL

!DiminishingEffect = 0 ; Guard Ring effect goes down with armor upgrades (0:no, 1:yes)
!MinimumDamage = 01 ; Minimum damage after ring damage reduction

macro BranchIfLessThanMinimum(minimum, address)
    if <minimum> <= 1
        BPL <address>
    else
        CMP <minimum> : BCC <address>
    endif
endmacro

macro DamageReduction(address, value, endpoint)
    if !DiminishingEffect != 0
        LDA $7EF35B : BEQ ?greenMail ; Check current mail
            CMP #$01 : BNE ?redMail
            ;?blueMail:
                LDA <address> : SEC : SBC #(<value>-1)
                %BranchIfLessThanMinimum(!MinimumDamage, <endpoint>)
                LDA #!MinimumDamage
                BRA <endpoint>
            ?redMail:
                LDA <address> : SEC : SBC #(<value>-2)
                %BranchIfLessThanMinimum(!MinimumDamage, <endpoint>)
                LDA #!MinimumDamage
                BRA <endpoint>
            ?greenMail:
                LDA <address> : SEC : SBC #<value>
                %BranchIfLessThanMinimum(!MinimumDamage, <endpoint>)
                LDA #!MinimumDamage
    else
        LDA <address> : SEC : SBC #<value>
            %BranchIfLessThanMinimum(!MinimumDamage, <endpoint>)
            LDA #!MinimumDamage
    endif
endmacro

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

BombDamage:
    LDA #1 : STA !BombDamage
    LDA $7EF35B : TAY
    LDA $980B, Y : STA $0373
RTL

FireDamage:
    LDA #1 : STA !FireDamage
    LDA $7EF35B : TAY
    ;LDA $????, Y : STA $0373
RTL

SpikeDamage:
    LDA #1 : STA !SpikeDamage
    LDA $7EF35B : TAY
    ;LDA $????, Y : STA $0373
RTL

