;--------------------------------------------------------------------------------
; Decomp
;--------------------------------------------------------------------------------

org $00FDEE ; Mirror_InitHdmaSettings
    JML Mirror_InitHdmaSettingsAux
    DecompGfx:
        JSR Decomp.begin
    RTL

!LoadSpriteDirect = $7EFFE0

org $00E7B2 ; Decomp.spr_variable
    JSL DecompExtra
    BRA Decomp.begin

;--------------------------------------------------------------------------------
; Special Properties
;--------------------------------------------------------------------------------

org $0DB84D ; Set Special Sprite Properties
JSL SetSpriteProperties : NOP

;--------------------------------------------------------------------------------
; Rings
;--------------------------------------------------------------------------------
org $06F400 ; <- 37F400 - Bank06.asm : 5963 (CLC : ADC $7EF35B)
JSL.l GeneralDamage : NOP

org $0DDDC3 ; JSR DrawAbilityText
JSL DrawLowerItemBox
NOP #(2+3+3)

org $0DE346 ; JSL DrawMoonPearl
JSL RestoreNormalMenuAux
NOP #2

org $0DDF15 ; equipment.asm:450 - NormalMenu: INC $207 : LDA $F0
    JSL MenuLoop
    NOP

org $0DDEA5 ; equipment.asm:450 - NormalMenu: INC $207 : LDA $F0
    JSL NoEquip
    RTS

org $0DE7B6 ; change DrawAbilityText's RTS to a RTL
RTL

org $0DE819 ; change DrawAbilityIcons' RTS to a RTL
RTL

org $0DE9CC ; change DrawProgressIcons's RTS to a RTL
RTL

org $0DECE9
DrawMoonPearl:

org $0DED03 ; change DrawMoonPearl's RTS to a RTL
RTL

org $089900 ; ancilla_bomb:575 - Bomb_CheckSpriteAndPlayerDamage: LDA $7EF35B
JSL BombDamage
RTS

;01ec07

!DebugRingLocations = 1 ; Rings in Chests around the world (0=No, 1=Yes)
if !DebugRingLocations != 0
    ; Village Well Cave
    org $01EA91
    db $B9
    org $01EA94
    db $B9
    org $01EA97
    db $B0
    org $01EA9A
    db $B1

    ; Village Hideout
    org $01EB12
    db $B4
    org $01EB15
    db $BA
    org $01EB18
    db $BA
    org $01EB1B
    db $BB

    ; Castle
    org $01E971 ; Lamp Chest in castle basement
    db $BB
endif

;--------------------------------------------------------------------------------
; Rupee Ring
;--------------------------------------------------------------------------------
org $06D1D2 ; Rupees dropped in the world (ADC $7EF360)
JSL AddCollectedRupees

org $07BB6D ; Rupees from dungeon blue rupees
JSL AddDungeonRupees

org $07C5FA ; Rupees from dungeon blue rupees
JSL AddDungeonRupees

org $09ADA0 ; Rupees from chests
JSL AddChestRupees
NOP #3

org $05843F ; Rupees from arrow game (sprite_archery_game_guy.asm:424 : ADC $7EF360)
JSL AddCollectedRupees

;================================================================================

;--------------------------------------------------------------------------------
; Power Ring
;--------------------------------------------------------------------------------
org $06EF67 ; Damage to Sprites
JSL DamageSprite : NOP

;================================================================================

;--------------------------------------------------------------------------------
; Fire Ring
;--------------------------------------------------------------------------------
org $09B329 ; garnish_ganon_bat_flame_objects.asm:79 : LDA chr_indices, X
; routine: Garnish_GanonBatFlame (which is also used by Trinexx's fire)
; we move the rest of the routine here, as well as all of the routine's
; tables, because of the difficult of changing a single line but also to
; free space in bank $09.
JML GarnishFireDamage

org $09B284 ; garnish_ganon_bat_flame_objects.asm:8 : db $AC, $AE...
; Space freed from us moving the tables from Garnish_GanonBatFlame

Garnish_SetOamPropsAndLargeSizeLong:
   PHB : PHK : PLB
   JSR Garnish_SetOamPropsAndLargeSize
   PLB
RTL

; move the table Garnish_BabusuFlash.chr here so we
; have space after the subroutine that comes before
; it, Garnish_CheckPlayerCollision.
Garnish_BabusuFlash_chrNew:
    db $A8, $8A, $86, $86

warnpc $09B2B2 ; End of the freed space

org $09B459 ; garnish_lightning_trail.asm:50
Garnish_CheckPlayerCollision:

org $09B482 ; garnish_lightning_trail.asm:64 : LDA.b #$10 : STA $46
JSL GarnishOnCollision

org $09B495 ; garnish_lightning_trail.asm:71 : RTS
; end of Garnish_CheckPlayerCollision
LDA #00 : STA !GarnishFire
RTS

org $09B4B3  ; garnish_babusu_flash.asm:31 : LDA .chr, X
LDA Garnish_BabusuFlash_chrNew, X

org $09B70C ; garnish_mothula_beam_trail.asm:25
Garnish_SetOamPropsAndLargeSize:

;--------------------------------------------------------------------------------
; Light Ring
;--------------------------------------------------------------------------------
org $06F59A ; Spin Attack Hitbox
PLX : JSL SpinAttackHitBox
RTS

org $08D8BA
JSL SpinAttackAnimationTimers
BRA SpinAttackAnimationTimers.returnPoint
org $08D8C9
SpinAttackAnimationTimers.returnPoint:

;================================================================================


