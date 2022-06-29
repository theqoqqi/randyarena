LinkLuaModifier('modifier_poison_orb', 'modifiers/poison_orb.lua', LUA_MODIFIER_MOTION_NONE);
LinkLuaModifier('modifier_poison_orb_debuff', 'modifiers/poison_orb.lua', LUA_MODIFIER_MOTION_NONE);

require('modifiers/modifier_orb_duplicate_base');

modifier_poison_orb = class({}, nil, ModifierOrbDuplicateBase);

modifier_poison_orb:Init({
    isPermanent = true,
    removeOnDeath = false,
    isHidden = false,
    texture = 'item_witch_blade',
    originalItemModifierName = 'modifier_item_witch_blade',
    originalEffectModifierName = 'modifier_witch_blade_buff',
    replacingEffectModifierName = 'modifier_poison_orb_debuff',
    attackLandedSoundName = 'Item.WitchBlade.Target',
});

function modifier_poison_orb:OnCreated(kv)
    self.abilityCooldown = GetItemKvValue('item_witch_blade', 'AbilityCooldown');
    self.poisonSlowDuration = GetItemSpecialValue('item_witch_blade', 'slow_duration');
    self.poisonSlow = GetItemSpecialValue('item_witch_blade', 'slow');
    self.poisonDamageMultiplier = GetItemSpecialValue('item_witch_blade', 'int_damage_multiplier');
    ModifierOrbDuplicateBase.OnCreated(self, kv);
end

function modifier_poison_orb:OnAttackLanded(keys)
    if not IsServer() then
        return;
    end

    ModifierOrbDuplicateBase.OnAttackLanded(self, keys);
end

function modifier_poison_orb:GetEffectDuration()
    return self.poisonSlowDuration;
end

function modifier_poison_orb:GetCooldown()
    return self.abilityCooldown;
end

function modifier_poison_orb:GetTooltips()
    return {
        self.poisonSlowDuration,
        self.poisonSlow,
        self.poisonDamageMultiplier,
    };
end

---------------------------------------------------------------------------------------------------

modifier_poison_orb_debuff = class({}, nil, ModifierOrbDuplicateEffectBase);

modifier_poison_orb_debuff:Init({
    isPermanent = false,
    removeOnDeath = true,
    isHidden = false,
    isDebuff = true,
    isPurgable = true,
    texture = 'item_witch_blade',
});

function modifier_poison_orb_debuff:OnCreated(kv)
    self.poisonSlow = GetItemSpecialValue('item_witch_blade', 'slow');
    ModifierOrbDuplicateEffectBase.OnCreated(self, kv);

    self:StartIntervalThink(1);
end

function modifier_poison_orb_debuff:OnIntervalThink()
    local parent = self:GetParent();
    local caster = self:GetCaster();
    local damage = caster:GetIntellect();
    local casterPlayer = caster:GetPlayerOwner();

    ApplyDamage({
        victim = parent,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
    });
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, parent, damage, casterPlayer);
end

function modifier_poison_orb_debuff:GetModifierMoveSpeedBonus_Percentage()
    return -self.poisonSlow;
end