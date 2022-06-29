LinkLuaModifier('modifier_item_wraith_band_strength', 'modifiers/wraith_band_strength.lua', LUA_MODIFIER_MOTION_NONE);
LinkLuaModifier('modifier_item_wraith_band_strength_active', 'modifiers/wraith_band_strength.lua', LUA_MODIFIER_MOTION_NONE);

require('modifiers/modifier_ancient_start_item_base');

modifier_item_wraith_band_strength = class({}, nil, ModifierAncientStartItemBase);

modifier_item_wraith_band_strength:Init({
    bonusesOrder = {'agility', 'strength', 'intellect'},
});

function modifier_item_wraith_band_strength:OnCreated(kv)
    ModifierAncientStartItemBase.OnCreated(self, kv);
    self.damagePassive = self:GetItemSpecialValue('damage_bonus_passive');
end

function modifier_item_wraith_band_strength:GetModifierPreAttack_BonusDamage()
    return self.damagePassive * self:GetTimeMultiplier();
end

---------------------------------------------------------------------------------------------------

modifier_item_wraith_band_strength_active = class({}, nil, ModifierAncientStartItemActiveBase);

modifier_item_wraith_band_strength_active:Init({
    --
});

function modifier_item_wraith_band_strength_active:OnCreated(kv)
    ModifierAncientStartItemActiveBase.OnCreated(self, kv);
    self.damageActive = self:GetItemSpecialValue('damage_bonus_active');
end

function modifier_item_wraith_band_strength_active:GetModifierPreAttack_BonusDamage()
    return self.damageActive * self:GetTimeMultiplier();
end