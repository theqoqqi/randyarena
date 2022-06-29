--
-- Created by IntelliJ IDEA.
-- User: Qoqqi
-- Date: 20.10.2018
-- Time: 18:34
-- To change this template use File | Settings | File Templates.
--

AbilityPointsExchanger = class({});

function AbilityPointsExchanger:Create(randyArena, options)

    local instance = AbilityPointsExchanger();

    RegisterCustomGameEventListener(instance, 'exchange_ability_point', 'OnExchangeAbilityPoint');

    return instance;
end

function AbilityPointsExchanger:OnExchangeAbilityPoint(event)
    print('OnExchangeAbilityPoint');

    local playerId = event.PlayerID;
    local heroEntity = Players:GetHeroEntity(playerId);

    if heroEntity:GetAbilityPoints() < 1 or not RandyArena.gameInProgress then
        return;
    end

    heroEntity:SetAbilityPoints(heroEntity:GetAbilityPoints() - 1);
    AddBonusStrength(heroEntity, nil, 2);
    AddBonusAgility(heroEntity, nil, 2);
    AddBonusIntelligence(heroEntity, nil, 2);
end