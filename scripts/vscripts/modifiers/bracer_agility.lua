LinkLuaModifier('modifier_item_bracer_agility', 'modifiers/bracer_agility.lua', LUA_MODIFIER_MOTION_NONE);
LinkLuaModifier('modifier_item_bracer_agility_active', 'modifiers/bracer_agility.lua', LUA_MODIFIER_MOTION_NONE);

require('modifiers/modifier_ancient_start_item_base');

modifier_item_bracer_agility = class({}, nil, ModifierAncientStartItemBase);

modifier_item_bracer_agility:Init({
    bonusesOrder = {'strength', 'agility', 'intellect'},
});

function modifier_item_bracer_agility:OnCreated(kv)
    ModifierAncientStartItemBase.OnCreated(self, kv);
    self.attackSpeedPassive = self:GetItemSpecialValue('attack_speed_bonus_passive');
end

function modifier_item_bracer_agility:GetModifierAttackSpeedBonus_Constant()
    return self.attackSpeedPassive * self:GetTimeMultiplier();
end

---------------------------------------------------------------------------------------------------

modifier_item_bracer_agility_active = class({}, nil, ModifierAncientStartItemActiveBase);

modifier_item_bracer_agility_active:Init({
    --
});

function modifier_item_bracer_agility_active:OnCreated(kv)
    ModifierAncientStartItemActiveBase.OnCreated(self, kv);
    self.attackSpeedActive = self:GetItemSpecialValue('attack_speed_bonus_active');
end

function modifier_item_bracer_agility_active:GetModifierAttackSpeedBonus_Constant()
    return self.attackSpeedActive * self:GetTimeMultiplier();
end