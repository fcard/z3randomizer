; Allow jumping into outdoor stairs
CheckMidairBeforeEnteringStairs:
    LDA !IsJumping : BNE .branch
    LDA $46 : BEQ .branch
        JML CheckMidairBeforeEnteringStairs.Continue
    .branch
JML CheckMidairBeforeEnteringStairs.Branch

; Set outdoor stairs flag
SetOutdoorStairsState:
    LDA #1 : STA !OutdoorStairs
    LDA #2 : STA $5E ; thing we wrote over
RTL

; Set indoor stairs flag
SetIndoorStairsState:
    LDA #0 : STA !OutdoorStairs
    LDA #2 : STA $5E ; thing we wrote over
RTL

