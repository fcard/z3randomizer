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
            LDA !JumpTimer : CMP #$19 : BCC +
                BRL .cannotAccelerate
            +
            LDA !JumpDirectionType : AND #02 : BNE ++
                LDA $F0 : AND #$04 : BEQ +++
                    LDA #$10 : STA $27
                    LDA !JumpForwardDirection : ORA #$04 : STA !JumpForwardDirection
                    LDA !JumpInverseDirection : ORA #$08 : STA !JumpInverseDirection
                    LDA !JumpDirectionType    : ORA #$02 : STA !JumpDirectionType
                    BRA ++
                +++
                LDA $F0 : AND #$08 : BEQ +++
                    LDA #-$10 : STA $27
                    LDA !JumpForwardDirection : ORA #$08 : STA !JumpForwardDirection
                    LDA !JumpInverseDirection : ORA #$04 : STA !JumpInverseDirection
                    LDA !JumpDirectionType    : ORA #$02 : STA !JumpDirectionType
                +++
            ++
            LDA !JumpDirectionType : AND #01 : BNE ++
                LDA $F0 : AND #$01 : BEQ +++
                    LDA #$10 : STA $28
                    LDA !JumpForwardDirection : ORA #$01 : STA !JumpForwardDirection
                    LDA !JumpInverseDirection : ORA #$02 : STA !JumpInverseDirection
                    LDA !JumpDirectionType    : ORA #$01 : STA !JumpDirectionType
                    BRA ++
                +++
                LDA $F0 : AND #$02 : BEQ +++
                    LDA #-$10 : STA $28
                    LDA !JumpForwardDirection : ORA #$02 : STA !JumpForwardDirection
                    LDA !JumpInverseDirection : ORA #$01 : STA !JumpInverseDirection
                    LDA !JumpDirectionType    : ORA #$01 : STA !JumpDirectionType
                +++
            ++
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
            if !StatueSlowsJump != 0
                LDA $5E : CMP #$08 : BNE +
                    INX
                +
            endif
            STX $4202
            LDA #!JumpDeccel : STA $4203
        ;.verticalMovement
            LDA !JumpDirectionType : AND #02 : BEQ .horizontalMovement
            LDA $27
            BEQ .horizontalMovement
            BPL .verticalPositive
            ;.verticalNegative
                LDA $27 : CLC : ADC $4217 : STA $27
                BRA .horizontalMovement
            .verticalPositive
                LDA $27 : SEC : SBC $4217 : STA $27
        .horizontalMovement
            LDA !JumpDirectionType : AND #01 : BEQ .done
            LDA $28
            BEQ .done
            BPL .horizontalPositive
            ;.horizontalNegative
                LDA $28 : CLC : ADC $4217 : STA $28
                BRA .done
            .horizontalPositive
                LDA $28 : SEC : SBC $4217 : STA $28
    .done
RTL
  .z_coord
      db $02, $04, $06, $07, $09, $0A, $0B, $0C, $0D, $0E, $0F, $10, $10, $11, $11, $11
      db $11, $11, $11, $10, $10, $0F, $0E, $0D, $0C, $0B, $0A, $09, $07, $06, $04, $02
      db $00, $00, $00, $00, $00


