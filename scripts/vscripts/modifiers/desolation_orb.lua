LinkLuaModifier('modifier_desolation_orb', 'modifiers/desolation_orb.lua', LUA_MODIFIER_MOTION_NONE);
LinkLuaModifier('modifier_desolation_orb_debuff', 'modifiers/desolation_orb.lua', LUA_MODIFIER_MOTION_NONE);

require('modifiers/modifier_orb_duplicate_base');

modifier_desolation_orb = class({}, nil, ModifierOrbDuplicateBase);

modifier_desolation_orb:Init({
    isPermanent = true,
    removeOnDeath = false,
    isHidden = false,
    texture = 'item_desolator',
    originalItemModifierName = 'modifier_item_desolator',
    originalEffectModifierName = 'modifier_desolator_buff',
    replacingEffectModifierName = 'modifier_desolation_orb_debuff',
    attackLandedSoundName = 'Item_Desolator.Target',
});

function modifier_desolation_orb:OnCreated(kv)
    self.corruptionArmor = GetItemSpecialValue('item_desolator', 'corruption_armor');
    self.corruptionDuration = GetItemSpecialValue('item_desolator', 'corruption_duration');
    ModifierOrbDuplicateBase.OnCreated(self, kv);
end

function modifier_desolation_orb:GetEffectDuration()
    return self.corruptionDuration;
end

function modifier_desolation_orb:GetModifierProjectileName()
    return 'particles/items_fx/desolator_projectile.vpcf';
end

function modifier_desolation_orb:GetTooltips()
    return {
        self.corruptionArmor,
        self.corruptionDuration,
    };
end

---------------------------------------------------------------------------------------------------

modifier_desolation_orb_debuff = class({}, nil, ModifierOrbDuplicateEffectBase);

modifier_desolation_orb_debuff:Init({
    isPermanent = false,
    removeOnDeath = true,
    isHidden = false,
    isDebuff = true,
    isPurgable = true,
    texture = 'item_desolator',
});

function modifier_desolation_orb_debuff:OnCreated(kv)
    self.corruptionArmor = GetItemSpecialValue('item_desolator', 'corruption_armor');
    ModifierOrbDuplicateEffectBase.OnCreated(self, kv);
end

function modifier_desolation_orb_debuff:GetModifierPhysicalArmorBonus()
    return self.corruptionArmor;
end