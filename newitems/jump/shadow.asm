CheckIfSmallShadow:
    LDA !IsJumping : BNE +
    LDA $4D : BNE +
        JML CheckIfSmallShadow.No
    +
    LDA $4D
JML CheckIfSmallShadow.Yes

