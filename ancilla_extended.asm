; This table contains the banks of the subroutines called each frame
; for every ancilla object active. All original ones use
; 0x08, the point of this table is for new ones, or in case
; we change where a subroutine points.
AncillaRoutineBanks:
; Original Effects
    db bank(Ancilla_SomarianBlast)
    db bank(Ancilla_FireShot)
    db bank(Ancilla_Unknown)
    db bank(Ancilla_BeamHit)
    db bank(Ancilla_Boomerang)
    db bank(Ancilla_WallHit)
    db bank(Ancilla_Bomb)

    db bank(Ancilla_DoorDebris)
    db bank(Ancilla_Arrow)
    db bank(Ancilla_HaltedArrow)
    db bank(Ancilla_IceShot)
    db bank(Ancilla_SwordBeam)
    db bank(Ancilla_SwordFullChargeSpark)
    db bank(Ancilla_Unused_)
    db bank(Ancilla_Unused_)

    db bank(Ancilla_Unused_)
    db bank(Ancilla_IceShotSpread)
    db bank(Ancilla_Unused_)
    db bank(Ancilla_IceShotSparkle)
    db bank(Ancilla_Unknown2)
    db bank(Ancilla_JumpSplash)
    db bank(Ancilla_HitStars)
    db bank(Ancilla_ShovelDirt)

    db bank(Ancilla_EtherSpell)
    db bank(Ancilla_BombosSpell)
    db bank(Ancilla_MagicPowder)
    db bank(Ancilla_SwordWallHit)
    db bank(Ancilla_QuakeSpell)
    db bank(Ancilla_DashTremor)
    db bank(Ancilla_DashDust)
    db bank(Ancilla_Hookshot)

    db bank(Ancilla_BedSpread)
    db bank(Ancilla_SleepIcon)
    db bank(Ancilla_ReceiveItem)
    db bank(Ancilla_MorphPoof)
    db bank(Ancilla_Gravestone)
    db bank(Ancilla_Unknown3)
    db bank(Ancilla_SwordSwingSparkle)
    db bank(Ancilla_TravelBird)

    db bank(Ancilla_WishPondItem)
    db bank(Ancilla_MilestoneItem)
    db bank(Ancilla_InitialSpinSpark)
    db bank(Ancilla_SpinSpark)
    db bank(Ancilla_SomarianBlock)
    db bank(Ancilla_SomarianBlockFizzle)
    db bank(Ancilla_SomarianBlockDivide)
    db bank(Ancilla_LampFlame)

    db bank(Ancilla_InitialCaneSpark)
    db bank(Ancilla_CaneSpark)
    db bank(Ancilla_BlastWallFireball)
    db bank(Ancilla_Unused_)
    db bank(Ancilla_SkullWoodsFire)
    db bank(Ancilla_SwordCeremony)
    db bank(Ancilla_Unknown4)
    db bank(Ancilla_Flute)
    ;db bank(Ancilla_WeathervaneExplosion)

    db bank(Ancilla_TravelBirdIntro)
    db bank(Ancilla_SomarianPlatformPoof)
    db bank(Ancilla_SuperBombExplosion)
    db bank(Ancilla_VictorySparkle)
    db bank(Ancilla_SwordChargeSpark)
    db bank(Ancilla_ObjectSplash)
    db bank(Ancilla_RisingCrystal)
    db bank(Ancilla_BushPoof)

    db bank(Ancilla_DwarfPoof)
    db bank(Ancilla_WaterfallSplash)
    db bank(Ancilla_HappinessPondRupees)
    db bank(Ancilla_BreakTowerSeal)

; New Effects
    db bank(AncillaExt_Example)
    db bank(AncillaExt_LightSpin)


; This table contains the word addresses of the subroutines called each frame
; for every ancilla object active.
AncillaRoutines:
; Original Effects
    dw Ancilla_SomarianBlast
    dw Ancilla_FireShot
    dw Ancilla_Unknown
    dw Ancilla_BeamHit
    dw Ancilla_Boomerang
    dw Ancilla_WallHit
    dw Ancilla_Bomb

    dw Ancilla_DoorDebris
    dw Ancilla_Arrow
    dw Ancilla_HaltedArrow
    dw Ancilla_IceShot
    dw Ancilla_SwordBeam
    dw Ancilla_SwordFullChargeSpark
    dw Ancilla_Unused_
    dw Ancilla_Unused_

    dw Ancilla_Unused_
    dw Ancilla_IceShotSpread
    dw Ancilla_Unused_
    dw Ancilla_IceShotSparkle
    dw Ancilla_Unknown2
    dw Ancilla_JumpSplash
    dw Ancilla_HitStars
    dw Ancilla_ShovelDirt

    dw Ancilla_EtherSpell
    dw Ancilla_BombosSpell
    dw Ancilla_MagicPowder
    dw Ancilla_SwordWallHit
    dw Ancilla_QuakeSpell
    dw Ancilla_DashTremor
    dw Ancilla_DashDust
    dw Ancilla_Hookshot

    dw Ancilla_BedSpread
    dw Ancilla_SleepIcon
    dw Ancilla_ReceiveItem
    dw Ancilla_MorphPoof
    dw Ancilla_Gravestone
    dw Ancilla_Unknown3
    dw Ancilla_SwordSwingSparkle
    dw Ancilla_TravelBird

    dw Ancilla_WishPondItem
    dw Ancilla_MilestoneItem
    dw Ancilla_InitialSpinSpark
    dw Ancilla_SpinSpark
    dw Ancilla_SomarianBlock
    dw Ancilla_SomarianBlockFizzle
    dw Ancilla_SomarianBlockDivide
    dw Ancilla_LampFlame

    dw Ancilla_InitialCaneSpark
    dw Ancilla_CaneSpark
    dw Ancilla_BlastWallFireball
    dw Ancilla_Unused_
    dw Ancilla_SkullWoodsFire
    dw Ancilla_SwordCeremony
    dw Ancilla_Unknown4
    ;dw Ancilla_WeathervaneExplosion
    dw Ancilla_Flute

    dw Ancilla_TravelBirdIntro
    dw Ancilla_SomarianPlatformPoof
    dw Ancilla_SuperBombExplosion
    dw Ancilla_VictorySparkle
    dw Ancilla_SwordChargeSpark
    dw Ancilla_ObjectSplash
    dw Ancilla_RisingCrystal
    dw Ancilla_BushPoof

    dw Ancilla_DwarfPoof
    dw Ancilla_WaterfallSplash
    dw Ancilla_HappinessPondRupees
    dw Ancilla_BreakTowerSeal

; New Effects
    dw AncillaExt_Example
    dw AncillaExt_LightSpin

; This table is the max amount of sprites an ancilla object
; can draw per frame times 4. Don't overdo it, or the sprites
; might flicker!
AncillaMaxSpriteCount:
; Original Effects
    db $08, $0C, $10, $10, $04, $10, $18
    db $08, $08, $08, $00, $14, $00, $10, $28
    db $18, $10, $10, $10, $0C, $08, $08, $50
    db $00, $10, $10, $08, $40, $00, $0C, $24
    db $10, $0C, $08, $10, $10, $04, $0C, $1C
    db $00, $10, $14, $14, $14, $10, $08, $20
    db $10, $10, $10, $04, $00, $80, $10, $04
    db $30, $14, $10, $00, $10, $00, $00, $08
    db $00, $10, $08, $78

; New Effects
    db $08, $10


AncillaExt_JumpToRoutine:
    PHB : PHK : PLB
    TAY
    DEY
    LDA AncillaRoutineBanks, Y : STA $02
    TYA : ASL A : TAY
    LDA AncillaRoutines+0, Y : STA $00
    LDA AncillaRoutines+1, Y : STA $01
    PLB
JML [$0000]

AncillaExt_LoadMaxSpriteCount:
    PHB : PHK : PLB
    LDA AncillaMaxSpriteCount-1, X
    PLB
RTL

function AncillaExt_CalculateHiOamIndex(index) = (index-4)>>2

macro AncillaExt_CalculateHiOamIndex()
    TYA : SEC : SBC #$04 : LSR #2 : TAY
endmacro

; -- Ancilla Example --

!AssembleExampleAncilla = 1 ; Boolean to enable assembling the subroutines
                            ; for the Example ancilla object.
                            ; 1 = Yes; 0 = No

if !AssembleExampleAncilla != 0
AncillaExt_AddExample: ; Subroutine to create ancilla object
    LDA #$44 ; `A` register must be the ancilla object's id/index
    JSL AddAncillaLong ; Call this to actually create the object
    BCS .noOpenSlots ; Upon calling AddAncillaLong, Carry will be set to one if no
                     ; slots are available. There are 10* slots available at a time.

   ; On Success, the X register will be set to the slot carrying the object.
   ; We can now use it to set certain memory locations reserved for ancilla objects.

   LDA #$80 : STA $0BF0, X ; Like this one
   LDA #$40 : STA $0C54, X ; Or this
   LDA #$20 : STA $0C5E, X ; Or this
   LDA #$10 : STA $0C72, X ; Or this

   ; For the purposes of this example, we will get a random value between 0 and 7
   ; into one of our general purpose memory locations.

   JSL GetRandomInt : AND #$07 : STA $0BF0, X

   ; We can also use this special memory location;
   ; it's a timer that automatically decrements each frame!
   ; It will stop at zero, and start again once a new value is set.
   LDA #$78 : STA $0C68, X

   ; Once the object is created, the subroutine associated with it will be called
   ; periodically. What subroutine that is can be set with the tables at the start of
   ; this file! Remember to put your new ones at the end or it will break the game.
   ; You also need to add an entry to AncillaMaxSpriteCount, the third table above;
   ; see it for more details. Now, see the subroutine AncillaExt_Example for more!

   .noOpenSlots
   ; Remember to put all cleanups within the case where no open slots were available!
RTL
;*Ancilla slots are complicated, see: https://alttp-wiki.net/index.php/Ancilla_glitches
; archive: https://web.archive.org/web/20191104142903/https://alttp-wiki.net/index.php/Ancilla_glitches
; Note that as long as you don't use special memory locations designed
; for specific slots, you don't need to check which slot you're on.
; All the ones listed above are available for all 10 slots.

AncillaExt_Example: ; Subroutine called for every Example ancilla object
    ; We again have `X` set to the slot our object is in,
    ; so we can access the memory locations we set in
    ; the Add function, among other things.

    LDA $0C68, X : BNE .dontTerminate ; Each Example object will exist for 120 frames
        STZ $0C4A, X ; This will terminate the ancilla object
                     ; If you're wondering what's in $0C4A, X, it's the object's id,
                     ; and "0" means "no object."

    .dontTerminate
    ; Here, we will draw a random sprite above link.
    ; It has to be different but stay the same for each individual object,
    ; which is why we generated a number at the Add function, which we will
    ; now use to pick and draw the sprite.

    REP #$20

    LDA $20 : SEC : SBC $E8 ; Get link's Y coordinate on the screen
    SEC : SBC #$0010 : STA $00 ; $00 will be used as the sprite's Y coordinates

    LDA $22 : SEC : SBC $E2 ; Get link's X coordinate on the screen
    CLC : ADC #$0004 : STA $02 ; $02 will be used as the sprite's X coordinates

    SEP #$20

    PHX

    PHB : PHK : PLB
    LDA $0BF0, X : TAX ; Load up our random number so we can index our tables

    LDA .y_offset, X : CLC : ADC $00 : STA $00 ; Add Y offset (tables are below)
    LDA .x_offset, X : CLC : ADC $02 : STA $02 ; Add X offset

    LDY #$00 ; OAM Buffer index; since this is the sprite we will draw,
             ; it should be 0
    JSL Ancilla_SetSafeOam_XY_Long ; We can optionally use this function to write the
                                   ; x and y coordinates of our sprites to OAM. It
                                   ; reads $00 as x, $02 as y, and the `Y` register
                                   ; to index into the OAM buffer. The advantage
                                   ; of using this routine instead of doing it
                                   ; ourselves is that this will do a boundscheck
                                   ; for us, handling offscreen sprites.
                                   ;
                                   ; Side note: Ancilla_SetOam_XY_Long is
                                   ; similar to this routine but it doesn't
                                   ; handle offscreen object as well and it
                                   ; won't fix the bank pointer
                                   ; (and consequently will break if it was changed!)

    LDA .sprite, X ; Load character table information

    STA ($90), Y : INY ; write character table data to the OAM buffer.

    ; Same as above, with sprite properties
    LDA .properties, X : STA ($90), Y

    ; write final data to high bytes in OAM
    LDA .extended, X : STA ($92)

    ; Now, if the sprite has a bottom part, we draw it,
    ; otherwise we cleanup and end the routine
    LDA .has_bottom_sprite, X : BEQ .done

    ; Draw bottom sprite!
    LDY #$04 ; Starting at OAM buffer index 4 (add 4 for each sprite)
    LDA $00 : CLC : ADC #$08 : STA $00 ; We use the same coordinates
    JSL Ancilla_SetSafeOam_XY_Long     ; but shift y down a little

    LDA .bottom_sprite, X : STA ($90), Y : INY
    LDA .properties, X : STA ($90), Y
    LDA .extended, X : LDY #$01 : STA ($92), Y
    ; when setting $92, you add 1 per sprite,
    ; instead of 4. We can use the utility
    ; function AncillaExt_CalculateHiOamIndex(index)
    ; to generate a high index from a low index,
    ; or the macro %AncillaExt_CalculateHiOamIndex()
    ; if your index is dynamically generated;
    ; for the latter,  remember to push your `Y`
    ; register to the stack beforehand if you
    ; need it later!

    ; We're done!
    ; Setting values to ($90) with the appropriate index is
    ; enough to draw sprites into the game, the engine will
    ; handle the rest. If you're sure you did that correctly
    ; and the sprites are flickering or otherwise glitching,
    ; make sure you setup the values at AncillaMaxSpriteCount
    ; correctly for your ancilla object.

.done
    ; Cleanup
    PLB : PLX ; We must return `X` to its original state at the end of the routine
JML AncillaExt_Return ; End with this always! Since we arrived with a jump, we must jump
                      ; back to the original bank so it can return locally with an RTS.

; Sprites, in order:
; Big Magic, Apple, Heart, Fairy, Key, Bomb, Arrow, Rupee

.y_offset
    db   0,   0,   8,   0,   0,   0,   0,  0

.x_offset
    db   0,  -4,   0,  -4,   0,  -4,   0,  0

.sprite
    db $62, $E5, $29, $EA, $6B, $6E, $63, $0B

.properties
    db $28, $22, $22, $28, $28, $24, $24, $22

.extended
    db $00, $02, $00, $02, $00, $02, $00, $00

.has_bottom_sprite
    db $01, $00, $00, $00, $01, $00, $01, $01

.bottom_sprite
    db $72, $00, $00, $00, $7B, $00, $73, $1B


else
AncillaExt_AddExample:
RTL

AncillaExt_Example:
    STZ $0C4A, X
JML AncillaExt_Return
endif


; Light Spin Attack Effect

!LightSpinSize = 32
!LightSpinDuration = $19

AncillaExt_AddLightSpin:
    LDA #$45
    JSL AddAncillaLong : BCS .noOpenSlots
        LDA #$00 : STA $0BF0, X
        LDA #$00 : STA $0C54, X
        LDA #$00 : STA $0C5E, X
        LDA #$01 : STA $0C68, X
    .noOpenSlots
RTL

AncillaExt_LightSpin:
    LDA $0C54, X : BNE .closingSpark
        JSR AncillaExt_LightSpinSp
        BRA .done
    .closingSpark
        JSR AncillaExt_LightSpinClosingSpin
    .done
JML AncillaExt_Return

AncillaExt_LightSpinSp:
    LDA $0C5E, X : CMP #!LightSpinDuration : BCC .dontClose
        LDA #$01 : STA $0C54, X
        LDA #$04 : STA $0C68, X
        RTS

    .dontClose
         PHB : PHK : PLB
         PHY : PHX

         PHA
         ASL : STA $00
         LDA $0C68, X : BNE .dontIncrement
             LDA #$01 : STA $0C68, X
             PLA : INC : STA $0C5E, X
             BRA +
         .dontIncrement
             PLA
         +

         LDX #$00 : PHX
         LDY #$00

         .drawSpark

         LDX $00
         CPX #(!LightSpinDuration*2) : BCS .doneDrawing

         REP #$20

         LDA .y_offsets, X : STA $00
         LDA .x_offsets, X : STA $02

         LDA $20 : SEC : SBC $E8 : CLC : ADC $00 : STA $00
         LDA $22 : SEC : SBC $E2 : CLC : ADC $02 : STA $02

         SEP #$20
         JSL Ancilla_SetSafeOam_XY_Long

         STX $00
         INC $00
         INC $00
         PLX

         LDA .spark_char, X : STA ($90), Y : INY

         LDA $0BF0, X : BEQ .blue
             LDA #$22 : STA ($90), Y : INY
             LDA #$00 : STA $0BF0, X
             BRA .doneColors
         .blue
             LDA #$24 : STA ($90), Y : INY
             LDA #$01 : STA $0BF0, X
         .doneColors

         PHY : %AncillaExt_CalculateHiOamIndex()
         LDA #$00 : STA ($92), Y
         PLY

         INX : PHX
         CPX #04 : BCC .drawSpark

         .doneDrawing

         PLX : PLX : PLY
         PLB
RTS

.spark_char:
    db $83, $80, $B7, $D7

if !LightSpinSize == 32
.x_offsets:
    dw 8, 17, 24, 28, 30, 38, 34, 27, 18, 8, 8, -2, -11, -18, -22, -24
    dw -22, -18, -11, -2, 8, 18, 27, 34, 38
.y_offsets:
    dw 38, 34, 27, 18, 8, 8, -2, -11, -18, -22, -24, -22, -18, -11, -2, 8
    dw 18, 27, 34, 38, 40, 38, 34, 27, 18
elseif !LightSpinSize == 34
.x_offsets:
    dw 9, 18, 26, 30, 32, 40, 36, 28, 19, 8, 8, -3, -12, -20, -24, -26
    dw -24, -20, -12, -3, 8, 19, 28, 36, 40
.y_offsets:
    dw 40, 36, 28, 19, 8, 8, -3, -12, -20, -24, -26, -24, -20, -12, -3, 8
    dw 19, 28, 36, 40, 42, 40, 36, 28, 19
elseif !LightSpinSize == 36
.x_offsets:
    dw 9, 19, 27, 32, 34, 42, 37, 29, 19, 8, 8, -3, -13, -21, -26, -28
    dw -26, -21, -13, -3, 8, 19, 29, 37, 42
.y_offsets:
    dw 42, 37, 29, 19, 8, 8, -3, -13, -21, -26, -28, -26, -21, -13, -3, 8
    dw 19, 29, 37, 42, 44, 42, 37, 29, 19
elseif !LightSpinSize == 40
.x_offsets:
    dw 16, 28, 36, 42, 44, 47, 41, 33, 21, 9, 9, -3, -15, -23, -29, -31
    dw -29, -23, -15, -3, 9, 21, 33, 41, 47
.y_offsets:
    dw 47, 41, 33, 21, 9, 9, -3, -15, -23, -29, -31, -29, -23, -15, -3, 9
    dw 21, 33, 41, 47, 49, 47, 41, 33, 21
endif

AncillaExt_LightSpinClosingSpin:
    LDA $0C68, X : BNE .dontTerminate
        STZ $0C4A, X
        RTS

    .dontTerminate
         PHX
         PHB : PHK : PLB

         LDA $0C68, X : CMP #$03 : BCC .blue
         ;.yellow
             LDA #$02 : STA $04
             BRA .doneColors
         .blue
             LDA #$04 : STA $04
         .doneColors

         REP #$20
         LDA $20 : SEC : SBC $E8 : SEC : SBC #$0008
         CLC : ADC AncillaExt_LightSpinSp_y_offsets+((!LightSpinDuration-1)*2)
         STA $00

         LDA $22 : SEC : SBC $E2 : SEC : SBC #$0004
         CLC : ADC AncillaExt_LightSpinSp_x_offsets+((!LightSpinDuration-1)*2)
         STA $02
         SEP #$20

         LDY #$00
         JSL Ancilla_SetSafeOam_XY_Long
         LDA #$D6 : STA ($90),Y : INY
         LDA #$20 : ORA $04 : STA ($90),Y
         LDA #$00 : STA ($92)

         LDA $00 : CLC : ADC #$08 : STA $00

         LDY #$04
         JSL Ancilla_SetSafeOam_XY_Long
         LDA #$D6 : STA ($90),Y : INY
         LDA #$A0 : ORA $04 : STA ($90),Y
         LDY #$01 : LDA #$00 : STA ($92), Y

         LDA $02 : CLC : ADC #$08 : STA $02

         LDY #$08
         JSL Ancilla_SetSafeOam_XY_Long
         LDA #$D6 : STA ($90),Y : INY
         LDA #$E0 : ORA $04 : STA ($90),Y
         LDY #$02 : LDA #$00 : STA ($92), Y

         LDA $00 : SEC : SBC #$08 : STA $00

         LDY #$0C
         JSL Ancilla_SetSafeOam_XY_Long
         LDA #$D6 : STA ($90),Y : INY
         LDA #$60 : ORA $04 : STA ($90),Y
         LDY #$03 : LDA #$00 : STA ($92), Y

         PLB : PLX
RTS
