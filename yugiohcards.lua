SMODS.Consumable({
    key = 'PotGreed', --joker key
    set = 'Tarot',
    loc_txt = { -- local text
        name = 'Pot Of Greed',
        text = {
            'Draw 2 cards from your Deck.'
        },
    },
    atlas = 'TCGyugioh', --atlas' key
    cost = 10, --cost
    unlocked = true, --where it is unlocked or not: if true,
    discovered = true, --whether or not it starts discovered
    pools = { TCG_Yugioh = true },
    pos = {x = 0, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    loc_vars = function(self, info_queue, center)
    return {vars = {2}}
    end,
    config = {
      extra = {
        card_limit = 3 --configurable value
      }
    },
    can_use = function(self, card)
    if G.GAME.facing_blind then
      return true
    elseif G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
      return true
    else
      return false
    end
  end,
    use = function(self, card, area, copier)
        if G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
            local _card = SMODS.create_card({ set = 'Tarot', area = G.consumeables, key = 'c_tcgyugi_PotGreed' })
            _card:add_to_deck()
            G.deck.config.card_limit = G.deck.config.card_limit + 1
            table.insert(G.playing_cards, _card)
            G.deck:emplace(_card)
        elseif G.STATE == G.STATES.PLAY_TAROT then
            G.FUNCS.draw_from_deck_to_hand(2)
        end
    end,
})

function forbidden_part_added(center, card, from_debuff)
    if not (G.GAME.won or G.GAME.win_notified)
    then
        for k, v in ipairs({ "j_tcgyugi_forbidden_one", "j_tcgyugi_left_arm", "j_tcgyugi_left_leg", "j_tcgyugi_right_arm", "j_tcgyugi_right_leg" }) do
            if center.key ~= v and #SMODS.find_card(v) == 0 then
                return
            end
        end
        G.GAME.win_notified = true
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            blocking = false,
            blockable = false,
            func = (function()
                win_game()
                G.GAME.won = true
                return true
            end)
        }))
    end
end

function destiny_board_win(center, card, from_debuff)
    if not (G.GAME.won or G.GAME.win_notified)
    then
        for k, v in ipairs({ "j_tcgyugi_Destiny_Board", "j_tcgyugi_Spirit_E", "j_tcgyugi_Spirit_A", "j_tcgyugi_Spirit_T", "j_tcgyugi_Spirit_H" }) do
            if center.key ~= v and #SMODS.find_card(v) == 0 then
                return
            end
        end
        G.GAME.win_notified = true
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            blocking = false,
            blockable = false,
            func = (function()
                win_game()
                G.GAME.won = true
                return true
            end)
        }))
    end
end

SMODS.Joker({
    key = "forbidden_one",
    loc_txt = {
    name = 'Exodia the Forbidden One',
    text = {
        'An automatic victory can be declared',
        'by the player whose hand contains this card with the',
        'card with the Left Leg/Right Leg/Left Arm/Right Arm',
        'of the ForbiddenOne.'      
    },
    },
    config = { payout = 4 },
    loc_vars = function(self, info_queue, card)
        table.insert(info_queue, SMODS.Centers.j_tcgyugi_left_arm)
        table.insert(info_queue, SMODS.Centers.j_tcgyugi_left_leg)
        table.insert(info_queue, SMODS.Centers.j_tcgyugi_right_arm)
        table.insert(info_queue, SMODS.Centers.j_tcgyugi_right_leg)
        return { vars = { card and card.ability.payout or self.config.payout } }
    end,
    rarity = 1,
    pos = { x = 1, y = 0 },
    atlas = "TCGyugioh",
    cost = 8,
    pools = { TCG_Yugioh = true },
    unlocked = true, --where it is unlocked or not: if true,
    discovered = true, --whether or not it starts discovered
    add_to_deck = forbidden_part_added,
    calc_dollar_bonus = function(self, card)
        return card.ability.payout
    end
})

SMODS.Joker({
    key = "left_arm",
    loc_txt = { -- local text
    name = 'left arm of the forbidden one',
    text = {
        'A forbidden left arm sealed ',
        'by magic. Whosoever breaks ',
        'this seal will know infinite power.'      
        },
    },
    config = { xchips = 2.5 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.ability.xchips or self.config.xchips } }
    end,
    rarity = 1,
    unlocked = true, 
    discovered = true, 
    pools = { TCG_Yugioh = true },
    pos = { x = 3, y = 0 },
    atlas = "TCGyugioh",
    cost = 6,
    blueprint_compat = true,
    add_to_deck = forbidden_part_added,
    calculate = function(self, card, context)
        if context.joker_main then
            return { xchips = card.ability.xchips }
        end
    end,
})

SMODS.Joker({
    key = "left_leg",
    loc_txt = {
    name = 'left leg of the forbidden one',
    text = {
        'A forbidden left leg sealed ',
        'by magic. Whosoever breaks ',
        'this seal will know infinite power.'      
        },
    },
    config = { chips = 50 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.ability.chips or self.config.chips } }
    end,
    rarity = 1,
    pos = { x = 5, y = 0 },
    atlas = "TCGyugioh",
    cost = 5,
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    pools = { TCG_Yugioh = true },
    blueprint_compat = true,
    add_to_deck = forbidden_part_added,
    calculate = function(self, card, context)
        if context.joker_main then
            return { chips = card.ability.chips }
        end
    end,
})
SMODS.Joker({
    key = "right_arm",
    loc_txt = {
    name = 'right arm of the forbidden one',
    text = {
        'A forbidden right arm sealed ',
        'by magic. Whosoever breaks ',
        'this seal will know infinite power.'      
    },
    },
    config = { xmult = 1.5 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.ability.xmult or self.config.xmult } }
    end,
    rarity = 1,
    pos = { x = 2, y = 0 },
    atlas = "TCGyugioh",
    unlocked = true, 
    discovered = true, 
    pools = { TCG_Yugioh = true },
    cost = 6,
    blueprint_compat = true,
    add_to_deck = forbidden_part_added,
    calculate = function(self, card, context)
        if context.joker_main then
            return { xmult = card.ability.xmult }
        end
    end,
})
SMODS.Joker({
    key = "right_leg",
    loc_txt = { -- local text
    name = 'right leg of the forbidden one',
    text = {
        'A forbidden right leg sealed ',
        'by magic. Whosoever breaks ',
        'this seal will know infinite power.'      
    },
    },
    config = { mult = 10 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.ability.mult or self.config.mult } }
    end,
    rarity = 1,
    pos = { x = 4, y = 0 },
    atlas = "TCGyugioh",
    cost = 5,
    unlocked = true, 
    discovered = true,
    pools = { TCG_Yugioh = true },
    blueprint_compat = true,
    add_to_deck = forbidden_part_added,
    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.mult }
        end
    end,
})

SMODS.Consumable({
    key = 'Scapegoat', --joker key
    set = 'Tarot',
    loc_txt = { -- local text
        name = 'Scapegoat',
        text = {
            'Special Summon 4 "Joker Cards"',
            'into your Joker Zone.'
        },
    },
    atlas = 'TCGyugioh', --atlas' key
    cost = 10, --cost
    unlocked = true, --where it is unlocked or not: if true,
    discovered = true, --whether or not it starts discovered
    pools = { TCG_Yugioh = true },
    pos = {x = 0, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    loc_vars = function(self, info_queue, center)
        return 
    end,
    config = {
      extra = {
        card_limit = 3 --configurable value
      }
    },
    can_use = function(self, card)
        if G.GAME.facing_blind then
            return true
          elseif G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
            return true
          else
            return false
          end
        end,
          use = function(self, card, area, copier)
              if G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
                play_sound('timpani')
                SMODS.add_card { set = 'Joker', key_append = 'randomteleport' }
                SMODS.add_card { set = 'Joker', key_append = 'randomteleport' }
                SMODS.add_card { set = 'Joker', key_append = 'randomteleport' }
                SMODS.add_card { set = 'Joker', key_append = 'randomteleport' }
              elseif G.STATE == G.STATES.PLAY_TAROT then
                play_sound('timpani')
                SMODS.add_card { set = 'Joker', key_append = 'randomteleport' }
                SMODS.add_card { set = 'Joker', key_append = 'randomteleport' }
                SMODS.add_card { set = 'Joker', key_append = 'randomteleport' }
                SMODS.add_card { set = 'Joker', key_append = 'randomteleport' }
        end
    end,
})

SMODS.Joker({
    key = "Jinzo",
    loc_txt = {
    name = 'Jinzo',
    text = {
        'Binds, and their effects',
        'during the round, cannot be activated.',
        'Negate all binds on the board.'      
        },
    },
        config = { xchips = 2.5 },
    rarity = 1,
    pos = { x = 6, y = 0 },
    atlas = "TCGyugioh",
    cost = 5,
    unlocked = true,
    discovered = true,
    pools = { TCG_Yugioh = true },
    blueprint_compat = true,
    calculate = function(self, card, from_debuff)
        if G.GAME.blind and ((not G.GAME.blind.disabled) and (G.GAME.blind:get_type() == 'Boss')) then 
            G.GAME.blind:disable()
            return ({delay = 3.5, message = localize('jinzo_boss_disabled')})
        end
    end,
})

SMODS.Consumable({
    key = 'Copycat', --joker key
    set = 'Tarot',
    loc_txt = { -- local text
        name = 'Copycat',
        text = {
            'Target 1 face-up Joker you control;',
            'this card becomes a copy of',
            'the selected Joker.'
        },
    },
    atlas = 'TCGyugioh', --atlas' key
    cost = 10, --cost
    unlocked = true, --where it is unlocked or not: if true,
    discovered = true, --whether or not it starts discovered
    pools = { TCG_Yugioh = true },
    pos = {x = 1, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    loc_vars = function(self, info_queue, center)
        return 
    end,
    config = {
      extra = {
        card_limit = 3 --configurable value
      }
    },
    can_use = function(self, card)
        if G.GAME.facing_blind then
            return true
          elseif G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
            return true
          else
            return false
          end
        end,
          use = function(self, card, area, copier)
              if G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
                local _card = copy_card(G.jokers.cards[1])
                card:start_materialize()
                card:add_to_deck()
                G.jokers:emplace(_card)
              elseif G.STATE == G.STATES.PLAY_TAROT then
                local _card = copy_card(G.jokers.cards[1])
                card:start_materialize()
                card:add_to_deck()
                G.jokers:emplace(_card)
        end
    end,
})



SMODS.Joker({
    key = "Slifer",
    loc_txt = { -- local text
    name = 'Slifer the Sky Dragon',
    text = {
        'The heavens twist and thunder roars,',
        'signaling the coming of this ancient',
        ' creature, and the dawn of true power.'      
        },
    },
    config = { xchips = 2.5 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.ability.xchips or self.config.xchips } }
    end,
    rarity = 1,
    unlocked = true, 
    discovered = true, 
    pools = { TCG_Yugioh = true },
    pos = { x = 7, y = 0 },
    atlas = "TCGyugioh",
    cost = 6,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return { xchips = card.ability.xchips }
        end
    end,
})

SMODS.Joker({
    key = "Ra",
    loc_txt = {
    name = 'The Winged Dragon of Ra',
    text = {
        'Spirits sing of a powerful creature',
        ' that rules over all that is mystic.'     
        },
    },
    config = { chips = 50 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.ability.chips or self.config.chips } }
    end,
    rarity = 1,
    pos = { x = 8, y = 0 },
    atlas = "TCGyugioh",
    cost = 5,
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    pools = { TCG_Yugioh = true },
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return { chips = card.ability.chips }
        end
    end,
})
SMODS.Joker({
    key = "Obelisk",
    loc_txt = {
    name = 'Obelisk the Tormentor',
    text = {
        'The descent of this mighty creature shall',
        'be heralded by burning winds and twisted land.',
        'And with the coming of this horror, those who',
        'draw breath shall know the true meaning of eternal slumber.'      
    },
    },
    config = { xmult = 1.5 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.ability.xmult or self.config.xmult } }
    end,
    rarity = 1,
    pos = { x = 9, y = 0 },
    atlas = "TCGyugioh",
    unlocked = true, 
    discovered = true, 
    pools = { TCG_Yugioh = true },
    cost = 6,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return { xmult = card.ability.xmult }
        end
    end,
})

SMODS.Joker({
    key = "Destiny_Board",
    loc_txt = {
    name = 'Destiny Board',
    text = {
        'When this card and all 4 "Spirit Message" cards with',
        'different names are placed on your field, you win',
        'the Duel. Once per turn, during end of each round',
        'Place 1 "Spirit Message" card from into your joker slot',
        'in the proper order of "E", "A", "T", and "H".',
        'When any "Spirit Message" card or "Destiny Board" you control leaves the field,',
        'send all "Spirit Message" cards and "Destiny Board" you control to the GY.'
    },
    },
    config = { payout = 4 },
    loc_vars = function(self, info_queue, card)
        table.insert(info_queue, SMODS.Centers.j_tcgyugi_Spirit_E)
        table.insert(info_queue, SMODS.Centers.j_tcgyugi_Spirit_A)
        table.insert(info_queue, SMODS.Centers.j_tcgyugi_Spirit_T)
        table.insert(info_queue, SMODS.Centers.j_tcgyugi_Spirit_H)
        return { vars = { card and card.ability.payout or self.config.payout } }
    end,
    rarity = 1,
    pos = { x = 2, y = 1 },
    atlas = "TCGyugioh",
    cost = 8,
    pools = { TCG_Yugioh = true },
    unlocked = true, --where it is unlocked or not: if true,
    discovered = true, --whether or not it starts discovered
    add_to_deck = destiny_board_win,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and G.GAME.blind.boss and #G.jokers.cards + (G.GAME.joker_buffer or 0) >= G.jokers.config.card_limit then
            if #SMODS.find_card('j_tcgyugi_Spirit_E') == 0 then
            SMODS.add_card { set = 'Joker', key = 'j_tcgyugi_Spirit_E' }
        elseif
            #SMODS.find_card('j_tcgyugi_Spirit_A') == 0 then
            SMODS.add_card { set = 'Joker', key = 'j_tcgyugi_Spirit_A' }
        elseif
            #SMODS.find_card('j_tcgyugi_Spirit_T') == 0 then
            SMODS.add_card { set = 'Joker', key = 'j_tcgyugi_Spirit_T' } 
        elseif
            #SMODS.find_card('j_tcgyugi_Spirit_H') == 0 then
            SMODS.add_card { set = 'Joker', key = 'j_tcgyugi_Spirit_H' } 
            end
        end
    end
})

SMODS.Joker({
    key = "Spirit_E",
    loc_txt = { -- local text
    name = 'Spirit Message "I" ',
    text = {
        'Can only be placed on the field',
        ' by the effect of "Destiny Board".'    
        },
    },
    config = { xchips = 2.5 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.ability.xchips or self.config.xchips } }
    end,
    rarity = 4,
    unlocked = true, 
    discovered = true, 
    pools = { TCG_Yugioh = false },
    pos = { x = 3, y = 1 },
    atlas = "TCGyugioh",
    cost = 6,
    blueprint_compat = true,
    add_to_deck = destiny_board_win,
    calculate = function(self, card, context)
        if context.joker_main then
            return { chips = card.ability.chips }
        end
    end,
})

SMODS.Joker({
    key = "Spirit_A",
    loc_txt = {
    name = 'Spirit Message "A" ',
    text = {
        'Can only be placed on the field',
        'by the effect of "Destiny Board".'    
        },
    },
    config = { chips = 50 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.ability.chips or self.config.chips } }
    end,
    rarity = 4,
    pos = { x = 4, y = 1 },
    atlas = "TCGyugioh",
    cost = 5,
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    pools = { TCG_Yugioh = false },
    blueprint_compat = true,
    add_to_deck = destiny_board_win,
    calculate = function(self, card, context)
        if context.joker_main then
            return { chips = card.ability.chips }
        end
    end,
})
SMODS.Joker({
    key = "Spirit_T",
    loc_txt = {
    name = 'Spirit Message "T" ',
    text = {
        'Can only be placed on the field',
        'by the effect of "Destiny Board".'    
        },
    },
    config = { xmult = 1.5 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.ability.xmult or self.config.xmult } }
    end,
    rarity = 4,
    pos = { x = 5, y = 1 },
    atlas = "TCGyugioh",
    unlocked = true, 
    discovered = true, 
    pools = { TCG_Yugioh = false },
    cost = 6,
    blueprint_compat = true,
    add_to_deck = destiny_board_win,
    calculate = function(self, card, context)
        if context.joker_main then
            return { xmult = card.ability.xmult }
        end
    end,
})

SMODS.Joker({
    key = "Spirit_H",
    loc_txt = { -- local text
    name = 'Spirit Message "H" ',
    text = {
        'Can only be placed on the field',
        'by the effect of "Destiny Board".'    
        },
    },
    config = { mult = 10 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.ability.mult or self.config.mult } }
    end,
    rarity = 4,
    pos = { x = 6, y = 1 },
    atlas = "TCGyugioh",
    cost = 5,
    unlocked = true, 
    discovered = true,
    pools = { TCG_Yugioh = false },
    blueprint_compat = true,
    add_to_deck = destiny_board_win,
    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.mult }
        end
    end,
})

SMODS.Consumable({
    key = 'Black_Illusion_Ritual', --joker key
    set = 'Tarot',
    loc_txt = { -- local text
        name = 'Black Illusion Ritual',
        text = {
            'This card is used to Ritual Summon',
            '"Relinquished". You must also Discard',
            'an ace card from your hand.'
        },
    },
    atlas = 'TCGyugioh', --atlas' key
    cost = 10, --cost
    unlocked = true, --where it is unlocked or not: if true,
    discovered = true, --whether or not it starts discovered
    pools = { TCG_Yugioh = true },
    pos = {x = 0, y = 2}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
--    loc_vars = function(self, info_queue, card,)
--        return { vars = { card and card.consumeable.ability or self.consumeable.ability } } 
--   end,
   config = {
    ability = remove_card,
      extra = {
        card_limit = 3 --configurable value
      }
    },
    can_use = function(self, card)
        if G.GAME.facing_blind then
            return true
          elseif G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
            return true
          else
            return false
          end
        end,
          use = function(self, card, area, copier)
              if G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
                if #SMODS.find_card('A_D', 'A_H', 'A_S', 'A_C') == 1 then
                    SMODS.add_card { set = 'Joker', key = 'j_tcgyugi_Relinquished' }
              elseif G.STATE == G.STATES.PLAY_TAROT then
                if #SMODS.find_card('A_D', 'A_H', 'A_S', 'A_C') == 1 then
                    SMODS.add_card { set = 'Joker', key = 'j_tcgyugi_Relinquished' }
                end
            end
        end
    end,
})


SMODS.Joker({
    key = "Relinquished",
    loc_txt = { -- local text
    name = 'Relinquished',
    text = {
        'Can only be placed on the field',
        'by the effect of "Destiny Board".'    
        },
    },
    config = { mult = 10 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.ability.mult or self.config.mult } }
    end,
    rarity = 4,
    pos = { x = 1, y = 2 },
    atlas = "TCGyugioh",
    cost = 5,
    unlocked = true, 
    discovered = true,
    pools = { TCG_Yugioh = false },
    blueprint_compat = true,
    add_to_deck = destiny_board_win,
    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.mult }
        end
    end,
})