function SendReactMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data or {} -- Ensure `data` is always a table
    })
end

local currentResourceName = GetCurrentResourceName()
local debugIsEnabled = GetConvarInt(('%s-debugMode'):format(currentResourceName), 0) == 1

function debugPrint(...)
    if not debugIsEnabled then return end

    -- Convert all arguments to strings and concatenate efficiently
    local formattedArgs = {}
    for i = 1, select("#", ...) do
        formattedArgs[i] = tostring(select(i, ...))
    end

    print(("^3[%s]^0 %s"):format(currentResourceName, table.concat(formattedArgs, " ")))
end
