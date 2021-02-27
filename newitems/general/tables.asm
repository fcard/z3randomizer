; Properties for sprites for new items:
; 000000BF
; |||||||'--1 = Is Fire / 0 = Isn't Fire
; ||||||'---1 = Is Bomb / 0 = Isn't Bomb
; |||||'----Unused
; ||||'-----Unused
; |||'------Unused
; ||'-------Unused
; |'--------Unused
; '---------Unused
SpecialSpriteProperties:
    ; 0x00-0x0F
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00

    ; 0x10-0x1F
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00

    ; 0x20-0x2F
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00

    ; 0x30-0x3F
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00

    ; 0x40-0x4F
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $02, $00 ; ??, ??, Bomb
    db $00, $00, $00, $00

    ; 0x50-0x5F
    db $00, $00, $00, $00
    db $00, $01, $00, $00 ; ??, Fireball
    db $00, $00, $00, $00
    db $00, $00, $00, $00

    ; 0x60-0x6F
    db $00, $01, $00, $00 ; ??, Beamos Laser
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00

    ; 0x70-0x7F
    db $01, $00, $00, $00 ; helmasaur fireball
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $01, $01 ; ??, ??, Guruguru Bar Clockwise, Guruguru Bar Counterclockwise

    ; 0x80-0x8F
    db $01, $00, $00, $00 ; Winder
    db $00, $00, $00, $01 ; ??, ??, ??, Kodongo's Fire
    db $00, $00, $00, $00
    db $00, $00, $00, $00

    ; 0x90-0x9F
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00

    ; 0xA0-0xAF
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00

    ; 0xB0-0xBF
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00

    ; 0xC0-0xCF
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $01, $00, $00 ; ??, ganon firebat
    db $00, $00, $00, $00

    ; 0xD0-0xDF
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00

    ; 0xE0-0xEF
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00

    ; 0xF0-0xF5
    db $00, $00, $00, $00
    db $00, $00

!SpriteProp = $1CC0

SetSpriteProperties:
    PHK : PLB
    LDA SpecialSpriteProperties, Y : STA.l !SpriteProp, X
    LDA $040A : LDY $1B ; thing we wrote over
RTL

