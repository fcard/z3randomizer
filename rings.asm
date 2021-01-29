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

!UpdateRingGraphics = $7FFFFF
!RButtonHeld = $7FFFFE
!WhichMenu = $7FFFFd
!UpdateMenuRingGraphics = $7FFFFc
!RupeeCharmFlag = $7F6600

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

RingsEnabled:
    db 01 ; 00 - Rings disabled, 01 - Rings Enabled

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
    LDA.l RingsEnabled : BEQ ++
       JSR DrawRingSwitchText
    ++
RTL

DrawRingSwitchText:
    !RingSwitchText = $2580

    REP #$20

    LDA.w #(!RingSwitchText+0) : STA $0016D8
    LDA.w #(!RingSwitchText+1) : STA $0016DA
    LDA.w #(!RingSwitchText+2) : STA $0016DC
    LDA.w #(!RingSwitchText+3) : STA $0016DE
    LDA.w #(!RingSwitchText+4) : STA $0016E0
    LDA.w #(!RingSwitchText+5) : STA $0016E2
    LDA.w #(!RingSwitchText+6) : STA $0016E4

    LDA.w #(!RingSwitchText+0+$10) : STA $001718
    LDA.w #(!RingSwitchText+1+$10) : STA $00171A
    LDA.w #(!RingSwitchText+2+$10) : STA $00171C
    LDA.w #(!RingSwitchText+3+$10) : STA $00171E
    LDA.w #(!RingSwitchText+4+$10) : STA $001720
    LDA.w #(!RingSwitchText+5+$10) : STA $001722
    LDA.w #(!RingSwitchText+6+$10) : STA $001724

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
    .removeRings
        !RingSpriteLocation = $15C8
        !RingSpriteDistance = $4
        LDA.w #$24F5 : STA !RingSpriteLocation, X
        LDA.w #$24F5 : STA !RingSpriteLocation+2, X
        LDA.w #$24F5 : STA !RingSpriteLocation+$40, X
        LDA.w #$24F5 : STA !RingSpriteLocation+$42, X
        INX #!RingSpriteDistance
        CPX #(!RingSpriteDistance*$4) : BCC .removeRings

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
    REP #$30

    !RingSpriteLocation = $15C8
    !RingSprite = $2Da0
    LDA !RupeeCharmFlag : BEQ +
        LDA #(!RingSprite+0)   : STA !RingSpriteLocation
        LDA #(!RingSprite+1)   : STA !RingSpriteLocation+2
        LDA #(!RingSprite+$10+0) : STA !RingSpriteLocation+$40
        LDA #(!RingSprite+$10+1) : STA !RingSpriteLocation+$42
    +

    ;JSR DrawRing

    ;LDA.w #$16C8 : STA $00
    ;LDA $7EF355 : AND.w #$00FF : STA $02
    ;LDA.w #$F801 : STA $04

    ;JSR DrawRing

    ;LDA.w #$16D8 : STA $00
    ;LDA $7EF356 : AND.w #$00FF : STA $02
    ;LDA.w #$F811 : STA $04

    ;JSR DrawRing

    SEP #$30
RTS

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

NoEquip:
    JSR HandleRingMenuToggle

    LDA $F4 : BEQ .noButtonPress

    LDA.b #$05 : STA $0200

    RTL
    .noButtonPress
RTL


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

; Add collected rupees to the total amount, handle Rupee Charm
AddCollectedRupees:
   ; Input:  A register = amount to add
   ; Output: A register = total rupees
   PHA
   LDA !RupeeCharmFlag : BEQ + ; check if we have the rupee ring
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
    LDA !RupeeCharmFlag : BEQ + ; check if we have the rupee charm
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
