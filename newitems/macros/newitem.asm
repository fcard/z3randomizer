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

