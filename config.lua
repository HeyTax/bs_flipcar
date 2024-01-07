Config = {}

-- For debug
Config.Debug = false
Config.DebugCar = false

Config.TimesTillFlip = 3  -- How long until the car flips.
Config.CustomProgBar = false -- If you have a custom progbar you can set it to true line = 47

Config.Langes = "de"
Config.Lang = {
	["en"] = {
		['flipped'] = 'You have flipped the vehicle!',
		['allset'] = 'Vehicle is already upright', 
		['in_vehicle'] = 'You can not flip the vehicle from inside!',
	},
	["de"] = {
		['flipped'] = 'Du hast das Fahrzeug umgekippt!',
		['allset'] = 'Das Fahrzeug steht bereits aufrecht.',
		['in_vehicle'] = 'Du kannst das Fahrzeug nicht von innen umkippen!',
	}
}

