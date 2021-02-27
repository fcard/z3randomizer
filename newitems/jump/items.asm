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

