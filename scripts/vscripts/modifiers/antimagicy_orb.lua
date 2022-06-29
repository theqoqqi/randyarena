LinkLuaModifier('modifier_antimagicy_orb', 'modifiers/antimagicy_orb.lua', LUA_MODIFIER_MOTION_NONE);
LinkLuaModifier('modifier_antimagicy_orb_debuff', 'modifiers/antimagicy_orb.lua', LUA_MODIFIER_MOTION_NONE);

require('modifiers/modifier_orb_duplicate_base');

modifier_antimagicy_orb = class({}, nil, ModifierOrbDuplicateBase);

modifier_antimagicy_orb:Init({
    isPermanent = true,
    removeOnDeath = false,
    isHidden = false,
    texture = 'item_mage_slayer',
    originalItemModifierName = 'modifier_item_mage_slayer',
    originalEffectModifierName = 'modifier_mage_slayer_buff',
    replacingEffectModifierName = 'modifier_antimagicy_orb_debuff',
});

function modifier_antimagicy_orb:OnCreated(kv)
    self.spellAmpDebuff = GetItemSpecialValue('item_mage_slayer', 'spell_amp_debuff');
    self.duration = GetItemSpecialValue('item_mage_slayer', 'duration');
    ModifierOrbDuplicateBase.OnCreated(self, kv);
end

function modifier_antimagicy_orb:GetEffectDuration()
    return self.duration;
end

function modifier_antimagicy_orb:GetTooltips()
    return {
        self.spellAmpDebuff,
        self.duration,
    };
end

---------------------------------------------------------------------------------------------------

modifier_antimagicy_orb_debuff = class({}, nil, ModifierOrbDuplicateEffectBase);

modifier_antimagicy_orb_debuff:Init({
    isPermanent = false,
    removeOnDeath = true,
    isHidden = false,
    isDebuff = true,
    isPurgable = true,
    texture = 'item_mage_slayer',
});

function modifier_antimagicy_orb_debuff:OnCreated(kv)
    self.spellAmpDebuff = GetItemSpecialValue('item_mage_slayer', 'spell_amp_debuff');
    ModifierOrbDuplicateEffectBase.OnCreated(self, kv);
end

function modifier_antimagicy_orb_debuff:GetModifierSpellAmplify_Percentage()
    return -self.spellAmpDebuff;
end