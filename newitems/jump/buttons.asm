; Handle collision detection with buttons
macro CheckJumpingAboveButton(return)
    LDA !IsJumping : BNE .branch
    LDA $4D : BNE .branch
        JML <return>
    .branch
        JML CheckJumpingAboveButton.BranchPoint
endmacro

CheckJumpingAboveButton:
    %CheckJumpingAboveButton(.returnPoint)

CheckJumpingAboveButton2:
    %CheckJumpingAboveButton(.returnPoint)

