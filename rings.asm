; Data
RingsEnabled:
    db 01 ; 00 - Rings disabled, 01 - Rings Enabled

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

ExtraMenuNMIUpdate:
    SEP #$20

    if !AllowStairJump != 0
        LDA $58 : BNE .skipStairCheck
    endif
    LDA $5E : CMP #$02 : BEQ .afterJumping ; don't jump when on stairs
    .skipStairCheck
    LDA $10
    CMP #$07 : BEQ .handleJumping
    CMP #$09 : BEQ .handleJumping
    CMP #$0B : BEQ .handleJumping
    CMP #$06 : BEQ .resetJumping
    CMP #$08 : BEQ .resetJumping
    CMP #$0A : BEQ .resetJumping
        BRA .afterJumping
    .resetJumping
        %M_STZ(!IsJumping,0)
        %M_STZ(!JumpTimer,0)
        BRA .afterJumping
    .handleJumping
        PHX
        SEP #$10
        JSL HandleJumping
        REP #$10
        PLX
    .afterJumping

    LDA.b #$80 : STA $2115

    LDA.l !UpdateMenuRingGraphics : BEQ +
        DEC : STA.l !UpdateMenuRingGraphics
        JSR LoadExtraMenuGfx
    +

    REP #$10
RTL

; Decompression and Transfer to VRAM

DecompExtraMenuGfx:
    if !CompressMenuRingsGFX != 0
        STZ $00
        LDA #$40 : STA $01
        LDA #$7F : STA $02 : STA $05
        LDA #$31 : STA $CA
        LDA #$F0 : STA $C9
        LDA #$00 : STA $C8
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
            %GfxTransfer(0, $F000, $31, $0200, $F800/2)
            RTS
        .secondPart
            %GfxTransfer(0, $F200, $31, $0200, $FA00/2)
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
    LDA.l RingsEnabled : BEQ +
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
    LDA.l RingsEnabled : BEQ ++
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
    LDA.l RingsEnabled : BEQ .end
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

; Ring Functionality

; Rupee Ring

; Add collected rupees to the total amount, handle Rupee Charm
AddCollectedRupees:
    ; Input:  A register = amount to add
    ; Output: A register = total rupees after addition
    PHA
    LDA !RupeeRingFlag : AND #$00FF : BEQ + ; check if we have the rupee ring
        PLA : ASL ; if we have it, double rupee amount
        ADC $7EF360 ; Add amount to current rupee count
        RTL
    +
    PLA
    ADC $7EF360 ; Add amount to current rupee count
RTL ; following code will sta $7EF360

AddDungeonRupees:
    ; Output: A register = total rupees before adding 5 more
    LDA !RupeeRingFlag : AND #$00FF : BEQ + ; check if we have the rupee ring
        LDA $7EF360 : CLC : ADC #$0005 ; Add 5 more
        RTL
    +
    LDA $07EF360
RTL


; Add rupees from chests to the total amount, handle Rupee Charm
AddChestRupees:
    ; Input: $00 = amount to add
    ; Output: A register = total rupees after addition
    LDA !RupeeRingFlag : AND #$00FF : BEQ + ; check if we have the rupee ring
        LDA $7EF360
        CLC
        ADC $00
        ADC $00
        RTL
    +
    LDA $7EF360
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

; Gravity Ring Jump

HandleJumping:
    JSL CheckJumpButtonPress
    JSL ExecuteJump
RTL

StopJump:
    %M_STZ(!IsJumping,0)
RTL

; Handle jumping over a button that requires
; Link to be standing on it.
ChangeTrapDoorState:
    LDA !IsJumping : AND #$00FF : BNE +
        STX $0468 ; thing we wrote over
        STZ $068E ; ^
        JML ChangeTrapDoorState.ReturnPoint
    +
JML ChangeTrapDoorState.EndPoint

; Handle jumping over a button that keeps
; its state after Link steps away from it.
PressGroundSwitch:
    LDA !IsJumping : AND #$00FF : BNE +
        LDA $0430 : BNE +
        JML PressGroundSwitch.ReturnPoint
    +
JML PressGroundSwitch.EndPoint

; Handle jumping over the tiles with a drawing of
; a yellow shine that change the formation of the
; pits of the floor.
ChangePitGroupsInFloor:
    PHA
    LDA !IsJumping : BNE +
        PLA
        STA $04BA
        STZ $BA
        JML ChangePitGroupsInFloor.ReturnPoint
    +
    PLA
JML ChangePitGroupsInFloor.EndPoint

; Don't update the variables that cache Link's
; coordinates and other state while jumping, so
; that when Link falls into water his position
; and state is restored to where it was before
; the jump.
CacheStateForJump:
    LDA $1B : BNE +
    LDA !IsJumping : BNE +
        JSL Player_CacheStatePriorToHandler
    +
JML CacheStateForJump.ReturnPoint

; Skip part of the Soldier's layer check
; when jumping so that Link can attack
; them on midair.
CheckSoldierOnSameLayer:
    LDA !IsJumping : BNE +
        LDA $46 : ORA $4D
        RTL
    +
    LDA #$00
RTL

; Don't reset height on recoil if jumping,
; so Link won't have an inconsistent Z position
; if he e.g. hits a Soldiers sword with his own.
ResetHeightOnRecoil:
    LDA !IsJumping : BNE +
        STZ $24
        STZ $25
    +
RTL

; Skip changing Link's state to "near a hole" if he
; is jumping, so his jump isn't cancelled.
FallIntoHole:
    LDA !IsJumping : BNE +
        LDA #$01 : STA $5B : STA $5D
    +
RTL

; Skip the code that dumps Link into water
; if he is in midair.
macro CheckJumpingAboveWater(fall_into_water, jump_above_water)
    LDA !IsJumping : BNE +
    LDA $4D : BNE +
        JML <fall_into_water>
    +
    JML <jump_above_water>
endmacro

CheckJumpingAboveWaterH:
    %CheckJumpingAboveWater(CheckJumpingAboveWaterH.FallIntoWater,\
                            CheckJumpingAboveWaterH.JumpAboveWater)

CheckJumpingAboveWaterV:
    %CheckJumpingAboveWater(CheckJumpingAboveWaterV.FallIntoWater,\
                            CheckJumpingAboveWaterV.JumpAboveWater)

; Don't reset Link's Z coordinates to $FFFF if he is jumping.
; This code is called periodically if he is not in a substate
; that would put him in midair. Since we don't use the normal
; substate address, $4D, we must add our own branch.
ResetZCoordinates:
    LDA !IsJumping : BNE +
        LDA #$FF : STA $24 : STA $25
    +
RTL

; Don't zero the counter $030D if we're jumping. This is used
; by the bug catching net to forward its animation. This counter
; used to be zeroed every frame that the $46 counter is not zero,
; which is always true for when Link is jumping.
ZeroCountersForStun:
    LDA !IsJumping : BNE +
        STZ $030D
    +
    STZ $030E
RTL

; Change the conditions allowing Link to use Y items in midair.
; Normally he is unable to if the $46 counter is nonzero, we've
; added a branch to skip that check if we're jumping (and if we
; meet a few other conditions, see below)
CheckYPress:
    ; To avoid a few glitches, we must limit the use of certain
    ; items if we are above deep water.
    LDA $0303
    CMP #$02 : BEQ .boomerang ; cannot use boomerang above deep water
                              ; (and is about to hit water)
    if !AllowHookshotWaterJump != 0
        CMP #$0F : BCC .canJumpAndUse ; or medallions
        CMP #$12 : BCC .canJumpAndUse ; ^
    else
        CMP #$0E : BCC .canJumpAndUse ; or hookshot
        CMP #$12 : BCS .canJumpAndUse ; or medallions
    endif
    LDA !JumpingAboveWater : BNE .cannotJumpAndUse
    BRA .canJumpAndUse

    .boomerang
    LDA !JumpingAboveWater : BEQ .canJumpAndUse
    LDA !JumpTimer : CMP #$18 : BCS .cannotJumpAndUse

    .canJumpAndUse
    LDA !IsJumping : BNE +

    .cannotJumpAndUse
    LDA $46 : BEQ +
        JML CheckYPress.No
    +
JML CheckYPress.Continue

; If we're jumping, skip the code that allows
; Link to jump off ledges. Very buggy things
; happen if he starts to drop off a ledge midjump.
JumpLedge:
    LDA $4D : CMP #$01 : BNE +
        JML JumpLedge.BranchAlpha
    +
    LDA !IsJumping : BEQ +
        JML JumpLedge.BranchAlpha
    +
JML JumpLedge.ReturnPoint

; Handle jumping over dungeon warp tiles
CheckDungeonWarpCollision:
    LDA !IsJumping : BNE +
    LDA $4D : BNE +
        JML CheckDungeonWarpCollision.ReturnPoint
    +
JML CheckDungeonWarpCollision.BranchPoint

; Don't change Link's state to falling off a ledge if he is jumping
; (Possibly unnecessary with JumpLedge?)
FallFromLedge:
    LDA !IsJumping : BNE +
        LDA #$06 : STA $5D
    +
RTL

; Don't change Link's state to falling off a ledge if he is jumping
; (Possibly unnecessary with JumpLedge?)
FallFromLedge2:
    LDA !IsJumping : BNE +
        LDA #$02 : STA $5D
    +
RTL

; Don't set any effects around Link if he is jumping (water/grass)
macro SetTileEffect(value)
    LDA !IsJumping : BNE +
        LDA #<value> : STA $0351
    +
    RTL
endmacro

SetGrassEffect:
    %SetTileEffect($02)

SetWaterEffect:
    LDA #$00 : STA !JumpingAboveWater
    %SetTileEffect($01)

SetWaterEffect2:
    LDA #$01 : STA !JumpingAboveWater
    %SetTileEffect($01)

RemoveWaterOrGrassEffect:
    LDA #$00 : STA !JumpingAboveWater
    STZ $0351 ; thing we wrote over
    LDA $02EE ; ^
RTL

; Don't play grass/water sounds if Link is jumping
macro PlayTileSound(sound)
    LDA !IsJumping : BNE +
    LDA $4D : BNE +
        LDA <sound> : JSL Player_DoSfx2Long
    +
    JML PlayTileSound.RTS
endmacro

PlayGrassSound:
    %PlayTileSound(#$1A)

PlayWaterSound:
    %PlayTileSound(#$1C)

PlayMireWaterSound:
    if !MireWaterSounds == !MireWaterSounds_NoFix
        LDA #$1B : JSL Player_DoSfx2Long
        JML PlayTileSound.RTS

    elseif !MireWaterSounds == !MireWaterSounds_FixForRingJump
        LDA !IsJumping : BNE +
            LDA #$1B : JSL Player_DoSfx2Long
        +
        JML PlayTileSound.RTS

    elseif !MireWaterSounds == !MireWaterSounds_FixForAllJumps
        %PlayTileSound(#$1B)

    else
        error "Invalid value for \!MireWaterSounds."
    endif


; Make the hookshot follow Link up when he jumps
FixHookshotY:
    LDA $24 : CMP #$FF : BEQ .doneWithZ
        LDA $00 : SEC : SBC $24 : STA $00
    .doneWithZ
    LDA $0385, X : BEQ +
        JML FixHookshotY.ReturnPoint
    +
JML FixHookshotY.BranchPoint

; When the hookshot's chain is drawn,
; the bits that are too close to Link
; are ommited. Below we recalculate
; the hookshot's Y coordinate without
; the changes from the height so it
; can do proper collision checking
; with Link.
FixHookshotY2:
    LDA $24 : CMP #$FFFF : BNE .hasZ
        LDA $00
        BRA .done
    .hasZ
        LDA $00
        CLC : ADC $24
    .done
    CLC : ADC #$0004
    STA $72
RTL

; Fix the boomerang being mispositioned when used during
; a jump, specifically the part in the animation where
; it's held in Link's hand. This changes the boomerang
; draw logic to always use Link's current coordinates,
; instead of using a cached value. It also, of course,
; adjusts the Y coordinate with Link's height off the
; ground. `.typical_y_offsets` and `typical_x_offsets`
; are copied verbatim from the disassembly.
UpdateHeldBoomerangCoords:
    PHB : PHK : PLB
    REP #$20
    LDY $2F
    LDA $24 : CMP #$FFFF : BNE .hasZ
        LDA $20
        BRA .afterZ
    .hasZ
        LDA $20
        SEC : SBC $24
    .afterZ
        CLC : ADC #$0008
        CLC : ADC .typical_y_offsets, Y
        STA $00

    LDA $22 : CLC : ADC .typical_x_offsets, Y : STA $02
    SEP #$20
    PLB

    JSL Ancilla_SetCoordsLong

    LDA $4D : BNE +
        JML UpdateHeldBoomerangCoords.JustDraw
    +
JML UpdateHeldBoomerangCoords.ReturnPoint

.typical_y_offsets
    dw -10,  -8,  -9,  -9, -10,  -8,  -9,  -9

.typical_x_offsets
    dw  -9,  11,   8,  -8, -10,  11,   8,  -8


; Have the boomerang start at Link's height off the ground
; when thrown.
FixBoomerangY:
    LDA $24 : CMP #$FFFF : BEQ .noZ
        LDA $20
        CLC : ADC #$0008
        CLC : ADC $90DC, Y
        SEC : SBC $24
        STA $00
        JML FixBoomerangY.ReturnPoint
    .noZ
        LDA $20
        CLC : ADC #$0008
        CLC : ADC $90DC, Y
        STA $00
JML FixBoomerangY.ReturnPoint

; Update the little sparkles from Link's sword
; to match his height off the ground. Only
; applicable to Master Sword and up.
SetYCoordinateForSwingSparkle:
    LDA $20 : CLC : SBC $24 : STA $0BFA, X
    LDA $21 : SBC $25 : STA $0C0E, X
JML SetYCoordinateForSwingSparkle.ReturnPoint

CheckIfSmallShadow:
    LDA !IsJumping : BNE +
    LDA $4D : BNE +
        JML CheckIfSmallShadow.No
    +
    LDA $4D
JML CheckIfSmallShadow.Yes

; Update the the tip of Link's sword
; to match his height off the ground.
; Only applicable to Master Sword and up.
AddExtendedSwordXYToOam:
    LDA $24 : CMP #$FFFF : BEQ +
        SEP #$20
        LDA $0A : STA $0800, X
        LDA $0B : SEC : SBC $24 : STA $0801, X
        REP #$20
        RTL
    +
    LDA $0A
    STA $0800, X
RTL

; Called every frame to check that the conditions to
; start a jump are met. In essence, they are:
;     * Link is not already jumping or stunned
;     * Link is in a ground state
;     * Link has the Gravity Ring (or is a bunny with the appropriate setting)
;     * The R button was pressed this frame
;
CheckJumpButtonPress:
    LDA $46 : BEQ .canMove ; stun countdown different than 0
        RTL
    .canMove

    if !AllowCutsceneJump == 0
        LDA $02E4 : BEQ .notInCutscene
            RTL
        .notInCutscene
    endif

    LDA $F6 : AND #$10 : BNE .pressingR
        RTL
    .pressingR

    if !AllowBunnyJump == !AllowBunnyJump_Always
        LDA $5D
        CMP #$17 : BEQ .canJump ; permabunny = can jump
        CMP #$1C : BEQ .canJump ; temporary bunny = can jump
    endif

    LDA !GravityRingFlag : BNE .hasGravityRing
        RTL
    .hasGravityRing

    LDA $5D : BEQ .canJump ; normal state = can jump
    CMP #$11 : BEQ .canJump ; dashing = can jump

    if !AllowBunnyJump == !AllowBunnyJump_WithRing
        CMP #$17 : BEQ .canJump ; permabunny = can jump
        CMP #$1C : BEQ .canJump ; temporary bunny = can jump
    endif

    CMP #01 : BNE .cannotMove         ; all other states other than being
    LDA $5B : CMP #02 : BCC .canJump  ; close to a hole means we can't jump
    .cannotMove
        RTL
    .canJump
    LDA $5E : CMP #$10 : BNE .notDashing
        PHB : PHK : PLB
        LDA $26 : ASL : ASL : TAX
        BRA .loadValues
    .notDashing
        PHB : PHK : PLB
        LDA $F0 : ASL : ASL : TAX
    .loadValues
        LDA .values+0, X : AND #$0F : STA !JumpNonStartingDirections
        LDA .values+0, X : LSR #$04 : STA !JumpDirectionType
        LDA .values+1, X : AND #$0F : STA !JumpForwardDirection
        LDA .values+1, X : LSR #$04 : STA !JumpInverseDirection
        LDA .values+2, X : STA $27
        LDA .values+3, X : STA $28

        STZ $0351 ; Remove water/grass effects

        ; use dash jump speed/distance if we're dashing
        LDA $5E : CMP #$10 : BNE +
            JSL Player_HaltDashAttackLong
            LDA $27 : BEQ .x
            BPL .positiveY
            ;.negativeY
                LDA #-!JumpDistanceDash : STA $27
                BRA .x
            .positiveY
                LDA #!JumpDistanceDash : STA $27

            .x
            LDA $28 : BEQ +
            BPL .positiveX
            ;.negativeX
                LDA #-!JumpDistanceDash : STA $28
                BRA +
            .positiveX
                LDA #!JumpDistanceDash : STA $28
        +

        ; Update Link's sprite
        LDA $50 : BNE .doneWithSprite
        LDA $2E ; Link's animation frame
        BEQ .stationarySprite
            ; When moving, alternate between animation frames
            ; 3,4 and 7,8.
            JSL GetRandomInt : AND #$01 : STA $00
            LDA !JumpFrame : AND #$01 : ASL : CLC : ADC $00
            TAX : LDA .moving_jump_sprites, X : STA $2E
            %M_INC(!JumpFrame,0)
            BRA .doneWithSprite
        .stationarySprite
            ; When stationary, use a random animation frame
            ; from 3, 4, 7, and 8.
            JSL GetRandomInt : AND #$03 : TAX
            LDA .stationary_jump_sprites, X : STA $2E
        .doneWithSprite

        if !PushOutOfDoorway != 0
            LDA $2F : BNE + ; if facing up
            LDA $6C : CMP #$01 : BNE + ; if in a vertical doorway
                REP #$20
                DEC $20 ; Move three pixels up
                DEC $20 ; ^
                DEC $20 ; ^
                SEP #$20
                STZ $6C ; No longer in a doorway
            +
        endif


        if !AllowBunnyJump != !AllowBunnyJump_Never
            LDA $5D : CMP #$12 : BCS .isBunny
                STZ $5D
            .isBunny
        else
            STZ $5D
        endif

        STZ $5E ; reset link's speed
        STZ $5B ; reset link's state
        LDA #$01 : STA !IsJumping
        LDA #$20 : STA $46
        LDA #$00 : STA !JumpTimer
        PLB
RTL
    .moving_jump_sprites
        db $03, $04, $07, $08

    .stationary_jump_sprites
        db $07, $08, $03, $04

    .values
        ; 1.a. direction type (0=no movement, 1=horizontal, 2=vertical, 3=both)
        ; 1.b. non-starting directions
        ; 2.a. forward direction,
        ; 2.b. inverse direction,
        ; 3. vertical speed
        ; 4. horizontal speed
        db $0F, $00, $00, $00 ; no direction pressed
        db $1C, $21, $00, !JumpDistance ; right
        db $1C, $12, $00, -!JumpDistance ; left
        db $1C, $21, $00, !JumpDistance ; left/right
        db $23, $84, !JumpDistance, $00 ; down
        db $30, $A5, !JumpDistanceDiagonal, !JumpDistanceDiagonal ; down/right
        db $30, $96, !JumpDistanceDiagonal, -!JumpDistanceDiagonal ; down/left
        db $30, $A5, !JumpDistanceDiagonal, !JumpDistanceDiagonal ; down/left/right
        db $23, $48, -!JumpDistance, $00 ; up pressed
        db $30, $69, -!JumpDistanceDiagonal, !JumpDistanceDiagonal ; up/right
        db $30, $5A, -!JumpDistanceDiagonal, -!JumpDistanceDiagonal ; up/left
        db $30, $69, -!JumpDistanceDiagonal, !JumpDistanceDiagonal ; up/left/right
        db $23, $84, !JumpDistance, $00 ; up/down pressed
        db $30, $A5, !JumpDistanceDiagonal, !JumpDistanceDiagonal ; up/down/right
        db $30, $96, !JumpDistanceDiagonal, -!JumpDistanceDiagonal ; up/down/left
        db $30, $A5, !JumpDistanceDiagonal, !JumpDistanceDiagonal ; up/down/left/right


; Called when Link lands after a jump, and will make a noise
; depending on the surface he has landed on and the current settings.
MakeJumpNoise:
    LDA $5D
    BEQ .canHaveNoise
    CMP #$17 : BEQ .canHaveNoise
    CMP #$1C : BEQ .canHaveNoise
        RTS
    .canHaveNoise

    %AllowsLandingNoise2(Result, OnWater, OnGrass)
    if !Result != 0
        LDA $0351

        %AllowsLandingNoise(Result, OnWater)
        if !Result != 0
            CMP #$01 : BNE .notOnWater
                LDA #$1C : JSL Player_DoSfx2Long
                BRA .afterNoise
            .notOnWater
        endif

        %AllowsLandingNoise(Result, OnGrass)
        if !Result != 0
            CMP #$02 : BNE .notOnGrass
                LDA #$1A : JSL Player_DoSfx2Long
                BRA .afterNoise
            .notOnGrass
        endif
    endif

    %AllowsLandingNoise(Result, OnLand)
    if !Result != 0
        LDA #$21 : JSL Player_DoSfx2Long
        BRA .afterNoise
    endif

    .afterNoise
RTS

; Called every frame, advances the jump state
; and updates Link's state according to it.
ExecuteJump:
    LDA !IsJumping : BNE .dontSkipJump
    LDA !JumpTimer : BEQ .didntJustEndJump
        %M_STZ(!JumpTimer,0)
        if !LandingNoise != 0
            JSR MakeJumpNoise
        endif
    .didntJustEndJump
        RTL
    .dontSkipJump
        ; End jump state once timer reaches its end
            LDA !JumpTimer
            CMP #$1F : BNE .notFrameBeforeEnd
                LDA !JumpingAboveWater : BEQ +
                    ; A is 1
                    ; act as if we just bonked on a wall
                    STA $0351
                    STA $4D
                +
                BRA .dontEndJump
            .notFrameBeforeEnd
            CMP #$20 : BCC .dontEndJump
                %M_STZ(!IsJumping,0)
                STZ $24
                STZ $27
                STZ $28
                if !AllowCutsceneJump != 0
                    LDA $02E4 : BEQ .notInCutscene
                        STZ $46
                    .notInCutscene
                endif
                RTL
            .dontEndJump
            %M_INC(!JumpTimer,0)
            LDA #01 : STA $46

        ; Set Z coordinate
           PHB : PHK : PLB
           %M_LDX(!JumpTimer,0)
           LDA .z_coord, X : STA $24
           PLB

        ; Jump acceleration on non-starting directions
            LDA !JumpTimer : CMP #$19 : BCS .cannotAccelerate
            LDA $F0 : AND !JumpNonStartingDirections : BEQ +
                LDA !JumpDirectionType : AND #02 : BNE ++
                    LDA $F0 : AND #$04 : BEQ +++
                        LDA #$10 : STA $27
                        LDA !JumpForwardDirection : ORA #$04 : STA !JumpForwardDirection
                        LDA !JumpNonStartingDirections : AND #($0F-$0C)
                        STA !JumpNonStartingDirections
                        BRA ++
                    +++
                    LDA $F0 : AND #$08 : BEQ +++
                        LDA #-$10 : STA $27
                        LDA !JumpForwardDirection : ORA #$08 : STA !JumpForwardDirection
                        LDA !JumpNonStartingDirections : AND #($0F-$0C)
                        STA !JumpNonStartingDirections
                    +++
                ++
                LDA !JumpDirectionType : AND #01 : BNE ++
                    LDA $F0 : AND #$01 : BEQ +++
                        LDA #$10 : STA $28
                        LDA !JumpForwardDirection : ORA #$01 : STA !JumpForwardDirection
                        LDA !JumpNonStartingDirections : AND #($0F-$03)
                        STA !JumpNonStartingDirections
                        BRA ++
                    +++
                    LDA $F0 : AND #$02 : BEQ +++
                        LDA #-$10 : STA $28
                        LDA !JumpForwardDirection : ORA #$02 : STA !JumpForwardDirection
                        LDA !JumpNonStartingDirections : AND #($0F-$03)
                        STA !JumpNonStartingDirections
                    +++
                ++
            +
            .cannotAccelerate

        ; Calculate jump decceleration depending on current input
            LDX #$02
            LDA $F0 : AND !JumpInverseDirection : BEQ +
                INX
                INX
            +
            LDA $F0 : AND !JumpForwardDirection : BEQ +
                DEX
            +
            STX $00

        ;.verticalMovement
            LDA !JumpDirectionType : AND #02 : BEQ .horizontalMovement
            LDA $27
            BEQ .horizontalMovement
            BPL .verticalPositive
            ;.verticalNegative
                LDA $27 : CLC : ADC $00 : STA $27
                BRA .horizontalMovement
            .verticalPositive
                LDA $27 : SEC : SBC $00 : STA $27
        .horizontalMovement
            LDA !JumpDirectionType : AND #01 : BEQ .done
            LDA $28
            BEQ .done
            BPL .horizontalPositive
            ;.horizontalNegative
                LDA $28 : CLC : ADC $00 : STA $28
                BRA .done
            .horizontalPositive
                LDA $28 : SEC : SBC $00 : STA $28
    .done
RTL
  .z_coord
      db $02, $04, $06, $07, $09, $0A, $0B, $0C, $0D, $0E, $0F, $10, $10, $11, $11, $11
      db $11, $11, $11, $10, $10, $0F, $0E, $0D, $0C, $0B, $0A, $09, $07, $06, $04, $02
      db $00, $00, $00, $00, $00

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

; Power Rings

macro ExtraDamage(extra)
    LDA #<extra> : CLC : ADC $0CE2,X : BCC +
    LDA #$FF
    + STA $0CE2,X
endmacro

; Called right before any sprite's health has damaged subtracted from it.
; We add our extra damage from the power/sword ring here.
; Input:  $00 (damage)
; Output: $00 (damage + extra damage)
DamageSprite:
    LDA !PowerRingFlag : BEQ .afterExtraDamage
        CMP #01 : BNE .swordRing
        ;.powerRing
            %ExtraDamage(2)
            BRA .afterExtraDamage
        .swordRing
            %ExtraDamage(4)
    .afterExtraDamage
    LDA $0E50,X : STA $00
RTL

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

