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

