; Update the little sparkles from Link's sword
; to match his height off the ground. Only
; applicable to Master Sword and up.
SetYCoordinateForSwingSparkle:
    LDA $20 : CLC : SBC $24 : STA $0BFA, X
    LDA $21 : SBC $25 : STA $0C0E, X
JML SetYCoordinateForSwingSparkle.ReturnPoint

; Update the the tip of Link's sword
; to match his height off the ground.
; Only applicable to Master Sword and up.
AddExtendedSwordXYToOam:
    LDA $24 : CMP #$FFFF : BEQ +
        SEP #$20
        LDA $0A : STA $0800, X
        LDA $0B : SEC : SBC $24 : STA $0801, X
        REP #$20
        RTL
    +
    LDA $0A
    STA $0800, X
RTL

