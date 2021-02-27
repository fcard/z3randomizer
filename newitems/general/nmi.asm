ExtraNMIUpdate:
    SEP #$30
    JSL NMIRingGraphics
    REP #$10
    LDA.b #$80 : STA $2115 ; thing we wrote over
RTL

