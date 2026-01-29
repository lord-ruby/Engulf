Engulf.ApplyEditionFuncs = Engulf.ApplyEditionFuncs or {}

local op_limit = 1000

Engulf.ApplyEditionFuncs["add_chips"] = function(card, hand, instant, amount, detected_key, cosmetic)
	if not cosmetic then
	    G.GAME.hands[hand].chips = G.GAME.hands[hand].chips + (card.edition[detected_key] * amount)
	end
	if (not instant) or Engulf.config.verbose then
	    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
			play_sound('chips1')
		    if card then card:juice_up(0.8, 0.5) end
	    return true end}))
	    Engulf.hc((card.edition[detected_key] > 0 and '+' or '-')..number_format(math.abs(card.edition[detected_key] * amount)), true)
	    delay(0.2)
	    Engulf.hc(number_format(G.GAME.hands[hand].chips), false)
		delay(0.7)
	end
end

Engulf.ApplyEditionFuncs["x_chips"] = function(card, hand, instant, amount, detected_key, cosmetic)
	if not cosmetic then
	    G.GAME.hands[hand].chips = G.GAME.hands[hand].chips * (card.edition[detected_key] ^ amount)
	end
	if (not instant) or Engulf.config.verbose then
	    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
			play_sound('xchips')
		    if card then card:juice_up(0.8, 0.5) end
	    return true end}))
	    Engulf.hc('X'..number_format(math.abs(card.edition[detected_key] ^ amount)), true)
	    delay(0.2)
	    Engulf.hc(number_format(G.GAME.hands[hand].mult), false)
		delay(0.7)
	end
end

Engulf.ApplyEditionFuncs["e_chips"] = function(card, hand, instant, amount, detected_key, cosmetic)
	local factor = math.abs(amount) == 1 and card.edition[detected_key] or to_big(card.edition[detected_key]) ^ math.abs(amount)
	if not cosmetic then
	    G.GAME.hands[hand].chips = G.GAME.hands[hand].chips ^ (card.edition[detected_key] ^ factor)
	end
	if (not instant) or Engulf.config.verbose then
	    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
			play_sound(Talisman and 'talisman_echip' or 'xchips')
		    if card then card:juice_up(0.8, 0.5) end
	    return true end}))
	    Engulf.hc('^'..number_format(math.abs(card.edition[detected_key] ^ factor)), true)
	    delay(0.2)
	    Engulf.hc(number_format(G.GAME.hands[hand].chips), false)
		delay(0.7)
	end
end

Engulf.ApplyEditionFuncs["ee_chips"] = function(card, hand, instant, amount, detected_key, cosmetic)
	if not cosmetic then
		for i = 1, to_number(math.min(amount, (Engulf.config.unlimit_hyperop and math.huge or op_limit))) do
			G.GAME.hands[hand].chips = to_big(G.GAME.hands[hand].chips):arrow(2, card.edition[detected_key])
		end
	end
	if (not instant) or Engulf.config.verbose then
	    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
			play_sound(Talisman and 'talisman_eechip' or 'xchips')
		    if card then card:juice_up(0.8, 0.5) end
	    return true end}))
	    Engulf.hc('^^'..number_format(math.abs(card.edition[detected_key])..' ('..number_format(math.floor(amount))..'X)'), true)
	    delay(0.2)
	    Engulf.hc(number_format(G.GAME.hands[hand].chips), false)
		delay(0.7)
	end
end

Engulf.ApplyEditionFuncs["eee_chips"] = function(card, hand, instant, amount, detected_key, cosmetic)
	if not cosmetic then
		for i = 1, to_number(math.min(amount, (Engulf.config.unlimit_hyperop and math.huge or op_limit))) do
			G.GAME.hands[hand].chips = to_big(G.GAME.hands[hand].chips):arrow(3, card.edition[detected_key])
		end
	end
	if (not instant) or Engulf.config.verbose then
	    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
			play_sound(Talisman and 'talisman_eeechip' or 'xchips')
		    if card then card:juice_up(0.8, 0.5) end
	    return true end}))
	    Engulf.hc('^^^'..number_format(math.abs(card.edition[detected_key])..' ('..number_format(math.floor(amount))..'X)'), true)
	    delay(0.2)
	    Engulf.hc(number_format(G.GAME.hands[hand].chips), false)
		delay(0.7)
	end
end

Engulf.ApplyEditionFuncs["hyper_chips"] = function(card, hand, instant, amount, detected_key, cosmetic)
	if not cosmetic then
		for i = 1, to_number(math.min(amount, (Engulf.config.unlimit_hyperop and math.huge or op_limit))) do
			G.GAME.hands[hand].chips = to_big(G.GAME.hands[hand].chips):arrow(card.edition[detected_key][1], card.edition[detected_key][2])
		end
	end
	if (not instant) or Engulf.config.verbose then
	    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
			play_sound(Talisman and Engulf.OperationSound('chips', card.edition[detected_key][1]) or 'xchips')
		    if card then card:juice_up(0.8, 0.5) end
	    return true end}))
	    Engulf.hc(Engulf.OperationText(card.edition[detected_key][1])..number_format(math.abs(card.edition[detected_key])..' ('..number_format(math.floor(amount))..'X)'), true)
	    delay(0.2)
	    Engulf.hc(number_format(G.GAME.hands[hand].chips), false)
		delay(0.7)
	end
end

Engulf.ApplyEditionFuncs["add_mult"] = function(card, hand, instant, amount, detected_key, cosmetic)
	if not cosmetic then
	    G.GAME.hands[hand].mult = G.GAME.hands[hand].mult + (card.edition[detected_key] * amount)
	end
    if (not instant) or Engulf.config.verbose then
	    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
			play_sound('multhit1')
		    if card then card:juice_up(0.8, 0.5) end
	    return true end}))
	    Engulf.hm((card.edition[detected_key] > 0 and '+' or '-')..number_format(math.abs(card.edition[detected_key] * amount)), true)
	    delay(0.2)
	    Engulf.hm(number_format(G.GAME.hands[hand].mult), false)
		delay(0.7)
	end
end 

Engulf.ApplyEditionFuncs["x_mult"] = function(card, hand, instant, amount, detected_key, cosmetic)
	if not cosmetic then
	    G.GAME.hands[hand].mult = G.GAME.hands[hand].mult * (card.edition[detected_key] ^ amount)
	end
	if (not instant) or Engulf.config.verbose then
	    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
			play_sound('multhit2')
		    if card then card:juice_up(0.8, 0.5) end
	    return true end}))
	    Engulf.hm('X'..number_format(math.abs(card.edition[detected_key] ^ amount)), true)
	    delay(0.2)
	    Engulf.hm(number_format(G.GAME.hands[hand].mult), false)
		delay(0.7)
	end
end

Engulf.ApplyEditionFuncs["e_mult"] = function(card, hand, instant, amount, detected_key, cosmetic)
	local factor = math.abs(amount) == 1 and card.edition[detected_key] or to_big(card.edition[detected_key]) ^ math.abs(amount) 
	if not cosmetic then
	    G.GAME.hands[hand].mult = G.GAME.hands[hand].mult ^ (card.edition[detected_key] ^ factor)
	end
	if (not instant) or Engulf.config.verbose then
	    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
			play_sound(Talisman and 'talisman_emult' or 'multhit2')
		    if card then card:juice_up(0.8, 0.5) end
	    return true end}))
	    Engulf.hm('^'..number_format(math.abs(card.edition[detected_key] ^ factor)), true)
	    delay(0.2)
	    Engulf.hm(number_format(G.GAME.hands[hand].mult), false)
		delay(0.7)
	end
end

Engulf.ApplyEditionFuncs["ee_mult"] = function(card, hand, instant, amount, detected_key, cosmetic)
	if not cosmetic then
		for i = 1, to_number(math.min(amount, (Engulf.config.unlimit_hyperop and math.huge or op_limit))) do
			G.GAME.hands[hand].mult = to_big(G.GAME.hands[hand].mult):arrow(2, card.edition[detected_key])
		end
	end
	if (not instant) or Engulf.config.verbose then
	    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
			play_sound(Talisman and 'talisman_eemult' or 'xmult')
		    if card then card:juice_up(0.8, 0.5) end
	    return true end}))
	    Engulf.hm('^^'..number_format(math.abs(card.edition[detected_key])..' ('..number_format(math.floor(amount))..'X)'), true)
	    delay(0.2)
	    Engulf.hm(number_format(G.GAME.hands[hand].mult), false)
		delay(0.7)
	end
end

Engulf.ApplyEditionFuncs["eee_mult"] = function(card, hand, instant, amount, detected_key, cosmetic)
	if not cosmetic then
		for i = 1, to_number(math.min(amount, (Engulf.config.unlimit_hyperop and math.huge or op_limit))) do
			G.GAME.hands[hand].mult = to_big(G.GAME.hands[hand].mult):arrow(3, card.edition[detected_key])
		end
	end
	if (not instant) or Engulf.config.verbose then
	    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
			play_sound(Talisman and 'talisman_eeemult' or 'multhit2')
		    if card then card:juice_up(0.8, 0.5) end
	    return true end}))
	    Engulf.hm('^^^'..number_format(math.abs(card.edition[detected_key])..' ('..number_format(math.floor(amount))..'X)'), true)
	    delay(0.2)
	    Engulf.hm(number_format(G.GAME.hands[hand].mult), false)
		delay(0.7)
	end
end

Engulf.ApplyEditionFuncs["hyper_mult"] = function(card, hand, instant, amount, detected_key, cosmetic)
	if not cosmetic then
		for i = 1, to_number(math.min(amount, (Engulf.config.unlimit_hyperop and math.huge or op_limit))) do
			G.GAME.hands[hand].mult = to_big(G.GAME.hands[hand].mult):arrow(card.edition[detected_key][1], card.edition[detected_key][2])
		end
	end
	if (not instant) or Engulf.config.verbose then
	    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
			play_sound(Talisman and Engulf.OperationSound('mult', card.edition[detected_key][1]) or 'multhit2')
		    if card then card:juice_up(0.8, 0.5) end
	    return true end}))
	    Engulf.hm(Engulf.OperationText(card.edition[detected_key][1])..number_format(math.abs(card.edition[detected_key])..' ('..number_format(math.floor(amount))..'X)'), true)
	    delay(0.2)
	    Engulf.hm(number_format(G.GAME.hands[hand].mult), false)
		delay(0.7)
	end
end


Engulf.ApplyEditionFuncs["dollars"] = function(card, hand, instant, amount, detected_key, cosmetic)
	if not cosmetic then
	    ease_dollars(card.edition[detected_key] * amount)
	end
end
