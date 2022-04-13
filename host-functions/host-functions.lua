HOST_FUNCTIONS = {
    [L_TRIG] = (function(m) return spawn_sync_object(id_bhvHostGrandStar, E_MODEL_STAR, m.pos.x, m.pos.y + 240, m.pos.z, nil) end);
    [R_JPAD] = (function(m) return RELOAD_LEVEL(m) end);
}

--[[Sample Functions]]

function RELOAD_LEVEL(m)
    gMarioStates[m.playerIndex].health = 2176
    return warp_to_level(gNetworkPlayers[m.playerIndex].currLevelNum, gNetworkPlayers[m.playerIndex].currAreaIndex, gNetworkPlayers[m.playerIndex].currActNum)
end

local function GRAND_STAR_SET(o)
    local p = get_temp_object_hitbox()
    p.interactType = INTERACT_COIN
    o.oInteractionSubtype = INT_SUBTYPE_GRAND_STAR
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    return play_sound(SOUND_GENERAL_GRAND_STAR_JUMP, o.header.gfx.cameraToObject), obj_set_hitbox(o, p), cur_obj_become_tangible()
end

local function GRAND_STAR_COLLECTED(o)
    if o.oInteractStatus & (INT_STATUS_INTERACTED) ~= 0 then
        return play_sound(SOUND_MENU_STAR_SOUND, o.header.gfx.cameraToObject), set_mario_action(gMarioStates[0], ACT_JUMBO_STAR_CUTSCENE, 0), obj_mark_for_deletion(o)
    end
end

id_bhvHostGrandStar = hook_behavior(nil, OBJ_LIST_LEVEL, true, GRAND_STAR_SET, GRAND_STAR_COLLECTED)