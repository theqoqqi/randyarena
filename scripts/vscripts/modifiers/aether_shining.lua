require('modifiers/modifier_base');

LinkLuaModifier('modifier_aether_shining', 'modifiers/aether_shining.lua', LUA_MODIFIER_MOTION_NONE);

modifier_aether_shining = class({}, nil, ModifierBase);

modifier_aether_shining:Init({
    isPermanent = true,
    removeOnDeath = false,
    isHidden = false,
    texture = 'item_aether_lens',
});

function modifier_aether_shining:OnCreated(kv)
    self.castRangeBonus = GetItemSpecialValue('item_aether_lens', 'cast_range_bonus');
end

function modifier_aether_shining:IsDebuff()
    return self:GetParent():HasModifier('modifier_item_aether_lens');
end

function modifier_aether_shining:GetModifierCastRangeBonus()
    return self.castRangeBonus;
end