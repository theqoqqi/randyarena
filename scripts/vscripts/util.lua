--
-- Created by IntelliJ IDEA.
-- User: Qoqqi
-- Date: 23.10.2018
-- Time: 19:52
-- To change this template use File | Settings | File Templates.
--

function inherit(self, baseClass)
    setmetatable(self, { __index = baseClass });
    for key, value in pairs(baseClass) do
        if type(value) == 'function' then
            self[key] = value;
        end
    end
end

function MergeTables(t1, t2)
    for name, info in pairs(t2) do
        if type(info) == 'table' and type(t1[name]) == 'table' then
            MergeTables(t1[name], info);
        else
            t1[name] = info;
        end
    end
end

function RegisterCustomGameEventListener(context, eventName, listener)
    CustomGameEventManager:RegisterListener(eventName, function(id, event)
        return context[listener](context, event, id);
    end)
end

function RandomFromTable(t)
    local keys = table.keys(t);
    local key = keys[RandomInt(1, #keys)];
    return t[key];
end

function ConsumeRandomFromTable(t)
    local keys = table.keys(t);
    local key = keys[RandomInt(1, #keys)];
    local value = t[key];
    t[key] = nil;
    return value;
end

function ParseHeroName(heroName)
    return string.sub(heroName, string.len('npc_dota_hero_') + 1);
end

function SpawnCourierForPlayer(playerId)

    local teamId = Players:TeamOf(playerId);
    local heroEntity = Players:GetHeroEntity(playerId);
    local courierSpawn = GetCourierSpawnForTeam(teamId);
    local position = courierSpawn:GetAbsOrigin();
    local courier = CreateUnitByName(
        'npc_dota_courier',
        position,
        true,
        nil,
        nil,
        teamId
    );

--    courier:AddNewModifier(courier, nil, 'modifier_turbo_courier_haste', {});
--    courier:AddNewModifier(courier, nil, 'modifier_turbo_courier_invulnerable', {});
--    courier:AddNewModifier(courier, nil, 'modifier_courier_flying', {});
    courier:AddNewModifier(courier, nil, 'modifier_custom_courier', { playerId = playerId });

    courier:SetControllableByPlayer(playerId, true);
    courier:SetOwner(heroEntity);

    return courier;
end

function GetCourierSpawnForTeam(teamId)

    if teamId == DOTA_TEAM_GOODGUYS then
        return Entities:FindByClassname(nil, 'info_courier_spawn_radiant');

    elseif teamId == DOTA_TEAM_BADGUYS then
        return Entities:FindByClassname(nil, 'info_courier_spawn_dire');
    end

    local courierSpawn;

    while true do
        courierSpawn = Entities:FindByClassname(courierSpawn, 'info_courier_spawn');
        if not (courierSpawn == nil) and courierSpawn:GetTeam() == teamId then
            return courierSpawn;
        end
        if courierSpawn == nil then
            return nil;
        end
    end
end

function AddBonusStrength(entity, ability, bonusAmount)
    AddBonusAttribute(entity, ability, 'modifier_bonus_strength', bonusAmount);
end

function AddBonusAgility(entity, ability, bonusAmount)
    AddBonusAttribute(entity, ability, 'modifier_bonus_agility', bonusAmount);
end

function AddBonusIntelligence(entity, ability, bonusAmount)
    AddBonusAttribute(entity, ability, 'modifier_bonus_intelligence', bonusAmount);
end

function AddBonusAttribute(entity, ability, modifierName, bonusAmount)
    if not entity:HasModifier(modifierName) then
        entity:AddNewModifier(entity, ability, modifierName, {});
        entity:SetModifierStackCount(modifierName, entity, 0);
    end

    local count = entity:GetModifierStackCount(modifierName, entity);
    entity:SetModifierStackCount(modifierName, entity, count + bonusAmount);

    -- Необходимо, чтобы корректно обновлялись числа в интерфейсе
    entity:AddNewModifier(entity, ability, 'modifier_dummy', {});
    entity:RemoveModifierByName('modifier_dummy');
end

function GetItemKvByName(itemName)
    return KV_ITEMS[itemName];
end

function GetItemKvValue(itemName, valueName)
    if KV_ITEMS[itemName] then
        return KV_ITEMS[itemName][valueName];
    end
    return nil;
end

function GetItemSpecialValue(item, key)
    return GetItemSpecialValueForLevel(item, key, 1);
end

function GetAbilitySpecialValue(item, key)
    return GetAbilitySpecialValueForLevel(item, key, 1);
end

function GetItemSpecialValueForLevel(item, key, level)
    return GetSpecialValueForLevel(KV_ITEMS[item], key, level);
end

function GetAbilitySpecialValueForLevel(item, key, level)
    return GetSpecialValueForLevel(KV_ABILITIES[item], key, level);
end

function GetSpecialValueForLevel(kv, key, level)
    -- new AbilityValues block
    local valuesByKeys = kv.AbilityValues;
    if valuesByKeys then
        local value = valuesByKeys[key];
        -- unwrap from subtable if wrapped
        if type(value) == 'table' then
            value = value.value;
        end
        -- parse string if contains spaces
        if type(value) == 'string' then
            local values = {};
            for str in value:gmatch('%S+') do
                table.insert(values, str);
            end
            if #values < level then
                return nil;
            end
            value = values[level];
        end
        -- cast if value is number
        if tonumber(value) ~= nil then
            return tonumber(value);
        else
            return value;
        end
    end

    -- fallback to legacy AbilitySpecial block
    local specials = kv.AbilitySpecial;
    if not specials then
        return nil;
    end
    for _, special in pairs(specials) do
        for k, v in pairs(special) do
            if k == key then
                local value = v;
                if type(v) == 'string' then
                    local values = {};
                    for str in v:gmatch('%S+') do
                        table.insert(values, str);
                    end
                    if #values < level then
                        return nil;
                    end
                    value = values[level];
                end
                if special.var_type == 'FIELD_INTEGER' or special.var_type == 'FIELD_FLOAT' then
                    return tonumber(value);
                else
                    return value;
                end
            end
        end
    end
    return nil;
end

KV_ITEMS = LoadKeyValues('scripts/npc/items.txt');
MergeTables(KV_ITEMS, LoadKeyValues('scripts/npc/npc_abilities_override.txt'));
MergeTables(KV_ITEMS, LoadKeyValues('scripts/npc/npc_items_custom.txt'));

KV_ABILITIES = LoadKeyValues('scripts/npc/npc_abilities.txt');
MergeTables(KV_ABILITIES, LoadKeyValues('scripts/npc/npc_abilities_override.txt'));

KV_HEROES = LoadKeyValues('scripts/npc/npc_heroes.txt');
MergeTables(KV_HEROES, LoadKeyValues('scripts/npc/npc_heroes_custom.txt'));