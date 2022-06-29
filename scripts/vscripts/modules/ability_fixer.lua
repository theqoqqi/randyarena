--
-- Created by IntelliJ IDEA.
-- User: Qoqqi
-- Date: 12.06.2020
-- Time: 17:22
-- To change this template use File | Settings | File Templates.
--

AbilityFixer = class({});

function AbilityFixer:Create(randyArena, options)

    local instance = AbilityFixer();

    ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(instance, 'OnAbilityUsed'), instance);

    return instance;
end

function AbilityFixer:OnHeroInGame(heroEntity)
    AbilityUtils:ForEachAbilityGroupOnHero(heroEntity, function(abilityGroup)
        local abilityList = abilityGroup.abilityList;
        for _, abilityName in pairs(abilityList) do
            local ability = heroEntity:FindAbilityByName(abilityName);
            if ability then
                ability:SetHidden(abilityList[1] ~= abilityName);
            end
        end
    end);
end

function AbilityFixer:OnAllHeroesInGame()
    Timers:CreateTimer(0.1, function()
        self:OnThink(0.1);
        return 0.1;
    end);
end

function AbilityFixer:OnThink()
    Players:ForEachHeroEntity(function(playerId, heroEntity)
        self:OnHeroEntityThink(heroEntity);
    end);
end

function AbilityFixer:OnHeroEntityThink(heroEntity)
    AbilityUtils:ForEachAbilityGroupOnHero(heroEntity, function(abilityGroup)
        local mainAbilityName = abilityGroup.abilityList[1];
        local mainAbility = heroEntity:FindAbilityByName(mainAbilityName);

        local activeAbilityName = AbilityUtils:GetActiveSwapButtonAbilityName(heroEntity, abilityGroup);
        local activeAbility = heroEntity:FindAbilityByName(activeAbilityName);

        if abilityGroup.resetOnCooldown then
            if mainAbility:IsCooldownReady() and mainAbility:IsHidden() then
                AbilityUtils:ToggleSwapButtonAbility(heroEntity, activeAbilityName, mainAbilityName);
            end
        end

        if abilityGroup.resetOnInactive then
            if mainAbility ~= activeAbility and not activeAbility:IsActivated() then
                AbilityUtils:ToggleSwapButtonAbility(heroEntity, activeAbilityName, mainAbilityName);
            end
        end
    end);
end

function AbilityFixer:OnAbilityUsed(event)

    local heroEntity = Players:GetHeroEntity(event.PlayerID);
    local abilityName = event.abilityname;

    if AbilityUtils:HasAbilityGroupForAbility(heroEntity, abilityName) then
        local abilityGroup = AbilityUtils:GetAbilityGroupForAbility(heroEntity, abilityName);

        if table.contains(abilityGroup.swapOnUse, abilityName) then
            local nextAbilityName = AbilityUtils:GetNextSwapButtonAbility(abilityName);
            AbilityUtils:ToggleSwapButtonAbility(heroEntity, abilityName, nextAbilityName);
        end

        local mainAbilityName = abilityGroup.abilityList[1];
        local mainAbility = heroEntity:FindAbilityByName(mainAbilityName);

        if abilityName == mainAbilityName and type(abilityGroup.resetOnCooldown) == 'function' then
            local timeout = abilityGroup.resetOnCooldown(heroEntity);

            Timers:CreateTimer(timeout, function()
                local activeAbilityName = AbilityUtils:GetActiveSwapButtonAbilityName(heroEntity, abilityGroup);
                if activeAbilityName ~= mainAbilityName and mainAbility:IsHidden() then
                    AbilityUtils:ToggleSwapButtonAbility(heroEntity, activeAbilityName, mainAbilityName);
                end
            end);
        end
    end
end