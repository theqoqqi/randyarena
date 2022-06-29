require('items/item_ancient_start_item_base');

item_bracer_agility = class({}, nil, ItemAncientStartItemBase);

item_bracer_agility:Init({
    intrinsicModifierName = 'modifier_item_bracer_agility',
    activeModifierName = 'modifier_item_bracer_agility_active',
    colorControlValue = Vector(0, -1, 0),
});