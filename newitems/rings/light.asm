; Light Ring

; Sword slash damage
; no sword, fighter, master, tempered, golden
SwordDamageTable:
db 0, 2, 4, 8, 16

; Change sword beam damage to the same as the
; basic sword slash, if we have the Light Ring.
SwordBeamDamage:
     LDA !LightRingFlag : BEQ .noLightRing
         PHB : LDA.b #bank(SwordDamageTable) : PHA : PLB
         PHX : LDA $7EF359 : TAX : LDA SwordDamageTable, X
         PLX : PLB
         RTL
     .noLightRing
         LDA #02
RTL

; Setup hit box for the charged spin attack
; minusx = Subtracts from Link's X coordinate for the starting X of the hitbox
; minusy = Subtracts from Link's Y coordinate for the starting Y of the hitbox
; size   = Width and height-1 of the hitbox
macro SpinAttackHitBox(minusx,minusy,size)
    LDA $22 : SEC : SBC.b #<minusx> : STA $00
    LDA $23 : SBC.b #$00 : STA $08

    LDA $20 : SEC : SBC.b #<minusy> : STA $01
    LDA $21 : SBC.b #$00 : STA $09

    LDA.b #<size> : STA $02
    INC A         : STA $03
endmacro

; Increase spin attack hitbox by 6 pixels at each direction
; if we have the Light Ring.
SpinAttackHitBox:
    LDA !LightRingFlag : BEQ .noLightRing
        %SpinAttackHitBox($000E+6,$000A+6,$002C+12)
        RTL

    .noLightRing
        %SpinAttackHitBox($000E,$000A,$002C)
RTL

; Hook into a early part of the spin attack
; animation so we can spawn our own new effect.
SpinAttackAnimationTimers:
    LDA !LightRingFlag : BEQ .noLightRing
        PHX
        JSL AncillaExt_AddLightSpin
        PLX
    .noLightRing
    LDA #$02 : STA $03B1, X ; thing we wrote over
    LDA #$4C : STA $0C5E, X ; ^
    LDA #$08 : STA $039F, X ; ^
RTL

