RANDYARENA_VERSION = "0.1";

-- Set this to true if you want to see a complete debug output of all events/processes done by randyarena
-- You can also change the cvar 'randyarena_spew' at any time to 1 or 0 for output/no output
RANDYARENA_DEBUG_SPEW = false;

if RandyArena == nil then
    DebugPrint('[RANDYARENA] creating randyarena game mode');
    _G.RandyArena = class({});
end

require('internal/randyarena');
require('internal/events');


require('dotaext/basenpc');


require('items/item_bracer_agility');
require('items/item_bracer_intellect');
require('items/item_wraith_band_strength');
require('items/item_wraith_band_intellect');
require('items/item_null_talisman_strength');
require('items/item_null_talisman_agility');


require('modifiers/custom_courier');
require('modifiers/bonus_stats');

require('modifiers/aether_shining');
require('modifiers/octarine_shining');
require('modifiers/holy_shining');
require('modifiers/desolation_orb');
require('modifiers/skadi_orb');
require('modifiers/true_sight_orb');
require('modifiers/poison_orb');
require('modifiers/antimagicy_orb');

require('modifiers/bracer_agility');
require('modifiers/bracer_intellect');
require('modifiers/wraith_band_strength');
require('modifiers/wraith_band_intellect');
require('modifiers/null_talisman_strength');
require('modifiers/null_talisman_agility');


require('modules/match_controller');
require('modules/ability_learning');
require('modules/ability_utils');
require('modules/ability_delivery');
require('modules/ability_scrambler');
require('modules/ability_randomizer');
require('modules/ability_points_exchanger');
require('modules/ability_fixer');
require('modules/gxpm_granter');
require('modules/bounty_rune_scrambler');
require('modules/creator_controller');
require('modules/illusion_fixer');


require('settings');
require('settings_' .. GetMapName());


require('lists/abilities');
require('lists/voices');


require('events');
require('util');

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync. These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items. PrecacheUnitByNameAsync will
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability#
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function RandyArena:PostLoadPrecache()
	DebugPrint("[RANDYARENA] Performing Post-Load precache");
	--PrecacheItemByNameAsync("item_example_item", function(...) end)
	--PrecacheItemByNameAsync("example_ability", function(...) end)

	--PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
	--PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function RandyArena:InitRandyArena()
	RandyArena = self;
	DebugPrint('[RANDYARENA] Starting to load RandyArena...');

    self.modules = {
        MatchController:Create(self, {}),
        AbilityFixer:Create(self, {}),
        AbilityDelivery:Create(self, {}),
        AbilityScrambler:Create(self, {}),
		AbilityRandomizer:Create(self, {}),
		AbilityPointsExchanger:Create(self, {}),
        AbilityLearning:Create(self, {}),
        GxpmGranter:Create(self, {}),
        BountyRuneScrambler:Create(self, {}),
		CreatorController:Create(self, {}),
		IllusionFixer:Create(self, {}),
    };

	self.heroesInGame = 0;
	self.gameSetup = {
		randomizePrice = 3,
		startPoints = 1,
		freeRandoms = 0,
		forceRules = 0,
		comebackFactor = 1,
	};
	self.allHeroesInGame = false;
	self.gameInProgress = false;

	local gmEntity = GameRules:GetGameModeEntity();

	gmEntity:SetFreeCourierModeEnabled(true);
	gmEntity:SetModifyGoldFilter(Dynamic_Wrap(self, 'ModifyGoldFilter'), self);

	if IsInToolsMode() then
		GameRules:SetUseUniversalShopMode(true);
		GameRules:SetStartingGold(99999);
	end

	CustomGameEventManager:RegisterListener(
		'game_setup_ui_loaded', Dynamic_Wrap(self, 'OnClientGameSetupUILoaded'));
	CustomGameEventManager:RegisterListener(
		'update_game_setup', Dynamic_Wrap(self, 'OnUpdateGameSetup'));

	DebugPrint('[RANDYARENA] Done loading RandyArena!\n\n');
end
--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock). At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc. This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function RandyArena:OnGameInProgress()
	DebugPrint("[RANDYARENA] The game has officially begun");

	Players:ForEachHeroEntity(function(playerId, heroEntity)
		local heroLevel = heroEntity:GetLevel();

		if IsInToolsMode() then
			heroEntity:SetAbilityPoints(100);
		else
			heroEntity:SetAbilityPoints(self.gameSetup.startPoints + heroLevel - 1);
		end
	end);

	self.gameInProgress = true;

    self:CallForModules('OnGameInProgress');
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitRandyArena() but needs to be done before everyone loads in.
]]
function RandyArena:OnFirstPlayerLoaded()
	DebugPrint("[RANDYARENA] First Player has loaded");
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function RandyArena:OnAllPlayersLoaded()
	DebugPrint("[RANDYARENA] All Players have loaded into the game");
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function RandyArena:OnHeroInGame(heroEntity)
	DebugPrint("[RANDYARENA] Hero spawned in game for first time -- " .. heroEntity:GetUnitName());

	if self.heroesInGame == Players:HeroCount() then
		return;
	end

	self.heroesInGame = self.heroesInGame + 1;

	if IsInToolsMode() then
--		heroEntity:AddItemByName('item_manta');
		heroEntity:AddItemByName('item_poison_orb');
		heroEntity:AddItemByName('item_antimagicy_orb');
		heroEntity:AddItemByName('item_blink');
		heroEntity:AddItemByName('item_christmas_gift');
		heroEntity:AddItemByName('item_manta');
--		heroEntity:AddItemByName('item_christmas_gift');
--		heroEntity:AddItemByName('item_christmas_gift');
--		heroEntity:AddItemByName('item_christmas_gift');
--		heroEntity:AddItemByName('item_bracer_agility');
--		heroEntity:AddItemByName('item_bracer_intellect');
--		heroEntity:AddItemByName('item_wraith_band_strength');
--		heroEntity:AddItemByName('item_wraith_band_intellect');
--		heroEntity:AddItemByName('item_null_talisman_strength');
--		heroEntity:AddItemByName('item_null_talisman_agility');
--		heroEntity:AddItemByName('item_skadi');
--		heroEntity:AddItemByName('item_relic');
--		heroEntity:AddItemByName('item_desolation_orb');
--		heroEntity:AddItemByName('item_desolator');
--		heroEntity:AddItemByName('item_aether_shining');
--		heroEntity:AddItemByName('item_octarine_shining');
--		heroEntity:AddItemByName('item_holy_shining');
--		heroEntity:AddItemByName('item_true_sight_orb');
--	    AbilityUtils:SetHeroAbilityByIndex(heroEntity, 0, 'phoenix_sun_ray');
--	    AbilityUtils:SetHeroAbilityByIndex(heroEntity, 1, 'spectre_haunt');
--		AbilityUtils:SetHeroAbilityByIndex(heroEntity, 2, 'tiny_tree_grab');
--		AbilityUtils:SetHeroAbilityByIndex(heroEntity, 3, 'spectre_haunt');
--		AbilityUtils:SetHeroAbilityByIndex(heroEntity, 4, 'tiny_craggy_exterior');
--		AbilityUtils:SetHeroAbilityByIndex(heroEntity, 5, 'tusk_snowball');
	end

	local playerId = heroEntity:GetPlayerID();

	heroEntity:SetAbilityPoints(self.gameSetup.freeRandoms);

	print('Player ' .. playerId .. ' entindex: ' .. heroEntity:GetEntityIndex());

	self:CallForModules('OnHeroInGame', heroEntity);

	if not self.allHeroesInGame and self.heroesInGame == Players:HeroCount() then
		self.allHeroesInGame = true;
		Timers:CreateTimer({
			endTime = 0.01,
			callback = function()
				self:OnAllHeroesInGame();
			end
		});
	end
end

function RandyArena:OnAllHeroesInGame()
	self:RemoveDuplicatedAbilities();
    self:CallForModules('OnAllHeroesInGame');
end

function RandyArena:OnClientGameSetupUILoaded(event)
	local playerEntity = PlayerResource:GetPlayer(event.PlayerID);
	local options = table.copy(GAME_SETUP_OPTIONS);
	options.canChange = GameRules:PlayerHasCustomGameHostPrivileges(playerEntity);
	CustomGameEventManager:Send_ServerToPlayer(playerEntity, 'init_game_setup', options);
end

function RandyArena:OnUpdateGameSetup(event)
	local value = GAME_SETUP_OPTIONS[event.optionName].options[event.optionIndex + 1];
	RandyArena.gameSetup[event.optionName] = value;
	Players:ForEachHeroEntity(function(playerId, heroEntity)
		if playerId ~= event.PlayerID then
			CustomGameEventManager:Send_ServerToPlayer(heroEntity, 'update_game_setup', event);
		end
	end);
end

function RandyArena:RemoveDuplicatedAbilities()
	local abilitiesToRemove = {};

	Players:ForEachHeroEntity(function(playerId, heroEntity)
		AbilityUtils:ForEachAbility(heroEntity, function(ability, index, name)
			table.insert(abilitiesToRemove, name);
		end);
	end);

	local filter = function(abilityInfo)
		return not table.contains(abilitiesToRemove, abilityInfo.abilityName);
	end;
	-- Способности для доставки подбираются до начала игры,
	-- но отфильтровать их можно только после появления всех героев.
	self.abilitiesToDelivery = table.filter(self.abilitiesToDelivery, filter, true);
	self.unusedAbilityPool = table.filter(self.unusedAbilityPool, filter, true);
end

function RandyArena:CallForModules(functionName, ...)
    for _, module in pairs(self.modules) do
        if module[functionName] ~= nil then
            module[functionName](module, ...);
        end
    end
end

function RandyArena:GetShuffledPlayerIds()
	local ids = table.filter(
		Players:GetIds(),
		function(playerId)
			return Players:HasSelectedHero(playerId);
		end
	);
	for i = 1, #ids do
		local ri = RandomInt(i, #ids);
		local temp = ids[i];
		ids[i] = ids[ri];
		ids[ri] = temp;
	end
	return ids;
end

function RandyArena:GetNumberOfPlayersForRules()
	local forceRules = self.gameSetup.forceRules;
	return forceRules == 0 and Players:HeroCount() or forceRules;
end