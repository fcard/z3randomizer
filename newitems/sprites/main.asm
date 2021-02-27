!NewItemSpriteBank = $A5

function new_item_sprite_address(offset) = (!NewItemSpriteBank<<16)+$8000+offset

if !CompressMenuRingsGFX != 0
    %NewSpriteSheet(GfxMenuRings, 2bpp, menurings.gfx, new_item_sprite_address($0000), 0)
else
    %NewSpriteSheet(GfxMenuRings, 2bpp, menurings.bin, new_item_sprite_address($0000), 0)
endif

%NewSpriteSheet(GfxRings, 3bpp, rings.gfx, new_item_sprite_address($0400), 1)

