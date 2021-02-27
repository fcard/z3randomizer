!Var_InitialAddress = $7FFF00
!Var_Address #= !Var_InitialAddress

!Var_SRAMInitialAddress = $7F6600
!Var_SRAMAddress #= !Var_SRAMInitialAddress

!Var_SettingInitialAddress = $308500
!Var_SettingAddress #= !Var_SettingInitialAddress

macro NewVar(var)
    !<var> #= !Var_Address
    !Var_Address #= !Var_Address+1
endmacro

macro NewSRAMVar(var)
    !<var> #= !Var_SRAMAddress
    !Var_SRAMAddress #= !Var_SRAMAddress+1
endmacro

macro NewSetting(var, default_value)
    !<var> #= !Var_SettingAddress
    !{Var_SettingDefault!{Var_SettingAddress}} #= <default_value>
    !Var_SettingAddress #= !Var_SettingAddress+1
endmacro

macro AddSettings()
    !setting #= !Var_SettingInitialAddress
    while !setting < !Var_SettingAddress
        !value #= !{Var_SettingDefault!{setting}}
        if !value <= $FF
            db !value
        elseif !value <= $FFFF
            dw !value
        elseif !value <= $FFFFFF
            dl !value
        endif
        !setting #= !setting+1
    endif
endmacro

