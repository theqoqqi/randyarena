if Players == nil then
	Players = {};
end

function Players:ForEachHeroEntityInTeam(teamInt, callback)
	return self:ForEachHeroEntity(callback, teamInt);
end

function Players:ForEachPlayerEntityInTeam(teamInt, callback)
	return self:ForEachPlayerEntity(callback, teamInt);
end

function Players:ForEachInTeam(teamInt, callback)
	return self:ForEach(callback, teamInt);
end

function Players:ForEachHeroEntity(callback, teamInt)
	return self:ForEach(function(playerId, heroEntity, playerEntity)
		if heroEntity ~= nil then
			if teamInt == nil or self:TeamOf(playerId) == teamInt then
				return callback(playerId, heroEntity);
			end
		end
	end, teamInt);
end

function Players:ForEachPlayerEntity(callback, teamInt)
	return self:ForEach(function(playerId, heroEntity, playerEntity)
		if teamInt == nil or self:TeamOf(playerId) == teamInt then
			return callback(playerId, playerEntity);
		end
	end, teamInt);
end

function Players:ForEach(callback, teamInt)
	local playerCount = PlayerResource:GetPlayerCount();
	for id = 0, playerCount - 1 do
		if teamInt == nil or self:TeamOf(id) == teamInt then
			local heroEntity = self:GetHeroEntity(id);
			local playerEntity = self:GetPlayerEntity(id);
			local result = callback(id, heroEntity, playerEntity);
			if result ~= nil then
				return result;
			end
		end
	end
end

function Players:GetActiveTeams()
	local allTeams = {
		DOTA_TEAM_GOODGUYS,
		DOTA_TEAM_BADGUYS,
		DOTA_TEAM_CUSTOM_1,
		DOTA_TEAM_CUSTOM_2,
		DOTA_TEAM_CUSTOM_3,
		DOTA_TEAM_CUSTOM_4,
		DOTA_TEAM_CUSTOM_5,
		DOTA_TEAM_CUSTOM_6,
		DOTA_TEAM_CUSTOM_7,
		DOTA_TEAM_CUSTOM_8,
	};
	local teams = {};
	for _, teamInt in pairs(allTeams) do
		if self:Count(teamInt) then
			table.insert(teams, teamInt);
		end
	end
	return teams;
end

function Players:GetTeamKills(teamId)
	return PlayerResource:GetTeamKills(teamId);
end

function Players:GetLeadingTeam()
	local maxKills = 0;
	local leadingTeamId = 0;
	for _, teamId in pairs(self:GetActiveTeams()) do
		local kills = self:GetTeamKills(teamId);
		if kills > maxKills then
			maxKills = kills;
			leadingTeamId = teamId;
		end
	end
	return leadingTeamId;
end

function Players:GetIds()
	return self:AccumulateValues({}, function(ids, playerId)
		table.insert(ids, playerId);
		return ids;
	end, function(playerId, heroEntity, playerEntity)
		return playerId;
	end);
end

function Players:GetHeroEntity(playerId)
	return PlayerResource:GetSelectedHeroEntity(playerId);
end

function Players:GetHeroEntities()
	return self:AccumulateValues({}, function(entities, heroEntity)
		if heroEntity ~= nil then
			table.insert(entities, heroEntity);
		end
		return entities;
	end, function(playerId, heroEntity, playerEntity)
		return heroEntity;
	end);
end

function Players:GetPlayerEntity(playerId)
	return PlayerResource:GetPlayer(playerId);
end

function Players:GetPlayerEntities()
	return self:AccumulateValues({}, function(entities, playerEntity)
		table.insert(entities, playerEntity);
		return entities;
	end, function(playerId, heroEntity, playerEntity)
		return playerEntity;
	end);
end

function Players:Count(teamInt)
	if teamInt == nil then
		return PlayerResource:GetPlayerCount();
	else
		return PlayerResource:GetPlayerCountForTeam(teamInt);
	end
end

function Players:HeroCount(teamInt)
	local count = 0;
	self:ForEach(function(playerId, heroEntity, playerEntity)
		if teamInt == nil or teamInt == self:TeamOf(playerId) then
			count = count + 1;
		end
	end);
	return count;
end

function Players:TeamOf(playerId)
	return PlayerResource:GetTeam(playerId);
end

function Players:IsEntityControlledBy(entity, playerId)
	return entity:GetMainControllingPlayer() == playerId
        or (entity.GetPlayerID and entity:GetPlayerID() == playerId);
end

function Players:ModifyGold(playerId, amount, isReliable, reason)
	return PlayerResource:ModifyGold(playerId, amount, isReliable, reason);
end

function Players:SpendGold(playerId, amount, reason)
	amount = math.min(amount, self:GetGold(playerId));
	return PlayerResource:SpendGold(playerId, amount, reason);
end

function Players:GetGold(playerId)
	return PlayerResource:GetGold(playerId);
end

function Players:AddExperience(playerId, amount, reason)
	local hero = self:GetHeroEntity(playerId);
	hero:AddExperience(amount, reason, false, true);
end

function Players:GetExperience(playerId)
	return PlayerResource:GetTotalEarnedXP(playerId);
end

function Players:GetTeamExperience(teamInt)
	return self:SumPlayerValues(function(playerId)
		return self:TeamOf(playerId) == teamInt and self:GetExperience(playerId) or 0;
	end);
end

function Players:GetNetWorth(playerId)
	return math.floor(PlayerResource:GetGoldPerMin(playerId) * GameRules:GetDOTATime(false, false) / 60);
	-- local worth = PlayerResource:GetGold(playerId);
	-- worth = worth + PlayerResource:GetTotalGoldSpent(playerId);
	-- return worth;

	-- Можно считать ТекущаяГолда + Все вещи на карте, которые принадлежат игроку (включая те, что на земле или в курьере/другом сюзном юните)
end

function Players:GetTeamNetWorth(teamInt)
	return self:SumPlayerValues(function(playerId)
		return self:TeamOf(playerId) == teamInt and self:GetNetWorth(playerId) or 0;
	end);
end

function Players:SumPlayerValues(valueFunc)
	return self:AccumulateValues(0, function(sum, toAdd)
		return sum + toAdd;
	end, valueFunc);
end

function Players:AccumulateValues(initialValue, accumFunc, valueFunc)
	local sum = initialValue;
	self:ForEach(function(playerId, heroEntity, playerEntity)
		sum = accumFunc(sum, valueFunc(playerId, heroEntity, playerEntity));
	end);
	return sum;
end

function Players:GetGoldSuperiority(team1Int, team2Int)
	if team2Int == nil then
		team2Int = self:GetOpponentTeam(team1Int);
	end

	local gold1 = self:GetTeamNetWorth(team1Int);
	local gold2 = self:GetTeamNetWorth(team2Int);

	if gold1 == 0 or gold2 == 0 then
		return 1;
	end

	return gold1 / gold2;
end

function Players:GetOpponentTeam(teamInt)
	if teamInt == DOTA_TEAM_BADGUYS then
		return DOTA_TEAM_GOODGUYS;
	end
	if teamInt == DOTA_TEAM_GOODGUYS then
		return DOTA_TEAM_BADGUYS;
	end
	return DOTA_TEAM_NOTEAM;
end

function Players:HasSelectedHero(playerId)
	return PlayerResource:HasSelectedHero(playerId);
end

function Players:IsBot(playerId)
	return PlayerResource:GetSteamAccountID(playerId) == 0;
end