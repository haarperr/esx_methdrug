--BY BNJ-- Deldu et 𝑯𝒐𝒎𝒎𝒆-𝒆𝒇𝒇𝒊𝒄𝒂𝒔𝒆
local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                             = nil
local PlayerData                = {}
local GUI                       = {}
GUI.Time                        = 0
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local run                       = 0

-- Meth
local methQTE										= 200
local myPed                     = GetPlayerPed(-1)
local myPos                     = GetEntityCoords(myPed)
local currentVehicle            = 0
local isGoodVehicle             = false
local currentCharge             = 0
local goodVehicle               = GetHashKey('journey')
local lastVehicle               = 0
local lastDommageVehicle        = 0
local TraitementOn	            = false
local TenueUse									= false

DecorRegister('illegal_chargeMeth', 3)


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

-- Verifie si le joueurs est dans un vehicule ou pas
function IsInVehicle()
		local ply = GetPlayerPed(-1)
		if IsPedSittingInAnyVehicle(ply) then
				return true
		else
				return false
		end
end

function recolte(currentVehicle, isGoodVehicle)
	if (PlayerData.job.name == 'police') then
		ESX.ShowNotification(_U('police_methylamine'))
	else
		if currentVehicle == 0 then
			ESX.ShowNotification(_U('need_vehicle'))
			return
		end
		if isGoodVehicle == false then
			ESX.ShowNotification(_U('bad_vehicle'))
		else
			if currentCharge >= 10000 then
				currentCharge = 10000
				ESX.ShowNotification(_U('full_vehicle'))
				Citizen.Wait(1000)
				ESX.ShowNotification(_U('full_vehicle_2'))
				Citizen.Wait(10000)
				ESX.ShowNotification(_U('full_vehicle_3'))
			else
				currentCharge = math.min(10000, currentCharge + 10)
				DecorSetInt(currentVehicle,'illegal_chargeMeth', currentCharge)
				ESX.ShowNotification(_U('filling_vehicle'))
				Citizen.Wait(100)
			end
		end
	end
end

function traitement(vehicle)
	if (PlayerData.job.name == 'police') then
		ESX.ShowNotification(_U('police_methylamine'))
	else
		local dist = GetDistanceBetweenCoords(myPos.x, myPos.y, myPos.z, Config.Zones.Recolte.Pos.x, Config.Zones.Recolte.Pos.y, Config.Zones.Recolte.Pos.z, false)
		if dist < Config.DistanceHarvesting then
			ESX.ShowNotification(_U('too_close'))
		else
			if currentCharge > 10000 then
				currentCharge = 10000
			elseif currentCharge >= 500 then
				currentCharge = DecorGetInt(vehicle,'illegal_chargeMeth')
				currentCharge = math.max(0, currentCharge - 500)
      	ESX.ShowNotification(_U('transform_meth'))
				DecorSetInt(vehicle,'illegal_chargeMeth', currentCharge)
				local myPed = GetPlayerPed(-1)
				local vehicleEntity = GetVehiclePedIsIn(myPed, false)
				local vehicleCoords = GetEntityCoords(vehicleEntity)
				TriggerServerEvent('esx_methdrug:smokeToServer', vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)
				Citizen.Wait(10000)
      	TriggerServerEvent('esx_methdrug:traitement')
	  		if TenueUse == false then
	   			ESX.ShowNotification(_U('need_clothes'))
	   			ApplyDamageToPed(myPed, 60, false)
				end
				return
			else
				ESX.ShowNotification(_U('empty_vehicle'))
				currentCharge = 0
			end
		end
	end
end

-- Quand le joueur entre dans la zone recolte
function checkPoint(currentVehicle, isGoodVehicle)
	local dist = GetDistanceBetweenCoords(myPos.x, myPos.y, myPos.z, Config.Zones.Recolte.Pos.x, Config.Zones.Recolte.Pos.y, Config.Zones.Recolte.Pos.z, false)
	if dist < Config.Zones.Recolte.Size.x then
		recolte(currentVehicle, isGoodVehicle)
		return
	end
	if isGoodVehicle then
		if IsControlJustReleased(1, Keys["K"]) and GetLastInputMethod(2) and not TraitementOn then
			TraitementOn = true
		end
		local myPed = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(myPed, false)
		local speed = GetEntitySpeed(vehicle)
		if speed == 0 then
			if TraitementOn == true then
				if currentCharge > 0 then
					traitement(currentVehicle)
					return
				end
			end
		else
			TraitementOn = false
		end
	end
end


function showChargement()
	--DrawRect(0.065, 0.04, 0.106, 0.033, 0,0,0,225)
	local currentChargeShowed = currentCharge / 100

	SetTextFont(6)
	SetTextScale(0.0,0.5)
	SetTextCentre(false)
	SetTextDropShadow(0, 0, 0, 0, 0)
	SetTextEdge(0, 0, 0, 0, 0)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	if currentChargeShowed < 25 then
		AddTextComponentString(_U('loading_text_25', currentChargeShowed) .. ' %')
	elseif currentChargeShowed > 75 then
		AddTextComponentString(_U('loading_text_75', currentChargeShowed) .. ' %')
	else
		AddTextComponentString(_U('loading_text_50', currentChargeShowed) .. ' %')
	end
	DrawText(0.020, 0.04 - 0.017)
end

function CheckDommageVehicle(vehicle)
	local cDmg = GetEntityHealth(vehicle)
	local deltaDmg =  lastDommageVehicle - cDmg
	if deltaDmg ~= 0 then
			currentCharge = math.max(currentCharge - deltaDmg * 100, 0)
			DecorSetInt(vehicle, 'illegal_chargeMeth', currentCharge)
			if currentCharge == 0 then
					ESX.ShowNotification(_U('substance_loss'))
			end
	end
	lastDommageVehicle = cDmg
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		myPed = GetPlayerPed(-1)
		myPos = GetEntityCoords(myPed)
		currentVehicle = GetVehiclePedIsIn(myPed, false)
		if currentVehicle ~= 0 then
			isGoodVehicle = IsVehicleModel(currentVehicle, goodVehicle)
		else
			isGoodVehicle = false
		end
		checkPoint(currentVehicle, isGoodVehicle)
		if isGoodVehicle then
			if lastVehicle == 0 then
				currentCharge = DecorGetInt(currentVehicle, 'illegal_chargeMeth')
				lastVehicle = currentVehicle
				lastDommageVehicle = GetEntityHealth(currentVehicle)
			end
			if currentCharge ~= 0 then
				CheckDommageVehicle(currentVehicle)
			end
		elseif lastVehicle ~= 0 then
			DecorSetInt(lastVehicle, 'illegal_chargeMeth', currentCharge)
			currentCharge = 0 
			lastVehicle = 0
			lastDommageVehicle = 0
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if currentCharge ~= 0 and not viewMode then
			showChargement()
		end
	end
end)

RegisterNetEvent('esx_methdrug:setDisplayLoading')
AddEventHandler('esx_methdrug:setDisplayLoading', function(trigger)
  viewMode = trigger
end)

-- RETURN NUMBER OF ITEMS FROM SERVER
RegisterNetEvent('esx_methdrug:ReturnInventory')
AddEventHandler('esx_methdrug:ReturnInventory', function(methNbr, currentZone)
		methQTE 		= methNbr
		TriggerEvent('esx_methdrug:hasEnteredMarker', currentZone)
end)

-- Quand le joueur entre dans la zone
AddEventHandler('esx_methdrug:hasEnteredMarker', function(zone)
	if zone == 'Vente' then
		if methQTE >= 1 then
			CurrentAction     = 'startVente'
			CurrentActionMsg  = _U('sell_meth')
			CurrentActionData = {}
		end
	end
end)



-- Quand le joueur sort de la zone
AddEventHandler('esx_methdrug:hasExitedMarker', function(zone)
	if zone == 'Vente' then
		TriggerServerEvent('esx_methdrug:stopVente')
	end
  CurrentAction = nil
	ESX.UI.Menu.CloseAll()	
end)

--[[
-- Activation du marker au sol
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if PlayerData.job ~= nil then
			local coords = GetEntityCoords(GetPlayerPed(-1))
			for k,v in pairs(Config.Zones) do
				if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end	
		end
	end
end)
]]--

-- Detection de l'entrer/sortie de la zone du joueur
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if PlayerData.job ~= nil then
			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil
			
			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) <= v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerServerEvent('esx_methdrug:GetUserInventory', currentZone)
			end
			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_methdrug:hasExitedMarker', LastZone)
			end
		end
	end
end)
-- Action après la demande d'accés 
Citizen.CreateThread(function()
  while true do
		Citizen.Wait(10)
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(1, Keys["E"]) and GetLastInputMethod(2) then
				Citizen.Wait(100)
				if CurrentAction == 'startVente' then
					if IsInVehicle() then
						ESX.ShowNotification(_U('no_sell_inside_veh'))
					else
						TriggerServerEvent('esx_methdrug:startVente')
					end
				end
				CurrentAction = nil
			end
		end
	end
end)

RegisterNetEvent('esx_methdrug:smokeToClients')
AddEventHandler('esx_methdrug:smokeToClients', function(coordsX, coordsY, coordsZ)
	if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Wait(1)
		end
	end
	SetPtfxAssetNextCall("core")
	--local effet = StartParticleFxLoopedOnEntity("exp_grd_grenade_smoke", vehicleEntity,0.0,-2.0,5.0,0.0,0.0,0.0,3.0,1,1,1)
	local effet = StartParticleFxLoopedAtCoord("exp_grd_grenade_smoke", coordsX, coordsY, coordsZ + 12.5, 0.0, 0.0, 0.0, 5.5, true, true, true, false)
		Citizen.Wait(10000)
	StopParticleFxLooped(effet, 0)
end)


function cleanPlayer(playerPed)
  SetPedArmour(playerPed, 0)
  ClearPedBloodDamage(playerPed)
  ResetPedVisibleDamage(playerPed)
  ClearPedLastWeaponDamage(playerPed)
  ResetPedMovementClipset(playerPed, 0)
end


-- Tenue Hazmat bleue
RegisterNetEvent('esx_methdrug:settenuehaz1')
AddEventHandler('esx_methdrug:settenuehaz1', function(job)
	local playerPed = GetPlayerPed(-1)

	if IsPedInAnyVehicle(playerPed,  false) then
		ESX.ShowNotification(_U('cant_wear_clothes_veh'))
	else
		UseTenu = not UseTenu
		cleanPlayer(playerPed)

			RequestAnimDict('mp_clothing@female@shoes')

			while not HasAnimDictLoaded('mp_clothing@female@shoes') do
				Citizen.Wait(0)
			end

			TaskPlayAnim(playerPed, 'mp_clothing@female@shoes', 'try_shoes_negative_a',8.0, -8.0, -1, 0, 0, false, false, false )

			if UseTenu then
				ESX.ShowNotification(_U('wear_clothes'))
			else
				ESX.ShowNotification(_U('unwear_clothes'))
			end

			Citizen.Wait(6500)

		if UseTenu then
			TriggerEvent('skinchanger:getSkin', function(skin)

				if skin.sex == 0 then
					if Config.Uniforms[job].male ~= nil then
						TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
						TenueUse = true
					else
						ESX.ShowNotification(_U('no_outfit'))
					end
				else
					if Config.Uniforms[job].female ~= nil then
						TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
						TenueUse = true
					else
						ESX.ShowNotification(_U('no_outfit'))
					end
				end

			end)
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
				TenueUse = false
			end)
		end
	end
end)
