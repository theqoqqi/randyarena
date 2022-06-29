require('items/item_base');

ItemAncientStartItemBase = class({}, nil, ItemBase);
setmetatable(ItemAncientStartItemBase, { __index = ItemBase });

function ItemAncientStartItemBase:Init(keys)
    keys = keys or {};

    ItemBase.Init(self, keys);
    inherit(self, ItemAncientStartItemBase);

    self.activeModifierName = keys.activeModifierName;
    self.particleName = 'particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_ring_spiral.vpcf';
    self.colorControlValue = keys.colorControlValue;
end

function ItemAncientStartItemBase:OnSpellStart()
    local parent = self:GetCaster();
    local duration = self:GetSpecialValueFor('duration');

    parent:AddNewModifier(parent, self, self.activeModifierName, {
        duration = duration,
    });

    self:PlayEffects(parent);
end

function ItemAncientStartItemBase:PlayEffects(target)

    local particleId = ParticleManager:CreateParticle(self.particleName, PATTACH_ABSORIGIN_FOLLOW, target);
    ParticleManager:SetParticleControl(particleId, 0, target:GetOrigin());
    ParticleManager:SetParticleControl(particleId, 62, self.colorControlValue);
    ParticleManager:ReleaseParticleIndex(particleId);

    EmitSoundOn('DOTA_Item.Butterfly', target);
end
