LinkLuaModifier('modifier_skadi_orb', 'modifiers/skadi_orb.lua', LUA_MODIFIER_MOTION_NONE);
LinkLuaModifier('modifier_skadi_orb_debuff', 'modifiers/skadi_orb.lua', LUA_MODIFIER_MOTION_NONE);

require('modifiers/modifier_orb_duplicate_base');

modifier_skadi_orb = class({}, nil, ModifierOrbDuplicateBase);

modifier_skadi_orb:Init({
    isPermanent = true,
    removeOnDeath = false,
    isHidden = false,
    texture = 'item_skadi',
    originalItemModifierName = 'modifier_item_skadi',
    originalEffectModifierName = 'modifier_item_skadi_slow',
    replacingEffectModifierName = 'modifier_skadi_orb_debuff',
});

function modifier_skadi_orb:OnCreated(kv)
    self.coldSlowMelee = GetItemSpecialValue('item_skadi', 'cold_slow_melee');
    self.coldSlowRanged = GetItemSpecialValue('item_skadi', 'cold_slow_ranged');
    self.coldDuration = GetItemSpecialValue('item_skadi', 'cold_duration');
    self.healReduction = GetItemSpecialValue('item_skadi', 'heal_reduction');
    ModifierOrbDuplicateBase.OnCreated(self, kv);
end

function modifier_skadi_orb:GetEffectDuration()
    return self.coldDuration;
end

function modifier_skadi_orb:GetModifierProjectileName()
    return 'particles/items2_fx/skadi_projectile.vpcf';
end

function modifier_skadi_orb:GetTooltips()
    return {
        self.healReduction,
        self.coldDuration,
        self.coldSlowRanged,
        self.coldSlowRanged,
        self.coldSlowMelee,
        self.coldSlowMelee,
    };
end

---------------------------------------------------------------------------------------------------

modifier_skadi_orb_debuff = class({}, nil, ModifierOrbDuplicateEffectBase);

modifier_skadi_orb_debuff:Init({
    isPermanent = false,
    removeOnDeath = true,
    isHidden = false,
    isDebuff = true,
    isPurgable = true,
    texture = 'item_skadi',
});

function modifier_skadi_orb_debuff:OnCreated(kv)
    self.coldSlowMelee = GetItemSpecialValue('item_skadi', 'cold_slow_melee');
    self.coldSlowRanged = GetItemSpecialValue('item_skadi', 'cold_slow_ranged');
    self.healReduction = GetItemSpecialValue('item_skadi', 'heal_reduction');
    ModifierOrbDuplicateEffectBase.OnCreated(self, kv);
end

function modifier_skadi_orb_debuff:GetModifierMoveSpeedBonus_Percentage()
    if self:GetParent():IsRangedAttacker() then
        return self.coldSlowRanged;
    else
        return self.coldSlowMelee;
    end
end

function modifier_skadi_orb_debuff:GetModifierAttackSpeedBonus_Constant()
    if self:GetParent():IsRangedAttacker() then
        return self.coldSlowRanged;
    else
        return self.coldSlowMelee;
    end
end

function modifier_skadi_orb_debuff:GetModifierHPRegenAmplify_Percentage()
    return -self.healReduction;
end

function modifier_skadi_orb_debuff:GetModifierHealAmplify_PercentageTarget()
    return -self.healReduction;
end

function modifier_skadi_orb_debuff:GetModifierHealAmplify_PercentageSource()
    return -self.healReduction;
end