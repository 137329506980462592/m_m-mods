ACT_PRESSED_DISALLOWED = (0x08A | ACT_FLAG_INTANGIBLE)

PREFERRED_ACT = ACT_PRESSED_DISALLOWED
COOP_ACT = ACT_TRIPLE_JUMP

DISABLED_ACTS = {
[ACT_READING_AUTOMATIC_DIALOG] = true;
[ACT_WAITING_FOR_DIALOG] = true;
[ACT_READING_NPC_DIALOG] = true;
[ACT_CRAZY_BOX_BOUNCE] = true;
[ACT_SHOT_FROM_CANNON] = true;
[ACT_READING_SIGN] = true;
[ACT_GROUND_POUND] = true;
[PREFERRED_ACT] = true;
}

function DISALLOWED_ACTION(m)
    local mS = gMarioStates[m.playerIndex]
    if mS.actionTimer < 2 and CHECK_PLAYER_INDEX(m) then
        set_mario_animation(mS, MARIO_ANIM_BACKWARDS_WATER_KB)
        set_anim_to_frame(mS, 2)
        mario_set_forward_vel(mS, mS.forwardVel + 45)
    end
    if mS.actionTimer < 1 and CHECK_PLAYER_INDEX(m) then
        play_character_sound(mS, CHAR_SOUND_ON_FIRE)
        mS.hurtCounter = mS.hurtCounter + CHECK_DAMAGE_AMOUNT(mS)
    end
    if mS.actionTimer > 2 and CHECK_PLAYER_INDEX(m) then
        return set_mario_action(mS, ACT_HARD_FORWARD_GROUND_KB, 0)
    end
    mS.actionTimer = mS.actionTimer + 1
    return 0
end

function NEW_ATTACK_ACTION(m)
    local mS = gMarioStates[m.playerIndex]
    if CHECK_PLAYER_INDEX(m) and CHECK_FLAGS(mS) and ALLOW_COOP_ACTION(mS) and not DISABLED_ACTS[mS.action] and not gGlobalSyncTable.AttackActionDisabled then
        set_mario_action(mS, COOP_ACT, 0)
        play_character_sound(mS, CHAR_SOUND_YAHOO_WAHA_YIPPEE) 
        play_sound(SOUND_ACTION_BOUNCE_OFF_OBJECT, mS.marioObj.header.gfx.cameraToObject)
        gPlayerSyncTable[m.playerIndex].CoopAction = false
        return mS.action
    end
end

function ALLOW_COOP_ACTION(m)
    if gMarioStates[m.playerIndex].action ~= COOP_ACT and not gPlayerSyncTable[m.playerIndex].DoingAction then
        gPlayerSyncTable[m.playerIndex].CoopAction = true
    elseif gPlayerSyncTable[m.playerIndex].DoingAction then
        gPlayerSyncTable[m.playerIndex].CoopAction = false
    end
    return gPlayerSyncTable[m.playerIndex].CoopAction
end

function UPDATE_PLAYER(m)
    if gPlayerSyncTable[m.playerIndex].DoingAction then
        gPlayerSyncTable[m.playerIndex].CoopAction = gPlayerSyncTable[m.playerIndex].DoingAction
        gPlayerSyncTable[m.playerIndex].DoingAction = not gPlayerSyncTable[m.playerIndex].CoopAction
    end
    return gPlayerSyncTable[m.playerIndex].DoingAction
end

function COOP_ACTION_CHECK(m)
    return gGlobalSyncTable.AttackActionDisabled, NEW_ATTACK_ACTION(gMarioStates[m.playerIndex])
end