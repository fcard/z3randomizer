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

