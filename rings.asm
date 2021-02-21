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

; Helper Variables
!UpdateRingGraphics = $7FFFFF
!RButtonHeld = $7FFFFE
!WhichMenu = $7FFFFD
!UpdateMenuRingGraphics = $7FFFFC
!BombDamage = $7FFFFB
!FireDamage = $7FFFFA
;!SpikeDamage = $7FFFF9
;!GarnishFire = $7FFFF8

; Ring Flags
!RupeeRingFlag = $7F6600
!GravityRingFlag = $7F6601
!FireRingFlag = $7F6602
!LightRingFlag = $7F6603
!PowerRingFlag = $7F6604
!GuardRingFlag = $7F6605

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

; Hook into the NMI function to move Ring sprites to VRAM

ExtraMenuNMIUpdate:
    SEP #$20

    LDA $10
    CMP #$07 : BEQ .handleJumping
    CMP #$09 : BEQ .handleJumping
        BRA .afterJumping
    .handleJumping
        SEP #$10
        JSL HandleJumping
        REP #$10
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
        LDA $07EF360 : CLC : ADC #$0005 ; Add 5 more
        RTL
    +
    LDA $07EF360
RTL


; Add rupees from chests to the total amount, handle Rupee Charm
AddChestRupees:
    ; Input: $00 = amount to add
    ; Output: A register = total rupees after addition
    LDA !RupeeRingFlag : AND #$00FF : BEQ + ; check if we have the rupee ring
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

; Gravity Ring Jump

; Settings

!AllowBunnyJump = 1 ; Bunny Link can jump with gravity ring (1=Yes, 0=No)

; Addresses

!JumpInverseDirection = $7C
!JumpForwardDirection = $7D
!JumpNonStartingDirections = $7E
!JumpDirectionType = $7F
!IsJumping = $80
!JumpTimer = $81
!JumpingAboveWater = $82
!JumpState = $83

; Constants

!JumpDistance = $30
!JumpDistanceDash = $60
!JumpDistanceDiagonal = $28

; Routines

HandleJumping:
    JSL CheckJumpButtonPress
    JSL ExecuteJump
RTL

StopJump:
    STZ !IsJumping
RTL

ChangeTrapDoorState:
    LDA !IsJumping : AND #$00FF : BNE +
        STX $0468
        STZ $068E
        JML ChangeTrapDoorState.ReturnPoint
    +
JML ChangeTrapDoorState.EndPoint

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

CacheStateForJump:
    LDA $1B : BNE +
    LDA !IsJumping : BNE +
        JSL Player_CacheStatePriorToHandler
    +
JML CacheStateForJump.ReturnPoint

CheckSoldierOnSameLayer:
    LDA !IsJumping : BNE +
        LDA $46 : ORA $4D
        RTL
    +
    LDA #$00
RTL

ResetHeightOnRecoil:
    LDA !IsJumping : BNE +
        STZ $24
        STZ $25
    +
RTL

FallIntoHole:
    LDA !IsJumping : BNE +
        LDA #$01 : STA $5B : STA $5D
    +
RTL

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

ResetZCoordinates:
    LDA !IsJumping : BNE +
        LDA #$FF : STA $24 : STA $25
    +
RTL

CheckYPress:
    LDA !IsJumping : BNE +
    LDA $46 : BEQ +
        JML CheckYPress.No
    +
JML CheckYPress.Continue

JumpLedge:
    LDA $4D : CMP #$01 : BNE +
        JML JumpLedge.BranchAlpha
    +
    LDA !IsJumping : BEQ +
        JML JumpLedge.BranchAlpha
    +
JML JumpLedge.ReturnPoint

FallFromLedge:
    LDA !IsJumping : BNE +
        LDA #$06 : STA $5D
    +
RTL

FallFromLedge2:
    LDA !IsJumping : BNE +
        LDA #$02 : STA $5D
    +
RTL

macro SetTileEffect(value)
    LDA !IsJumping : BNE +
        LDA #<value> : STA $0351
    +
    RTL
endmacro

SetGrassEffect:
    %SetTileEffect($02)

SetWaterEffect:
    %SetTileEffect($01)

SetWaterEffect2:
    LDA #$01 : STA !JumpingAboveWater
    %SetTileEffect($01)

RemoveWaterEffect:
    LDA #$00 : STA !JumpingAboveWater
    STZ $0351 ; thing we wrote over
    LDA $02EE ; ^
RTL

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


CheckJumpButtonPress:
    LDA !GravityRingFlag : BNE .hasGravityRing
        RTL
    .hasGravityRing

    LDA $F6 : AND #$10 : BNE .pressingR
        RTL
    .pressingR

    LDA $46 : BEQ .canMove ; stun countdown different than 0
        RTL
    .canMove

    LDA $5D : BEQ .canJump ; normal state = can jump
    CMP #$11 : BEQ .canJump ; dashing = can jump

    if !AllowBunnyJump != 0
        CMP #$17 : BEQ .canJump ; permabunny = can jump
        CMP #$1C : BEQ .canJump ; temporary bunny = can jump
    endif

    CMP #01 : BNE .cannotMove         ; all other states other than being
    LDA $5B : CMP #02 : BCC .canJump  ; close to a hole means we can't jump
    .cannotMove
        RTL
    .canJump
    LDA $5E : CMP #$10 : BNE .notDashing
        PHX : PHB : PHK : PLB
        LDA $26 : ASL : ASL : TAX
        BRA .loadValues
    .notDashing
        PHX : PHB : PHK : PLB
        LDA $F0 : ASL : ASL : TAX
    .loadValues
        LDA .distances+0, X : AND #$0F : STA !JumpNonStartingDirections
        LDA .distances+0, X : LSR #$04 : STA !JumpDirectionType
        LDA .distances+1, X : AND #$0F : STA !JumpForwardDirection
        LDA .distances+1, X : LSR #$04 : STA !JumpInverseDirection
        LDA .distances+2, X : STA $27
        LDA .distances+3, X : STA $28

        STZ $0351 ; Remove water/grass effects

        ; double jump speed/distance if we're dashing
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

        ; Update Link's sprite when it's stationary
        LDA $2E
        BEQ .stationarySprite
        CMP #$01 : BEQ .stationarySprite
        CMP #$05 : BEQ .stationarySprite
            BRA .dontChangeSprite
        .stationarySprite
            LDA #$03 : STA $2E
        .dontChangeSprite

        if !AllowBunnyJump != 0
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
        PLB : PLX
RTL
    .distances
        ; 1.a. direction type (0=no movement, 1=horizontal, 2=vertical, 3=both)
        ; 2.b. non-starting directions
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

ExecuteJump:
    PHX
    LDA !IsJumping : BNE .dontSkipJump
        PLX
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
                STZ !IsJumping
                STZ $46
                STZ $24
                STZ $27
                STZ $28
            .dontEndJump
            INC !JumpTimer

        ; Set Z coordinate
           PHB : PHK : PLB
           LDX !JumpTimer
           LDA .z_coord, X : STA $24
           PLB

        ; Jump acceleration on non-starting directions
            LDA $46 : CMP #$10 : BCC .cannotAccelerate
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
    PLX
RTL
  .z_coord
      db $02, $04, $06, $07, $09, $0A, $0B, $0C, $0D, $0E, $0F, $10, $10, $11, $11, $11
      db $11, $11, $11, $10, $10, $0F, $0E, $0D, $0C, $0B, $0A, $09, $07, $06, $04, $02
      db $00, $00, $00, $00, $00

; Guard/Fire Rings

!GuardRingDiminishingEffect = 0 ; Guard Ring effect goes down with armor upgrades (0:no, 1:yes)
!MinimumDamage = 01 ; Minimum damage after ring damage reduction

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

macro _DamageReduction(address, value, endpoint, branchendpoint)
    LDA <address> : SEC : SBC #<value>
    %BranchIfGreaterOrEqual(!MinimumDamage, <endpoint>)
    LDA #!MinimumDamage
    if <branchendpoint> != 0
        BRA <endpoint>
    endif
endmacro


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

BombDamage: ; called when link's bomb damages him
    LDA #1 : STA !BombDamage
    LDA $7EF35B : TAY
    LDA $980B, Y : STA $0373
RTL

GarnishFireDamage: ; used by Trinexx's and some of Ganon's fire
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


GarnishOnCollision: ; called when "garnish" objects hit Link,
                    ; like Aghanim's lightning trail or Trinexx's fire
    LDA !GarnishFire : BEQ +
        LDA #1 : STA !FireDamage
    +
    LDA #$10 : STA $46 ; thing we wrote over
RTL

GeneralDamage: ; When most things hit link
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

SwordDamageTable:
db 0, 2, 4, 8, 16

SwordBeamDamage:
     LDA !LightRingFlag : BEQ .noLightRing
         PHB : LDA.b #bank(SwordDamageTable) : PHA : PLB
         PHX : LDA $7EF359 : TAX : LDA SwordDamageTable, X
         PLX : PLB
         RTL
     .noLightRing
         LDA #02
RTL

macro SpinAttackHitBox(minusx,minusy,size)
    LDA $22 : SEC : SBC.b #<minusx> : STA $00
    LDA $23 : SBC.b #$00 : STA $08

    LDA $20 : SEC : SBC.b #<minusy> : STA $01
    LDA $21 : SBC.b #$00 : STA $09

    LDA.b #<size> : STA $02
    INC A       : STA $03
endmacro

SpinAttackHitBox:
    LDA !LightRingFlag : BEQ .noLightRing
        %SpinAttackHitBox($000E+6,$000A+6,$002C+12)
        RTL

    .noLightRing
        %SpinAttackHitBox($000E,$000A,$002C)
RTL


SpinAttackAnimationTimers:
    LDA !LightRingFlag : BEQ .noLightRing
        PHX
        JSL AncillaExt_AddLightSpin
        PLX
    .noLightRing
    LDA #$02 : STA $03B1, X
    LDA #$4C : STA $0C5E, X
    LDA #$08 : STA $039F, X
RTL
