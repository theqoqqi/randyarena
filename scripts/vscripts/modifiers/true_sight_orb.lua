require('modifiers/modifier_base');

LinkLuaModifier('modifier_true_sight_orb', 'modifiers/true_sight_orb.lua', LUA_MODIFIER_MOTION_NONE);

modifier_true_sight_orb = class({}, nil, ModifierBase);

modifier_true_sight_orb:Init({
    isPermanent = true,
    removeOnDeath = false,
    isHidden = false,
    texture = 'item_gem',
});

function modifier_true_sight_orb:OnCreated(kv)
    self.radius = GetItemSpecialValue('item_gem', 'radius');
end

function modifier_true_sight_orb:IsDebuff()
    return self:GetParent():HasModifier('modifier_item_gem');
end

function modifier_true_sight_orb:IsAura()
    return true;
end

function modifier_true_sight_orb:GetAuraDuration()
    return 0.1;
end

function modifier_true_sight_orb:GetAuraRadius()
    return self.radius;
end

function modifier_true_sight_orb:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE;
end

function modifier_true_sight_orb:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY;
end

function modifier_true_sight_orb:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL;
end

function modifier_true_sight_orb:GetModifierAura()
    return 'modifier_truesight';
end