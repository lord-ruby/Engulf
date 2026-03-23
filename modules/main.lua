Engulf.AllowedSets = Engulf.AllowedSets or {}
table.insert(Engulf.AllowedSets, 'Planet')

Engulf.AllowedKeys = Engulf.AllowedKeys or {}
table.insert(Engulf.AllowedKeys, 'c_black_hole')
table.insert(Engulf.AllowedKeys, 'c_cry_white_hole')

Engulf.SpecialCardFuncs = Engulf.SpecialCardFuncs or {}

Engulf.SpecialEditionFuncs = Engulf.SpecialEditionFuncs or {}

Engulf.TargetHandFuncs = Engulf.TargetHandFuncs or {}

Engulf.EditionFuncs = Engulf.EditionFuncs or {}

Engulf.EditionBlacklist = Engulf.EditionBlacklist or {}

Engulf.CardBlacklist = Engulf.CardBlacklist or {}

function Engulf.table_contains(tab, item)
	for k, v in pairs(tab) do
		if v == item then 
			return true
		end 
	end
	return false
end

local loadmodsref = SMODS.injectItems
function SMODS.injectItems(...)
    loadmodsref(...)
    for i, v in pairs(AurinkoAddons or {}) do if not Engulf.EditionFuncs["e_"..i] then Engulf.EditionFuncs["e_"..i] = v end end
    for i, v in pairs(AurinkoWhitelist or {}) do 
		if v then
			table.insert(Engulf.AllowedKeys, i) 
		end
	end
    local ccr = create_card
    function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append,...)
        local card = ccr(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append,...)
        if Engulf.table_contains(Engulf.AllowedSets, card:gc().set) or Engulf.table_contains(Engulf.AllowedKeys, card:gc().key) and not Engulf.table_contains(Engulf.CardBlacklist, card:gc().key) then
            local edition = poll_edition('edi'..(key_append or '')..tostring(G.GAME.round_resets.ante))
            if edition then
                G.E_MANAGER:add_event(Event({blocking = false, blockable = false, func = function()
                    if not card.edition then
                        card:set_edition(edition)
                    end
                return true end}))
            end
        end
        return card
    end
end

-- List of acceptable keys in Edition's config
-- Each item is a table: {KEY, FUNCTION, PRIORITY}
Engulf.GenericKeys = Engulf.GenericKeys or {}

for k, v in ipairs({
	{'chips', 'add_chips', 1}, {'chips_mod', 'add_chips', 1}, 
	{'x_chips', 'x_chips', 2}, {'xchips', 'x_chips', 2}, {'Xchips', 'x_chips', 2}, {'Xchips_mod', 'x_chips', 2}, 
	{'e_chips', 'e_chips', 3}, {'echips', 'e_chips', 3}, {'Echips', 'e_chips', 3}, {'Echips_mod', 'e_chips', 3}, 
	{'ee_chips', 'ee_chips', 4}, {'eechips', 'ee_chips', 4}, {'EEchips', 'ee_chips', 4}, {'EEchips_mod', 'ee_chips', 4}, 
	{'eee_chips', 'eee_chips', 5}, {'eeechips', 'eee_chips', 5}, {'EEEchips', 'eee_chips', 5}, {'EEEchips_mod', 'eee_chips', 5}, 
	{'hyper_chips', 'hyper_chips', 6}, {'hyperchips', 'hyper_chips', 6},
	
	{'mult', 'add_mult', 101}, {'mult_mod', 'add_mult', 101}, 
	{'x_mult', 'x_mult', 102}, {'xmult', 'x_mult', 102}, {'Xmult', 'x_mult', 102}, {'Xmult_mod', 'x_mult', 102}, 
	{'e_mult', 'e_mult', 103}, {'emult', 'e_mult', 103}, {'Emult', 'e_mult', 103}, {'Emult_mod', 'e_mult', 103}, 
	{'ee_mult', 'ee_mult', 4}, {'eemult', 'ee_mult', 4}, {'EEmult', 'ee_mult', 4}, {'EEmult_mod', 'ee_mult', 4}, 
	{'eee_mult', 'eee_mult', 5}, {'eeemult', 'eee_mult', 5}, {'EEEmult', 'eee_mult', 5}, {'EEEmult_mod', 'eee_mult', 5}, 
	{'hyper_mult', 'hyper_mult', 6}, {'hypermult', 'hyper_mult', 6},
	
	{'p_dollars', 'dollars', 1}, {'h_dollars', 'dollars', 201}, {'dollars', 'dollars', 201}, {'money', 'dollars', 201}
}) do
	table.insert(Engulf.GenericKeys, v)
end

function Engulf.ApplyEdition(card, hand, amount, instant, cosmetic)
	if Engulf.table_contains(Engulf.AllowedSets, card:gc().set) or Engulf.table_contains(Engulf.AllowedKeys, card:gc().key) then
		local to_apply = {}
		local applied = {}
		if Engulf.SpecialCardFuncs[card:gc().key] then 
			Engulf.SpecialCardFuncs[card:gc().key](card, hand, instant, amount or 1, cosmetic)
		elseif Engulf.EditionFuncs[card.edition.key] then
			Engulf.EditionFuncs[card.edition.key](card, hand, instant, amount, card.edition, cosmetic)
		else
			for k, v in pairs(card.edition) do
				local accepted
				local func
				local key
				for k2, v2 in pairs(Engulf.GenericKeys) do
					if v2[1] == k then 
						accepted = true
						func = v2[2]
						break
					end 
				end
				if accepted and Engulf.ApplyEditionFuncs[func] then
					if not to_apply[func] then table.insert(to_apply, {func, k}) end
				end
			end
		end
		table.sort(to_apply, function(a, b)
			local a_pos = 0
		    local b_pos = 0
		    for k, v in pairs(Engulf.GenericKeys) do
				if v[2] == a[1] then 
					a_pos = v[3]
				elseif v[2] == b[1] then
					b_pos = v[3]
				end 
				if a_pos > 0 and b_pos > 0 then 
					break
				end
			end
			return a_pos < b_pos
        end)
		if #to_apply > 0 then
			if Engulf.config.verbose and instant then
				Engulf.th(hand)
			end
		end
	    for k, v in ipairs(to_apply) do
			if not applied[v[1]] then
			    Engulf.ApplyEditionFuncs[v[1]](card, hand, instant, Engulf.config.stackeffects and (amount or 1) or 1, v[2], cosmetic) 
				applied[v[1]] = true
			end 
		end
	end 
end

local use_cardref = G.FUNCS.use_card
G.FUNCS.use_card = function(e, mute, nosave,...)
    local card = e.config.ref_table
	use_cardref(e, mute, nosave,...)
	if card.edition and card:gc().set ~= 'Planet' and (Engulf.table_contains(Engulf.AllowedSets, card:gc().set) or Engulf.table_contains(Engulf.AllowedKeys, card:gc().key)) then
		if Engulf.TargetHandFuncs[card:gc().key] then
			Engulf.th(Engulf.TargetHandFuncs[card:gc().key](card))
			Engulf.ApplyEdition(card, Engulf.TargetHandFuncs[card:gc().key](card), card:getQty(), false)
			Engulf.ch()
		elseif Engulf.TargetHandFuncs[card:gc().set] then
			Engulf.th(Engulf.TargetHandFuncs[card:gc().set](card))
			Engulf.ApplyEdition(card, Engulf.TargetHandFuncs[card:gc().set](card), card:getQty(), false)
			Engulf.ch()
		end
	end
end

local luh_ref = level_up_hand
function level_up_hand(card, hand, instant, amount)
    if card and card.edition and (card.edition.retriggers or card.edition.repetitions) then
        if card.edition.retriggers then
            amount = (amount or 1) * (Engulf.config.negative_apply and (card.edition.retriggers + 1) or math.max(1, card.edition.retriggers + 1))
        else
            amount = (amount or 1) * (Engulf.config.negative_apply and (card.edition.repetitions + 1) or math.max(1, card.edition.repetitions + 1))
        end
    end
    luh_ref(card, hand, instant, amount)
end

function Engulf.EditionHand(card, hand, edition, amount, instant, cosmetic)
	if card and card.edition then
		Engulf.ApplyEdition(card, hand, amount, instant, cosmetic)
	else
		if Engulf.EditionFuncs[card.edition.key] then
			Engulf.EditionFuncs[card.edition.key](card, hand, instant, amount, card.edition, cosmetic)
		else
			for k, v in pairs(G.P_CENTERS[edition].config) do
				local accepted
				local func
				local key
				for k2, v2 in pairs(Engulf.GenericKeys) do
					if v2[1] == k then 
						accepted = true
						func = v2[2]
						break
					end 
				end
				if accepted and Engulf.ApplyEditionFuncs[func] then
					if not to_apply[func] then table.insert(to_apply, {func, k}) end
				end
			end
		end
		table.sort(to_apply, function(a, b)
			local a_pos = 0
		    local b_pos = 0
		    for k, v in pairs(Engulf.GenericKeys) do
				if v[2] == a[1] then 
					a_pos = v[3]
				elseif v[2] == b[1] then
					b_pos = v[3]
				end 
				if a_pos > 0 and b_pos > 0 then 
					break
				end
			end
			return a_pos < b_pos
        end)
		if #to_apply > 0 then
			if Engulf.config.verbose and instant then
				Engulf.th(hand)
			end
		end
	    for k, v in ipairs(to_apply) do
			if not applied[v[1]] then
			    Engulf.ApplyEditionFuncs[v[1]](nil, hand, instant, Engulf.config.stackeffects and (amount or 1) or 1, v[2], cosmetic) 
				applied[v[1]] = true
			end 
		end
	end
end

-- All of the below is deprecated, purely for backwards compatibility
function Engulf.performop(num1, num2, op)
    if op == "+" then return to_big(num1)+to_big(num2) end
    if op == "X" then return to_big(num1)*to_big(num2) end
    if op == "^" then return to_big(num1)^to_big(num2) end
    if type(op) == "number" then return to_big(num1):arrow(op, num2) end
end

function Engulf.StackOP(num1, num2, op) 
    if op == "^" or op == "X" or type(op) == "number" then 
        return to_big(num1)^to_big(num2) 
    else 
        local base = num1
        if num2 < 1000 then
            if num2 > 1 then
                for i = 1, num2 - 1 do num1 = Engulf.performop(num1, base, op) end
            end
        end
        return to_big(num1)*to_big(num2) 
    end 
end
