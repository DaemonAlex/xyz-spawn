XYZ = exports['qb-core']:GetCoreObject()

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        -- Removed console logging
    end
end)

local function hasApartment(cid)
    if not cid or type(cid) ~= "string" then return false end
    return MySQL.single.await('SELECT * FROM properties WHERE owner_citizenid = ? LIMIT 1', {cid}) ~= nil
end

lib.callback.register('xyz_spawn:GetOwnedApartment', function(source, cid)
    local Player = XYZ.Functions.GetPlayer(source)
    if not Player then
        return false
    end

    cid = cid or Player.PlayerData.citizenid
    if hasApartment(cid) then
        return MySQL.single.await('SELECT * FROM properties WHERE owner_citizenid = ? LIMIT 1', {cid})
    else
        return false
    end
end)

lib.callback.register('qb-spawn:server:getOwnedHouses', function(_, cid)
    if not cid then return nil end
    local houses = MySQL.query.await('SELECT * FROM properties WHERE owner_citizenid = ?', {cid})
    return houses[1] and houses or nil
end)

lib.callback.register('xyz_spawnmenu:server:updateUI', function(source)
    local Player = XYZ.Functions.GetPlayer(source)
    if not Player then
        return {
            name = 'Unknown',
            job = 'Unemployed'
        }
    end

    return {
        name = (Player.PlayerData.charinfo.firstname or 'Unknown') .. ' ' .. (Player.PlayerData.charinfo.lastname or ''),
        job = (Player.PlayerData.job and Player.PlayerData.job.label) or 'Unemployed'
    }
end)
