; Gameplay Settings

!EnableRings = 1 ; Enable ring items
!GuardRingDiminishingEffect = 0 ; Guard Ring effect goes down with armor upgrades (bool)
!MinimumDamage = 01 ; Minimum damage after ring damage reduction

; Technical Settings

!CompressMenuRingsGFX = 1 ; Use compression algorithms with the 2bpp menu ring sprites.
                          ; Saves memory but is slower than just using them raw (bool)

; Helper Variables

%NewVar(WhichMenu) ; Used to display and switch between the rings and ability menu
                   ; * If set to 1, we are at the ability menu
                   ; * If set to 2, we are at the rings menu
                   ; * 0 is unused.

%NewVar(UpdateMenuRingGraphics) ; Controls if/how the menu rings graphics data is to
                                ; be transfered to VRAM.
                                ; * If set to 2, transfer the first half.
                                ; * If set to 1, transfer the second half.
                                ; * If set to 0, don't transfer.
                                ; As the data is transfered, the address will be
                                ; updated accordingly. If the data is compressed,
                                ; it must be uncompressed before this address is set.


%NewVar(BombDamage) ; Set to 1 when Link is damaged by bombs, used by the
                    ; fire/flame rings to negate the damage.

%NewVar(FireDamage) ; Set to 1 when Link is damaged by fire, used by the
                    ; fire/flame rings to half/negate the damage.

%NewVar(SpikeDamage) ; Unused, meant to be set when Link is damaged by spikes,
                     ; so new items can deal with that.

%NewVar(GarnishFire) ; flag set by GarnishFireDamage,
                     ; checked and reset by Garnish_CheckPlayerCollision

%NewVar(OutdoorStairs) ; Set to 1 on outdoor stairs, and to 0 on indoor stairs

; SRAM Variables

%NewSRAMVar(RupeeRingFlag)
%NewSRAMVar(GravityRingFlag)
%NewSRAMVar(FireRingFlag)
%NewSRAMVar(LightRingFlag)
%NewSRAMVar(PowerRingFlag)
%NewSRAMVar(GuardRingFlag)

; Settings (runtime)

%NewSetting(EnableRingsRuntime, !EnableRings)

; Item Constants

if !EnableRings != 0
    %NewItem(RupeeRing,   $4B, $02, !RupeeRingFlag,   $01, $02, $04, $0600, -4, 0)
    %NewItem(GravityRing, $4C, $02, !GravityRingFlag, $01, $02, $04, $0630, -4, 0)
    %NewItem(FireRing,    $4D, $02, !FireRingFlag,    $01, $01, $02, $0660, -4, 0)
    %NewItem(FlameRing,   $4E, $02, !FireRingFlag,    $02, $01, $02, $0690, -4, 0)
    %NewItem(LightRing,   $4F, $02, !LightRingFlag,   $01, $04, $08, $06C0, -4, 0)
    %NewItem(PowerRing,   $50, $02, !PowerRingFlag,   $01, $04, $08, $06F0, -4, 0)
    %NewItem(SwordRing,   $51, $02, !PowerRingFlag,   $02, $04, $08, $0720, -4, 0)
    %NewItem(GuardRing,   $52, $02, !GuardRingFlag,   $01, $02, $04, $0750, -4, 0)
    %NewItem(DiamondRing, $53, $02, !GuardRingFlag,   $02, $02, $04, $0900, -4, 0)

    %NewProgressiveItem(ProgressiveFireRing,  $02, !FireRingFlag,  $01, -4, 0, 2, $47)
    %NewProgressiveItem(ProgressivePowerRing, $02, !PowerRingFlag, $04, -4, 0, 2, $47)
    %NewProgressiveItem(ProgressiveGuardRing, $02, !GuardRingFlag, $02, -4, 0, 2, $47)
endif

; other Gravity Ring defines are in jump_defines.asm

