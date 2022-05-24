local debug_mode = false

local coalition_mode = true
local coalition_choice = 2 --neutral == 0, red == 1, blue == 2

Frosty_ShotEvent = {}
subtotal = 0
shooting_start = 0

local gun_rof = {
['M_230_new'] = 620 / 60,  -- / 60 to get rounds per second from minute
['M_134'] = 4800 / 60,
['GAU_8'] = 4200 / 60
}

local weaponcost = {
-- All pricing data is set for the current year (2022) where possible. Otherwise most up to date price data is used
-- All prices in USD $
-- LAST UPDATED 24 MAY 2022

-- A2A MISSILES --
['AIM_9'] = 178387,  -- AIM-9M
['AIM-9X'] = 460807,
['AIM-120B'] = 1273809, -- PRICED ASSUMED TO BE SAME AS 120C
['AIM-120C'] = 1273809,

-- A2G MISSILES --
['AGM_114K'] = 109628,

-- BLUFOR BOMBS --
['CBU_87'] = 26110,
['CBU_97'] = 459815,
['CBU_103'] = 39074,
['CBU_105'] = 481040,
['Mk_82'] = 27848,  -- NEEDS CHECKING
['MK_82AIR'] = 27848, -- INFORMATION NEEDED
['Mk_83'] = 4495,
['Mk_84'] = 7540,
['GBU_38'] = CostOfMk_82 + 40532,  -- 40532 is value of JDAM kit
['GBU_31'] = CostOfMk_84 + 40532,
['GBU_31_V_3B'] = 12 + CostOfMk_84 + 40532,  -- $12 is cost of BLU-109
['GBU_12'] = 16856,
['GBU_10'] = 41203,

-- REDFOR BOMBS --

-- GUN -- 
['M_230_new'] = 139,
['M_134'] = 1,
['GAU_8'] = 137,
['M_61'] = 27,

-- BLUFOR ROCKETS --
['HYDRA_70_M151'] = 1800,
['HYDRA_70_M229'] = 2500,
['HYDRA_70_M257'] = 2300,
['HYDRA_70_M274'] = 2550,
['HYDRA_70_M282'] = 2900,
['HYDRA_70_MK5'] = 1000

-- REDFOR ROCKETS --
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