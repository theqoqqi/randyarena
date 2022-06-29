require('modifiers/modifier_base');

LinkLuaModifier('modifier_octarine_shining', 'modifiers/octarine_shining.lua', LUA_MODIFIER_MOTION_NONE);

modifier_octarine_shining = class({}, nil, ModifierBase);

modifier_octarine_shining:Init({
    isPermanent = true,
    removeOnDeath = false,
    isHidden = false,
    texture = 'item_octarine_core',
});

function modifier_octarine_shining:OnCreated(kv)
    self.cooldownReduction = GetItemSpecialValue('item_octarine_core', 'bonus_cooldown');
    self.heroLifesteal = GetItemSpecialValue('item_octarine_core', 'hero_lifesteal');
    self.creepLifesteal = GetItemSpecialValue('item_octarine_core', 'creep_lifesteal');
end

function modifier_octarine_shining:IsDebuff()
    return self:GetParent():HasModifier('modifier_item_octarine_core');
end

function modifier_octarine_shining:GetModifierPercentageCooldown()
    local parent = self:GetParent();
    if parent:HasModifier('modifier_item_octarine_core') then
        return 0;
    end
    return self.cooldownReduction;
end

function modifier_octarine_shining:OnTooltip()
    return self.heroLifesteal;
end

function modifier_octarine_shining:OnTooltip2()
    return self.creepLifesteal;
end

function modifier_octarine_shining:OnTakeDamage(event)
    local parent = self:GetParent();

    if not IsServer() or parent:HasModifier('modifier_item_octarine_core') then
        return;
    end

    local applyHeal = (event.damage_type == DAMAGE_TYPE_MAGICAL
            or event.damage_category == DOTA_DAMAGE_CATEGORY_SPELL)
        and parent:GetTeamNumber() ~= event.unit:GetTeamNumber()
        and event.attacker == parent
        and event.unit ~= parent;

    if applyHeal then
        local lifestealAmount = event.unit:IsRealHero() and self.heroLifesteal or self.creepLifesteal;
        local heal = event.damage * lifestealAmount / 100;
        local playerEntity = parent:GetPlayerOwner();

        parent:Heal(heal, self:GetAbility());

        SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, heal, playerEntity);

        self:PlayEffects(parent);
    end
end

function modifier_octarine_shining:PlayEffects(target)
    local particleName = 'particles/items3_fx/octarine_core_lifesteal.vpcf';

    local particleId = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target);
    ParticleManager:SetParticleControl(particleId, 1, target:GetOrigin());
    ParticleManager:ReleaseParticleIndex(particleId);
end