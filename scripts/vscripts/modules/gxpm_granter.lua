--
-- Created by IntelliJ IDEA.
-- User: Qoqqi
-- Date: 21.10.2018
-- Time: 1:09
-- To change this template use File | Settings | File Templates.
--

GxpmGranter = class({});

function GxpmGranter:Create(randyArena, options)

    local instance = GxpmGranter();

    instance.randyArena = randyArena;

    return instance;
end

function GxpmGranter:OnAllHeroesInGame()

    Timers:CreateTimer({
        endTime = GXPM_SETTINGS.global.tickRate,
        callback = function()
            self:DoGxpmTick(
                GXPM_SETTINGS.global.goldPerTick,
                GXPM_SETTINGS.global.xpPerTick,
                GXPM_SETTINGS.global.killFactor,
                -1
            );
            return GXPM_SETTINGS.global.tickRate;
        end
    });

    Timers:CreateTimer({
        endTime = GXPM_SETTINGS.circle.tickRate,
        callback = function()
            self:DoGxpmTick(
                GXPM_SETTINGS.circle.goldPerTick,
                GXPM_SETTINGS.circle.xpPerTick,
                GXPM_SETTINGS.circle.killFactor,
                GXPM_SETTINGS.circle.radius
            );
            return GXPM_SETTINGS.circle.tickRate;
        end
    });
end

function GxpmGranter:DoGxpmTick(gold, xp, killFactor, radius)
    local maxKills = Players:GetTeamKills(Players:GetLeadingTeam());
    Players:ForEachHeroEntity(function (playerId, heroEntity)
        if radius == -1 or heroEntity:GetAbsOrigin():Length2D() < radius then
            local teamKills = Players:GetTeamKills(heroEntity:GetTeam());
            local comebackFactor = self.randyArena.gameSetup.comebackFactor;
            local multiplier = 1 + (maxKills - teamKills) * (killFactor * comebackFactor);

            Players:ModifyGold(playerId, gold * multiplier, true, DOTA_ModifyGold_GameTick);
            Players:AddExperience(playerId, xp * multiplier, DOTA_ModifyXP_Unspecified);
        end
    end);
end