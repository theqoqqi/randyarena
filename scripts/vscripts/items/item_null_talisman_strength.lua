require('items/item_ancient_start_item_base');

item_null_talisman_strength = class({}, nil, ItemAncientStartItemBase);

item_null_talisman_strength:Init({
    intrinsicModifierName = 'modifier_item_null_talisman_strength',
    activeModifierName = 'modifier_item_null_talisman_strength_active',
    colorControlValue = Vector(0.8, 0, 0),
});