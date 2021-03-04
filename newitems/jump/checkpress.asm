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
        LDA .values+0, X : LSR #$04 : STA !JumpDirectionType
        LDA .values+1, X : AND #$0F : STA !JumpForwardDirection
        LDA .values+1, X : LSR #$04 : STA !JumpInverseDirection
        LDA .values+2, X : STA $27
        LDA .values+3, X : STA $28

        STZ $0351 ; Remove water/grass effects
        STZ $0430 ; Unpress buttons

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

