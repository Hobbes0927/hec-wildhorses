Config = {}

Config.NotificationOn = true
Config.Notification = "Rare Wild Horse(s) Appeared Nearby"

Config.DiscordIntegration = false
Config.DiscordWebHook = ""
Config.DiscordBotName= "HEC Wildhorse"
Config.DiscordAvatar = ""

Config.Jobs = {}  -- Add jobs to job lock horse spawning Ex:  {'horsetrainer'}

Config.SpawnChance = 7 -- Valid entries (1 = 0.25%, 2 = 0.50%, 3 = 1%, 4 = 2%, 5 = 3%, 6 = 4%, 7 = 5%)
Config.RespawnDelay = 900000 --In milliseconds (60000 = 1 minute)
Config.RNGTimer = 5000 -- How often the RNG timer rolls for the player in milliseconds (5000 = 5 seconds)
Config.MaxHorses = 3 -- The maximum number of horses that can spawn when rolled.  No greater than 5 horses

Config.Spawns = {
    {
        breed = "Arabian",
        locations = {
            coords = vector3(-2162.6, -2078.67, 70.34),
            coords = vector3(-2653.41, -2137.45, 76.43),
        },
        horses = {
            `a_c_horse_arabian_black`,
            `a_c_horse_arabian_grey`,
            `A_C_Horse_Arabian_RedChestnut`,
            `A_C_Horse_Arabian_RedChestnut_PC`,
            `a_c_horse_arabian_rosegreybay`,
            `A_C_Horse_Arabian_WarpedBrindle_PC`,
            `a_c_horse_arabian_white`,
            `a_c_horse_gang_dutch`,
        }
    },
    {
        breed = "Mustang",
        locations = {
            coords = vector3(-5931.86, -3014.2, -1.99),
            coords = vector3(-5126.08, -2744.38, -8.08),
            coords = vector3(-4204.92, -2562.65, 8.44),
        },
        horses = {
            `A_C_Horse_Mustang_GoldenDun`,
			`A_C_Horse_Mustang_TigerStripedBay`,
			`a_c_horse_mustang_buckskin`,
			`a_c_horse_mustang_chestnuttovero`,
			`a_c_horse_mustang_reddunovero`,
			`a_c_horse_gang_lenny`,
			`a_c_horse_gang_sadie_endlesssummer`,
        }
    },
    {
        breed = "Turkoman",
        locations = {
            coords = vector3(921.51, 977.37, 130.61),
        },
        horses = {
            `A_C_Horse_Turkoman_DarkBay`,
			`A_C_Horse_Turkoman_Gold`,
			`A_C_Horse_Turkoman_Silver`,
			`a_c_horse_turkoman_chestnut`,
			`a_c_horse_turkoman_grey`,
			`a_c_horse_turkoman_perlino`,
			`a_c_horse_gang_sadie`,
        }
    },
}
    
