LinkLuaModifier('modifier_item_wraith_band_intellect', 'modifiers/wraith_band_intellect.lua', LUA_MODIFIER_MOTION_NONE);
LinkLuaModifier('modifier_item_wraith_band_intellect_active', 'modifiers/wraith_band_intellect.lua', LUA_MODIFIER_MOTION_NONE);

require('modifiers/modifier_ancient_start_item_base');

modifier_item_wraith_band_intellect = class({}, nil, ModifierAncientStartItemBase);

modifier_item_wraith_band_intellect:Init({
    bonusesOrder = {'agility', 'intellect', 'strength'},
});

function modifier_item_wraith_band_intellect:OnCreated(kv)
    ModifierAncientStartItemBase.OnCreated(self, kv);
    self.moveSpeedPassive = self:GetItemSpecialValue('move_speed_bonus_passive');
end

function modifier_item_wraith_band_intellect:GetModifierMoveSpeedBonus_Constant()
    return self.moveSpeedPassive * self:GetTimeMultiplier();
end

---------------------------------------------------------------------------------------------------

modifier_item_wraith_band_intellect_active = class({}, nil, ModifierAncientStartItemActiveBase);

modifier_item_wraith_band_intellect_active:Init({
    --
});

function modifier_item_wraith_band_intellect_active:OnCreated(kv)
    ModifierAncientStartItemActiveBase.OnCreated(self, kv);
    self.moveSpeedActive = self:GetItemSpecialValue('move_speed_bonus_active');
end

function modifier_item_wraith_band_intellect_active:GetModifierMoveSpeedBonus_Constant()
    return self.moveSpeedActive * self:GetTimeMultiplier();
end