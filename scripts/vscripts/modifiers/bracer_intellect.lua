LinkLuaModifier('modifier_item_bracer_intellect', 'modifiers/bracer_intellect.lua', LUA_MODIFIER_MOTION_NONE);
LinkLuaModifier('modifier_item_bracer_intellect_active', 'modifiers/bracer_intellect.lua', LUA_MODIFIER_MOTION_NONE);

require('modifiers/modifier_ancient_start_item_base');

modifier_item_bracer_intellect = class({}, nil, ModifierAncientStartItemBase);

modifier_item_bracer_intellect:Init({
    bonusesOrder = {'strength', 'intellect', 'agility'},
});

function modifier_item_bracer_intellect:OnCreated(kv)
    ModifierAncientStartItemBase.OnCreated(self, kv);
    self.magicResistPassive = self:GetItemSpecialValue('magic_resist_bonus_passive');
end

function modifier_item_bracer_intellect:GetModifierMagicalResistanceBonus()
    return self.magicResistPassive * self:GetTimeMultiplier();
end

---------------------------------------------------------------------------------------------------

modifier_item_bracer_intellect_active = class({}, nil, ModifierAncientStartItemActiveBase);

modifier_item_bracer_intellect_active:Init({
    --
});

function modifier_item_bracer_intellect_active:OnCreated(kv)
    ModifierAncientStartItemActiveBase.OnCreated(self, kv);
    self.magicResistActive = self:GetItemSpecialValue('magic_resist_bonus_active');
end

function modifier_item_bracer_intellect_active:GetModifierMagicalResistanceBonus()
    return self.magicResistActive * self:GetTimeMultiplier();
end