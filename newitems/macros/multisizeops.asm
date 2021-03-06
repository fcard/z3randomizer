; Macros that allow a address to be changed easily between a long address
; and a word/zero page address. Instead of using
;    STZ !MyAddress
; We can use
;    %M_STZ(!MyAddress,1)
; And it will work regardless of the size of !MyAddress.
;
; Whenever the macro takes a second argument, it's "preserveA", or if the macro
; should preserve the value in the A register from before the operation.

macro M_STZ(address, preserveA)
    if <address> > $FFFF
        if preserveA != 0
            PHA : LDA #$00 : STA <address> : PLA
        else
            LDA #$00 : STA <address>
        endif
    else
        STZ <address>
    endif
endmacro

macro M_INC(address, preserveA)
    if <address> > $FFFF
        if <preserveA> != 0
            PHA
            LDA <address>
            INC
            STA <address>
            PLA
        else
            LDA <address>
            INC
            STA <address>
        endif
    else
        INC <address>
    endif
endmacro

macro M_DEC(address, preserveA)
    if <address> > $FFFF
        if <preserveA> != 0
            PHA
            LDA <address>
            DEC
            STA <address>
            PLA
        else
            LDA <address>
            DEC
            STA <address>
        endif
    else
        DEC <address>
    endif
endmacro

macro M_LDX(address, preserveA)
    if <address> > $FFFF
        if <preserveA> != 0
            PHA : LDA <address> : TAX : PLA
        else
            LDA <address> : TAX
        endif
    else
        LDX <address>
    endif
endmacro

macro M_LDY(address, preserveA)
    if <address> > $FFFF
        if <preserveA> != 0
            PHA : LDA <address> : TAY : PLA
        else
            LDA <address> : TAY
        endif
    else
        LDY <address>
    endif
endmacro

macro M_STX(address, preserveA)
    if <address> > $FFFF
        if <preserveA> != 0
            PHA : TXA : STA <address> : PLA
        else
            TXA : STA <address>
        endif
    else
        STX <address>
    endif
endmacro

macro M_STY(address, preserveA)
    if <address> > $FFFF
        if <preserveA> != 0
            PHA : TYA : STA <address> : PLA
        else
            TYA : STA <address>
        endif
    else
        STY <address>
    endif
endmacro

