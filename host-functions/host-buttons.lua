local HELD_BUTTON = Y_BUTTON

function ACTIVATE_BINDS(m)
    if (m.controller.buttonDown & HELD_BUTTON) ~= 0 and (HOST_FUNCTIONS[m.controller.buttonPressed]) then
        return HOST_FUNCTIONS[m.controller.buttonPressed](m)
    end
end

function HOST_BINDS()
    if network_is_server() then
        return ACTIVATE_BINDS(gMarioStates[0])
    end
end

hook_event(HOOK_UPDATE, HOST_BINDS)