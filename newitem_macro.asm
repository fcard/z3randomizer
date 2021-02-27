!PrintItemSettings = 0

!CurrentItemId #= $B0
!CurrentSpriteId #= $4A

!ItemDataType_sprite = byte
!ItemDataType_special_sprite = byte
!ItemDataType_wide = byte
!ItemDataType_properties = byte
!ItemDataType_target_address = word
!ItemDataType_value = byte
!ItemDataType_palette = byte
!ItemDataType_yoffset = byte
!ItemDataType_xoffset = byte

!DefaultItem_sprite #= $49
!DefaultItem_special_sprite #= $49
!DefaultItem_wide #= $02
!DefaultItem_properties #= 4
!DefaultItem_target_address #= $F36A
!DefaultItem_value #= $FF
!DefaultItem_palette #= $08
!DefaultItem_yoffset #= -4
!DefaultItem_xoffset #= 0

function digit(value,d) = (value>>(d*4))-((value>>((d+1)*4))<<4)

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

function word(x) = x-(bank(x)<<16)

macro NewItem(prefix, sprite, wide, target, value, properties, palette, spritebufferpos, yoffset, xoffset)
    assert !CurrentItemId <= $FD,"No item slots available for <prefix>"

    !<prefix>_id #= !CurrentItemId

    !<prefix>_sprite #= <sprite>
    !{NewItem!{CurrentItemId}_sprite} #= <sprite>

    !<prefix>_special_sprite #= <sprite>
    !{NewItem!{CurrentItemId}_special_sprite} #= <sprite>

    !<prefix>_properties #= <properties>
    !{NewItem!{CurrentItemId}_properties} #= <properties>

    !<prefix>_wide #= <wide>
    !{NewItem!{CurrentItemId}_wide} #= <wide>

    !<prefix>_target_address #= word(<target>)
    !{NewItem!{CurrentItemId}_target_address} #= word(<target>)

    !<prefix>_value #= <value>
    !{NewItem!{CurrentItemId}_value} #= <value>

    !<prefix>_palette #= <palette>
    !{NewItem!{CurrentItemId}_palette} #= <palette>

    !<prefix>_yoffset #= <yoffset>
    !{NewItem!{CurrentItemId}_yoffset} #= <yoffset>

    !<prefix>_xoffset #= <xoffset>
    !{NewItem!{CurrentItemId}_xoffset} #= <xoffset>

    if <spritebufferpos> != 0
        !<prefix>_spritebufferpos #= <spritebufferpos>
        !{SpriteBufferPos!{<prefix>_sprite}} #= <spritebufferpos>
    endif

    !CurrentItemId #= !CurrentItemId+1

    if <sprite> > !CurrentSpriteId && <sprite> != $FF
        !CurrentSpriteId #= <sprite>
    endif

    if !PrintItemSettings != 0
        %Dec2Hex(s, !<prefix>_id)
        print "<prefix>_id = 0x!s"
    endif
endmacro

!ProgressiveSlot #= $F7
!ProgressiveSettingsAddressOffset #= $00

macro NewProgressiveItem(prefix, wide, target, properties, yoffset, xoffset, limit, replacement)
    %NewItem(<prefix>, $FF, <wide>, <target>, $FF,
             <properties>, $FF, 0, <yoffset>, <xoffset>)

    !CurrentItemId #= !CurrentItemId-1

    !<prefix>_special_sprite #= !ProgressiveSlot
    !{NewItem!{CurrentItemId}_special_sprite} #= !ProgressiveSlot

    !<prefix>_palette #= !ProgressiveSlot
    !{NewItem!{CurrentItemId}_palette} #= !ProgressiveSlot

    !CurrentItemId #= !CurrentItemId+1
    !ProgressiveSlot #= !ProgressiveSlot-1

    !<prefix>_limit #= $308400+!ProgressiveSettingsAddressOffset
    !{ProgressiveItemSetting!{ProgressiveSettingsAddressOffset}} #= <limit>

    !ProgressiveSettingsAddressOffset #= !ProgressiveSettingsAddressOffset+1

    !<prefix>_replacement #= $308400+!ProgressiveSettingsAddressOffset
    !{ProgressiveItemSetting!{ProgressiveSettingsAddressOffset}} #= <replacement>

    !ProgressiveSettingsAddressOffset #= !ProgressiveSettingsAddressOffset+1

    if !PrintItemSettings != 0
        %Dec2Hex(s1, !<prefix>_limit)
        %Dec2Hex(s2, !<prefix>_replacement)
        print "<prefix>_limit = 0x!s1"
        print "<prefix>_replacement = 0x!s2"
    endif
endmacro

macro AddItemData1(type, value)
    if stringsequal("!{ItemDataType_<type>}", "byte")
        db <value>
    elseif stringsequal("!{ItemDataType_<type>}", "word")
        dw <value>
    elseif stringsequal("!{ItemDataType_<type>}", "long")
        dl <value>
    else
        error "Unknown type '!{ItemDataType_<type>}' for item data '<type>'"
    endif
endmacro

macro AddItemData(type)
    !id #= $B0
    while !id < !CurrentItemId
        %AddItemData1(<type>, !{NewItem!{id}_<type>})
        !id #= !id+1
    endif
    while !id <= $FF
        %AddItemData1(<type>, !{DefaultItem_<type>})
        !id #= !id+1
    endif
endmacro

macro AddSpriteBufferPos()
    !id #= $4B
    while !id <= !CurrentSpriteId
        dw !{SpriteBufferPos!{id}}
        !id #= !id+1
    endif
endmacro

macro AddProgressiveItemSettings()
    !setting #= 0
    while !setting < !ProgressiveSettingsAddressOffset
        db !{ProgressiveItemSetting!{setting}}
        !setting #= !setting+1
    endif
endmacro

