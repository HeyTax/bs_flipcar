PlayerData = nil
PlayerJob = nil
PlayerGrade = nil

local VehicleData = nil

function prnt(msg) if Config.Debug then print(msg) end end

RegisterNetEvent('bs_flipcar:Notify', function(message, type)
	SetTextFont(fontId)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(message)
	DrawNotification(false, true)
end)

local flippedCar = nil

function isCarFlipped(vehicle)
    local roll = GetEntityRoll(vehicle)
    return roll > 75.0 or roll < -75.0
end

function displayText()
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 70)
	prnt("Displaying text")
    if DoesEntityExist(vehicle) and isCarFlipped(vehicle) and not IsPedRagdoll(playerPed) then
		prnt("Drawing 3D Text")
		DrawText3D(GetEntityCoords(vehicle).x, GetEntityCoords(vehicle).y, GetEntityCoords(vehicle).z + 1.0, "~w~Drücke ~g~E~w~ um das Auto zu flippen")
        flippedCar = vehicle
    else
		prnt("Flipped car nil")
        flippedCar = nil
    end
end

function flipCar()
	local ped = PlayerPedId()
    local pedcoords = GetEntityCoords(ped)
    if flippedCar ~= nil and not IsPedInAnyVehicle(PlayerPedId(), false) then
		local playerPed = GetPlayerPed(-1)
		
		VehicleData = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 70)
        prnt("Starting anim")
        RequestAnimDict('missfinale_c2ig_11')
        while not HasAnimDictLoaded("missfinale_c2ig_11") do
            Wait(10)
        end
        TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
		local timesa = Config.TimesTillFlip*1000
		if Config.CustomProgBar then
		prnt("Custom Progbar true")
		TriggerEvent("hud:taskBar", timesa, "Auto wird umgekippt")
		end
        Wait(timesa)
        local carCoords = GetEntityRotation(VehicleData, 2)
        SetEntityRotation(VehicleData, carCoords[1], 0, carCoords[3], 2, true)
        SetVehicleOnGroundProperly(VehicleData)
        TriggerEvent('bs_flipcar:Notify', Config.Lang[Config.Langes]['flipped'])
        ClearPedTasks(ped)
		prnt("Flipped car")
        flippedCar = nil
	elseif IsPedInAnyVehicle(PlayerPedId(), false) then
		prnt("Not in vehicle car")
		TriggerEvent('bs_flipcar:Notify', Config.Lang[Config.Langes]['in_vehicle'])
    end
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)

    AddTextComponentString(text)
    DrawText(_x, _y)
end

Citizen.CreateThread(function()
	local playerPed = GetPlayerPed(-1)
    while true do
        Citizen.Wait(0)
        displayText()

        if IsControlJustReleased(0, 38) and flippedCar ~= nil and not IsPedRagdoll(playerPed) then -- 'E' key
            flipCar()
        end
    end
end)

if Config.DebugCar then
	prnt("Replacing car rot")
	local playerPed = GetPlayerPed(-1)
	VehicleData = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 70)
	SetEntityRotation(VehicleData, GetEntityCoords(VehicleData).x - 90, 0, 0, 2, true)
end