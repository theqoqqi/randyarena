LinkLuaModifier('modifier_item_null_talisman_strength', 'modifiers/null_talisman_strength.lua', LUA_MODIFIER_MOTION_NONE);
LinkLuaModifier('modifier_item_null_talisman_strength_active', 'modifiers/null_talisman_strength.lua', LUA_MODIFIER_MOTION_NONE);

require('modifiers/modifier_ancient_start_item_base');

modifier_item_null_talisman_strength = class({}, nil, ModifierAncientStartItemBase);

modifier_item_null_talisman_strength:Init({
    bonusesOrder = {'intellect', 'strength', 'agility'},
});

function modifier_item_null_talisman_strength:OnCreated(kv)
    ModifierAncientStartItemBase.OnCreated(self, kv);
    self.manaReductionPassive = self:GetItemSpecialValue('mana_reduction_bonus_passive');
end

function modifier_item_null_talisman_strength:GetModifierPercentageManacostStacking()
    return self.manaReductionPassive * self:GetTimeMultiplier();
end

---------------------------------------------------------------------------------------------------

modifier_item_null_talisman_strength_active = class({}, nil, ModifierAncientStartItemActiveBase);

modifier_item_null_talisman_strength_active:Init({
    --
});

function modifier_item_null_talisman_strength_active:OnCreated(kv)
    ModifierAncientStartItemActiveBase.OnCreated(self, kv);
    self.manaReductionActive = self:GetItemSpecialValue('mana_reduction_bonus_active');
end

function modifier_item_null_talisman_strength_active:GetModifierPercentageManacostStacking()
    return self.manaReductionActive * self:GetTimeMultiplier();
end