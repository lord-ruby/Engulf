Engulf.config = SMODS.current_mod.config

SMODS.current_mod.config_tab = function()
	ovrf_nodes = {}
	left_settings = { n = G.UIT.C, config = { align = "tl", padding = 0.05 }, nodes = {} }
	right_settings = { n = G.UIT.C, config = { align = "tl", padding = 0.05 }, nodes = {} }
	config = { n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = { left_settings, right_settings } }
	ovrf_nodes[#ovrf_nodes + 1] = config
	ovrf_nodes[#ovrf_nodes + 1] = create_toggle({
		label = localize("k_stackeffects"),
		active_colour = HEX("40c76d"),
		ref_table = Engulf.config,
		ref_value = "stackeffects",
		callback = function() end,
	})
	ovrf_nodes[#ovrf_nodes + 1] = create_toggle({
		label = localize("k_verbose"),
		active_colour = HEX("40c76d"),
		ref_table = Engulf.config,
		ref_value = "verbose",
		callback = function() end,
	})
	ovrf_nodes[#ovrf_nodes + 1] = create_toggle({
		label = localize("k_unlimit_hyperop"),
		active_colour = HEX("40c76d"),
		ref_table = Engulf.config,
		ref_value = "unlimit_hyperop",
		callback = function() end,
	})
	ovrf_nodes[#ovrf_nodes + 1] = create_toggle({
		label = localize("k_negative_apply"),
		active_colour = HEX("40c76d"),
		ref_table = Engulf.config,
		ref_value = "negative_apply",
		callback = function() end,
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
