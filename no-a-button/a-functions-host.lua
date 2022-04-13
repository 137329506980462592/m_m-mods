local function SETTINGS(m)
    if (gMarioStates[m.playerIndex].controller.buttonDown & R_TRIG) ~= 0 and (gMarioStates[m.playerIndex].controller.buttonPressed & U_JPAD) ~= 0 then
        gGlobalSyncTable.AButtonDisabled = not gGlobalSyncTable.AButtonDisabled
        return djui_popup_create('No A Button: \\#ffaaff\\'..string.upper(tostring(gGlobalSyncTable.AButtonDisabled)), 2)
    end
end

local function HOST_SETTINGS()
    if network_is_server() then
        return SETTINGS(gMarioStates[0])
    end
end

hook_event(HOOK_UPDATE, HOST_SETTINGS)