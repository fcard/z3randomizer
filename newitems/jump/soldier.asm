; Skip part of the Soldier's layer check
; when jumping so that Link can attack
; them on midair.
CheckSoldierOnSameLayer:
    LDA !IsJumping : BNE +
        LDA $46 : ORA $4D
        RTL
    +
    LDA #$00
RTL

