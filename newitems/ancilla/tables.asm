; This table contains the banks of the subroutines called each frame
; for every ancilla object active. All original ones use
; 0x08, the point of this table is for new ones, or in case
; we change where a subroutine points.
AncillaRoutineBanks:
; Original Effects
    db bank(Ancilla_SomarianBlast)
    db bank(Ancilla_FireShot)
    db bank(Ancilla_Unknown)
    db bank(Ancilla_BeamHit)
    db bank(Ancilla_Boomerang)
    db bank(Ancilla_WallHit)
    db bank(Ancilla_Bomb)

    db bank(Ancilla_DoorDebris)
    db bank(Ancilla_Arrow)
    db bank(Ancilla_HaltedArrow)
    db bank(Ancilla_IceShot)
    db bank(Ancilla_SwordBeam)
    db bank(Ancilla_SwordFullChargeSpark)
    db bank(Ancilla_Unused_)
    db bank(Ancilla_Unused_)

    db bank(Ancilla_Unused_)
    db bank(Ancilla_IceShotSpread)
    db bank(Ancilla_Unused_)
    db bank(Ancilla_IceShotSparkle)
    db bank(Ancilla_Unknown2)
    db bank(Ancilla_JumpSplash)
    db bank(Ancilla_HitStars)
    db bank(Ancilla_ShovelDirt)

    db bank(Ancilla_EtherSpell)
    db bank(Ancilla_BombosSpell)
    db bank(Ancilla_MagicPowder)
    db bank(Ancilla_SwordWallHit)
    db bank(Ancilla_QuakeSpell)
    db bank(Ancilla_DashTremor)
    db bank(Ancilla_DashDust)
    db bank(Ancilla_Hookshot)

    db bank(Ancilla_BedSpread)
    db bank(Ancilla_SleepIcon)
    db bank(Ancilla_ReceiveItem)
    db bank(Ancilla_MorphPoof)
    db bank(Ancilla_Gravestone)
    db bank(Ancilla_Unknown3)
    db bank(Ancilla_SwordSwingSparkle)
    db bank(Ancilla_TravelBird)

    db bank(Ancilla_WishPondItem)
    db bank(Ancilla_MilestoneItem)
    db bank(Ancilla_InitialSpinSpark)
    db bank(Ancilla_SpinSpark)
    db bank(Ancilla_SomarianBlock)
    db bank(Ancilla_SomarianBlockFizzle)
    db bank(Ancilla_SomarianBlockDivide)
    db bank(Ancilla_LampFlame)

    db bank(Ancilla_InitialCaneSpark)
    db bank(Ancilla_CaneSpark)
    db bank(Ancilla_BlastWallFireball)
    db bank(Ancilla_Unused_)
    db bank(Ancilla_SkullWoodsFire)
    db bank(Ancilla_SwordCeremony)
    db bank(Ancilla_Unknown4)
    db bank(Ancilla_Flute)
    ;db bank(Ancilla_WeathervaneExplosion)

    db bank(Ancilla_TravelBirdIntro)
    db bank(Ancilla_SomarianPlatformPoof)
    db bank(Ancilla_SuperBombExplosion)
    db bank(Ancilla_VictorySparkle)
    db bank(Ancilla_SwordChargeSpark)
    db bank(Ancilla_ObjectSplash)
    db bank(Ancilla_RisingCrystal)
    db bank(Ancilla_BushPoof)

    db bank(Ancilla_DwarfPoof)
    db bank(Ancilla_WaterfallSplash)
    db bank(Ancilla_HappinessPondRupees)
    db bank(Ancilla_BreakTowerSeal)

; New Effects
    db bank(AncillaExt_Example)
    db bank(AncillaExt_LightSpin)


; This table contains the word addresses of the subroutines called each frame
; for every ancilla object active.
AncillaRoutines:
; Original Effects
    dw Ancilla_SomarianBlast
    dw Ancilla_FireShot
    dw Ancilla_Unknown
    dw Ancilla_BeamHit
    dw Ancilla_Boomerang
    dw Ancilla_WallHit
    dw Ancilla_Bomb

    dw Ancilla_DoorDebris
    dw Ancilla_Arrow
    dw Ancilla_HaltedArrow
    dw Ancilla_IceShot
    dw Ancilla_SwordBeam
    dw Ancilla_SwordFullChargeSpark
    dw Ancilla_Unused_
    dw Ancilla_Unused_

    dw Ancilla_Unused_
    dw Ancilla_IceShotSpread
    dw Ancilla_Unused_
    dw Ancilla_IceShotSparkle
    dw Ancilla_Unknown2
    dw Ancilla_JumpSplash
    dw Ancilla_HitStars
    dw Ancilla_ShovelDirt

    dw Ancilla_EtherSpell
    dw Ancilla_BombosSpell
    dw Ancilla_MagicPowder
    dw Ancilla_SwordWallHit
    dw Ancilla_QuakeSpell
    dw Ancilla_DashTremor
    dw Ancilla_DashDust
    dw Ancilla_Hookshot

    dw Ancilla_BedSpread
    dw Ancilla_SleepIcon
    dw Ancilla_ReceiveItem
    dw Ancilla_MorphPoof
    dw Ancilla_Gravestone
    dw Ancilla_Unknown3
    dw Ancilla_SwordSwingSparkle
    dw Ancilla_TravelBird

    dw Ancilla_WishPondItem
    dw Ancilla_MilestoneItem
    dw Ancilla_InitialSpinSpark
    dw Ancilla_SpinSpark
    dw Ancilla_SomarianBlock
    dw Ancilla_SomarianBlockFizzle
    dw Ancilla_SomarianBlockDivide
    dw Ancilla_LampFlame

    dw Ancilla_InitialCaneSpark
    dw Ancilla_CaneSpark
    dw Ancilla_BlastWallFireball
    dw Ancilla_Unused_
    dw Ancilla_SkullWoodsFire
    dw Ancilla_SwordCeremony
    dw Ancilla_Unknown4
    ;dw Ancilla_WeathervaneExplosion
    dw Ancilla_Flute

    dw Ancilla_TravelBirdIntro
    dw Ancilla_SomarianPlatformPoof
    dw Ancilla_SuperBombExplosion
    dw Ancilla_VictorySparkle
    dw Ancilla_SwordChargeSpark
    dw Ancilla_ObjectSplash
    dw Ancilla_RisingCrystal
    dw Ancilla_BushPoof

    dw Ancilla_DwarfPoof
    dw Ancilla_WaterfallSplash
    dw Ancilla_HappinessPondRupees
    dw Ancilla_BreakTowerSeal

; New Effects
    dw AncillaExt_Example
    dw AncillaExt_LightSpin

; This table is the max amount of sprites an ancilla object
; can draw per frame times 4. Don't overdo it, or the sprites
; might flicker!
AncillaMaxSpriteCount:
; Original Effects
    db $08, $0C, $10, $10, $04, $10, $18
    db $08, $08, $08, $00, $14, $00, $10, $28
    db $18, $10, $10, $10, $0C, $08, $08, $50
    db $00, $10, $10, $08, $40, $00, $0C, $24
    db $10, $0C, $08, $10, $10, $04, $0C, $1C
    db $00, $10, $14, $14, $14, $10, $08, $20
    db $10, $10, $10, $04, $00, $80, $10, $04
    db $30, $14, $10, $00, $10, $00, $00, $08
    db $00, $10, $08, $78

; New Effects
    db $08, $10

