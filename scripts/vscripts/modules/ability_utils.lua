--
-- Created by IntelliJ IDEA.
-- User: Qoqqi
-- Date: 20.10.2018
-- Time: 18:52
-- To change this template use File | Settings | File Templates.
--

if AbilityUtils == nil then
    AbilityUtils = {};
    AbilityUtils.fixableAbilityModifiers = {
        mirana_starfall = {
            'modifier_mirana_starfall_scepter_thinker',
        },
        monkey_king_jingu_mastery = {
            'modifier_monkey_king_quadruple_tap',
            'modifier_monkey_king_quadruple_tap_counter',
        },
    };
    AbilityUtils.fixableAbilities = {
        'abaddon_frostmourne',
        'axe_counter_helix',
        'bloodseeker_rupture',
       -- 'dawnbreaker_luminosity', -- crashes the game anyway
        'legion_commander_moment_of_courage',
        'lina_fiery_soul',
        'mirana_starfall',
        'monkey_king_jingu_mastery',
        'viper_poison_attack',
        'visage_summon_familiars',
        'weaver_geminate_attack',
    };
end

function AbilityUtils:GetAllAbilitiesInfoByPlayers(swappableOnly)
    local allAbilitiesInfo = {};

    Players:ForEachHeroEntity(function(playerId, heroEntity)
        allAbilitiesInfo[playerId] = AbilityUtils:GetPlayerAbilitiesInfoTo(heroEntity, {}, function(list, abilityInfo)
            if swappableOnly then
                local heroName = ParseHeroName(heroEntity:GetClassname());
                local heroSwappableAbilities = ABILITIES[heroName].swappable;
                if table.contains(heroSwappableAbilities, abilityInfo.abilityName) then
                    list[abilityInfo.abilityIndex] = abilityInfo;
                end
            else
                list[abilityInfo.abilityIndex] = abilityInfo;
            end
        end);
    end);

    return allAbilitiesInfo;
end

function AbilityUtils:GetPlayerAbilitiesInfoTo(heroEntity, abilityList, insertFunc)
    AbilityUtils:ForEachAbilityInfo(heroEntity, function(abilityInfo, index)
        if abilityInfo ~= nil and abilityInfo.abilityName ~= 'generic_hidden' then
            insertFunc(abilityList, abilityInfo);
        end
    end);
    return abilityList;
end

function AbilityUtils:SetHeroAbilityByIndex(heroEntity, abilityIndex, newAbilityName)
    local oldAbilityName = heroEntity:GetAbilityByIndex(abilityIndex):GetAbilityName();

    if oldAbilityName == newAbilityName then
        return;
    end

    local ability = self:AddAbility(heroEntity, newAbilityName);
    local mainAbilityName = ability:GetAbilityName();

    heroEntity:SwapAbilities(oldAbilityName, mainAbilityName, false, true);
    self:RemoveAbility(heroEntity, oldAbilityName);

    return ability;
end

function AbilityUtils:AddAbility(heroEntity, abilityName)
    local abilityGroup = self:GetAbilityGroupForAbility(nil, abilityName);

    if not abilityGroup then
        heroEntity:AddAbility(abilityName);
        self:FixAbility(heroEntity, abilityName);
        return heroEntity:FindAbilityByName(abilityName);
    end

    local abilityList = abilityGroup.abilityList;
    for _, newAbilityName in pairs(abilityList) do
        heroEntity:AddAbility(newAbilityName);
        self:FixAbility(heroEntity, newAbilityName);
    end

    self:ResetActiveAbility(heroEntity, abilityGroup);

    return heroEntity:FindAbilityByName(abilityList[1]);
end

function AbilityUtils:RemoveAbility(heroEntity, abilityName)
    local abilityGroup = self:GetAbilityGroupForAbility(nil, abilityName);
    if abilityGroup then
        local abilityList = abilityGroup.abilityList;
        for _, newAbilityName in pairs(abilityList) do
            heroEntity:RemoveAbility(newAbilityName);
        end
    else
        heroEntity:RemoveAbility(abilityName);
    end
end

function AbilityUtils:FixAbility(heroEntity, abilityName)
    if table.contains(self.fixableAbilities, abilityName) then
        heroEntity:RemoveModifierByName('modifier_' .. abilityName);
        heroEntity:RemoveModifierByName('modifier_' .. abilityName .. '_aura');
        heroEntity:RemoveModifierByName('modifier_' .. abilityName .. '_buff');
        heroEntity:RemoveModifierByName('modifier_' .. abilityName .. '_thinker');
    end

    for _, modifierName in pairs(self.fixableAbilityModifiers[abilityName] or {}) do
        heroEntity:RemoveModifierByName(modifierName);
    end
end

function AbilityUtils:GetVisibleAbilityCount(heroEntity)
    local abilityCount = 0;
    AbilityUtils:ForEachVisibleAbility(heroEntity, function(ability)
        abilityCount = abilityCount + 1;
    end);
    return abilityCount;
end

function AbilityUtils:GetVisibleAbilities(heroEntity)
    local abilities = {};
    AbilityUtils:ForEachVisibleAbility(heroEntity, function(ability)
        table.insert(abilities, ability);
    end);
    return abilities;
end

function AbilityUtils:ForEachAbilityInfo(heroEntity, callback)
    for abilityIndex = 0, 5 do
        callback(AbilityUtils:GetAbilityInfoByIndex(heroEntity, abilityIndex), abilityIndex);
    end
end

function AbilityUtils:ForEachVisibleAbility(heroEntity, callback)
    AbilityUtils:ForEachAbility(heroEntity, function(ability, index, name)
        if not ability:IsHidden() then
            callback(ability, index, name);
        end
    end);
end

function AbilityUtils:ForEachAbility(heroEntity, callback)
    for abilityIndex = 0, 5 do
        local ability = heroEntity:GetAbilityByIndex(abilityIndex);
        if ability ~= nil then
            callback(ability, abilityIndex, ability:GetAbilityName());
        end
    end
end

function AbilityUtils:RandomizeAbilityLevel(heroEntity, abilityIndex)
    local ability = heroEntity:GetAbilityByIndex(abilityIndex);
    if ability == nil then
        return;
    end
    local maxLevel = ability:GetMaxLevel();
    if maxLevel == 1 then
        ability:UpgradeAbility(true);
        return;
    end
    local playerCount = RandyArena:GetNumberOfPlayersForRules();
    local levelChances = ABILITY_CHEST_SETTINGS[playerCount]['level_chances'][maxLevel];
    local chance = RandomInt(1, 100);
    local index = 0;
    while chance > 0 do
        index = index + 1;
        chance = chance - levelChances[index];
        if index > 1 then
            ability:UpgradeAbility(true);
        end
    end
end

function AbilityUtils:GetAbilityInfoByIndex(heroEntity, abilityIndex)
    local ability = heroEntity:GetAbilityByIndex(abilityIndex);
    if ability == nil then
        return nil;
    end

    return {
        abilityIndex = abilityIndex,
        abilityName = ability:GetAbilityName(),
    };
end

function AbilityUtils:ToggleSwapButtonAbility(heroEntity, currentAbilityName, nextAbilityName)
    local currentAbility = heroEntity:FindAbilityByName(currentAbilityName);
    local nextAbility = heroEntity:FindAbilityByName(nextAbilityName);

    heroEntity:SwapAbilities(currentAbilityName, nextAbilityName, true, true);
    currentAbility:SetHidden(true);
    nextAbility:SetHidden(false);
end

function AbilityUtils:ResetActiveAbility(heroEntity, abilityGroup)
    local abilityList = abilityGroup.abilityList;
    local mainAbilityName = abilityList[1];
    for _, abilityName in pairs(abilityList) do
        local ability = heroEntity:FindAbilityByName(abilityName);
        ability:SetHidden(abilityName ~= mainAbilityName);
    end
end

function AbilityUtils:GetNextSwapButtonAbility(currentAbilityName)
    for _, abilityGroup in pairs(SWAP_BUTTON_ABILITIES) do
        local abilityList = abilityGroup.abilityList;
        for index, abilityName in pairs(abilityList) do
            if abilityName == currentAbilityName then
                local returnIndex = index == #abilityList and 1 or index + 1;
                return abilityList[returnIndex];
            end
        end
    end
    return nil;
end

function AbilityUtils:IsSwapButtonAbility(currentAbilityName)
    for _, abilityGroup in pairs(SWAP_BUTTON_ABILITIES) do
        local abilityList = abilityGroup.abilityList;
        for _, abilityName in pairs(abilityList) do
            if abilityName == currentAbilityName then
                return true;
            end
        end
    end
    return false;
end

function AbilityUtils:GetHeroAbilityGroups(heroEntity)
    local abilityGroups = {};
    self:ForEachAbilityGroupOnHero(heroEntity, function(abilityGroup)
        table.insert(abilityGroups, abilityGroup);
    end);
    return abilityGroups;
end

function AbilityUtils:ForEachAbilityGroupOnHero(heroEntity, callback)
    for _, abilityGroup in pairs(SWAP_BUTTON_ABILITIES) do
        if self:HasAbilityGroup(heroEntity, abilityGroup) then
            callback(abilityGroup);
        end
    end
end

function AbilityUtils:HasAbilityGroup(heroEntity, abilityGroup)
    local abilityList = abilityGroup.abilityList;
    for _, abilityName in pairs(abilityList) do
        if not heroEntity:HasAbility(abilityName) then
            return false;
        end
    end
    return true;
end

function AbilityUtils:HasAbilityGroupForAbility(heroEntity, forAbilityName)
    return self:GetAbilityGroupForAbility(heroEntity, forAbilityName) ~= nil;
end

function AbilityUtils:GetAbilityGroupForAbility(heroEntity, forAbilityName)
    local abilityGroups;
    if heroEntity ~= nil then
        abilityGroups = self:GetHeroAbilityGroups(heroEntity);
    else
        abilityGroups = SWAP_BUTTON_ABILITIES;
    end
    for _, abilityGroup in pairs(abilityGroups) do
        local abilityList = abilityGroup.abilityList;
        for _, abilityName in pairs(abilityList) do
            if abilityName == forAbilityName then
                return abilityGroup;
            end
        end
    end
    return nil;
end

function AbilityUtils:GetActiveSwapButtonAbilityName(heroEntity, abilityGroup)
    local abilityList = abilityGroup.abilityList;
    for _, abilityName in pairs(abilityList) do
        local ability = heroEntity:FindAbilityByName(abilityName);
        if not ability:IsHidden() then
            return abilityName;
        end
    end
    return nil;
end