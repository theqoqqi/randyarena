

require('libraries/timers'); -- This library allow for easily delayed/timed actions
require('libraries/physics'); -- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/projectiles'); -- This library can be used for advanced 3D projectile systems.
require('libraries/notifications'); -- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/animations'); -- This library can be used for starting customized animations on units from lua
require('libraries/attachments'); -- This library can be used for performing "Frankenstein" attachments on units
require('libraries/playertables'); -- This library can be used to synchronize client-server data via player/client-specific nettables
require('libraries/containers'); -- This library can be used to create container inventories or container shops
require('libraries/modmaker'); -- This library provides a searchable, automatically updating lua API in the tools-mode via "modmaker_api" console command
require('libraries/pathgraph'); -- This library provides an automatic graph construction of path_corner entities within the map
require('libraries/selection'); -- This library (by Noya) provides player selection inspection and management from server lua

require('libraries/players'); -- My own library. Provides simpler API to work with players/teams

require('internal/util');
require('luaext');
require('randyarena');

function Precache(context)
	DebugPrint("[RANDYARENA] Performing pre-load precache");

	local kvHeroes = LoadKeyValues('scripts/npc/npc_heroes.txt');

	local unusedAbilityPool = AbilityDelivery:GetAllDeliverableAbilities();
	local abilitiesToDelivery = {};

	local courierCount = HEROES_TO_PRECACHE;

	for i = 1, courierCount do
		local abilityInfo = ConsumeRandomFromTable(unusedAbilityPool);
		local heroName = abilityInfo.heroName;
		PrecacheUnitByNameAsync('npc_dota_hero_' .. heroName, function(...) end);
--		PrecacheModel('models/heroes/' .. heroName .. '/' .. heroName .. '.vmdl', context);
		table.insert(abilitiesToDelivery, abilityInfo);
		print('Random ability added: ' .. abilityInfo.abilityName .. ' (' .. heroName .. ')');
	end

	RandyArena.abilitiesToDelivery = abilitiesToDelivery;
	RandyArena.unusedAbilityPool = unusedAbilityPool;

	for heroName, kvHero in pairs(kvHeroes) do
		if heroName ~= 'Version' and heroName ~= 'npc_dota_hero_base' then
			local heroName = string.sub(heroName, string.len('npc_dota_hero_') + 1);
			PrecacheResource('soundfile', 'soundevents/voscripts/game_sounds_vo_' .. heroName .. '.vsndevts', context);
			PrecacheResource('soundfile', 'soundevents/game_sounds_heroes/game_sounds_' .. heroName .. '.vsndevts', context);
		end
	end

	local playerCount = 10;
	local freePreloadedCourierModels = {};

	for i = 1, playerCount do
		local modelInfo = ConsumeRandomFromTable(COURIER_MODELS);
		PrecacheResource('model', modelInfo.ground, context);
		PrecacheResource('model', modelInfo.flying, context);
		table.insert(freePreloadedCourierModels, modelInfo);
		print('Courier model preloaded: ' .. modelInfo.ground);
		print('Courier model preloaded: ' .. modelInfo.flying);
	end

	PrecacheResource('model', 'models/props_gameplay/treasure_chest001.vmdl', context);

	RandyArena.freePreloadedCourierModels = freePreloadedCourierModels;
end

function Activate()
	GameRules.RandyArena = RandyArena();
	GameRules.RandyArena:_InitRandyArena();
end