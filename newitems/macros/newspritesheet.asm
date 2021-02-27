!SpriteSheetId = 0
!SpriteMemoryId = 0

macro NewSpriteMemory(var, starting_address, end_address)
    !<var> #= !SpriteMemoryId
    !{SpriteMemory!{SpriteMemoryId}_starting_address} #= <starting_address>
    !{SpriteMemory!{SpriteMemoryId}_end_address} #= <end_address>
    !{SpriteMemory!{SpriteMemoryId}_address} #= <starting_address>
    !SpriteMemoryId #= !SpriteMemoryId+1
endmacro

macro NewSpriteSheet(var, spritetype, file, memory, add_to_sheet_library)
    !memory #= <memory>
    !address #= !{SpriteMemory!{memory}_address}
    !{<var>_address} #= !address
    !{<var>_bank} #= bank(!address)
    !{<var>_word} #= word(!address)
    !{<var>_high} #= hibyte(!address)
    !{<var>_mid}  #= midbyte(!address)
    !{<var>_low}  #= lowbyte(!address)
    if <add_to_sheet_library> != 0
        !{<var>_id}   #= !SpriteSheetId
        !{SpriteSheet!{SpriteSheetId}_high} #= hibyte(!address)
        !{SpriteSheet!{SpriteSheetId}_mid}  #= midbyte(!address)
        !{SpriteSheet!{SpriteSheetId}_low}  #= lowbyte(!address)
        !SpriteSheetId #= !SpriteSheetId+1
    endif
    pushpc
    org !address
        incbin newitems/sprites/<spritetype>/<file>
        if stringsequal("<spritetype>", "2bpp")
            warnpc !address+$0400
            !{SpriteMemory!{memory}_address} #= !address+$0400
        elseif stringsequal("<spritetype>", "3bpp")
            warnpc !address+$0600
            !{SpriteMemory!{memory}_address} #= !address+$0600
        elseif stringsequal("<spritetype>", "4bpp")
            warnpc !address+$0800
            !{SpriteMemory!{memory}_address} #= !address+$0800
        else
            error "Unknown type for sprite: '<spritetype>'"
        endif
    warnpc !{SpriteMemory!{memory}_end_address}
    pullpc
endmacro

macro AddSpriteSheets(type)
    !id = 0
    while !id < !SpriteSheetId
        db !{SpriteSheet!{id}_<type>}
        !id #= !id+1
    endif
endmacro

macro AddSpriteSheetsHigh()
    %AddSpriteSheets(high)
endmacro

macro AddSpriteSheetsMiddle()
    %AddSpriteSheets(mid)
endmacro

macro AddSpriteSheetsLow()
    %AddSpriteSheets(low)
endmacro

