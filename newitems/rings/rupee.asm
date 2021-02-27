; Rupee Ring

; Add collected rupees to the total amount, handle Rupee Charm
AddCollectedRupees:
    ; Input:  A register = amount to add
    ; Output: A register = total rupees after addition
    PHA
    LDA !RupeeRingFlag : AND #$00FF : BEQ + ; check if we have the rupee ring
        PLA : ASL ; if we have it, double rupee amount
        ADC $7EF360 ; Add amount to current rupee count
        RTL
    +
    PLA
    ADC $7EF360 ; Add amount to current rupee count
RTL ; following code will sta $7EF360

AddDungeonRupees:
    ; Output: A register = total rupees before adding 5 more
    LDA !RupeeRingFlag : AND #$00FF : BEQ + ; check if we have the rupee ring
        LDA $7EF360 : CLC : ADC #$0005 ; Add 5 more
        RTL
    +
    LDA $07EF360
RTL


; Add rupees from chests to the total amount, handle Rupee Charm
AddChestRupees:
    ; Input: $00 = amount to add
    ; Output: A register = total rupees after addition
    LDA !RupeeRingFlag : AND #$00FF : BEQ + ; check if we have the rupee ring
        LDA $7EF360
        CLC
        ADC $00
        ADC $00
        RTL
    +
    LDA $7EF360
    CLC
    ADC $00
RTL

