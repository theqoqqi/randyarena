--
-- Created by IntelliJ IDEA.
-- User: Qoqqi
-- Date: 21.10.2018
-- Time: 1:27
-- To change this template use File | Settings | File Templates.
--

MatchController = class({});

function MatchController:Create(randyArena, options)

    local instance = MatchController();

    instance.m_VictoryMessages = {};
    instance.m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#VictoryMessage_GoodGuys";
    instance.m_VictoryMessages[DOTA_TEAM_BADGUYS]  = "#VictoryMessage_BadGuys";
    instance.m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1";
    instance.m_VictoryMessages[DOTA_TEAM_CUSTOM_2] = "#VictoryMessage_Custom2";
    instance.m_VictoryMessages[DOTA_TEAM_CUSTOM_3] = "#VictoryMessage_Custom3";
    instance.m_VictoryMessages[DOTA_TEAM_CUSTOM_4] = "#VictoryMessage_Custom4";
    instance.m_VictoryMessages[DOTA_TEAM_CUSTOM_5] = "#VictoryMessage_Custom5";
    instance.m_VictoryMessages[DOTA_TEAM_CUSTOM_6] = "#VictoryMessage_Custom6";
    instance.m_VictoryMessages[DOTA_TEAM_CUSTOM_7] = "#VictoryMessage_Custom7";
    instance.m_VictoryMessages[DOTA_TEAM_CUSTOM_8] = "#VictoryMessage_Custom8";

    instance.leadingTeam = -1;
    instance.runnerupTeam = -1;
    instance.leadingTeamScore = 0;
    instance.runnerupTeamScore = 0;
    instance.isGameTied = true;
    instance.countdownEnabled = false;

    GameRules:GetGameModeEntity():SetThink('OnThink', instance, 1);
    ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(instance, 'OnTeamKillCredit'), instance);

    return instance;
end

function MatchController:OnGameInProgress()
    self.countdownEnabled = true;
end

function MatchController:OnAllHeroesInGame()

    local numberOfPlayers = RandyArena:GetNumberOfPlayersForRules();
    print('PLAYERS ' .. numberOfPlayers);
    local matchSettings = MATCH_SETTINGS[numberOfPlayers];

    self.killsToWin = matchSettings.killsToWin;
    self.countdownTimer = matchSettings.matchDuration;

    CustomGameEventManager:Send_ServerToAllClients("show_timer", {});
    CustomGameEventManager:Send_ServerToAllClients("game_setup", { kills_to_win = self.killsToWin });
end

function MatchController:OnThink()

    self:UpdateScoreboard();

    if GameRules:IsGamePaused() then
        return 1;
    end

    if self.countdownEnabled then
        self:UpdateCountdownTimer();
        if self.countdownTimer == 30 then
            CustomGameEventManager:Send_ServerToAllClients("timer_alert", {});
        end
        if self.countdownTimer <= 0 then
            --Check to see if there's a tie
            if self.isGameTied then
                self.killsToWin = self.leadingTeamScore + 1;
                local broadcast_killcount = {
                    killcount = self.killsToWin
                };
                CustomGameEventManager:Send_ServerToAllClients("overtime_alert", broadcast_killcount);
            else
                GameRules:SetCustomVictoryMessage(self.m_VictoryMessages[self.leadingTeam]);
                self:EndGame(self.leadingTeam);
                self.countdownEnabled = false;
            end
        end
    end

    return 1;
end

function MatchController:UpdateCountdownTimer()
    self.countdownTimer = self.countdownTimer - 1;
    local t = self.countdownTimer;
    --print( t )
    local minutes = math.floor(t / 60);
    local seconds = t - minutes * 60;
    local m10 = math.floor(minutes / 10);
    local m01 = minutes - m10 * 10;
    local s10 = math.floor(seconds / 10);
    local s01 = seconds - s10 * 10;
    local broadcast_gametimer = {
        timer_minute_10 = m10,
        timer_minute_01 = m01,
        timer_second_10 = s10,
        timer_second_01 = s01,
    };
    CustomGameEventManager:Send_ServerToAllClients("countdown", broadcast_gametimer);
    if t <= 120 then
        CustomGameEventManager:Send_ServerToAllClients("time_remaining", broadcast_gametimer);
    end
end

function MatchController:EndGame(winnerTeam)
    GameRules:SetGameWinner(winnerTeam);
end

---------------------------------------------------------------------------
-- Simple scoreboard using debug text
---------------------------------------------------------------------------
function MatchController:UpdateScoreboard()
    local sortedTeams = {}
    for _, team in pairs( Players:GetActiveTeams() ) do
        table.insert( sortedTeams, { teamID = team, teamScore = GetTeamHeroKills( team ) } )
    end

    -- reverse-sort by score
    table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

    for _, t in pairs( sortedTeams ) do
        -- local clr = self:ColorForTeam( t.teamID )

        -- Scaleform UI Scoreboard
        local score =
        {
            team_id = t.teamID,
            team_score = t.teamScore
        }
        FireGameEvent( "score_board", score )
    end
    -- Leader effects (moved from OnTeamKillCredit)
    local leader = sortedTeams[1].teamID
    --print("Leader = " .. leader)
    self.leadingTeam = leader
    self.runnerupTeam = sortedTeams[2].teamID
    self.leadingTeamScore = sortedTeams[1].teamScore
    self.runnerupTeamScore = sortedTeams[2].teamScore
    self.isGameTied = sortedTeams[1].teamScore == sortedTeams[2].teamScore;
    local allHeroes = HeroList:GetAllHeroes()
    for _,entity in pairs( allHeroes) do
        if entity:GetTeamNumber() == leader and sortedTeams[1].teamScore ~= sortedTeams[2].teamScore then
            if entity:IsAlive() then
                -- Attaching a particle to the leading team heroes
                local existingParticle = entity:Attribute_GetIntValue( "particleID", -1 )
                if existingParticle == -1 then
                    local particleLeader = ParticleManager:CreateParticle( "particles/leader/leader_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, entity )
                    ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, entity, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", entity:GetAbsOrigin(), true )
                    entity:Attribute_SetIntValue( "particleID", particleLeader )
                end
            else
                local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
                if particleLeader ~= -1 then
                    ParticleManager:DestroyParticle( particleLeader, true )
                    entity:DeleteAttribute( "particleID" )
                end
            end
        else
            local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
            if particleLeader ~= -1 then
                ParticleManager:DestroyParticle( particleLeader, true )
                entity:DeleteAttribute( "particleID" )
            end
        end
    end
end

function MatchController:OnTeamKillCredit(keys)
    DebugPrint('[RANDYARENA] OnTeamKillCredit')
    DebugPrintTable(keys)

    local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
    local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
    local numKills = keys.herokills
    local killerTeamNumber = keys.teamnumber



    -- from Overthrow

    local nTeamID = keys.teamnumber;
    local nTeamKills = keys.herokills;
    local nKillsRemaining = self.killsToWin - nTeamKills;

    local broadcast_kill_event = {
        killer_id = keys.killer_userid,
        team_id = keys.teamnumber,
        team_kills = nTeamKills,
        kills_remaining = nKillsRemaining,
        victory = 0,
        close_to_victory = 0,
        very_close_to_victory = 0,
    };

    if nKillsRemaining <= 0 then
        GameRules:SetCustomVictoryMessage(self.m_VictoryMessages[nTeamID]);
        GameRules:SetGameWinner(nTeamID);
        broadcast_kill_event.victory = 1;
    elseif nKillsRemaining == 1 then
        EmitGlobalSound("ui.npe_objective_complete");
        broadcast_kill_event.very_close_to_victory = 1;
    elseif nKillsRemaining <= CLOSE_TO_VICTORY_THRESHOLD then
        EmitGlobalSound("ui.npe_objective_given");
        broadcast_kill_event.close_to_victory = 1;
    end

    CustomGameEventManager:Send_ServerToAllClients("kill_event", broadcast_kill_event);
end