require('modifiers/modifier_base');

LinkLuaModifier('modifier_custom_courier', 'modifiers/custom_courier.lua', LUA_MODIFIER_MOTION_NONE);

modifier_custom_courier = class({}, nil, ModifierBase);

modifier_custom_courier:Init({
    isPermanent = true,
    removeOnDeath = false,
    isHidden = true,
    isDebuff = false,
});

if IsServer() then

    function modifier_custom_courier:OnIntervalThink()

    end

    function modifier_custom_courier:OnStackCountChanged(old)
        local level = self:GetStackCount();
        local courier = self:GetParent();

        courier:SetDeathXP(level * 20 + 100);
        courier:SetMaximumGoldBounty(level * 10 + 100);
        courier:SetMinimumGoldBounty(level * 10 + 100);

        if (level >= 4) then
            self.flying = true;
            self:OnModelChanged();
        end
    end

    function modifier_custom_courier:OnCreated(event)
        local maxLevel = 30;

        if #RandyArena.freePreloadedCourierModels > 0 then
            self.model = ConsumeRandomFromTable(RandyArena.freePreloadedCourierModels);
        else
            self.model = {
                ground = 'models/props_gameplay/donkey.vmdl',
                flying = 'models/props_gameplay/donkey_wings.vmdl',
            };
        end
        self.startlevel = math.min(maxLevel, event.level or 1);
        self.playerId = event.playerId;
        self.flying = false;
        self:SetStackCount(self.startlevel);
        self:OnModelChanged();
        self:StartIntervalThink(5);

        self.levelListener = ListenToGameEvent('dota_player_gained_level', function(self, event)
            if self.playerId ~= event.player_id then
                return;
            end
            local newLevel = self.startlevel - 1 + event.level;
            newLevel = math.min(newLevel, maxLevel);
            self:SetStackCount(newLevel);
        end, self)
    end

    function modifier_custom_courier:OnModelChanged()
        local modelName = self.flying and self.model.flying or self.model.ground;
        self:GetParent():SetOriginalModel(modelName);
        self:GetParent():SetModel(modelName);
    end

    function modifier_custom_courier:OnDestroy(event)
        StopListeningToGameEvent(self.levelListener);
    end

elseif IsClient() then

    function modifier_custom_courier:GetVisualZDelta()
        return self:GetStackCount() >= 5 and 220 or 0;
    end
end

function modifier_custom_courier:isFlying()
    return self.flying;
end

function modifier_custom_courier:GetModifierTurnRate_Override()
    return 10;
end

function modifier_custom_courier:GetModifierMoveSpeedOverride()
    local level = self:GetStackCount();
    return level * 20 + 200;
end

function modifier_custom_courier:CheckState()
    return {
        [MODIFIER_STATE_FLYING] = self:isFlying(),
        -- https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/API#modifierstate
    }
end