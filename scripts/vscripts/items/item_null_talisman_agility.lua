require('items/item_ancient_start_item_base');

item_null_talisman_agility = class({}, nil, ItemAncientStartItemBase);

item_null_talisman_agility:Init({
    intrinsicModifierName = 'modifier_item_null_talisman_agility',
    activeModifierName = 'modifier_item_null_talisman_agility_active',
    colorControlValue = Vector(0.2, 0, 0),
});