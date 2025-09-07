
LeaderFowRevealer = class({});

function LeaderFowRevealer:Create(randyArena, options)

    local instance = LeaderFowRevealer();

    instance.randyArena = randyArena;

    return instance;
end

function LeaderFowRevealer:OnAllHeroesInGame()
    self.revealer = CreateUnitByName(
            'npc_vision_revealer',
            Vector(0, 0, 0),
            false, nil, nil,
            DOTA_TEAM_GOODGUYS
    );

    Timers:CreateTimer({
        endTime = 0.1,
        callback = function()
            self:UpdateRevealer();
            return 0.1;
        end
    });
end

function LeaderFowRevealer:UpdateRevealer()
    local leadingTeamId = Players:GetLeadingTeam();
    local gameMinute = GameRules:GetGameTime() / 60;

    if leadingTeamId == 0 or gameMinute < 5 then
        self.revealer:SetAbsOrigin(Vector(0, 0, 0));
        return;
    end

    local leadingPlayerId = PlayerResource:GetNthPlayerIDOnTeam(leadingTeamId, 1);
    local leadingHeroEntity = Players:GetHeroEntity(leadingPlayerId);
    local position = leadingHeroEntity:GetAbsOrigin();

    self.revealer:SetAbsOrigin(position);
end
