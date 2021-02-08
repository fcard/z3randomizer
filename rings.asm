; Data
RingsEnabled:
    db 01 ; 00 - Rings disabled, 01 - Rings Enabled

; Properties for sprites for new items:
; 0000000F
; |||||||'--1 = Is Fire / 0 = Isn't Fire
; ||||||'---Unused
; |||||'---Unused
; ||||'---Unused
; |||'---Unused
; ||'---Unused
; |'---Unused
; '---Unused
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
    db $00, $00, $00, $00
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
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00

    ; 0x80-0x8F
    db $00, $00, $00, $00
    db $00, $00, $00, $00
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
    db $00, $00, $00, $00
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
!SpikeDamage = $7FFFF9

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

function item_locx(lc) = 3+(2*lc)

macro RemoveMenuItemSprite(lc)
    %RemoveMenuSprite16x16(item_locx(<lc>), 3, 0)
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
    %RemoveRing(6)

    LDX #$0000
    SEP #$30
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
   LDA !RupeeRingFlag : AND #$00FF : BEQ + ; check if we have the rupee ring
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
    LDA !RupeeRingFlag : AND #$00FF : BEQ + ; check if we have the rupee charm
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

macro BranchIfGreaterOrEqual(minimum, address)
    if <minimum> == 0
        BNE <address>
    else
        CMP #<minimum> : BCS <address>
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
    if !DiminishingEffect != 0
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

BombDamage:
    LDA #1 : STA !BombDamage
    LDA $7EF35B : TAY
    LDA $980B, Y : STA $0373
RTL

GeneralDamage:
    PHA
    LDA.l !SpriteProp, X : AND #$01 : BEQ .notFire
        LDA #1 : STA !FireDamage
    .notFire
    PLA
    JSL.l LoadModifiedArmorLevel
RTL

SpikeDamage:
    LDA #1 : STA !SpikeDamage
    LDA $7EF35B : TAY
    ;LDA $????, Y : STA $0373
RTL

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
        .swordRing
            %ExtraDamage(4)
    .afterExtraDamage
    LDA $0E50,X : STA $00
RTL

DamagingSpecialItem:
    CMP #02 : BNE .isntSwordBeam
        LDA !LightRingFlag : BEQ +
            PHB : LDA.b #bank(SwordSlashDamageTable) : PHA : PLB
            PHX : LDA $7EF35A : TAX : LDA SwordSlashDamageTable, X : ASL
            PLX : PLB
            JML PlayerWeaponDealDamage.notZeroDamageType
        +
            LDA #01
    .isntSwordBeam
RTL





