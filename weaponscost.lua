local debug_mode = false

local coalition_mode = true
local coalition_choice = 2 --neutral == 0, red == 1, blue == 2

Frosty_ShotEvent = {}
subtotal = 0
shooting_start = 0

local gun_rof = {
['BrowningM2'] = 798 / 60, -- some aircraft have multiple guns tho...
['M_230_new'] = 620 / 60,  -- / 60 to get rounds per second from minute
['M_134'] = 4800 / 60,
['M_61'] = 6000 / 60,
['M-61A1'] = 6000 / 60, -- F-14's gun
['GAU_8'] = 4200 / 60,
['GSh_30_1'] = 1500 / 60, -- Su-27 gun
['GSh_30_2'] = 2460 / 60, -- Su-25T gun
--------------------------------------------
['GUN_END'] = 1  -- DO NOT TOUCH THIS LINE
--------------------------------------------
}

local weaponcost = {
-- WW2 weapons are not included
-- All pricing data is adjusted for inflation to current year (2022) where possible. Otherwise most up to date price data is used
-- All prices in USD $
-- LAST UPDATED 25 MAY 2022

-- ALL GUNS -- 
['BrowningM2'] = 3.30 -- 24 MAY 2022
['M_230_new'] = 139, -- 24 MAY 2022
['M_134'] = 1, -- 24 MAY 2022
['M_61'] = 27, -- 24 MAY 2022
['M-61A1'] = 27, -- 24 MAY 2022
['GAU_8'] = 137, -- 24 MAY 2022
['GSh_30_1'] = 50, -- UNKNOWN
['GSh_30_2'] = 50, -- UNKNOWN

-- CRUISE MISSILES -- 
['BGM_109B'] = 1, -- TBA (TOMAHAWK)
['HY-2'] = 1, -- TBA Silkwork missile
['KD-20'] = 1, -- TBA Chinese cruise missile
['KD-63'] = 1, -- TBA Chinese LACM
['KD-63B'] = 1,-- TBA Improved Chinese LACM
['SCUD_RAKETA'] = 1, -- TBA

-- ATGM --
['KONKURS'] = 1, -- TBA
['MALUTKA'] = 1, -- TBA
['P_9M117'] = 1, -- TBA Bastion ATGM
['P_9M133'] = 1, -- TBA Kornet ATGM
['REFLEX'] = 1, -- TBA 9M119 Svir AT-11
['SVIR'] = 1, -- TBA
['TOW'] = 1, -- TBA
['TOW2'] = 1, -- TBA


----------------------------------------------
--------------- BLUFOR SECTION ---------------
----------------------------------------------

-- BLUFOR A2A MISSILES --
['AIM-7E'] = 1, -- TBA
['AIM-7F'] = 1, -- TBA
['AIM-7MH'] = 608301, -- TBA
['AIM-9J'] = 1, -- TBA
['AIM-9JULI'] = 1, -- TBA
['AIM-9L'] = 1, -- TBA
['AIM-9P'] = 1, -- TBA
['AIM-9P5'] = 1, -- TBA
['AIM-120'] = 1273809, -- 24 MAY 2022 PRICED ASSUMED TO BE SAME AS 120C
['AIM-120B'] = 1273809, -- 24 MAY 2022 PRICED ASSUMED TO BE SAME AS 120C
['AIM-120C'] = 1273809, -- 24 MAY 2022
['AIM_54'] = 1, -- TBA
['AIM_54A_Mk47'] = 1, -- TBA
['AIM_54A_Mk60'] = 1, -- TBA
['AIM_54C_Mk47'] = 1, -- TBA
['AIM_7'] = 1, -- TBA
['AIM_9'] = 156157,  -- 24 MAY 2022 AIM-9M
['AIM-9X'] = 460807, -- 24 MAY 2022
['CATM_9M'] = 1, -- TBA
['GAR-8'] = 1, -- TBA 1st Gen Sidewinder
['Matra Super 530D'] = 1, -- TBA
['MBDA_Mistral'] = 1, -- TBA
['MICA_R'] = 1, -- TBA
['MICA_T'] = 1, -- TBA
['MMagicII'] = 1, -- TBA
['R550_M1'] = 1, -- TBA Magic missile
['R_530F_EM'] = 1, -- TBA
['R_530F_IR'] = 1, -- TBA
['R_550'] = 1, -- TBA Matra
['Super_530D'] = 1, -- TBA

-- BLUFOR A2G MISSILES --
['AGM_114K'] = 109628, -- 24 MAY 2022
['AGM_62'] = 1,  -- TBA
['ADM_141A'] = 1, -- TBA
['ADM_141B'] = 1, -- TBA
['AGM_114'] = 1, -- TBA
['AGM_114K'] = 1, -- TBA
['AGM_119'] = 1, -- TBA
['AGM_122'] = 1, -- TBA
['AGM_130'] = 1, -- TBA
['AGM_154'] = 1, -- TBA
['AGM_154A'] = 1, -- TBA
['AGM_154B'] = 1, -- TBA
['AGM_45'] = 1, -- TBA
['AGM_45A'] = 1, -- TBA
['AGM_65A'] = 1, -- TBA
['AGM_65B'] = 1, -- TBA
['AGM_65D'] = 1, -- TBA
['AGM_65E'] = 1, -- TBA
['AGM_65F'] = 1, -- TBA
['AGM_65G'] = 1, -- TBA
['AGM_65H'] = 1, -- TBA
['AGM_65K'] = 1, -- TBA
['AGM_65L'] = 1, -- TBA
['AGM_84A'] = 1, -- TBA
['AGM_84D'] = 1, -- TBA
['AGM_84E'] = 1, -- TBA
['AGM_84H'] = 1, -- TBA
['AGM_84S'] = 1, -- TBA
['AGM_86'] = 1, -- TBA
['AGM_86C'] = 1, -- TBA
['AGM_88'] = 1, -- TBA
['AGR_20A'] = 1, -- TBA (APKWS)
['AGR_20_M282'] = 1, -- TBA (APKWS)
['ALARM'] = 1, -- TBA
['BK90_MJ1'] = 1, -- TBA (BK-90 Anti-Personnel)
['BK90_MJ1_MJ2'] = 1, -- TBA
['BK90_MJ2'] = 1, -- TBA (BK-90 Anti-Armor)
['CATM_65K'] = 1, -- TBA
['DWS39_MJ1'] = 1, -- TBA (BK-90 Anti-Personnel)
['DWS39_MJ1_MJ2'] = 1, -- TBA (BK-90 mixed)
['DWS39_MJ2'] = 1, -- TBA (BK-90 Anti-Armor)
['HOT2'] = 1, -- TBA
['HOT3'] = 1, -- TBA
['Kormoran'] = 1, -- TBA AS.34 Kormoran
['Rb 04E (for A'] = 1, -- TBA
['Rb 04E'] = 1, -- TBA
['Rb 05A'] = 1, -- TBA
['Rb 15F (for A'] = 1, -- TBA
['Rb 15F'] = 1, -- TBA
['Rb 24'] = 1, -- TBA
['Rb 24J'] = 1, -- TBA
['Rb 74'] = 1, -- TBA
['RB75'] = 1, -- TBA
['RB75B'] = 1, -- TBA
['RB75T'] = 1, -- TBA
['TGM_65D'] = 1, -- TBA
['TGM_65G'] = 1, -- TBA
['TGM_65H'] = 1, -- TBA

-- BLUFOR SAMS --
['FIM_92C'] = 1, -- TBA STINGER
['HAWK_RAKETA'] = 1, -- TBA Hawk missile
['MIM_104'] = 1, -- TBA PATRIOT MISSILE
['MIM_72G'] = 1, -- TBA Chaparral missile
['Mistral'] = 1, -- TBA
['Rapier'] = 1, -- TBA
['RIM_116A'] = 1, -- TBA
['ROLAND_R'] = 1, -- TBA
['SeaSparrow'] = 1, -- TBA
['Sea_Cat'] = 1, -- TBA
['Sea_Dart'] = 1, -- TBA
['Sea_Eagle'] = 1, -- TBA
['SM_2'] = 1, -- TBA

-- BLUFOR BOMBS --
['BAP-100'] = 1,  -- TBA (MIRAGE 2000, PLAYER VERSION)
['BAP_100'] = 1,  -- TBA (MIRAGE 2000, AI VERSION)
['BAT-120'] = 1,  -- TBA (MIRAGE 2000 BAP-100 DEVELOPMENT)
['BDU_33'] = 1,  -- TBA
['BDU_45'] = 1,  -- TBA
['BDU_45B'] = 1,  -- TBA
['BDU_45LGB'] = 1,  -- TBA
['BDU_50HD'] = 1,  -- TBA
['BDU_50LD'] = 1,  -- TBA
['BDU_50LGB'] = 1,  -- TBA
['BELOUGA'] = 1,  -- TBA (USED ON C-101)
['BIN_200'] = 1,  -- TBA (200kg Napalm Incendiary Bomb USED ON C-101)
['BLG66'] = 1,  -- TBA
['BLG66_BELOUGA'] = 1,  -- TBA
['BL_755'] = 39985,  -- 25 MAY 2022
['BR_250'] = 1,  -- TBA (USED ON C-101)
['BR_500'] = 1,  -- TBA (USED ON C-101)
['CBU_52B'] = 1,  -- TBA
['CBU_87'] = 26110,
['CBU_97'] = 459815,
['CBU_99'] = 1,  -- TBA
['CBU_103'] = 39074,
['CBU_105'] = 481040,
['Durandal'] = 1,  -- TBA (BLU-107/B DURANDAL)
['LUU_19'] = 1,  -- TBA
['LUU_2AB'] = 1,  -- TBA
['LUU_2B'] = 1,  -- TBA
['LUU_2BB'] = 1,  -- TBA
['MK76'] = 1, -- TBA (BDU-33 PRACTICE BOMB)
['Mk_81'] = 1,  -- TBA
['Mk_82'] = 1,  -- TBA
['MK_82AIR'] = 1, -- TBA
['MK_82SNAKEYE'] = 1,  -- TBA
['Mk_82Y'] = 1,  -- TBA
['Mk_83'] = 4495,
['Mk_83CT'] = 1,  -- TBA (BSU-85 TAIL, BALLUTE HI-DRAG)
['Mk_84'] = 7540,
['MK106'] = 1, -- TBA (MK82SE PRACTICE BOMB)
['M_117'] = 1, -- TBA
['GBU_12'] = 16856,
['GBU_10'] = 41203,
['GBU_11'] = 1,  -- TBA
['GBU_12'] = 1,  -- TBA
['GBU_16'] = 1,  -- TBA
['GBU_17'] = 1,  -- TBA
['GBU_24'] = 1,  -- TBA
['GBU_27'] = 1,  -- TBA
['GBU_28'] = 1,  -- TBA
['GBU_29'] = 1,  -- TBA
['GBU_30'] =  1,  -- TBA
--['GBU_31'] = CostOfMk_84 + 40532,
['GBU_31_V_2B'] = 1,  -- TBA
--['GBU_31_V_3B'] = 12 + CostOfMk_84 + 40532,  -- $12 is cost of BLU-109
['GBU_31_V_4B'] = 1,  -- TBA
['GBU_32_V_2B'] = 1,  -- TBA
--['GBU_38'] = CostOfMk_82 + 40532,  -- 40532 is value of JDAM kit
['GBU_54_V_1B'] = 1,  -- TBA
['HEBOMB'] = 1,-- TBA (AJS-37 M/71 HE-Bomb)
['HEBOMBD'] = 1,-- TBA (AJS-37 M/71 HE-Bomb w chute)
['LYSBOMB'] = 1,  -- TBA (AJS-37 VIGGEN THING)
['LYSBOMB_CANDLE'] = 1,  -- TBA (AJS-37 VIGGEN THING)
['ROCKEYE'] = 1,  -- TBA
['SAMP125LD'] = 1,  -- TBA
['SAMP250HD'] = 1,  -- TBA
['SAMP250LD'] = 1,  -- TBA
['SAMP400HD'] = 1,  -- TBA
['SAMP400LD'] = 1,  -- TBA

-- BLUFOR ROCKETS --
['HYDRA_70_M151'] = 1800,
['HYDRA_70_M229'] = 2500,
['HYDRA_70_M257'] = 2300,
['HYDRA_70_M274'] = 2550,
['HYDRA_70_M282'] = 2900,
['HYDRA_70_MK5'] = 1000,

----------------------------------------------
--------------- REDFOR SECTION ---------------
----------------------------------------------

-- REDFOR A2A MISSILES --
['PL-12'] = 1, -- TBA
['PL-5EII'] = 1, -- TBA
['PL-8A'] = 1, -- TBA
['PL-8B'] = 1, -- TBA
['P_24R'] = 1, -- TBA
['P_24T'] = 1, -- TBA
['P_27P'] = 1, -- TBA
['P_27PE'] = 1, -- TBA
['P_27T'] = 1, -- TBA
['P_27TE'] = 1, -- TBA
['P_33E'] = 1, -- TBA
['P_40R'] = 1, -- TBA
['P_40T'] = 1, -- TBA
['P_500'] = 1, -- TBA
['P_60'] = 1, -- TBA
['P_700'] = 1, -- TBA
['P_73'] = 1, -- TBA
['P_77'] = 1, -- TBA
['R-13M'] = 1, -- TBA
['R-13M1'] = 1, -- TBA
['R-3R'] = 1, -- TBA
['R-3S'] = 1, -- TBA
['R-55'] = 1, -- TBA
['R-60'] = 1, -- TBA
['RS2US'] = 1, -- TBA K-5 missile
['SD-10'] = 1, -- TBA PL-12 CHINESE AMRAAM

-- REDFOR A2G MISSILES --
['AKD-10'] = 1, -- TBA (HJ-10 CHINESE)
['Ataka_9M120'] = 1, -- TBA
['Ataka_9M120F'] = 1, -- TBA
['Ataka_9M220'] = 1, -- TBA
['AT_6'] = 1, -- TBA
['C-701IR'] = 1, -- TBA (CHINESE YJ-7 AShM)
['C-701T'] = 1, -- TBA (CHINESE YJ-7 AShM)
['C-802AK'] = 1, -- TBA (AIR LAUNCHED YJ-83 AShM)
['C_802AK'] = 1, -- TBA (CHINESE AIR LAUNCHED ANTI SHIP MISSILE)
['CM-802AKG'] = 1, -- TBA (CHINESE AIR LAUNCHED STANDOFF WEAPON)
['CM_802AKG'] = 1, -- TBA (CHINESE AIR LAUNCHED STANDOFF WEAPON)
['GB-6-HE'] = 1, -- TBA CHINESE GLIDE BOMB
['GB-6-SFW'] = 1, -- TBA CHINESE GLIDE BOMB
['GB-6'] = 1, -- TBA CHINESE GLIDE BOMB
['Kh-66_Grom'] = 1, -- TBA
['Kh25MP_PRGS1VP'] = 1, -- TBA
['LD-10'] = 1, -- TBA Chinese SEAD missile
['LS-6-500'] = 1, -- TBA Chinese glide bomb
['Vikhr'] = 1, -- TBA
['Vikhr_M'] = 1, -- TBA
['X_22'] = 1, -- TBA Kh-22 AS-4 Kitchen
['X_25ML'] = 1, -- TBA Kh-25ML
['X_25MP'] = 1, -- TBA Kh-25MP
['X_25MR'] = 1, -- TBA Kh-25MR
['X_28'] = 1, -- TBA Kh-28
['X_29L'] = 1, -- TBA Kh-29L
['X_29T'] = 1, -- TBA Kh-29T
['X_29TE'] = 1, -- TBA Kh-29TE
['X_31A'] = 1, -- TBA Kh-31A
['X_31P'] = 1, -- TBA Kh-31P
['X_35'] = 1, -- TBA Kh-35
['X_41'] = 1, -- TBA Kh-41
['X_58'] = 1, -- TBA Kh-58
['X_59M'] = 1, -- TBA Kh-59M
['X_65'] = 1, -- TBA Kh-65


-- REDFOR SAMs --
['9M317'] = 1, -- TBA (BUK MISSILE)
['HHQ-9'] = 1, -- TBA Chinese naval SAM version of HQ-9
['HQ-16'] = 1, -- TBA
['HQ-7'] = 1, -- TBA
['Igla_1E'] = 1, -- TBA SA-16
['SA2V755'] = 1, -- TBA
['SA3M9M'] = 1, -- TBA
['SA48H6E2'] = 1, -- TBA
['SA5B27'] = 1, -- TBA
['SA5B55'] = 1, -- TBA
['SA5V28'] = 1, -- TBA
['SA9M31'] = 1, -- TBA
['SA9M311'] = 1, -- TBA
['SA9M33'] = 1, -- TBA
['SA9M330'] = 1, -- TBA
['SA9M333'] = 1, -- TBA
['SA9M38M1'] = 1, -- TBA

-- REDFOR STATIC ANTI-SHIP --
['YJ-12'] = 1, -- TBA Chinese Anti-Ship Cruise missile 
['YJ-62'] = 1, -- TBA Chinese Anti-Ship Cruise missile 
['YJ-83'] = 1, -- TBA Chinese Anti-Ship Cruise missile 
['YJ-83K'] = 1, -- TBA Chinese Anti-Ship Cruise missile 
['YJ-84'] = 1, -- TBA  Chinese Anti-Ship Cruise missile [UNSURE]

-- REDFOR BOMBS --
['250-2'] = 1,  -- TBA (CHINESE 250KG HD)
['250-3'] = 1,  -- TBA (CHINESE 250KG LD)
['AO_2_5RT'] = 1,  -- TBA (BOMBLET FOR RBK-500 CLUSTER BOMB)
['BETAB-500M'] = 1, -- TBA
['BETAB-500S'] = 1, -- TBA
['BetAB_500'] = 1, -- TBA
['BetAB_500ShP'] = 1, -- TBA
['BKF_AO2_5RT'] = 1, -- TBA
['BKF_PTAB2_5KO'] = 1, -- TBA
['FAB-250-M62'] = 1, -- TBA
['FAB-250M54'] = 1, -- TBA 
['FAB-250M54TU'] = 1, -- TBA
['FAB-500M54'] = 1, -- TBA
['FAB-500M54TU'] = 1, -- TBA
['FAB-500SL'] = 1, -- TBA
['FAB-500TA'] = 1, -- TBA
['FAB_100'] = 1, -- TBA
['FAB_100M'] = 1, -- TBA
['FAB_100SV'] = 1, -- TBA
['FAB_1500'] = 1, -- TBA
['FAB_250'] = 1, -- TBA
['FAB_50'] = 1, -- TBA
['FAB_500'] = 1, -- TBA
['IAB-500'] = 1, -- TBA (MiG-21 IAB-500 - 470 kg)
['KAB_1500Kr'] = 1, -- TBA
['KAB_1500LG'] = 1, -- TBA
['KAB_1500T'] = 1, -- TBA
['KAB_500'] = 1, -- TBA
['KAB_500Kr'] = 1, -- TBA
['KAB_500KrOD'] = 1, -- TBA
['KAB_500S'] = 1, -- TBA
['ODAB-500PM'] = 1, -- TBA
['OFAB-100 Jupiter'] = 1, -- TBA
['OFAB-100-120TU'] = 1, -- TBA
['P-50T'] = 1, -- TBA (PRACTICE BOMB FOR L-39)
['PTAB_2_5KO'] = 1, -- TBA
['RBK_250'] = 1, -- TBA
['RBK_250S'] = 1, -- TBA
['RBK_250_275_AO_1SCH'] = 1, -- TBA
['RBK_500AO'] = 1, -- TBA
['RBK_500SOAB'] = 1, -- TBA
['RBK_500U'] = 1, -- TBA
['RBK_500U_BETAB_M'] = 1, -- TBA
['RBK_500U_OAB_2_5RT'] = 1, -- TBA
['RN-24'] = 1, -- TBA
['RN-28'] = 1, -- TBA
['SAB_100'] = 1, -- TBA (RUSSIAN CLUSTER BOMB USED ON MiG-27 AND SU-7)
['TYPE-200A'] = 1, -- TBA (CHINESE BOMB)

-- REDFOR ROCKETS --
['BRM-1_90MM'] = 1, -- TBA (JF-17 ROCKETS)
['C_5'] = 1, -- TBA
['C_13'] = 1, -- TBA
['C_24'] = 1, -- TBA
['C_80FP2'] = 1, -- TBA
['S_25L'] = 1, -- TBA
['S_25-O'] = 1, -- TBA

----------------------------------------------
['WEAPONS_END'] = 1  -- DO NOT TOUCH THIS LINE
----------------------------------------------
}

--local aircraftcost = {
-- BLUFOR JETS --
--['FA-18C_hornet'] = 29000000,
--['F-16C_50'] = 28271509,
--['F-14A'] = 999,
--['F-14B'] = 999,
--['F-14D'] = 999,
--['F-15E'] = 55161288,

-- BLUFOR HELICOPTERS --
--['AH-64D_BLK_II'] = 23213333
--}

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
---------------------------------------- ADVANCED CODE BELOW DO NOT TOUCH ----------------------------------------
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

function fprint(...)
	local args = {...}
	for k,thing in pairs(args) do
		trigger.action.outText(tostring(thing), 10)
	end
end

function db_fprint(...)
	if debug_mode == true then
		fprint(...)
	end
end

function Process_Event(event)
	if event.id == 1 then
		db_fprint("Weapon Name: " .. event.weapon:getTypeName())
		db_fprint("Initiator Coalition: " .. event.initiator:getCoalition())
		if weaponcost[event.weapon:getTypeName()] ~= nil then
			subtotal = subtotal + weaponcost[event.weapon:getTypeName()]
		else
			fprint("Weapon Cost Not Found: " .. event.weapon:getTypeName())
		end
	end
	if event.id == 23 then
		shooting_start = event.time
		db_fprint("shooting_start: " .. shooting_start)
		db_fprint("Weapon Name: " .. event.weapon_name)
	end
	if event.id == 24 then
		local time_taken = event.time - shooting_start
		db_fprint("Shooting Duration: " .. time_taken)
		if gun_rof[event.weapon_name] ~= nil then
			local rounds_fired = math.modf(time_taken * gun_rof[event.weapon_name])
			db_fprint("Rounds Fired: " .. rounds_fired)
			if weaponcost[event.weapon_name] ~= nil then
				subtotal = subtotal + (weaponcost[event.weapon_name] * rounds_fired)
			else
				fprint("Weapon Cost Not Found: " .. event.weapon_name)
			end
		else
			fprint("Weapon RoF Not Found: " .. event.weapon_name)
		end
	end
end

function Frosty_ShotEvent:onEvent(event)
	if event.id == 1 or event.id == 23 or event.id == 24 then
		if coalition_mode == true then
			if event.initiator:getCoalition() == coalition_choice then
				Process_Event(event)
			end
		else
			Process_Event(event)
		end
	end
end

world.addEventHandler(Frosty_ShotEvent)

function outtoscreen()
	fprint("Total: $" .. subtotal .. ' Dollarinos')
	timer.scheduleFunction(outtoscreen, {}, timer.getTime() + 11)
end

outtoscreen()