; Settings

; Boolean Settings (1 = Yes, 0 = No)

!PushOutOfDoorway = 1 ; Push Link out of vertical doorways when he jumps
!AllowHookshotWaterJump = 0 ; Allow using hookshot while jumping above deep water
!AllowStairJump = 0 ; Allow jumping while on outdoor staircases

; !AllowBunnyJump: Allow Bunny Link to jump with the R button

!AllowBunnyJump_Never = 0
!AllowBunnyJump_WithRing = 1
!AllowBunnyJump_Always = 2

!AllowBunnyJump #= !AllowBunnyJump_Always

; !MireWaterSounds: Fix water sounds playing while in midair in mire

!MireWaterSounds_NoFix = 0
!MireWaterSounds_FixForRingJump = 1
!MireWaterSounds_FixForAllJumps = 2

!MireWaterSounds #= !MireWaterSounds_FixForAllJumps

; !LandingNoise: Allow noises when you land after a jump (bitfield)

!LandingNoise_OnWater = 1
!LandingNoise_OnLand = 2
!LandingNoise_OnGrass = 4

!LandingNoise #= !LandingNoise_OnWater|!LandingNoise_OnGrass

; Addresses

function jumpvar(offset) = $7C+offset

!JumpInverseDirection #= jumpvar(0)
!JumpForwardDirection #= jumpvar(1)
!JumpNonStartingDirections #= jumpvar(2)
!JumpDirectionType #= jumpvar(3)
!IsJumping #= jumpvar(4)
!JumpTimer #= jumpvar(5)
!JumpingAboveWater #= jumpvar(6)
!JumpFrame #= jumpvar(7)

; Constants

!JumpDistance = $30
!JumpDistanceDash = $60
!JumpDistanceDiagonal = $28

; Helper macros

; Used like so:
;     %AllowsLandingNoise(Result, OnWater)
; !Result will then be nonzero if we allow a landing noise on water, and 0 otherwise.
; Can be used with OnLand, OnWater or OnGrass.
macro AllowsLandingNoise(var, mask)
    !<var> #= !LandingNoise&!LandingNoise_<mask>
endmacro

; Used like so:
;     %AllowsLandingNoise2(Result, OnWater, OnLand)
; !Result will then be nonzero if we allow a landing noise on both water and land,
; and 0 otherwise. Can be used with OnLand, OnWater or OnGrass.
macro AllowsLandingNoise2(var, mask1, mask2)
    !<var> #= !LandingNoise&(!LandingNoise_<mask1>|!LandingNoise_<mask2>)
endmacro

