; Handle jumping over a button that requires
; Link to be standing on it.
ChangeTrapDoorState:
    CPX #$0000 : BNE .openDoor
    ;.closeDoor
    LDA !IsJumping : AND #$00FF : BEQ .openDoor
        LDX #$0001
        CPX $0468 : BEQ .done
        BRA .skipJumpCheck
    .openDoor
    CPX $0468 : BEQ .done
    LDA !IsJumping : AND #$00FF : BNE .done
        .skipJumpCheck
        STX $0468 ; thing we wrote over
        STZ $068E ; ^
        JML ChangeTrapDoorState.ReturnPoint
    .done
JML ChangeTrapDoorState.EndPoint

; Handle jumping over a button that keeps
; its state after Link steps away from it.
PressGroundSwitch:
    LDA !IsJumping : AND #$00FF : BNE +
        LDA $0430 : BNE +
        JML PressGroundSwitch.ReturnPoint
    +
JML PressGroundSwitch.EndPoint

; Handle jumping over the tiles with a drawing of
; a yellow shine that change the formation of the
; pits of the floor.
ChangePitGroupsInFloor:
    PHA
    LDA !IsJumping : BNE +
        PLA
        STA $04BA
        STZ $BA
        JML ChangePitGroupsInFloor.ReturnPoint
    +
    PLA
JML ChangePitGroupsInFloor.EndPoint

