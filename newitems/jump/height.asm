; Don't reset height on recoil if jumping,
; so Link won't have an inconsistent Z position
; if he e.g. hits a Soldiers sword with his own.
ResetHeightOnRecoil:
    LDA !IsJumping : BNE +
        STZ $24
        STZ $25
    +
RTL

; Don't reset Link's Z coordinates to $FFFF if he is jumping.
; This code is called periodically if he is not in a substate
; that would put him in midair. Since we don't use the normal
; substate address, $4D, we must add our own branch.
ResetZCoordinates:
    LDA !IsJumping : BNE +
        LDA #$FF : STA $24 : STA $25
    +
RTL

