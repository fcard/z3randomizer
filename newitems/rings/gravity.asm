; Gravity Ring

; Negate pit damage if we have the gravity ring
; Guard/Diamond rings also reduces the damage dealt.
DoPitDamage:
    LDA !GravityRingFlag : BEQ + ; check if we have the gravity ring
        RTL ; if we have it, don't do anything
    +
    JSL.l OHKOTimer ; otherwise, call damage routines
    LDA $7EF36D : SBC #8 ; and reduce health by one heart (8 health)
    ADC !GuardRingFlag   ; calculate guard ring reduction
    ADC !GuardRingFlag   ; (it's double the current ring)
    STA $7EF36D

    CMP.b #$A8 : BCC .notDead ; for overflowed numbers, set health to 0
        LDA.b #$00 : STA $7EF36D
    .notDead
RTL

; See newitems/jump for the jump functionality
