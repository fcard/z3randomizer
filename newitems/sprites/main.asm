%NewSpriteMemory(NewItemSpriteMemory, $A58000, $A60000)

if !CompressMenuRingsGFX != 0
    %NewSpriteSheet(GfxMenuRings, 2bpp, menurings.gfx, !NewItemSpriteMemory, 0)
else
    %NewSpriteSheet(GfxMenuRings, 2bpp, menurings.bin, !NewItemSpriteMemory, 0)
endif

%NewSpriteSheet(GfxRings, 3bpp, rings.gfx, !NewItemSpriteMemory, 1)

