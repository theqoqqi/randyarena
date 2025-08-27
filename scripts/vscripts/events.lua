-- This file contains all randyarena-registered events and has already set up the passed-in parameters for your use.

-- Cleanup a player when they leave
function RandyArena:OnDisconnect(keys)
  DebugPrint('[RANDYARENA] Player Disconnected ' .. tostring(keys.userid))
  DebugPrintTable(keys)

  local name = keys.name
  local networkid = keys.networkid
  local reason = keys.reason
  local userid = keys.userid

end

-- The overall game state has changed
function RandyArena:OnGameRulesStateChange(keys)
	DebugPrint("[RANDYARENA] GameRules State Changed");
	DebugPrintTable(keys);

	local newState = GameRules:State_Get();
end

-- An NPC has spawned somewhere in game.  This includes heroes
function RandyArena:OnNPCSpawned(keys)
	DebugPrint('[RANDYARENA] NPC Spawned');
	DebugPrintTable(keys);

	local npc = EntIndexToHScript(keys.entindex);

	if npc:IsCourier() then
		local playerId = npc:GetPlayerOwnerID();

		npc:AddNewModifier(npc, nil, 'modifier_custom_courier', {
			playerId = playerId,
		});
	end
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function RandyArena:OnEntityHurt(keys)
	DebugPrint("[RANDYARENA] Entity Hurt");
	DebugPrintTable(keys);

	local damagebits = keys.damagebits -- This might always be 0 and therefore useless
	if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
		local entCause = EntIndexToHScript(keys.entindex_attacker)
		local entVictim = EntIndexToHScript(keys.entindex_killed)

		-- The ability/item used to damage, or nil if not damaged by an item/ability
		local damagingAbility = nil

		if keys.entindex_inflictor ~= nil then
			damagingAbility = EntIndexToHScript( keys.entindex_inflictor )
		end
	end
end

-- An item was picked up off the ground
function RandyArena:OnItemPickedUp(keys)
	DebugPrint('[RANDYARENA] OnItemPickedUp');
	DebugPrintTable(keys);

	if keys.HeroEntityIndex == nil then
		return;
	end

	local heroEntity = EntIndexToHScript(keys.HeroEntityIndex);
	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex);
	local playerEntity = PlayerResource:GetPlayer(keys.PlayerID);
	local itemName = keys.itemname;

	if keys.PlayerID == -1 then
		return;
	end
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function RandyArena:OnPlayerReconnect(keys)
	DebugPrint('[RANDYARENA] OnPlayerReconnect');
	DebugPrintTable(keys);

	local playerEntity = PlayerResource:GetPlayer(keys.PlayerID);

	CustomGameEventManager:Send_ServerToPlayer(playerEntity, 'self_reconnected', {});
end

-- An item was purchased by a player
function RandyArena:OnItemPurchased( keys )
  DebugPrint( '[RANDYARENA] OnItemPurchased' )
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
  
end

-- An ability was used by a player
function RandyArena:OnAbilityUsed(keys)
	DebugPrint('[RANDYARENA] AbilityUsed')
	DebugPrintTable(keys)

	local heroEntity = Players:GetHeroEntity(keys.PlayerID);
	local abilityName = keys.abilityname;

end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function RandyArena:OnNonPlayerUsedAbility(keys)
	DebugPrint('[RANDYARENA] OnNonPlayerUsedAbility');
	DebugPrintTable(keys);

	local abilityname = keys.abilityname;
	local caster = EntIndexToHScript(keys.caster_entindex);
end

-- A player changed their name
function RandyArena:OnPlayerChangedName(keys)
  DebugPrint('[RANDYARENA] OnPlayerChangedName')
  DebugPrintTable(keys)

  local newName = keys.newname
  local oldName = keys.oldName
end

-- A player leveled up an ability
function RandyArena:OnPlayerLearnedAbility( keys)
  DebugPrint('[RANDYARENA] OnPlayerLearnedAbility')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function RandyArena:OnAbilityChannelFinished(keys)
  DebugPrint('[RANDYARENA] OnAbilityChannelFinished')
  DebugPrintTable(keys)

  local abilityname = keys.abilityname
  local interrupted = keys.interrupted == 1
end

-- A player leveled up
function RandyArena:OnPlayerLevelUp(keys)
  DebugPrint('[RANDYARENA] OnPlayerLevelUp')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local level = keys.level
end

-- A player last hit a creep, a tower, or a hero
function RandyArena:OnLastHit(keys)
	DebugPrint('[RANDYARENA] OnLastHit');
	DebugPrintTable(keys);

	local isFirstBlood = keys.FirstBlood == 1;
	local isHeroKill = keys.HeroKill == 1;
	local isTowerKill = keys.TowerKill == 1;
	local playerId = keys.PlayerID;
	local player = PlayerResource:GetPlayer(keys.PlayerID);
	local killedEnt = EntIndexToHScript(keys.EntKilled);

	if isFirstBlood then
		local gameTime = GameRules:GetGameTime();
		if gameTime >= 60 then
			EmitGlobalSound('rubick_rubick_firstblood_01');
		else
			EmitGlobalSound('rubick_rubick_firstblood_02');
		end
	end

	if isHeroKill then
		local killedHero = killedEnt;
		local killedPlayerId = killedHero:GetPlayerID();
		local goldBounty = HERO_KILL_SETTINGS.baseBounty
			+ math.max(0, killedHero:GetStreak() - 2) * HERO_KILL_SETTINGS.streakMultiplier
			+ killedHero:GetLevel() * HERO_KILL_SETTINGS.levelMultiplier
			+ Players:GetNetWorth(killedPlayerId) * HERO_KILL_SETTINGS.netWorthMultiplier;
		Players:ModifyGold(playerId, goldBounty, false, DOTA_ModifyGold_HeroKill);
	end
end

-- A tree was cut down by tango, quelling blade, etc
function RandyArena:OnTreeCut(keys)
  DebugPrint('[RANDYARENA] OnTreeCut')
  DebugPrintTable(keys)

  local treeX = keys.tree_x
  local treeY = keys.tree_y
end

--[[ Rune Can be one of the following types
	DOTA_RUNE_DOUBLEDAMAGE
	DOTA_RUNE_HASTE
	DOTA_RUNE_HAUNTED
	DOTA_RUNE_ILLUSION
	DOTA_RUNE_INVISIBILITY
	DOTA_RUNE_BOUNTY
	DOTA_RUNE_MYSTERY
	DOTA_RUNE_RAPIER
	DOTA_RUNE_REGENERATION
	DOTA_RUNE_SPOOKY
	DOTA_RUNE_TURBO
]]

function RandyArena:RuneSpawnFilter(keys)
	DebugPrint('[RANDYARENA] OnRuneActivated');
	DebugPrintTable(keys);

	local runeType = keys.rune_type;
	local spawner = EntIndexToHScript(keys.spawner_entindex_const);
end

function RandyArena:BountyRunePickupFilter(keys)
	-- keys.player_id_const
	-- keys.xp_bounty
	-- keys.gold_bounty
	DebugPrint('[RANDYARENA] BountyRunePickupFilter');
	DebugPrintTable(keys);

	local playerId = keys.player_id_const;
	local playerEntity = Players:GetPlayerEntity(playerId);
	local heroEntity = Players:GetHeroEntity(playerId);
    local gameMinute = GameRules:GetGameTime() / 60;
end

function RandyArena:ModifyGoldFilter(keys)
	if keys.reason_const == DOTA_ModifyGold_HeroKill then
		keys.gold = 0;
	end
	return true;
end

-- A rune was activated by a player
function RandyArena:OnRuneActivated (keys)
	DebugPrint('[RANDYARENA] OnRuneActivated');
	DebugPrintTable(keys);

	local player = PlayerResource:GetPlayer(keys.PlayerID);
	local rune = keys.rune;
end

-- A player took damage from a tower
function RandyArena:OnPlayerTakeTowerDamage(keys)
  DebugPrint('[RANDYARENA] OnPlayerTakeTowerDamage')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local damage = keys.damage
end

-- A player picked a hero
function RandyArena:OnPlayerPickHero(keys)
  DebugPrint('[RANDYARENA] OnPlayerPickHero')
  DebugPrintTable(keys)

  local heroClass = keys.hero
  local heroEntity = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
end

-- A player killed another player in a multi-team context
function RandyArena:OnTeamKillCredit(keys)
	DebugPrint('[RANDYARENA] OnTeamKillCredit')
	DebugPrintTable(keys)

	local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
	local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
	local numKills = keys.herokills
	local killerTeamNumber = keys.teamnumber
end

-- An entity died
function RandyArena:OnEntityKilled(keys)
	print('[RANDYARENA] OnEntityKilled');

	local killedUnit = EntIndexToHScript(keys.entindex_killed);

	local killerEntity;
	if keys.entindex_attacker ~= nil then
		killerEntity = EntIndexToHScript(keys.entindex_attacker);
	end

	local killerAbility;
	if keys.entindex_inflictor ~= nil then
		killerAbility = EntIndexToHScript(keys.entindex_inflictor);
	end

	local damagebits = keys.damagebits; -- This might always be 0 and therefore useless

	-- Put code here to handle when an entity gets killed
end



-- This function is called 1 to 2 times as the player connects initially but before they
-- have completely connected
function RandyArena:PlayerConnect(keys)
  DebugPrint('[RANDYARENA] PlayerConnect')
  DebugPrintTable(keys)
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function RandyArena:OnConnectFull(keys)
  DebugPrint('[RANDYARENA] OnConnectFull')
  DebugPrintTable(keys)

  local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)

  -- The Player ID of the joining player
--  local playerID = ply:GetPlayerID()
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function RandyArena:OnIllusionsCreated(keys)
  DebugPrint('[RANDYARENA] OnIllusionsCreated')
  DebugPrintTable(keys)

  local originalEntity = EntIndexToHScript(keys.original_entindex)
end

-- This function is called whenever an item is combined to create a new item
function RandyArena:OnItemCombined(keys)
  DebugPrint('[RANDYARENA] OnItemCombined')
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end
  local player = PlayerResource:GetPlayer(plyID)

  -- The name of the item purchased
  local itemName = keys.itemname

  -- The cost of the item purchased
  local itemcost = keys.itemcost
end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function RandyArena:OnAbilityCastBegins(keys)
  DebugPrint('[RANDYARENA] OnAbilityCastBegins')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityName = keys.abilityname
end

-- This function is called whenever a tower is killed
function RandyArena:OnTowerKill(keys)
  DebugPrint('[RANDYARENA] OnTowerKill')
  DebugPrintTable(keys)

  local gold = keys.gold
  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local team = keys.teamnumber
end

-- This function is called whenever a player changes there custom team selection during Game Setup
function RandyArena:OnPlayerSelectedCustomTeam(keys)
  DebugPrint('[RANDYARENA] OnPlayerSelectedCustomTeam')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.player_id)
  local success = (keys.success == 1)
  local team = keys.team_id
end

-- This function is called whenever an NPC reaches its goal position/target
function RandyArena:OnNPCGoalReached(keys)
	DebugPrint('[RANDYARENA] OnNPCGoalReached')
	DebugPrintTable(keys)

	local goalEntity = EntIndexToHScript(keys.goal_entindex)
	local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
	local npc = EntIndexToHScript(keys.npc_entindex)
end

-- This function is called whenever any player sends a chat message to team or All
function RandyArena:OnPlayerChat(keys)
  local teamonly = keys.teamonly
  local userID = keys.userid
--  local playerID = self.vUserIds[userID]:GetPlayerID()

  local text = keys.text
end
