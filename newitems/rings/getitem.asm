; Handling for getting Rings

; Helper Macros

macro CmpRingLimit(location)
    if <location> == !FireRingFlag
        CMP.l !ProgressiveFireRing_limit
    elseif <location> == !PowerRingFlag
        CMP.l !ProgressivePowerRing_limit
    elseif <location> == !GuardRingFlag
        CMP.l !ProgressiveGuardRing_limit
    endif
endmacro

macro LdaRingReplacement(location)
    if <location> == !FireRingFlag
        LDA.l !ProgressiveFireRing_replacement
    elseif <location> == !PowerRingFlag
        LDA.l !ProgressivePowerRing_replacement
    elseif <location> == !GuardRingFlag
        LDA.l !ProgressiveGuardRing_replacement
    endif
endmacro

macro GetRingId(location, id1, id2, getid)
    LDA.l <location> : %CmpRingLimit(<location>)
    BCC ?within_limit
        %LdaRingReplacement(<location>)
        JSL.l <getid>
        RTL
    ?within_limit:
        CMP #$00 : BNE ?second_item
            LDA.b <id1> : RTL
        ?second_item:
            LDA.b <id2> : RTL
endmacro

macro ProgressiveRingReplace(location, ring1, ring2)
    LDA.l <location> : %CmpRingLimit(<location>)
    BCC ?within_limit
        %LdaRingReplacement(<location>) : STA $02D8
        BRA .done
    ?within_limit:
        CMP #$00 : BNE ?second_item
            LDA.b <ring1> : STA $02D8
            BRA .done
        ?second_item:
            LDA.b <ring2> : STA $02D8
            BRA .done
endmacro


macro GetRingSpriteID(location, id1, id2)
    %GetRingId(<location>, <id1>, <id2>, GetSpriteID)
endmacro

macro GetRingPalette(location, id1, id2)
    %GetRingId(<location>, <id1>, <id2>, GetSpritePalette)
endmacro

; Routines

if !EnableRings != 0
AddReceivedRingGetItem:
    CMP.b #!RupeeRing_id : BNE + ; Rupee Ring
        ;Double Rupee Amount
        REP #$20
        LDA.l $07EF360
        ASL
        STA.l $07EF360
        SEP #$20
        JML AddReceivedItemExpandedGetItem_done
    + CMP.b #!FireRing_id : BNE +
        LDA #$10 : STA $7EF375 ; Add 10 bombs
        JML AddReceivedItemExpandedGetItem_done
    + CMP.b #!FlameRing_id : BNE +
        LDA #$50 : STA $7EF375 ; Add 50 bombs
        JML AddReceivedItemExpandedGetItem_done
    +
JML AddReceivedItemExpandedGetItem_ringReturn

AddReceivedRing:
    CMP.b #!ProgressiveFireRing_id : BNE +
        %ProgressiveRingReplace(!FireRingFlag, #!FireRing_id, #!FlameRing_id)
    + CMP.b #!ProgressivePowerRing_id : BNE +
        %ProgressiveRingReplace(!PowerRingFlag, #!PowerRing_id, #!SwordRing_id)
    + CMP.b #!ProgressiveGuardRing_id : BNE +
        %ProgressiveRingReplace(!GuardRingFlag, #!GuardRing_id, #!DiamondRing_id)
    +
JML AddReceivedItemExpanded_ringReturn
    .done
JML AddReceivedItemExpanded_done

GetRingSpriteID:
    CMP.b #!ProgressiveFireRing_special_sprite : BNE +
        %GetRingSpriteID(!FireRingFlag, #!FireRing_sprite, #!FlameRing_sprite)
    + CMP.b #!ProgressivePowerRing_special_sprite : BNE +
        %GetRingSpriteID(!PowerRingFlag, #!PowerRing_sprite, #!SwordRing_sprite)
    + CMP.b #!ProgressiveGuardRing_special_sprite : BNE +
        %GetRingSpriteID(!GuardRingFlag, #!GuardRing_sprite, #!DiamondRing_sprite)
    +
JML GetSpriteID_ringReturn

GetRingPalette:
    CMP.b #!ProgressiveFireRing_palette : BNE +
         %GetRingPalette(!FireRingFlag, #!FireRing_palette, #!FlameRing_palette)
    + CMP.b #!ProgressivePowerRing_special_sprite : BNE +
         %GetRingPalette(!PowerRingFlag, #!PowerRing_palette, #!SwordRing_palette)
    + CMP.b #!ProgressiveGuardRing_special_sprite : BNE +
         %GetRingPalette(!GuardRingFlag, #!GuardRing_palette, #!DiamondRing_palette)
    +
JML GetSpritePalette_ringReturn
endif

