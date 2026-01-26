-- Overflow/Noituus compat
Card.getQty = Card.getQty or function() return 1 end 

function Engulf.OperationSound(multchips, arrow)
	if multchips == 'chips' then 
	    local tab = {
			'chips1',
			'x_chips', 
			'talisman_echip', 
			'talisman_eechip', 
			'talisman_eeechip',
	    }
		return tab[math.min(arrow + 2, Talisman and #tab or 2)]
	elseif multchips == 'mult' then
		local tab = {
			'multhit1',
			'multhit2', 
			'talisman_emult', 
			'talisman_eemult', 
			'talisman_eeemult',
	    }
		return tab[math.min(arrow + 2, Talisman and #tab or 2)]
	end
end

function Engulf.OperationText(length)
	if length < 5 then 
		return string.rep('^', length)
	else
		return '{'..number_format(length)..'}'
	end
end

-- All of the below are taken from JenLib by jenwalter666

function Card:gc()
	return (self.config or {}).center or {}
end

function Engulf.h(name, chip, mul, lv, notif, snd, vol, pit, de)
	update_hand_text({sound = type(snd) == 'string' and snd or type(snd) == 'nil' and 'button', volume = vol or 0.7, pitch = pit or 0.8, delay = de or 0.3}, {handname=name or '????', chips = chip or '?', mult = mul or '?', level=lv or '?', StatusText = notif})
end

function Engulf.hn(newname)
	update_hand_text({delay = 0}, {handname = newname})
end

function Engulf.hlv(newlevel)
	update_hand_text({delay = 0}, {level = newlevel})
end

function Engulf.hc(newchips, notif)
	update_hand_text({delay = 0}, {chips = newchips, StatusText = notif})
end

function Engulf.hm(newmult, notif)
	update_hand_text({delay = 0}, {mult = newmult, StatusText = notif})
end

function Engulf.hcm(newchips, newmult, notif)
	update_hand_text({delay = 0}, {chips = newchips, mult = newmult, StatusText = notif})
end

--Updates the hand text to a specified hand
function Engulf.th(hand, notify)
	if hand == 'all' or hand == 'allhands' or hand == 'all_hands' then
		Engulf.h(localize('k_all_hands'), '...', '...', '', notify)
	elseif G.GAME.hands[hand or 'NO_HAND_SPECIFIED'] then
		Engulf.h(localize(hand, 'poker_hands'), G.GAME.hands[hand].chips, G.GAME.hands[hand].mult, G.GAME.hands[hand].level, notify)
	else
		Engulf.h('ERROR', 'ERROR', 'ERROR', 'ERROR', notify)
	end
end

--Fast and easy-to-type function to clear the hand text
function Engulf.ch()
	update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
end
