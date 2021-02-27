; Power Rings

macro ExtraDamage(extra)
    LDA #<extra> : CLC : ADC $0CE2,X : BCC +
    LDA #$FF
    + STA $0CE2,X
endmacro

; Called right before any sprite's health has damaged subtracted from it.
; We add our extra damage from the power/sword ring here.
; Input:  $00 (damage)
; Output: $00 (damage + extra damage)
DamageSprite:
    LDA !PowerRingFlag : BEQ .afterExtraDamage
        CMP #01 : BNE .swordRing
        ;.powerRing
            %ExtraDamage(2)
            BRA .afterExtraDamage
        .swordRing
            %ExtraDamage(4)
    .afterExtraDamage
    LDA $0E50,X : STA $00
RTL


