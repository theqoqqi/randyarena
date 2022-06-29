require('items/item_ancient_start_item_base');

item_bracer_intellect = class({}, nil, ItemAncientStartItemBase);

item_bracer_intellect:Init({
    intrinsicModifierName = 'modifier_item_bracer_intellect',
    activeModifierName = 'modifier_item_bracer_intellect_active',
    colorControlValue = Vector(0.5, 0, 0),
});