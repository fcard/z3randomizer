; Settings (1 = Yes, 0 = No)

!PushOutOfDoorway = 1 ; Push Link out of vertical doorways when he jumps
!AllowBunnyJumpWithRing = 0 ; Bunny Link can jump with gravity ring
!AllowBunnyJumpAlways = 1 ; Bunny Link can jump always
!AllowHookshotWaterJump = 0 ; Allow using hookshot while jumping above water
!AllowStairJump = 0 ; allow jumping while on outdoor staircases

assert !AllowBunnyJumpWithRing == 0 || !AllowBunnyJumpAlways == 0,\
"\!AllowBunnyJumpWithRing and \!AllowBunnyJumpAlways cannot simutaneously be true."

; Addresses

!JumpInverseDirection = $7C
!JumpForwardDirection = $7D
!JumpNonStartingDirections = $7E
!JumpDirectionType = $7F
!IsJumping = $80
!JumpTimer = $81
!JumpingAboveWater = $82

; Constants

!JumpDistance = $30
!JumpDistanceDash = $60
!JumpDistanceDiagonal = $28


