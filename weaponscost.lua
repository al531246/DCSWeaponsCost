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
-- MISSILES --
['AGM_114K'] = 45449,
['AIM_9'] = 178387,

-- BOMBS --
['CBU_87'] = 26110,
['CBU_97'] = 459815,
['CBU_103'] = 39074,
['CBU_105'] = 481040,
['Mk_82'] = 933,
['MK_82AIR'] = 1300, --unknown price
['Mk_84'] = 3504,
['GBU_38'] = 28853,
['GBU_31'] = 39000,
['GBU_31_V_3B'] = 42000,
['GBU_12'] = 16856,
['GBU_10'] = 41203,

-- GUN -- 
['M_230_new'] = 105,
['M_134'] = 4,
['GAU_8'] = 137,

-- ROCKETS --
['HYDRA_70_M151'] = 1800,
['HYDRA_70_M229'] = 2500,
['HYDRA_70_M257'] = 2300,
['HYDRA_70_M274'] = 2550,
['HYDRA_70_M282'] = 2900,
['HYDRA_70_MK5'] = 1000
}

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
	if coalition_mode == true then
		if event.initiator:getCoalition() == coalition_choice then
			Process_Event(event)
		end
	else
		Process_Event(event)
	end
end

world.addEventHandler(Frosty_ShotEvent)

function outtoscreen()
	fprint("Total: $" .. subtotal .. ' Dollarinos')
	timer.scheduleFunction(outtoscreen, {}, timer.getTime() + 11)
end

outtoscreen()
