; Handle jumping over dungeon warp tiles
CheckDungeonWarpCollision:
    LDA !IsJumping : BNE +
    LDA $4D : BNE +
        JML CheckDungeonWarpCollision.ReturnPoint
    +
JML CheckDungeonWarpCollision.BranchPoint

