LinkLuaModifier('modifier_item_null_talisman_agility', 'modifiers/null_talisman_agility.lua', LUA_MODIFIER_MOTION_NONE);
LinkLuaModifier('modifier_item_null_talisman_agility_active', 'modifiers/null_talisman_agility.lua', LUA_MODIFIER_MOTION_NONE);

require('modifiers/modifier_ancient_start_item_base');

modifier_item_null_talisman_agility = class({}, nil, ModifierAncientStartItemBase);

modifier_item_null_talisman_agility:Init({
    bonusesOrder = {'intellect', 'agility', 'strength'},
});

function modifier_item_null_talisman_agility:OnCreated(kv)
    ModifierAncientStartItemBase.OnCreated(self, kv);
    self.spellAmpPassive = self:GetItemSpecialValue('spell_amp_bonus_passive');
end

function modifier_item_null_talisman_agility:GetModifierSpellAmplify_Percentage()
    return self.spellAmpPassive * self:GetTimeMultiplier();
end

---------------------------------------------------------------------------------------------------

modifier_item_null_talisman_agility_active = class({}, nil, ModifierAncientStartItemActiveBase);

modifier_item_null_talisman_agility_active:Init({
    --
});

function modifier_item_null_talisman_agility_active:OnCreated(kv)
    ModifierAncientStartItemActiveBase.OnCreated(self, kv);
    self.spellAmpActive = self:GetItemSpecialValue('spell_amp_bonus_active');
end

function modifier_item_null_talisman_agility_active:GetModifierSpellAmplify_Percentage()
    return self.spellAmpActive * self:GetTimeMultiplier();
end