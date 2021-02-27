function digit(value,d) = (value>>(d*4))-((value>>((d+1)*4))<<4)
function word(x) = x-(bank(x)<<16)
function hibyte(x) = bank(x)
function midbyte(x) = ((x>>8)-(bank(x)<<8))
function lowbyte(x) = (x-((x>>8)<<8))

macro Dec2Hex(result, value)
    !Dec2Hex_value #= <value>
    if !Dec2Hex_value > $0FFFFF
        %Dec2Hex1(Dec2Hex_x0, digit(!Dec2Hex_value,0))
        %Dec2Hex1(Dec2Hex_x1, digit(!Dec2Hex_value,1))
        %Dec2Hex1(Dec2Hex_x2, digit(!Dec2Hex_value,2))
        %Dec2Hex1(Dec2Hex_x3, digit(!Dec2Hex_value,3))
        %Dec2Hex1(Dec2Hex_x4, digit(!Dec2Hex_value,4))
        %Dec2Hex1(Dec2Hex_x5, digit(!Dec2Hex_value,5))
        !<result> := "!Dec2Hex_x5!Dec2Hex_x4!Dec2Hex_x3!Dec2Hex_x2!Dec2Hex_x1!Dec2Hex_x0"
    elseif !Dec2Hex_value > $00FFFF
        %Dec2Hex1(Dec2Hex_x0, digit(!Dec2Hex_value,0))
        %Dec2Hex1(Dec2Hex_x1, digit(!Dec2Hex_value,1))
        %Dec2Hex1(Dec2Hex_x2, digit(!Dec2Hex_value,2))
        %Dec2Hex1(Dec2Hex_x3, digit(!Dec2Hex_value,3))
        %Dec2Hex1(Dec2Hex_x4, digit(!Dec2Hex_value,4))
        !<result> := "!Dec2Hex_x4!Dec2Hex_x3!Dec2Hex_x2!Dec2Hex_x1!Dec2Hex_x0"
    elseif !Dec2Hex_value > $000FFF
        %Dec2Hex1(Dec2Hex_x0, digit(!Dec2Hex_value,0))
        %Dec2Hex1(Dec2Hex_x1, digit(!Dec2Hex_value,1))
        %Dec2Hex1(Dec2Hex_x2, digit(!Dec2Hex_value,2))
        %Dec2Hex1(Dec2Hex_x3, digit(!Dec2Hex_value,3))
        !<result> := "!Dec2Hex_x3!Dec2Hex_x2!Dec2Hex_x1!Dec2Hex_x0"
    elseif !Dec2Hex_value > $0000FF
        %Dec2Hex1(Dec2Hex_x0, digit(!Dec2Hex_value,0))
        %Dec2Hex1(Dec2Hex_x1, digit(!Dec2Hex_value,1))
        %Dec2Hex1(Dec2Hex_x2, digit(!Dec2Hex_value,2))
        !<result> := "!Dec2Hex_x2!Dec2Hex_x1!Dec2Hex_x0"
    elseif !Dec2Hex_value > $00000F
        %Dec2Hex1(Dec2Hex_x0, digit(!Dec2Hex_value,0))
        %Dec2Hex1(Dec2Hex_x1, digit(!Dec2Hex_value,1))
        !<result> := "!Dec2Hex_x1!Dec2Hex_x0"
    else
        %Dec2Hex1(<result>, digit(!Dec2Hex_value,0))
    endif
endmacro

macro Dec2Hex1(result, value)
    !Dec2Hex1_value #= <value>
    if !Dec2Hex1_value < $A
        !<result> := !Dec2Hex1_value
    elseif !Dec2Hex1_value == $A
        !<result> = A
    elseif !Dec2Hex1_value == $B
        !<result> = B
    elseif !Dec2Hex1_value == $C
        !<result> = C
    elseif !Dec2Hex1_value == $D
        !<result> = D
    elseif !Dec2Hex1_value == $E
        !<result> = E
    else
        !<result> = F
    endif
endmacro

