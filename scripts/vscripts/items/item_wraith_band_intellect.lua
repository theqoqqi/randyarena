require('items/item_ancient_start_item_base');

item_wraith_band_intellect = class({}, nil, ItemAncientStartItemBase);

item_wraith_band_intellect:Init({
    intrinsicModifierName = 'modifier_item_wraith_band_intellect',
    activeModifierName = 'modifier_item_wraith_band_intellect_active',
    colorControlValue = Vector(0, 0, 0),
});