!PaletteOrange = 0
!PaletteRed    = 1
!PaletteYellow = 2
!PaletteBlue   = 3
!PaletteGray   = 4
!PaletteBurn   = 5
!PaletteRB     = 6
!PaletteGreen  = 7

!ABoxWidth  = 16
!ABoxHeight = 6

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

; Hook into the NMI function

NMIRingGraphics:
    LDA.l !UpdateMenuRingGraphics : BEQ +
        DEC : STA.l !UpdateMenuRingGraphics
        JSR LoadExtraMenuGfx
    +
RTL

; Decompression and Transfer to VRAM

DecompExtraMenuGfx:
    if !CompressMenuRingsGFX != 0
        STZ $00
        LDA #$40 : STA $01
        LDA #$7F : STA $02 : STA $05
        LDA.b #!GfxMenuRings_high : STA $CA
        LDA.b #!GfxMenuRings_mid  : STA $C9
        LDA.b #!GfxMenuRings_low  : STA $C8
        JSL DecompGfx
    endif

    SEP #$20
    LDA.b #$02 : STA.l !UpdateMenuRingGraphics
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
    if !CompressMenuRingsGFX != 0
        CMP #$01 : BNE .secondPart
        ;.firstPart
            %GfxTransfer(0, $4000, $7F, $0200, $F800/2)
            RTS
        .secondPart
            %GfxTransfer(0, $4200, $7F, $0200, $FA00/2)
    else
        CMP #$01 : BNE .secondPart
        ;.firstPart
            %GfxTransfer(0, !GfxMenuRings_word, !GfxMenuRings_bank, $0200, $F800/2)
            RTS
        .secondPart
            %GfxTransfer(0, !GfxMenuRings_word+$200, !GfxMenuRings_bank, $0200, $FA00/2)
    else
    endif
RTS

; Sprite Drawing Macros

function abox_addr(x,y) = $1584+(x*2)+(y*$40)
function menu_sprite_addr(palette,x,y) = $2000+(palette*$0400)+(x*1)+(y*$10)
function ring_sprite_addr(palette,x,y) = $2100+(palette*$0400)+$0080+(x*1)+(y*$10)

function ring_sprx(id) = 8+(2*(id%4))
function ring_spry(id) = 2*(id/4)
function ring_locx(lc) = 2+(4*(lc%4))+(4*(lc/4))
function ring_locy(lc) = 2+(3*(lc/4))

!RingStartLocation = $1608 ; for reference

macro RepIf(flag)
    if <flag> != 0
        REP #$20
    endif
endmacro

macro SepIf(flag)
    if <flag> != 0
        SEP #$20
    endif
endmacro

macro DrawMenuSprite8x8(x,y,sx,sy,palette,repsep)
    %RepIf(<repsep>)
    LDA #(menu_sprite_addr(<palette>, <sx>, <sy>)) : STA.l abox_addr(<x>, <y>)
    %SepIf(<repsep>)
endmacro

macro DrawMenuSpriteYFlipped8x8(x,y,sx,sy,palette,repsep)
    %RepIf(<repsep>)
    LDA #(menu_sprite_addr(<palette>, <sx>, <sy>)|$8000) : STA.l abox_addr(<x>, <y>)
    %SepIf(<repsep>)
endmacro

macro DrawLastMenuSpriteYFliped8x8(x,y,repsep)
    %RepIf(<repsep>)
    ORA.w #$8000 : STA.l abox_addr(<x>, <y>)
    %SepIf(<repsep>)
endmacro

macro DrawLastMenuSpriteYUnfliped8x8(x,y,repsep)
    %RepIf(<repsep>)
    EOR.w #$8000 : STA.l abox_addr(<x>, <y>)
    %SepIf(<repsep>)
endmacro

macro DrawLastMenuSpriteXFliped8x8(x,y,repsep)
    %RepIf(<repsep>)
    ORA.w #$4000 : STA.l abox_addr(<x>, <y>)
    %SepIf(<repsep>)
endmacro

macro DrawExtraMenuSprite8x8(x,y,sx,sy,palette,repsep)
    %RepIf(<repsep>)
    LDA #(ring_sprite_addr(<palette>, <sx>, <sy>)) : STA.l abox_addr(<x>, <y>)
    %SepIf(<repsep>)
endmacro

macro DrawExtraMenuSprite16x16(x,y,sx,sy,palette,repsep)
    %RepIf(<repsep>)
    LDA #(ring_sprite_addr(<palette>, <sx>,   <sy>))   : STA.l abox_addr(<x>,   <y>)
    LDA #(ring_sprite_addr(<palette>, <sx>+1, <sy>))   : STA.l abox_addr(<x>+1, <y>)
    LDA #(ring_sprite_addr(<palette>, <sx>,   <sy>+1)) : STA.l abox_addr(<x>,   <y>+1)
    LDA #(ring_sprite_addr(<palette>, <sx>+1, <sy>+1)) : STA.l abox_addr(<x>+1, <y>+1)
    %SepIf(<repsep>)
endmacro

macro RemoveMenuSprite8x8(x,y,repsep)
    %RepIf(<repsep>)
    LDA.w #$24F5 : STA.l abox_addr(<x>, <y>)
    %SepIf(<repsep>)
endmacro

macro RemoveMenuSprite16x16(x,y,repsep)
    %RepIf(<repsep>)
    LDA.w #$24F5 : STA.l abox_addr(<x>,   <y>)
    LDA.w #$24F5 : STA.l abox_addr(<x>+1, <y>)
    LDA.w #$24F5 : STA.l abox_addr(<x>,   <y>+1)
    LDA.w #$24F5 : STA.l abox_addr(<x>+1, <y>+1)
    %SepIf(<repsep>)
endmacro

macro DrawABoxCorners(palette)
    ;?drawCorners:
        %DrawMenuSprite8x8(-1, -1, 11, 15, <palette>, 0)
        %DrawLastMenuSpriteYFliped8x8(-1, !ABoxHeight+1, 0)
        %DrawLastMenuSpriteXFliped8x8(!ABoxWidth+1, !ABoxHeight+1, 0)
        %DrawLastMenuSpriteYUnfliped8x8(!ABoxWidth+1, -1, 0)

    ;?drawVerticalEdgesPrep:
        CLC
        LDX.w #$0000 ; starting point to draw vertical edges
        LDY.w #$0006 ; number of pair of vertical edges to draw

    ?drawVerticalEdges:
        LDA.w #menu_sprite_addr(<palette>,12,15) : STA abox_addr(-1,0), X
        ORA.w #$4000 : STA abox_addr(!ABoxWidth+1,0), X ; flip horizontally and draw

        TXA : ADC.w #$0040 : TAX ; adding 40 to X means drawing one line lower in the menu

        DEY : BPL ?drawVerticalEdges


    ;?drawHorizontalEdgesPrep:
        LDX.w #$0000 ; starting point to draw horizontal edges
        LDY.w #$0010 ; number of pair of horizontal edges to draw

    ?drawHorizontalEdges:
        LDA.w #menu_sprite_addr(<palette>,9,15) : STA abox_addr(0,-1), X
        ORA.w #$8000 : STA abox_addr(0,!ABoxHeight+1), X ; flip vertically and draw

        INX #2 ; adding 2 to X means drawing one column to the right in the menu

        DEY : BPL ?drawHorizontalEdges
endmacro

; Ring Drawing Macros

macro _DrawRing(lc,id,palette)
    !X #= ring_locx(<lc>)
    !Y #= ring_locy(<lc>)
    !SX #= ring_sprx(<id>)
    !SY #= ring_spry(<id>)
    %DrawExtraMenuSprite16x16(!X, !Y, !SX, !SY, <palette>, 1)
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
    !X = ring_locx(<lc>)
    !Y = ring_locy(<lc>)
    %RemoveMenuSprite16x16(!X, !Y, 0)
endmacro

macro DrawR()
    %DrawExtraMenuSprite8x8(0, 0, 0, 2, !PaletteYellow, 0)
    %DrawExtraMenuSprite8x8(0, 1, 0, 3, !PaletteYellow, 0)
endmacro

macro DrawSmallRingsText()
    !P = !PaletteYellow
    !SX = 1 : !SY = 2
    !X  = 1 : !Y  = -1
    %DrawExtraMenuSprite8x8(!X,   !Y, !SX,   !SY, !P, 0)
    %DrawExtraMenuSprite8x8(!X+1, !Y, !SX+1, !SY, !P, 0)
    %DrawExtraMenuSprite8x8(!X+2, !Y, !SX+2, !SY, !P, 0)
    %DrawExtraMenuSprite8x8(!X+3, !Y, !SX+3, !SY, !P, 0)
endmacro

; Item Drawing Macros

function item_locx(lc) = 2+(4*lc)

macro RemoveMenuItemSprite(lc)
    %RemoveMenuSprite16x16(item_locx(<lc>), 2, 0)
endmacro

; Menu Drawing

RestoreNormalMenuAux:
    LDA !WhichMenu : CMP #02 : BEQ +
        JSL DrawMoonPearl
    +
    JSL DrawProgressIcons
RTL

DrawLowerItemBox:
    JSL DrawAbilityText
    LDA.l !EnableRingsRuntime : BEQ +
        JSR DecompExtraMenuGfx
        LDA $F2 : AND $10 : BEQ +
        JSR DrawRingBox
        JSR DrawRingIcons
        RTL
    +
    LDA #$01 : STA !WhichMenu
    JSL DrawAbilityIcons
    JSL DrawMoonPearl
    JSL DrawProgressIcons
    LDA.l !EnableRingsRuntime : BEQ ++
       JSR DrawRingSwitchText
    ++
RTL

DrawRingSwitchText:
    !RingSwitchText = $2580
    !RingSwitchTextLoc = $0016D8

    REP #$20

    %DrawExtraMenuSprite16x16(10, 5, 0, 0, !PaletteRed, 0)
    %DrawExtraMenuSprite16x16(12, 5, 2, 0, !PaletteRed, 0)
    %DrawExtraMenuSprite16x16(14, 5, 4, 0, !PaletteRed, 0)
    %DrawExtraMenuSprite8x8(16, 5, 6, 0, !PaletteRed, 0)
    %DrawExtraMenuSprite8x8(16, 6, 6, 1, !PaletteRed, 0)

    SEP #$20
RTS

DrawAbilitiesBox:
    LDA #$01 : STA !WhichMenu
    REP #$30

    %DrawABoxCorners(!PaletteRed)

    ; Draw 'A' button icon
    %DrawMenuSpriteYFlipped8x8(0, 0, 0, 15, !PaletteRed, 0)
    %DrawMenuSprite8x8(0, 1, 2, 15, !PaletteRed, 0)

    ; Draw little 'do' text
    %DrawMenuSprite8x8(1, -1, 2, 8, !PaletteRed, 0)
    %DrawMenuSprite8x8(2, -1, 3, 8, !PaletteRed, 0)

    ; Remove Rings
    %RemoveRing(0)
    %RemoveRing(1)
    %RemoveRing(2)
    %RemoveRing(3)
    %RemoveRing(4)
    %RemoveRing(5)

    LDX #$0000
    SEP #$30
    JSL DrawMoonPearl
    JSL DrawAbilityIcons
    LDA.l !EnableRingsRuntime : BEQ .end
       JSR DrawRingSwitchText
    .end
RTS

DrawRingBox:
    LDA #$02 : STA !WhichMenu
    REP #$30

    %DrawABoxCorners(!PaletteYellow)

    ; Remove 'A' button icon
    %RemoveMenuSprite8x8(0,0,0)
    %RemoveMenuSprite8x8(0,1,0)

    ; Remove Ability Items
    %RemoveMenuItemSprite(0)
    %RemoveMenuItemSprite(1)
    %RemoveMenuItemSprite(2)
    %RemoveMenuItemSprite(3)

    ; Remove ring switch text
    %RemoveMenuSprite16x16(10,5,0)
    %RemoveMenuSprite16x16(12,5,0)
    %RemoveMenuSprite16x16(14,5,0)
    %RemoveMenuSprite8x8(16,5,0)
    %RemoveMenuSprite8x8(16,6,0)

    ; Draw text
    %DrawR()
    %DrawSmallRingsText()

    SEP #$30
RTS

DrawRingIcons:
    %DrawRing(!RupeeRingFlag,   0, 0, !PaletteBlue)
    %DrawRing(!GravityRingFlag, 1, 1, !PaletteBlue)
    %DrawRing(!FireRingFlag,    2, 3, !PaletteRed)
    %DrawRing(!LightRingFlag,   3, 4, !PaletteYellow)
    %DrawRing(!PowerRingFlag,   4, 5, !PaletteGreen)
    %DrawRing(!GuardRingFlag,   5, 6, !PaletteBlue)
RTS

; Handling Menu Input

HandleRingMenuToggle:
    LDA !EnableRingsRuntime : BEQ .afterRingMenu
    LDA $F2 : AND #$10 : BEQ .RNotHeld
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
        LDA #$00 : STA !WhichMenu
        LDA.b #$05 : STA $0200
        RTL
    .noButtonPress
RTL

; Has Items
MenuLoop:
    JSR HandleRingMenuToggle
    INC $0207

    ; Handle menu closing
    LDA $F0 : BEQ ++
        PHA : LDA $F4 : AND.b #$10 : BEQ +
            LDA #$00 : STA !WhichMenu
        +
        PLA
    ++
RTL


