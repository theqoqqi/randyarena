--
-- Created by IntelliJ IDEA.
-- User: Qoqqi
-- Date: 21.10.2018
-- Time: 1:16
-- To change this template use File | Settings | File Templates.
--

BountyRuneScrambler = class({});

function BountyRuneScrambler:Create(randyArena, options)

    local instance = BountyRuneScrambler();

    instance.bountyRuneSpawners = Entities:FindAllByName('bounty_rune_spawner');
    instance.activeBountyRuneSpawners = {};

    local gmEntity = GameRules:GetGameModeEntity();

    gmEntity:ClearRuneSpawnFilter();
    gmEntity:SetRuneSpawnFilter(Dynamic_Wrap(instance, 'RuneSpawnFilter'), instance);
    gmEntity:SetBountyRunePickupFilter(Dynamic_Wrap(instance, 'BountyRunePickupFilter'), instance);

    return instance;
end

function BountyRuneScrambler:OnGameInProgress()

    Timers:CreateTimer({
        endTime = 1,
        callback = function()
            self:UpdateActiveBountyRuneSpawners();
            return self.bountyRuneSpawnTime;
        end
    });
end

function BountyRuneScrambler:OnAllHeroesInGame()

    local numberOfPlayers = RandyArena:GetNumberOfPlayersForRules();
    local runeSettings = RUNE_SETTINGS[numberOfPlayers];

    self.bountyRuneSpawnTime = runeSettings.spawnTime;
    self.bountyRunesToSpawn = runeSettings.count;
    self.bountyRuneBaseGold = runeSettings.baseGold;
    self.bountyRuneGoldPerMinute = runeSettings.goldPerMinute;

    GameRules:SetRuneSpawnTime(RUNE_SETTINGS[numberOfPlayers].spawnTime);

    self:UpdateActiveBountyRuneSpawners();
end

function BountyRuneScrambler:UpdateActiveBountyRuneSpawners()
    local runesToSpawn = self.bountyRunesToSpawn;
    local pool = table.copy(self.bountyRuneSpawners);
    self.activeBountyRuneSpawners = {};
    for i = 1, runesToSpawn do
        table.insert(self.activeBountyRuneSpawners, ConsumeRandomFromTable(pool));
    end
    return self.activeBountyRuneSpawners;
end

function BountyRuneScrambler:RuneSpawnFilter(keys)
    DebugPrint('[RANDYARENA] RuneSpawnFilter');
    DebugPrintTable(keys);

    local runeType = keys.rune_type;
    local spawner = EntIndexToHScript(keys.spawner_entindex_const);

    if GameRules:GetDOTATime(false, false) < 1 then
        return false;
    end

    if table.contains(self.bountyRuneSpawners, spawner) then
        keys.rune_type = DOTA_RUNE_BOUNTY;
        return table.contains(self.activeBountyRuneSpawners, spawner);
    end

    return true;
end

function BountyRuneScrambler:BountyRunePickupFilter(keys)
    -- keys.player_id_const
    -- keys.xp_bounty
    -- keys.gold_bounty
    DebugPrint('[RANDYARENA] BountyRunePickupFilter');
    DebugPrintTable(keys);

    local playerId = keys.player_id_const;
    local playerEntity = Players:GetPlayerEntity(playerId);
    local heroEntity = Players:GetHeroEntity(playerId);
    local gameMinute = GameRules:GetGameTime() / 60;

    EmitSoundOnClient('General.LevelUp.Bonus', playerEntity);
    heroEntity:SetAbilityPoints(heroEntity:GetAbilityPoints() + 1);

    keys.gold_bounty = self.bountyRuneBaseGold + gameMinute * self.bountyRuneGoldPerMinute;
    keys.xp_bounty = 0;
    return true;
end