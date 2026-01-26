Engulf = Engulf or {}

for k, v in ipairs({
	'config.lua',
	'utils.lua',
	'main.lua',
	'funcs.lua', 
}) do
	assert(SMODS.load_file('modules/'..v))()
end

SMODS.Atlas {
	key = "modicon",
	path = "icon.png",
	px = 34,
	py = 34
}