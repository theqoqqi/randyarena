local giftWeights = {
    {
        item = 'item_flask',
        weight = 100 / 110
    },
    {
        item = 'item_quelling_blade',
        weight = 100 / 130
    },
    {
        item = 'item_gauntlets',
        weight = 100 / 145
    },
    {
        item = 'item_mantle',
        weight = 100 / 145
    },
    {
        item = 'item_slippers',
        weight = 100 / 145
    },
    {
        item = 'item_circlet',
        weight = 100 / 155
    },
    {
        item = 'item_ring_of_protection',
        weight = 100 / 175
    },
    {
        item = 'item_ring_of_regen',
        weight = 100 / 175
    },
    {
        item = 'item_sobi_mask',
        weight = 100 / 175
    },
    {
        item = 'item_magic_stick',
        weight = 100 / 200
    },
    {
        item = 'item_infused_raindrop',
        weight = 100 / 225
    },
    {
        item = 'item_fluffy_hat',
        weight = 100 / 250
    },
    {
        item = 'item_wind_lace',
        weight = 100 / 250
    },
    {
        item = 'item_tango_single',
        weight = 100 / 30
    },
    {
        item = 'item_blight_stone',
        weight = 100 / 300
    },
    {
        item = 'item_buckler',
        weight = 100 / 375
    },
    {
        item = 'item_headdress',
        weight = 100 / 425
    },
    {
        item = 'item_ring_of_basilius',
        weight = 100 / 425
    },
    {
        item = 'item_belt_of_strength',
        weight = 100 / 450
    },
    {
        item = 'item_blades_of_attack',
        weight = 100 / 450
    },
    {
        item = 'item_boots_of_elves',
        weight = 100 / 450
    },
    {
        item = 'item_cloak',
        weight = 100 / 450
    },
    {
        item = 'item_crown',
        weight = 100 / 450
    },
    {
        item = 'item_gloves',
        weight = 100 / 450
    },
    {
        item = 'item_magic_wand',
        weight = 100 / 450
    },
    {
        item = 'item_robe',
        weight = 100 / 450
    },
    {
        item = 'item_branches',
        weight = 100 / 50
    },
    {
        item = 'item_clarity',
        weight = 100 / 50
    },
    {
        item = 'item_smoke_of_deceit',
        weight = 100 / 50
    },
    {
        item = 'item_enchanted_mango',
        weight = 100 / 70
    },
    {
        item = 'item_faerie_fire',
        weight = 100 / 70
    },
    {
        item = 'item_tome_of_knowledge',
        weight = 100 / 75
    },
    {
        item = 'item_ward_sentry',
        weight = 100 / 75
    },
    {
        item = 'item_dust',
        weight = 100 / 80
    },
    {
        item = 'item_tango',
        weight = 100 / 90
    },
    {
        item = 'item_tpscroll',
        weight = 100 / 90
    },
    {
        item = 'item_ward_observer',
        weight = 100 / 90
    },
};

local weightsSum = table.reduce(giftWeights, function(current, item)
    return current + item.weight;
end);

function Consume(keys)
    local caster = keys.caster;
    local casterId = caster:GetPlayerID();

    if caster:IsRealHero() and caster == PlayerResource:GetSelectedHeroEntity(casterId) then

        local ability = keys.ability;
        local playerEntity = Players:GetPlayerEntity(casterId);
        local heroEntity = Players:GetHeroEntity(casterId);

        if heroEntity ~= ability:GetPurchaser() then

            local random = RandomFloat(0, weightsSum);
            local index = 0;
            while random > 0 do
                index = index + 1;
                random = random - giftWeights[index].weight;
            end
            local randomItemName = giftWeights[index].item;

            ability:RemoveSelf();
            heroEntity:AddItemByName(randomItemName);

            EmitSoundOnClient('Item.MoonShard.Consume', playerEntity);

        else
            CustomGameEventManager:Send_ServerToPlayer(playerEntity, 'show_error_message', {
                message = '#dota_hud_error_cannot_unpack_own_gift',
            });
            -- Any message?
        end
    end
end