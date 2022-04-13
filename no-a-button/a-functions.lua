function BUTTON_CHECK(m)
    local mS = gMarioStates[m.playerIndex]
    if (mS.controller.buttonPressed & A_BUTTON) ~= 0 and gGlobalSyncTable.AButtonDisabled then
        return DISALLOWED_BUTTON(gMarioStates[m.playerIndex])
    end
end

function DISALLOWED_BUTTON(m)
    if not gGlobalSyncTable.AButtonDisabled then return end
    local mS = gMarioStates[m.playerIndex]
    if CHECK_PLAYER_INDEX(m) and (mS.action & (ACT_FLAG_SWIMMING | ACT_FLAG_METAL_WATER)) ~= 0 and mS.hurtCounter < 2 and CHECK_MARIO_DEAD(mS) and not CHECK_LEVEL(mS) then
        mS.hurtCounter = mS.hurtCounter + CHECK_DAMAGE_AMOUNT(mS)
        return set_mario_action(mS, ACT_WATER_SHOCKED, 0), REMIND_PLAYER(mS)
    end
    if CHECK_PLAYER_INDEX(m) and not DISABLED_ACTS[mS.action] and not CHECK_LEVEL(mS) then
        return FAIL_PLAYER(mS)
    end
end

function FAIL_PLAYER(m)
    local mS = gMarioStates[m.playerIndex]
    if CHECK_PLAYER_INDEX(m) and CHECK_FLAGS(mS) and CHECK_PLAYER_INDEX(mS) and CHECK_MARIO_DEAD(mS) then
        return set_mario_action(mS, PREFERRED_ACT, 0), REMIND_PLAYER(mS), mario_stop_riding_and_holding(mS)
    end
end

function REMIND_PLAYER(m)
    local mS = gMarioStates[m.playerIndex]
    if CHECK_PLAYER_INDEX(m) then
        play_sound(SOUND_GENERAL_RACE_GUN_SHOT, mS.marioObj.header.gfx.cameraToObject)
        spawn_non_sync_object(id_bhvWhitePuff2, E_MODEL_EXPLOSION, mS.pos.x, mS.pos.y + 40, mS.pos.z, nil)
        djui_popup_create("Don't press \\#ff6060\\A\n"..CHECK_PLAYER_COLOR(m)..gNetworkPlayers[0].name.."\\#ffffff\\!", 2)
    end
end

function CLIENT_UPDATING(m)
    return UPDATE_PLAYER(m), BUTTON_CHECK(m), CHECK_WATER(m)
end