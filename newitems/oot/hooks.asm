!DisableSoundIfMagicDisabled = 0

if !DisableSoundIfMagicDisabled != 0
org $06D135
HandleAbsorbableSfxNew_sfx:

org $06D14E
    JSL HandleAbsorbableSfxNew : NOP #3

org $0DDBAE
    JML IncrementMagicNew

org $0DDBB7
IncrementMagicNew.Increment:
org $0DDBD0
IncrementMagicNew.DontIncrement:

endif


