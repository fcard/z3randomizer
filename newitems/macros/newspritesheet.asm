!SpriteSheetId = 0

macro NewSpriteSheet(var, spritetype, file, address, add_to_sheet_library)
    !{<var>_address} #= <address>
    !{<var>_bank} #= bank(<address>)
    !{<var>_word} #= word(<address>)
    !{<var>_high} #= hibyte(<address>)
    !{<var>_mid}  #= midbyte(<address>)
    !{<var>_low}  #= lowbyte(<address>)
    if <add_to_sheet_library> != 0
        !{<var>_id}   #= !SpriteSheetId
        !{SpriteSheet!{SpriteSheetId}_high} #= hibyte(<address>)
        !{SpriteSheet!{SpriteSheetId}_mid}  #= midbyte(<address>)
        !{SpriteSheet!{SpriteSheetId}_low}  #= lowbyte(<address>)
        !SpriteSheetId #= !SpriteSheetId+1
    endif
    pushpc
    org <address>
        incbin newitems/sprites/<spritetype>/<file>
        if stringsequal("<spritetype>", "2bpp")
            warnpc <address>+$0400
        elseif stringsequal("<spritetype>", "3bpp")
            warnpc <address>+$0600
        elseif stringsequal("<spritetype>", "4bpp")
            warnpc <address>+$0800
        else
            error "Unknown type for sprite: '<spritetype>'"
        endif
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

