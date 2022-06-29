--
-- Created by IntelliJ IDEA.
-- User: Qoqqi
-- Date: 20.10.2018
-- Time: 18:34
-- To change this template use File | Settings | File Templates.
--

AbilityRandomizer = class({});

function AbilityRandomizer:Create(randyArena, options)

    local instance = AbilityRandomizer();

    instance.randyArena = randyArena;

    RegisterCustomGameEventListener(instance, 'randomize_ability_request', 'OnRequestRandomizeAbility');
    RegisterCustomGameEventListener(instance, 'randomize_ability_cancelled', 'OnRandomizeAbilityCancelled');
    RegisterCustomGameEventListener(instance, 'ability_randomized', 'OnAbilityRandomized');

    ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(instance, 'OnPlayerLearnedAbility'), instance);

    return instance;
end

function AbilityRandomizer:OnRequestRandomizeAbility(event)
    print('OnRequestRandomizeAbility');

    local playerId = event.PlayerID;

    local playerEntity = Players:GetPlayerEntity(playerId);
    local heroEntity = Players:GetHeroEntity(playerId);

    if heroEntity:GetAbilityPoints() < RandyArena.gameSetup.randomizePrice or not RandyArena.gameInProgress then
        return;
    end

    heroEntity:SetAbilityPoints(heroEntity:GetAbilityPoints() - RandyArena.gameSetup.randomizePrice);

    local heroName = ParseHeroName(heroEntity:GetClassname());

    local abilityCount = AbilityUtils:GetVisibleAbilityCount(heroEntity);
    local selectableIndices = table.keys(ABILITIES[heroName].discardable);
    CustomGameEventManager:Send_ServerToPlayer(playerEntity, 'randomize_ability_response', {
        abilityCount = abilityCount,
        allowedAbilities = selectableIndices
    });
end

function AbilityRandomizer:OnAbilityRandomized(event)
    print('OnAbilityRandomized');

    local playerId = event.PlayerID;
    local abilityIndex = event.abilityIndex;

    local heroEntity = Players:GetHeroEntity(playerId);
    local abilityPoints = heroEntity:GetAbilityPoints();

    if abilityPoints < 0 then
        return;
    end

    local abilityInfo;
    if DEBUG_ABILITY_RANDOMIZER and #FORCE_RANDOMIZED_ABILITY > 0 then
        abilityInfo = {
            heroName = nil,
            abilityName = table.remove(FORCE_RANDOMIZED_ABILITY, 1),
        };
    else
        -- TODO: preload sounds
        abilityInfo = ConsumeRandomFromTable(self.randyArena.unusedAbilityPool);
    end

    AbilityUtils:SetHeroAbilityByIndex(heroEntity, abilityIndex, abilityInfo.abilityName);
    if RandyArena.gameInProgress then
        AbilityUtils:RandomizeAbilityLevel(heroEntity, abilityIndex);
    else
        heroEntity:SetAbilityPoints(abilityPoints - 1);
    end
end

function AbilityRandomizer:OnRandomizeAbilityCancelled(event)
    print('OnRandomizeAbilityCancelled');

    local playerId = event.PlayerID;

    local heroEntity = Players:GetHeroEntity(playerId);

    heroEntity:SetAbilityPoints(heroEntity:GetAbilityPoints() + RandyArena.gameSetup.randomizePrice);
end

function AbilityRandomizer:OnPlayerLearnedAbility(event)

    if not RandyArena.gameInProgress then
        return;
    end

    local playerId = event.player;
    local abilityName = event.abilityname;

--    local heroEntity = Players:GetHeroEntity(playerId);
--    local ability = heroEntity:FindAbilityByName(abilityName);
--
--    heroEntity:SetAbilityPoints(heroEntity:GetAbilityPoints() + ability:GetLevel());
--    ability:SetLevel(0);
end