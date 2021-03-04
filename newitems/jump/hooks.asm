;--------------------------------------------------------------------------------
; Gravity Ring
;--------------------------------------------------------------------------------

; main

org $078003
    JSL UpdateJump

; buttons

org $01CD41
JML CheckJumpingAboveButton : NOP
CheckJumpingAboveButton_returnPoint:

org $01CDD4
JML CheckJumpingAboveButton2 : NOP
CheckJumpingAboveButton2_returnPoint:

org $01CDA0
CheckJumpingAboveButton.BranchPoint:


; soldier

org $06EB83
JSL CheckSoldierOnSameLayer

; height

org $0781A0
JSL ResetZCoordinates : NOP #2

org $06F6A0
JSL ResetHeightOnRecoil

; items

org $0781E6
JSL ZeroCountersForStun : NOP #2

org $07B060
JML CheckYPress
org $07B064
CheckYPress.Continue:
org $07B06E
CheckYPress.No:

org $08BF03
JML FixHookshotY : NOP
FixHookshotY.ReturnPoint:
org $08BF0C
FixHookshotY.BranchPoint:

org $08F7F0
JSL FixHookshotY2 : NOP #2

org $08912C
JML UpdateHeldBoomerangCoords
UpdateHeldBoomerangCoords.ReturnPoint:
org $089133
UpdateHeldBoomerangCoords.JustDraw:

org $08913C
JML FixBoomerangY
org $089148
FixBoomerangY.ReturnPoint:

; hole

org $07BCE7
JSL FallIntoHole : NOP #4

org $07BEC5
JSL FallIntoHole : NOP #4

org $07C722
JSL FallIntoHole : NOP #4

org $07C8FC
JSL FallIntoHole : NOP #4

; ledge

org $07CC67
JSL FallFromLedge

org $078199
JSL FallFromLedge2

org $07C156
JML JumpLedge : NOP #2
JumpLedge.ReturnPoint:

org $07C172
JumpLedge.BranchAlpha:

; water/grass

org $07F4EE
JML CacheStateForJump
org $07F4F6
CacheStateForJump.ReturnPoint:

org $01FF28
Player_CacheStatePriorToHandler:

org $07BEF8
JML CheckJumpingAboveWaterV
CheckJumpingAboveWaterV.FallIntoWater:
org $07BF4D
CheckJumpingAboveWaterV.JumpAboveWater:

org $07C92F
JML CheckJumpingAboveWaterH
CheckJumpingAboveWaterH.FallIntoWater:
org $07C984
CheckJumpingAboveWaterH.JumpAboveWater:

org $07D14F
JSL SetGrassEffect : NOP

org $07D16C
JSL SetWaterEffect : NOP

org $07D1C2
JSL SetWaterEffect2 : NOP

org $07D1E5
JSL RemoveWaterOrGrassEffect : NOP #2

org $07D159
JML PlayGrassSound

org $07D19F
JML PlayMireWaterSound

org $07D1A6
JML PlayWaterSound

org $07D1D2
JML PlayMireWaterSound

org $07D1D9
JML PlayWaterSound

org $07D2AE
PlayTileSound.RTS:

; stairs

if !AllowStairJump != 0
org $07C0A3
JML CheckMidairBeforeEnteringStairs
CheckMidairBeforeEnteringStairs.Continue:
org $07C0B0
CheckMidairBeforeEnteringStairs.Branch:

org $07C0B6
JSL SetOutdoorStairsState

org $07BCA7
JSL SetIndoorStairsState
endif

; warp

org $07D114
JML CheckDungeonWarpCollision
CheckDungeonWarpCollision.ReturnPoint:
org $07D142
CheckDungeonWarpCollision.BranchPoint:

; sword

org $08D697
JML SetYCoordinateForSwingSparkle
org $08D6A1
SetYCoordinateForSwingSparkle.ReturnPoint:

org $0DAD5F
JSL AddExtendedSwordXYToOam : NOP

; shadow

org $0DA89B
JML CheckIfSmallShadow
CheckIfSmallShadow.Yes:
org $0DA8A9
CheckIfSmallShadow.No:

;================================================================================

