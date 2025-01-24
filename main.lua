--- STEAMODDED HEADER
--- MOD_NAME: Yu-gi-oh Cards
--- MOD_ID: Yugioh
--- MOD_AUTHOR: [elial1]
--- MOD_DESCRIPTION: An example mod on how to create Jokers.
--- PREFIX: tcgyugi
----------------------------------------------
------------MOD CODE -------------------------


assert(SMODS.load_file('yugiohcards.lua'))()

SMODS.ObjectType { key = 'TCG_Yugioh' }
SMODS.ObjectType { key = 'varg_Thumb' }
G.localization.misc.dictionary["YugiBoost"] = "Yu-gi-oh Booster"
G.localization.misc.dictionary["vargThumb"] = "vargThumb"
G.localization.misc.dictionary["JoelCards"] = "Joel Cards"



-- SMODS.add_card({set = 'Tarot', key = 'PotGreed'})

SMODS.Atlas({ -- png for booster packs
    key = "joeymod",
    path = "joeypacks.png",
    px = 71,
    py = 95
})

SMODS.Atlas({ -- png for yugioh cards
    key = 'TCGyugioh', --atlas key
    path = 'TCGyugioh.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
})

SMODS.Booster({
    key = 'TCG_Yugioh',
    loc_txt = {
            name = 'Yugioh Pack',
            group_name = 'yugioh',
            text = { 'A collection of yugioh cards' }
            },
    atlas = 'joeymod',
    pos = { x = 0, y = 0 },
    config = { extra = 5, choose = 1 },
    weight = 999,
    cost = 4,
    group_key = 'YugiBoost',
    draw_hand = true,
    unlocked = true,
    discovered = true,  
    kind = { Tarot, Jokers },
    create_card = function(self)
        return { set = 'TCG_Yugioh', area = G.pack_cards }
      end
})

SMODS.Booster({
    key = 'varg_Thumb',
    loc_txt = {
            name = 'vargThumb Pack',
            group_name = 'vargThumb',
            text = { 'A collection of terrible cards' }
        },
    atlas = 'joeymod',
    pos = { x = 1, y = 0 },
    config = { extra = 5, choose = 1 },
    weight = 998,
    cost = 4,
    group_key = 'vargThumb',
    draw_hand = true,
    unlocked = true,
    discovered = true,
    kind = { Tarot, Jokers },
    no_mod_badges = true,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('k_JoelCards'), G.C.RED, G.C.BLACK, 1.2 )
    end,
end
    create_card = function(self)
        return { set = 'varg_Thumb', area = G.pack_cards }
    end,
end
})

