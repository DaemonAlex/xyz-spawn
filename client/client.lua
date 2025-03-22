local Core = exports['qb-core']:GetCoreObject()
lib.locale()

local function toggleNuiFrame(shouldShow)
    local userinfo = lib.callback.await('xyz_spawnmenu:server:updateUI', false) or { name = "Unknown", job = "Unemployed" }

    SetNuiFocus(shouldShow, shouldShow)
    SendReactMessage('setVisible', shouldShow)
    SendReactMessage('userinfo', userinfo)
end

RegisterNetEvent('apartments:client:setupSpawnUI', function(cData)
    if not cData or not cData.citizenid then return end
    local result = lib.callback.await('xyz_spawn:GetOwnedApartment', false, cData.citizenid)

    TriggerScreenblurFadeIn(500)
    SwitchOutPlayer(cache.ped, 0, 1)

    while GetPlayerSwitchState() ~= 5 do Wait(0) end

    DoScreenFadeIn(1000)
    toggleNuiFrame(true)
    SendReactMessage('IsNew', not result or type(result) ~= "table")
end)

RegisterNetEvent('qb-spawn:client:openUI', function()
    SetNuiFocus(true, true)
    SetEntityVisible(cache.ped, false)
    DoScreenFadeOut(250)

    while GetPlayerSwitchState() ~= 5 do Wait(0) end
    DoScreenFadeIn(1000)

    Core.Functions.GetPlayerData(function(PlayerData)
        if not PlayerData then return end
        TriggerEvent('apartments:client:setupSpawnUI', PlayerData)
    end)

    toggleNuiFrame(true)
    TriggerEvent('xyz-weather:client:EnableSync')
end)

RegisterNUICallback('hideFrame', function(_, cb)
    toggleNuiFrame(false)
    cb('ok')
end)

RegisterNUICallback('forge-spawn', function(data, cb)
    if not data or not data.coords then return cb('error') end
    local spawnLocation = vector4(data.coords.x, data.coords.y, data.coords.z, data.coords.h)

    toggleNuiFrame(false)
    TriggerScreenblurFadeOut(0)
    spawnPlayer(spawnLocation)

    cb('ok')
end)

RegisterNUICallback('forge-navbar', function(_, cb)
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    cb('ok')
end)

RegisterNUICallback('logout', function(_, cb)
    cb('ok')
end)

RegisterNUICallback('forge-introplayer', function(_, cb)
    toggleNuiFrame(false)
    DoScreenFadeOut(0)
    SwitchInPlayer(cache.ped)

    while GetPlayerSwitchState() ~= 12 do Wait(0) end
    CreateCam(cache.ped)
    cb('ok')
end)

function spawnPlayer(spawnLocation)
    if not spawnLocation then return end

    local ped = cache.ped
    SetEntityVisible(ped, true)
    RequestCollisionAtCoord(spawnLocation.x, spawnLocation.y, spawnLocation.z)
    SetEntityCoordsNoOffset(ped, spawnLocation.x, spawnLocation.y, spawnLocation.z, false, false, false, true)
    SetEntityHeading(ped, spawnLocation.h)
    FreezeEntityPosition(ped, true)

    while not HasCollisionLoadedAroundEntity(ped) do Wait(0) end

    FreezeEntityPosition(ped, false)

    TriggerServerEvent('ps-housing:server:resetMetaData')
    TriggerEvent('xyz-weather:client:EnableSync')
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
end

RegisterNUICallback('lastlocation', function(_, cb)
    TriggerScreenblurFadeOut(0)

    Core.Functions.GetPlayerData(function(pd)
        if not pd or not pd.position then return cb('error') end

        local ped = cache.ped
        local insideMeta = pd.metadata and pd.metadata["inside"]

        SetEntityVisible(ped, true)
        RequestCollisionAtCoord(pd.position.x, pd.position.y, pd.position.z, -1.0)
        SetEntityCoords(ped, pd.position.x, pd.position.y, pd.position.z - 2.0)
        SetEntityHeading(ped, pd.position.a)

        FreezeEntityPosition(ped, true)

        while not HasCollisionLoadedAroundEntity(ped) do Wait(0) end

        if insideMeta and insideMeta.property_id then
            TriggerServerEvent('ps-housing:server:enterProperty', tostring(insideMeta.property_id))
        else
            TriggerServerEvent('ps-housing:server:resetMetaData')
        end

        TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
        TriggerEvent('QBCore:Client:OnPlayerLoaded')
        TriggerEvent('xyz-weather:client:EnableSync')

        cb('ok')
    end)
end)
