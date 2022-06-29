require('items/item_ancient_start_item_base');

item_wraith_band_strength = class({}, nil, ItemAncientStartItemBase);

item_wraith_band_strength:Init({
    intrinsicModifierName = 'modifier_item_wraith_band_strength',
    activeModifierName = 'modifier_item_wraith_band_strength_active',
    colorControlValue = Vector(0.42, 0, 0),
});