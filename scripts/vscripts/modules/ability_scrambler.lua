--
-- Created by IntelliJ IDEA.
-- User: Qoqqi
-- Date: 20.10.2018
-- Time: 18:34
-- To change this template use File | Settings | File Templates.
--

AbilityScrambler = class({});

function AbilityScrambler:Create(randyArena, options)

    local instance = AbilityScrambler();

    instance.abilitiesToScramble = {};
    instance.replaceAbilityTimer = nil;

    RegisterCustomGameEventListener(instance, 'ability_scrambled', 'OnAbilityScrambled');

    return instance;
end

function AbilityScrambler:OnGameInProgress()
    self:ShuffleAbilities();
    CustomGameEventManager:Send_ServerToAllClients('abilities_scrambled', {});
end

function AbilityScrambler:OnAllHeroesInGame()

    Players:ForEachHeroEntity(function(playerId, heroEntity)
        local playerEntity = Players:GetPlayerEntity(playerId);
        local abilityCount = AbilityUtils:GetVisibleAbilityCount(heroEntity);
        local heroName = ParseHeroName(heroEntity:GetClassname());
        local selectableIndices = table.keys(ABILITIES[heroName].swappable);

        CustomGameEventManager:Send_ServerToPlayer(playerEntity, 'hero_spawned', {
            useScrambler = RandyArena.gameSetup.freeRandoms == 0,
            abilityCount = abilityCount,
            allowedAbilities = selectableIndices,
            timeToSelect = PRE_GAME_TIME
        });
    end);

    Convars:RegisterCommand('shuffle', function()
        AbilityScrambler:ShuffleAbilities();
    end, 'shuffle abilities', FCVAR_CHEAT);
end

function AbilityScrambler:ShuffleAbilities()

    local playerPool = RandyArena:GetShuffledPlayerIds();

    if #playerPool <= 1 then
        return;
    end

    local pool = AbilityUtils:GetAllAbilitiesInfoByPlayers(true);

    local abilitiesToRoll = {};
    for i, playerIdOne in pairs(playerPool) do

        local abilityInfo;

        local abilityIndex = self.abilitiesToScramble[playerIdOne];
        if abilityIndex ~= nil then
            abilityInfo = pool[playerIdOne][abilityIndex];
        end

        if abilityInfo == nil then
            abilityInfo = ConsumeRandomFromTable(pool[playerIdOne]);
        end

        table.insert(abilitiesToRoll, abilityInfo);
    end

    for playerIdIndex, abilityInfoOne in pairs(abilitiesToRoll) do
        local playerIdOne = playerPool[playerIdIndex];
        local nextPlayerIdIndex = playerIdIndex == #playerPool and 1 or playerIdIndex + 1;
        local abilityInfoTwo = abilitiesToRoll[nextPlayerIdIndex];
        local heroEntity = Players:GetHeroEntity(playerIdOne);

        AbilityUtils:SetHeroAbilityByIndex(
            heroEntity,
            abilityInfoOne.abilityIndex,
            abilityInfoTwo.abilityName
        );
    end
end

function AbilityScrambler:OnAbilityScrambled(event)
    print('OnAbilityScrambled');
    local playerId = event.PlayerID;
    local abilityIndex = event.abilityIndex;

    local heroEntity = Players:GetHeroEntity(playerId);
    local heroName = ParseHeroName(heroEntity:GetClassname());

    if ABILITIES[heroName].swappable[abilityIndex] ~= nil then
        self.abilitiesToScramble[playerId] = abilityIndex;
    end
end