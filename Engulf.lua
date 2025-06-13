Engulf = {}
Engulf.config = SMODS.current_mod.config
SMODS.Atlas {key = "modicon",path = "icon.png",px = 34,py = 34,}:register()
function Engulf.Editionfunc(mtype, sound, numfunc, all)
    return function(card, hand, instant, amount, edition) 
        local num = numfunc(edition, card)
        if mtype.chips then G.GAME.hands[hand].chips = Engulf.performop(G.GAME.hands[hand].chips, Engulf.StackOP(num,amount, mtype.type), mtype.type) end
        if mtype.mult then G.GAME.hands[hand].mult = Engulf.performop(G.GAME.hands[hand].mult, Engulf.StackOP(num,amount, mtype.type), mtype.type) end
        if not instant then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                play_sound('tarot1');if card then card:juice_up(0.8, 0.5) end;G.TAROT_INTERRUPT_PULSE = nil;return true 
            end}))
            local c, m, l, hn
            if G.PROFILES[G.SETTINGS.profile].cry_none and G.GAME.hands["cry_None"].visible and G.GAME.blind and G.GAME.blind.blind_set then 
                c, m, l, hn = G.GAME.hands["cry_None"].chips, G.GAME.hands["cry_None"].mult, localize("cry_None", "poker_hands") 
            end
            update_hand_text({ sound = sound, volume = 0.7, pitch = 0.9, delay = 0 }, {chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult, level = G.GAME.hands[hand].level, handname = localize(hand, "poker_hands")})
            update_hand_text({ sound = sound, volume = 0.7, pitch = 0.9, delay = 0.1 }, {StatusText=true, chips = mtype.chips and mtype.type..number_format(Engulf.StackOP(num,amount, mtype.type)), mult = mtype.mult and mtype.type..number_format(Engulf.StackOP(num,amount, mtype.type))})
            update_hand_text({ sound = sound, volume = 0.7, pitch = 0.9, delay = 1 }, {chips = c, mult = m, level = l, handname = hn})
        end
    end
end
AurinkoAddons = AurinkoAddons or {};AurinkoWhitelist = AurinkoWhitelist or {}
Engulf.SpecialFuncs = {
    c_black_hole = function(card, hand, instant, amount)
        if card.edition then
            for i, v in pairs(G.GAME.hands) do
                Engulf.EditionHand(card, i, card.edition, Engulf.config.stackeffects and amount or 1, true)
            end
        end
    end
}
Engulf.EditionFuncs = {
    e_foil = Engulf.Editionfunc({chips=true,type="+"}, "chips1", function(edition) return edition.chips end),
    e_holo = Engulf.Editionfunc({mult=true,type="+"}, "multhit1", function(edition) return edition.mult end),
    e_polychrome = Engulf.Editionfunc({mult=true,type="X"}, "multhit2", function(edition) return edition.x_mult end),
}
local level_up_handref = level_up_hand
function level_up_hand(card, hand, instant, amount,...)
    level_up_handref(card, hand, instant, amount,...)
    if card and card.edition and to_big(amount or 1) > to_big(0) then
        if Engulf.SpecialFuncs[card.config.center.key] then 
        else Engulf.EditionHand(card, hand, card.edition, math.min(amount or 1, Engulf.config.stackeffects and 1 or amount), instant) end end
end
Engulf.SpecialWhitelist = {}
function Engulf.EditionHand(card, hand, edition, amount, instant)
    if Engulf.EditionFuncs[edition.key] then Engulf.EditionFuncs[edition.key](card, hand, instant, Engulf.config.stackeffects and amount or 1, edition) else
        if edition.chips then Engulf.Editionfunc({chips=true,type="+"}, "chips1", function(edition) return edition.chips end)(card, hand, instant, amount or 1, edition) end
        if edition.mult then Engulf.Editionfunc({mult=true,type="+"}, "multhit1", function(edition) return edition.mult end)(card, hand, instant, amount or 1, edition) end
        if edition.x_chips then Engulf.Editionfunc({chips=true,type="X"}, "talisman_xchip", function(edition) return edition.x_chips end)(card, hand, instant, amount or 1, edition) end
        if edition.x_mult then Engulf.Editionfunc({mult=true,type="X"}, "multhit2", function(edition) return edition.x_mult end)(card, hand, instant, amount or 1, edition) end
        if edition.e_chips then Engulf.Editionfunc({chips=true,type="^"}, "talisman_echip", function(edition) return edition.e_chips end)(card, hand, instant or 1, amount, edition) end
        if edition.e_mult then Engulf.Editionfunc({mult=true,type="^"}, "talisman_emult", function(edition) return edition.e_mult end)(card, hand, instant, amount or 1, edition) end
        if edition.ee_chips then Engulf.Editionfunc({chips=true,type=2}, "talisman_eechip", function(edition) return edition.ee_chips end)(card, hand, instant, amount or 1, edition) end
        if edition.ee_mult then Engulf.Editionfunc({mult=true,type=2}, "talisman_eemult", function(edition) return edition.ee_mult end)(card, hand, instant, amount or 1, edition) end
        if edition.eee_chips then Engulf.Editionfunc({chips=true,type=3}, "talisman_eeechip", function(edition) return edition.eee_chips end)(card, hand, instant, amount or 1, edition) end
        if edition.eee_mult then Engulf.Editionfunc({mult=true,type=3}, "talisman_eeemult", function(edition) return edition.eee_mult end)(card, hand, instant, amount or 1, edition) end
        if edition.hyper_chips then Engulf.Editionfunc({chips=true,type=edition.hyper_chips[1]}, "talisman_eeechip", function(edition) return edition.hyper_chips[2] end)(card, hand, instant, amount or 1, edition) end
        if edition.hyper_mult then Engulf.Editionfunc({mult=true,type=edition.hyper_chips[1]}, "talisman_eeemult", function(edition) return edition.hyper_chips[2] end)(card, hand, instant, amount or 1, edition) end
        if edition.repetitions or edition.retriggers then level_up_hand(card, hand, instant, edition.repetitions or edition.retriggers) end
    end
end

function Engulf.performop(num1, num2, op)
    if op == "+" then return to_big(num1)+to_big(num2) end
    if op == "X" then return to_big(num1)*to_big(num2) end
    if op == "^" then return to_big(num1)^to_big(num2) end
    if type(op) == "number" then to_big(num1):arrow(op, num2) end
end
function Engulf.StackOP(num1, num2, op) if op == "^" or op == "X" or type(op) == "number" then return to_big(num1)^to_big(num2) else return to_big(num1)*to_big(num2) end end
local use_cardref = G.FUNCS.use_card
G.FUNCS.use_card = function(e, mute, nosave,...)
    local card = e.config.ref_table
	use_cardref(e,mute,nosave,...)
    G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = 0.3,
        func = function()
            if Engulf.SpecialFuncs[card.config.center.key] then Engulf.SpecialFuncs[card.config.center.key] (card, hand, instant, amount) end
            return true
        end
    }))
end
local loadmodsref = SMODS.injectItems
function SMODS.injectItems(...)
    loadmodsref(...)
    for i, v in pairs(AurinkoAddons) do if not Engulf.EditionFuncs["e_"..i] then Engulf.EditionFuncs["e_"..i]=v end end
    for i, v in pairs(AurinkoWhitelist) do Engulf.SpecialWhitelist[i]=v end
    local ccr = create_card
    function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append,...)
        local card = ccr(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append,...)
        if _type=="Planet" or Engulf.SpecialWhitelist[card.config.center.key] or Engulf.SpecialWhitelist[_type] then
            local edition = poll_edition('edi'..(key_append or '')..tostring(G.GAME.round_resets.ante))
            G.E_MANAGER:add_event(Event({
                blocking = false,
                blockable = false,
                func = function()
                    card:set_edition(edition)
                    return true
                end
            }))
        end
        return card
    end
end

local engulfConfigTab = function()
	ovrf_nodes = {
	}
	left_settings = { n = G.UIT.C, config = { align = "tl", padding = 0.05 }, nodes = {} }
	right_settings = { n = G.UIT.C, config = { align = "tl", padding = 0.05 }, nodes = {} }
	config = { n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = { left_settings, right_settings } }
	ovrf_nodes[#ovrf_nodes + 1] = config
	ovrf_nodes[#ovrf_nodes + 1] = create_toggle({
		label = localize("k_stackeffects"),
		active_colour = HEX("40c76d"),
		ref_table = Engulf.config,
		ref_value = "stackeffects",
		callback = function()
        end,
	})
	return {
		n = G.UIT.ROOT,
		config = {
			emboss = 0.05,
			minh = 6,
			r = 0.1,
			minw = 10,
			align = "cm",
			padding = 0.2,
			colour = G.C.BLACK,
		},
		nodes = ovrf_nodes,
	}
end

SMODS.current_mod.config_tab = engulfConfigTab
