Player_DoSfx1Long:
    JSR Player_SetSfxPan : STA $012D
RTL

Player_DoSfx2Long:
    JSR Player_SetSfxPan : STA $012E
RTL

Player_DoSfx3Long:
    JSR Player_SetSfxPan : STA $012F
RTL

Player_SetSfxPan:
    STA $0CF8
    JSL Sound_SetSfxPanWithPlayerCoords : ORA $0CF8
RTS


