function CHECK_PLAYER_INDEX(m)
    if m.playerIndex == 0 then
        return true
    end
end

function CHECK_LEVEL(m)
    local mNP = gNetworkPlayers[m.playerIndex]
    if (CASTLE_LEVELS[mNP.currLevelNum] and not gGlobalSyncTable.CastleDisabled) or (BOWSER_LEVELS[mNP.currLevelNum] and not gGlobalSyncTable.BowserDisabled) then
        return true
    end
end

function CHECK_FLAGS(m)
    local mS = gMarioStates[m.playerIndex]
    if (mS.action & (ACT_FLAG_INTANGIBLE | ACT_FLAG_INVULNERABLE | ACT_FLAG_SWIMMING_OR_FLYING | ACT_FLAG_WATER_OR_TEXT)) == 0 then
        return true
    end
end

function CHECK_WATER(m)
    local mS = gMarioStates[m.playerIndex]
    if (mS.action & (ACT_FLAG_SWIMMING)) ~= 0 and not CHECK_LEVEL(mS) then
        local terrainIsSnow = (mS.area.terrainType & 7) == 2
        if (mS.pos.y >= (mS.waterLevel - 140)) and not terrainIsSnow then
            mS.health = mS.health - 0x1A
            return true
        end
    end
end

function CHECK_DAMAGE_AMOUNT(m)
    local mS = gMarioStates[m.playerIndex]
    local A
    if (mS.flags & MARIO_METAL_CAP) ~= 0 then
        A = 4
    else
        A = 4 * 2
    end
    if not gGlobalSyncTable.InstaDeathDisabled then
        A = 4 * 8
    end
    return A
end

function CHECK_MARIO_DEAD(m)
    local mS = gMarioStates[m.playerIndex]
    if mS.health >= 0x100 then
        return true
    end
end

function CHECK_PLAYER_COLOR(m)
    if CHECK_PLAYER_INDEX(m) then
        return network_get_player_text_color_string(m.playerIndex)
    end
end