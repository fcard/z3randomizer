; Gameplay Settings

!GuardRingDiminishingEffect = 0 ; Guard Ring effect goes down with armor upgrades (bool)
!MinimumDamage = 01 ; Minimum damage after ring damage reduction

; Technical Settings

!CompressMenuRingsGFX = 1 ; Use compression algorithms with the 2bpp menu ring sprites.
                          ; Saves memory but is slower than just using them raw (bool)

; Helper Variables

function var(offset) = $7FF000+offset ; Generates an address to be used as a variable

!WhichMenu #= var(0) ; Used to display and switch between the rings and ability menu
                         ; * If set to 1, we are at the ability menu
                         ; * If set to 2, we are at the rings menu
                         ; * 0 is unused.

!UpdateMenuRingGraphics #= var(1) ; Controls if/how the menu rings graphics data is to
                                  ; be transfered to VRAM.
                                  ; * If set to 2, transfer the first half.
                                  ; * If set to 1, transfer the second half.
                                  ; * If set to 0, don't transfer.
                                  ; As the data is transfered, the address will be
                                  ; updated accordingly. If the data is compressed,
                                  ; it must be uncompressed before this address is set.


!BombDamage #= var(2) ; Set to 1 when Link is damaged by bombs, used by the
                      ; fire/flame rings to negate the damage.

!FireDamage #= var(3) ; Set to 1 when Link is damaged by fire, used by the
                      ; fire/flame rings to half/negate the damage.

!SpikeDamage #= var(4) ; Unused, meant to be set when Link is damaged by spikes,
                       ; so new items can deal with that.

!GarnishFire #= var(5) ; flag set by GarnishFireDamage,
                       ; checked and reset by Garnish_CheckPlayerCollision

; Ring Flags

function svar(offset) = $7F6600+offset ; A variable that is saved to sram

!RupeeRingFlag   #= svar(0)
!GravityRingFlag #= svar(1)
!FireRingFlag    #= svar(2)
!LightRingFlag   #= svar(3)
!PowerRingFlag   #= svar(4)
!GuardRingFlag   #= svar(5)

; Gravity Ring defines are in jump_defines.asm

