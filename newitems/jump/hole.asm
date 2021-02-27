; Skip changing Link's state to "near a hole" if he
; is jumping, so his jump isn't cancelled.
FallIntoHole:
    LDA !IsJumping : BNE +
        LDA #$01 : STA $5B : STA $5D
    +
RTL


