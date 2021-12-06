--[[ 
	QB-AnchorBoat
 ]]

local anchored = false
local boat = nil
Citizen.CreateThread(function()
	while true do

		Wait(0)
		local ped = GetPlayerPed(-1)
		if IsControlJustReleased(0, 47) and not IsPedInAnyVehicle(ped) then
			local posPed = GetEntityCoords(ped)
			boat = GetClosestVehicle(posPed[1], posPed[2], posPed[3], 10.000, 0, 12294)
			if DoesEntityExist(boat) then
				if IsThisModelABoat(GetEntityModel(boat)) and IsEntityInWater(boat) then	--- Player is on top of a boat that is in water
					if not anchored then
						TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
						QBCore.Functions.Progressbar("anchor_boat", "Anchoring Boat", 10000, false, true, {
							disableMovement = false,
							disableCarMovement = false,
							disableMouse = false,
							disableCombat = false,
						}, {}, {}, {}, function() -- Done
							SetBoatAnchor(boat, true)
							anchored = not anchored
							QBCore.Functions.Notify("Boat anchored!", "success")
						end, function()
							QBCore.Functions.Notify("Failed!", "error")
						end)
						ClearPedTasks(ped)
					else
						TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
						QBCore.Functions.Progressbar("anchor_boat", "Unanchoring Boat", 10000, false, true, {
							disableMovement = false,
							disableCarMovement = false,
							disableMouse = false,
							disableCombat = false,
						}, {}, {}, {}, function() -- Done
							SetBoatAnchor(boat, false)
							anchored = not anchored
							QBCore.Functions.Notify("Boat not anchored anymore", "success")
						end, function()
							QBCore.Functions.Notify("Failed!", "error")
						end)
						ClearPedTasks(ped)
					end
						
				end
			end
		end
		if IsVehicleEngineOn(boat) then
			if anchored then
				anchored = false
				QBCore.Functions.Notify("Boat not anchored anymore", "success")
			end
		end
	end
end)
