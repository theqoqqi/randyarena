-- In this file you can set up all the properties and settings for your game mode.

PARTICLES_FOLDER = 'particles/maps/solo';

DEBUG_ABILITY_CHESTS = true and IsInToolsMode();
DEBUG_ABILITY_RANDOMIZER = true and IsInToolsMode();
FAST_START = false and IsInToolsMode();
DEBUG_ABILITY_CHEST = true and IsInToolsMode();
DEBUG_RUNES = false and IsInToolsMode();
DEBUG_DISABLE_CREATOR = true or not IsInToolsMode();

if DEBUG_ABILITY_CHEST then
	FORCE_ABILITY_COURIER = 'hoodwink';
	FORCE_CHEST_ABILITY = {
		'abyssal_underlord_dark_portal',
		'hoodwink_scurry',
		'hoodwink_sharpshooter',
	};
end

if DEBUG_ABILITY_RANDOMIZER then
	FORCE_RANDOMIZED_ABILITY = {
		'muerta_dead_shot',
		'muerta_the_calling',
		'muerta_gunslinger',
		'muerta_pierce_the_veil',
	};
end

if DEBUG_ABILITY_CHESTS then
	ABILITY_COURIER_TELEPORT_DURATION = 3;
	ABILITY_CHEST_SPAWN_WARN_OFFSET = 3.5;
	ABILITY_CHEST_SPAWN_TIME_FIRST = 4;
	ABILITY_CHEST_SPAWN_TIME_DELAY = 12;
	ABILITY_CHEST_DENY_DELAY = 2.5;
else
	ABILITY_COURIER_TELEPORT_DURATION = 3;
	ABILITY_CHEST_SPAWN_WARN_OFFSET = 15;
	ABILITY_CHEST_SPAWN_TIME_FIRST = 60;
	ABILITY_CHEST_SPAWN_TIME_DELAY = 120;
	ABILITY_CHEST_DENY_DELAY = 30;
end

if FAST_START then
	SKIP_TEAM_SETUP = true;
	FORCE_PICKED_HERO = 'npc_dota_hero_oracle';
else
	SKIP_TEAM_SETUP = false;
	FORCE_PICKED_HERO = nil;
end

HEROES_TO_PRECACHE = IsInToolsMode() and 1 or 15;
CLOSE_TO_VICTORY_THRESHOLD = 5;
ABILITY_CHEST_THINKING_TIME = IsInToolsMode() and 5 or 17;

GAME_SETUP_OPTIONS = {
	startPoints = {
		options = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
		defaultIndex = 0,
	},
	freeRandoms = {
		options = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
		defaultIndex = 0,
	},
	forceRules = {
		options = { 0, 1, 2, 3, 4, 5, 6, 7, 8 },
		defaultIndex = 0,
	},
	comebackFactor = {
		options = { 1, 2, 3, 5, 10 },
		defaultIndex = 0,
	},
};

HERO_KILL_SETTINGS = {
	baseBounty = 120,
	streakMultiplier = 120,
	levelMultiplier = 8,
	netWorthMultiplier = 0.04,
};

GXPM_SETTINGS = {
    global = { goldPerTick = 5, xpPerTick = 5, tickRate = 0.5, killFactor = 0.1, },
    circle = { goldPerTick = 1, xpPerTick = 2, tickRate = 0.1, killFactor = 0.1, radius = 1000, },
};

RUNE_SETTINGS = {
	[1] = { count = 4, spawnTime = 120, baseGold = 240, goldPerMinute = 24 },
	[2] = { count = 2, spawnTime = 120, baseGold = 120, goldPerMinute = 12 },
	[3] = { count = 2, spawnTime = 120, baseGold = 180, goldPerMinute = 18 },
	[4] = { count = 3, spawnTime = 120, baseGold = 160, goldPerMinute = 16 },
	[5] = { count = 3, spawnTime = 120, baseGold = 200, goldPerMinute = 20 },
	[6] = { count = 3, spawnTime = 120, baseGold = 240, goldPerMinute = 24 },
	[7] = { count = 4, spawnTime = 120, baseGold = 210, goldPerMinute = 21 },
	[8] = { count = 4, spawnTime = 120, baseGold = 240, goldPerMinute = 24 },
};

ABILITY_CHEST_SETTINGS = {   -- ultimative				-- generic abilities
	[1] = { level_chances = { [3] = { 100,0,  0,  0,  }, [4] = { 100,0,  0,  0,  0,  }, } },
--	[1] = { level_chances = { [3] = { 25, 25, 25, 25, }, [4] = { 20, 20, 20, 20, 20, }, } },
	[2] = { level_chances = { [3] = { 80, 15, 5,  0,  }, [4] = { 60, 25, 10, 5,  0,  }, } },
	[3] = { level_chances = { [3] = { 75, 15, 10, 0,  }, [4] = { 50, 25, 15, 5,  5,  }, } },
	[4] = { level_chances = { [3] = { 70, 20, 10, 0,  }, [4] = { 40, 30, 20, 5,  5,  }, } },
	[5] = { level_chances = { [3] = { 65, 25, 10, 0,  }, [4] = { 30, 30, 25, 10, 5,  }, } },
	[6] = { level_chances = { [3] = { 60, 25, 10, 5,  }, [4] = { 20, 35, 25, 10, 10, }, } },
	[7] = { level_chances = { [3] = { 55, 25, 15, 5,  }, [4] = { 10, 35, 30, 15, 10, }, } },
	[8] = { level_chances = { [3] = { 50, 25, 15, 10, }, [4] = { 0,  35, 30, 20, 15, }, } },
};

MATCH_SETTINGS = {
	[1] = { killsToWin = 20, matchDuration = 1801 },
	[2] = { killsToWin = 20, matchDuration = 1801 },
	[3] = { killsToWin = 20, matchDuration = 1801 },
	[4] = { killsToWin = 25, matchDuration = 1801 },
	[5] = { killsToWin = 25, matchDuration = 1801 },
	[6] = { killsToWin = 25, matchDuration = 1801 },
	[7] = { killsToWin = 30, matchDuration = 1801 },
	[8] = { killsToWin = 30, matchDuration = 1801 },
};


ENABLE_HERO_RESPAWN = true;              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = true;             -- Should the main shop contain Secret Shop items as well as regular items
ALLOW_SAME_HERO_SELECTION = false;        -- Should we let people select the same hero as each other

GAME_SETUP_AUTOLAUNCH_DELAY = 30;
HERO_SELECTION_TIME = 60;              -- How long should we let people select their hero?
STRATEGY_TIME = 15;
SHOWCASE_TIME = 0;
PRE_GAME_TIME = IsInToolsMode() and 5 or 17;                    -- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60;                   -- How long should we let people look at the scoreboard before closing the server automatically?

TREE_REGROW_TIME = 20;                 -- How long should it take individual trees to respawn after being cut down/destroyed?

GOLD_PER_TICK = 0;                     -- How much gold should players get per tick?
GOLD_TICK_TIME = 999;                      -- How long should we wait in seconds between gold ticks?

RECOMMENDED_BUILDS_DISABLED = false;     -- Should we disable the recommened builds for heroes
CAMERA_DISTANCE_OVERRIDE = 1200;           -- How far out should we allow the camera to go?  Use -1 for the default (1134) while still allowing for panorama camera distance changes

MINIMAP_ICON_SIZE = 1;                   -- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1;             -- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1;              -- What icon size should we use for runes?

CUSTOM_BUYBACK_COST_ENABLED = false;      -- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = false;  -- Should we use a custom buyback time?
BUYBACK_ENABLED = true;                 -- Should we allow people to buyback when they die?

DISABLE_FOG_OF_WAR_ENTIRELY = false;     -- Should we disable fog of war entirely for both teams?
USE_UNSEEN_FOG_OF_WAR = false;           -- Should we make unseen and fogged areas of the map completely black until uncovered by each team? 
                                            -- Note: DISABLE_FOG_OF_WAR_ENTIRELY must be false for USE_UNSEEN_FOG_OF_WAR to work
USE_STANDARD_DOTA_BOT_THINKING = false;  -- Should we have bots act like they would in Dota? (This requires 3 lanes, normal items, etc)
USE_STANDARD_HERO_GOLD_BOUNTY = true;    -- Should we give gold for hero kills the same as in Dota, or allow those values to be changed?

USE_CUSTOM_TOP_BAR_VALUES = true;        -- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true;                  -- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = true;             -- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = false;-- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = false;       -- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false;             -- Should we disable the gold sound when players get gold?

END_GAME_ON_KILLS = false;                -- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = 10;         -- How many kills for a team should signify an end of game?

USE_CUSTOM_HERO_LEVELS = false;           -- Should we allow heroes to have custom levels?
MAX_LEVEL = 25;                          -- What level should we let heroes get to?
USE_CUSTOM_XP_VALUES = false;             -- Should we use custom XP values to level up heroes, or the default Dota numbers?

-- Fill this table up with the required XP per level if you want to change it
XP_PER_LEVEL_TABLE = {};
for i=1,MAX_LEVEL do
  XP_PER_LEVEL_TABLE[i] = (i-1) * 100;
end

ENABLE_FIRST_BLOOD = true;               -- Should we enable first blood for the first kill in this game?
HIDE_KILL_BANNERS = false;               -- Should we hide the kill banners that show when a player is killed?
LOSE_GOLD_ON_DEATH = true;               -- Should we have players lose the normal amount of dota gold on death?
SHOW_ONLY_PLAYER_INVENTORY = false;      -- Should we only allow players to see their own inventory even when selecting other units?
DISABLE_STASH_PURCHASING = false;        -- Should we prevent players from being able to buy items into their stash when not at a shop?
DISABLE_ANNOUNCER = true;                -- Should we disable the announcer from working in the game?

FIXED_RESPAWN_TIME = 10;                 -- What time should we use for a fixed respawn timer?  Use -1 to keep the default dota behavior.
FOUNTAIN_CONSTANT_MANA_REGEN = -1;       -- What should we use for the constant fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_MANA_REGEN = -1;     -- What should we use for the percentage fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_HEALTH_REGEN = -1;   -- What should we use for the percentage fountain health regen?  Use -1 to keep the default dota behavior.
MAXIMUM_ATTACK_SPEED = 600;              -- What should we use for the maximum attack speed?
MINIMUM_ATTACK_SPEED = 20;               -- What should we use for the minimum attack speed?

GAME_END_DELAY = -1;                     -- How long should we wait after the game winner is set to display the victory banner and End Screen?  Use -1 to keep the default (about 10 seconds)
VICTORY_MESSAGE_DURATION = 3;            -- How long should we wait after the victory message displays to show the End Screen?  Use 
STARTING_GOLD = 1100;                    -- How much starting gold should we give to each player?
DISABLE_DAY_NIGHT_CYCLE = false;         -- Should we disable the day night cycle from naturally occurring? (Manual adjustment still possible)
DISABLE_KILLING_SPREE_ANNOUNCER = false; -- Shuold we disable the killing spree announcer?
DISABLE_STICKY_ITEM = false;             -- Should we disable the sticky item button in the quick buy area?
ENABLE_AUTO_LAUNCH = true;               -- Should we automatically have the game complete team setup after AUTO_LAUNCH_DELAY seconds?
AUTO_LAUNCH_DELAY = 30;                  -- How long should the default team selection launch timer be?  The default for custom games is 30.  Setting to 0 will skip team selection.
LOCK_TEAM_SETUP = false;                 -- Should we lock the teams initially?  Note that the host can still unlock the teams 


-- NOTE: You always need at least 2 non-bounty type runes to be able to spawn or your game will crash!
ENABLED_RUNES = {};                      -- Which runes should be enabled to spawn in our game mode?
ENABLED_RUNES[DOTA_RUNE_DOUBLEDAMAGE] = true;
ENABLED_RUNES[DOTA_RUNE_HASTE] = true;
ENABLED_RUNES[DOTA_RUNE_ILLUSION] = true;
ENABLED_RUNES[DOTA_RUNE_INVISIBILITY] = true;
ENABLED_RUNES[DOTA_RUNE_REGENERATION] = true;
ENABLED_RUNES[DOTA_RUNE_BOUNTY] = true;
ENABLED_RUNES[DOTA_RUNE_ARCANE] = true;


MAX_NUMBER_OF_TEAMS = 10;                -- How many potential teams can be in this game mode?
USE_CUSTOM_TEAM_COLORS = true;           -- Should we use custom team colors?
USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS = true;          -- Should we use custom team colors to color the players/minimap?

TEAM_COLORS = {};                        -- If USE_CUSTOM_TEAM_COLORS is set, use these colors.
TEAM_COLORS[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 };  --    Teal
TEAM_COLORS[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 };   --    Yellow
TEAM_COLORS[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 };  --    Pink
TEAM_COLORS[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 };   --    Orange
TEAM_COLORS[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 };   --    Blue
TEAM_COLORS[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 };  --    Green
TEAM_COLORS[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 };   --    Brown
TEAM_COLORS[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 };  --    Cyan
TEAM_COLORS[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 };  --    Olive
TEAM_COLORS[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 };  --    Purple


USE_AUTOMATIC_PLAYERS_PER_TEAM = false;   -- Should we set the number of players to 10 / MAX_NUMBER_OF_TEAMS?


CUSTOM_TEAM_PLAYER_COUNT = {};           -- If we're not automatically setting the number of players per team, use this table
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = IsInToolsMode() and 1 or 0;
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = IsInToolsMode() and 1 or 0;
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_1] = 1;
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_2] = 1;
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_3] = 1;
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_4] = 1;
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_5] = 1;
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_6] = 1;
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_7] = 1;
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_8] = 1;