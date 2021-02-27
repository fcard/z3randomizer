; Light Spin Attack Effect

!LightSpinSize = 32
!LightSpinDuration = $19

AncillaExt_AddLightSpin:
    LDA #$45
    JSL AddAncillaLong : BCS .noOpenSlots
        LDA #$00 : STA $0BF0, X ; Color (0 = Yellow, 1 = Blue)
        LDA #$00 : STA $0C54, X ; Executing Final Spark (1 = Yes, 0 = No)
        LDA #$00 : STA $0C5E, X ; Increasing timer for the spin animation

        LDA #$01 : STA $0C68, X ; For the spin animation, used to advance the
                                ; animation only when the game is not paused.
                                ; Used as an actual timer for the closing spark.
    .noOpenSlots
RTL

; Main routine of the Light Spin, the effect
; the Light Ring adds to the spin attack.
AncillaExt_LightSpin:
    LDA $0C54, X : BNE .closingSpark
        JSR AncillaExt_LightSpinSp
        BRA .done
    .closingSpark
        JSR AncillaExt_LightSpinClosingSpin
    .done
JML AncillaExt_Return

; Spin part of the animation
AncillaExt_LightSpinSp:
    LDA $0C5E, X : CMP #!LightSpinDuration : BCC .dontClose
        LDA #$01 : STA $0C54, X ; Change state to the closing spark
        LDA #$04 : STA $0C68, X ; Set duration to 4 frames
        RTS

    .dontClose
         PHB : PHK : PLB
         PHY : PHX

         ASL : STA $00 ; The value currently in $00 is the value used to index into
                       ; the x and y offset tables. It will switch locations between
                       ; $00 and the X register.
                       ; This value is calculated by taking the current frame
                       ; of the animation and multiplying it by two. As we will
                       ; draw a few sprites in different points of the spin,
                       ; we will increment this value between each draw.


         ; This blocks the animation timer from being incremented until
         ; the ancilla timer is decremented. This keeps it from increasing
         ; while the game is paused.
         LDA $0C68, X : BNE +
             LDA #$01 : STA $0C68, X
             INC $0C5E, X
             BRA +
         +

         ; Prepare the state for the draw loop.
         ; The next value in the stack will be the index of the
         ; sprite table, '.spark_char'.
         LDX #$00 : PHX
         LDY #$00 ; Y is the index into the OAM buffer

         .drawSpark ; start of the draw loop. We will draw 4 sprites,
                    ; each further in the spin animation.

         LDX $00 ; Load x/y offset index. This will remain in the
                 ; X register until later in the iteration, where
                 ; it will be restored to the $00 address.

         ; If we're past the end of the x/y offset tables, we end the loop now.
         CPX #(!LightSpinDuration*2) : BCS .doneDrawing

         REP #$20

         ; Calculate x/y coordinates of sprites by calculating Link's
         ; coordinates relative to the screen, then adding the offsets.
         LDA $20 : SEC : SBC $E8 : CLC : ADC .y_offsets, X : STA $00
         LDA $22 : SEC : SBC $E2 : CLC : ADC .x_offsets, X : STA $02

         SEP #$20
         JSL Ancilla_SetSafeOam_XY_Long

         STX $00 ; as promised, set $00 once again to the index of the x/y offset tables
         INC $00 ; increment $00 to the position of the next sprite. Note that we
         INC $00 ; don't bring this change back to the timer.

         PLX ; Load the sprite index
         LDA .spark_char, X : STA ($90), Y : INY

         ; Set the color properties of the sprite, then switch
         ; the color variable to the alternate for the next frame.
         LDA $0BF0, X : BEQ .blue
             LDA #$22 : STA ($90), Y : INY
             LDA #$00 : STA $0BF0, X
             BRA .doneColors
         .blue
             LDA #$24 : STA ($90), Y : INY
             LDA #$01 : STA $0BF0, X
         .doneColors

         ; Set high oam values (always 0x00)
         PHY : %AncillaExt_CalculateHiOamIndex()
         LDA #$00 : STA ($92), Y
         PLY

         INX : PHX ; increment sprite index
         CPX #04 : BCC .drawSpark ; do while sprite index < 4

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

; Final spark after the spin animation: A larger spark that lingers for a few frames
AncillaExt_LightSpinClosingSpin:
    LDA $0C68, X : BNE .dontTerminate
        STZ $0C4A, X ; terminate object
        RTS

    .dontTerminate
         PHX
         PHB : PHK : PLB

         ; The spark is yellow for the first two frames, (timer is 4,3)
         ; and blue for the last two (timer is 2,1).
         LDA $0C68, X : CMP #$03 : BCC .blue
         ;.yellow
             LDA #$02 : STA $04
             BRA .doneColors
         .blue
             LDA #$04 : STA $04
         .doneColors

         REP #$20
         ; Calculate Y coordinate: Final position of the spin animation
         ; but a little up.
         LDA $20 : SEC : SBC $E8 : SEC : SBC #$0008
         CLC : ADC AncillaExt_LightSpinSp_y_offsets+((!LightSpinDuration-1)*2)
         STA $00

         ; Calculate X coordinate: Final position of the spin animation
         ; but a little to the left.
         LDA $22 : SEC : SBC $E2 : SEC : SBC #$0004
         CLC : ADC AncillaExt_LightSpinSp_x_offsets+((!LightSpinDuration-1)*2)
         STA $02
         SEP #$20

         ; The final graphic is 16x16, but it is actually a single
         ; 8x8 sprite flipped in different ways, so we must draw
         ; 4 sprites.

         ; Draw top left sprite
         LDY #$00
         JSL Ancilla_SetSafeOam_XY_Long
         LDA #$D6 : STA ($90),Y : INY
         LDA #$20 : ORA $04 : STA ($90),Y
         LDA #$00 : STA ($92)

         ; Draw bottom left sprite
         REP #$20
         LDA $00 : CLC : ADC #$0008 : STA $00
         SEP #$20

         LDY #$04
         JSL Ancilla_SetSafeOam_XY_Long
         LDA #$D6 : STA ($90),Y : INY
         LDA #$A0 : ORA $04 : STA ($90),Y
         LDY #$01 : LDA #$00 : STA ($92), Y

         ; Draw bottom right sprite
         REP #$20
         LDA $02 : CLC : ADC #$0008 : STA $02
         SEP #$20

         LDY #$08
         JSL Ancilla_SetSafeOam_XY_Long
         LDA #$D6 : STA ($90),Y : INY
         LDA #$E0 : ORA $04 : STA ($90),Y
         LDY #$02 : LDA #$00 : STA ($92), Y

         ; Draw top right sprite
         REP #$20
         LDA $00 : SEC : SBC #$0008 : STA $00
         SEP #$20

         LDY #$0C
         JSL Ancilla_SetSafeOam_XY_Long
         LDA #$D6 : STA ($90),Y : INY
         LDA #$60 : ORA $04 : STA ($90),Y
         LDY #$03 : LDA #$00 : STA ($92), Y

         PLB : PLX
RTS

