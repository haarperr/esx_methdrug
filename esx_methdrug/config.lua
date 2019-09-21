--BY BNJ-- 𝑯𝒐𝒎𝒎𝒆-𝒆𝒇𝒇𝒊𝒄𝒂𝒔𝒆
Config								= {}
Config.Locale 				= 'fr'
Config.DrawDistance		= 10.0

Config.DistanceHarvesting	= 500
Config.PoliceNeeded				= 0
Config.PayeType = 3 -- [1 = Cash , 2 = Banque , 3 = Argent Sale]

Config.Zones = {

  Recolte = {
		Pos   = {x=-288.96426, 	 y=6299.6616,  z=31.4922},		
		Size  = {x = 8.0, y = 8.0, z = 0.6},
		Color = {r = 204, g = 204, b = 0},
		Type  = -1
	},

  Vente = {
		Pos   = {x=-1661.64, y=-3192.178, z=13.944},
		Size  = {x = 3.5, y = 3.5, z = 0.6},
		Color = {r = 204, g = 204, b = 0},
		Type  = -1
	}

}

Config.Uniforms = {
    
  GADGET_HAZMAT1 = {
    male = {
			['tshirt_1'] 	= 62, ['tshirt_2'] 	= 3,
			['torso_1'] 	= 67, ['torso_2'] 	= 3,
			['decals_1'] 	= 0,  ['decals_2'] 	= 0,
			['mask_1'] 		= 46, ['mask_2'] 	= 0,
			['arms'] 		= 86,
			['pants_1'] 	= 40, ['pants_2'] 	= 3,
			['shoes_1'] 	= 25, ['shoes_2'] 	= 0,
			['helmet_1'] 	= -1, ['helmet_2'] 	= 0,
			['chain_1'] = -1,    ['chain_2'] = 0,
      ['ears_1'] = -1,     ['ears_2'] = 0,
			['bags_1']		= 44, ['bags_2']	= 0,
			['bproof_1'] 	= 0,  ['bproof_2'] 	= 0
    },
    female = {
			['tshirt_1'] 	= 43, ['tshirt_2'] 	= 3,
			['torso_1'] 	= 61, ['torso_2'] 	= 3,
			['decals_1'] 	= 0,  ['decals_2'] 	= 0,
			['mask_1'] 		= 46, ['mask_2'] 	= 0,
			['arms'] 		= 101,
			['pants_1'] 	= 40, ['pants_2'] 	= 3,
			['shoes_1'] 	= 25, ['shoes_2'] 	= 0,
			['helmet_1'] 	= -1, ['helmet_2'] 	= 0,
			['chain_1'] = -1,    ['chain_2'] = 0,
      ['ears_1'] = -1,     ['ears_2'] = 0,
			['bags_1']		= 44, ['bags_2']	= 0,
			['bproof_1'] 	= 0,  ['bproof_2'] 	= 0
    }
  }

}