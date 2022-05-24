Frosty_ShotEvent = {}
local subtotal = 0

local weaponcost = {
-- MISSILES --
['AGM_114K'] = 10000,

-- GUN -- 
['M230'] = 100

-- ROCKETS --
}

function fprint(...)
	local args = {...}
	for k,thing in pairs(args) do
		trigger.action.outText(tostring(thing), 10)
	end
end

function Frosty_ShotEvent:onEvent(event)
	if event.id == 1 then
		--subtotal = subtotal + weaponcost[event.weapon]
		fprint(event.weapon:getTypeName())
		fprint(event.initiator:getCoalition())
	end
end

world.addEventHandler(Frosty_ShotEvent)

function outtoscreen()
	fprint(subtotal .. 'Dollarinos')
	timer.scheduleFunction(outotscreen, timer.getTime() + 11)
end