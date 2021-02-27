incsrc ./buttons.asm
incsrc ./checkpress.asm
incsrc ./execute.asm
incsrc ./height.asm
incsrc ./hole.asm
incsrc ./items.asm
incsrc ./ledge.asm
incsrc ./shadow.asm
incsrc ./soldier.asm
incsrc ./stairs.asm
incsrc ./sword.asm
incsrc ./warp.asm
incsrc ./watergrass.asm

; Called in height.asm
UpdateJump:
    JSL CanCallJumpCode : BCS .done
        JSL HandleJumping
    .done
    REP #$20 ; thing we wrote over
    LDA $22  ; ^
RTL

CanCallJumpCode:
    if !AllowStairJump == 0
        LDA $5E : CMP #$02 : BEQ .noJumping ; don't jump when on stairs
    endif
    LDA $10
    CMP #$07 : BEQ .correctModule
    CMP #$09 : BEQ .correctModule
    CMP #$0B : BEQ .correctModule
    CMP #$06 : BEQ .resetJumping
    CMP #$08 : BEQ .resetJumping
    CMP #$0A : BEQ .resetJumping
        BRA .noJumping
    .correctModule
    LDA $11 : BEQ .jumping ; only jump on submodule 0
        BRA .noJumping
    .resetJumping
        %M_STZ(!IsJumping,0)
        %M_STZ(!JumpTimer,0)
        BRA .noJumping
    .jumping
        CLC : RTL
    .noJumping
        SEC : RTL

HandleJumping:
    JSL CheckJumpButtonPress
    JSL ExecuteJump
RTL

StopJump:
    %M_STZ(!IsJumping,0)
RTL

