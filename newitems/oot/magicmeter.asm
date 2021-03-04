if !DisableSoundIfMagicDisabled != 0
!MagicEnabled = $7FFF30

HandleAbsorbableSfxNew:
    CMP #$07 : BEQ .magicRefill
    CMP #$08 : BEQ .magicRefill
    BRA .playSound
    .magicRefill
        LDA !MagicEnabled : BNE .playSound
        BRA .done
    .playSound
        LDA.w .sfx, Y : JSL Sound_SetSfx3PanLong
    .done
RTL

IncrementMagicNew:
    LDA !MagicEnabled : BEQ .dontIncrement
        LDA $7EF373
        DEC
        STA $7EF373 JML IncrementMagicNew.Increment
   .dontIncrement
        LDA #$00
        STA $7EF373 ; zero out magic increase
        JML IncrementMagicNew.DontIncrement
endif

if !HideMagicMeterIfMagicDisabled != 0
HideMagicMeter:
    LDA $7EC788 : CMP #$007F : BEQ + ; Don't update unless necessary

    LDY #$7E : PHB : PHY : PLB ; Set B register to 0x7E

    ; Remove Magic Meter (Independent parts)
    LDA #$007F
    STA $C704 : STA $C706
    STA $C744 : STA $C746
    STA $C784 : STA $C786
    STA $C7C4 : STA $C7C6
    STA $C804 : STA $C806 : STA $C808
    STA $C844 : STA $C846 : STA $C848

    ; Remove Magic Meter from Item Box
    LDA #$685C : STA $C708
    LDA #$685D : STA $C748 : STA $C788
    LDA #$E85C : STA $C7C8
    PLB
    +
RTL

endif
