local payCheckTimers = {}

RegisterServerEvent('paycheck:checkAndPay')
AddEventHandler('paycheck:checkAndPay', function()
    local _source = source
    local playerId = GetPlayerIdentifier(_source, 0)
    
    if not playerId then return end
    
    local currentTime = os.time()
    local lastPaycheck = payCheckTimers[playerId] or 0
    local cooldownSeconds = Config.minutes * 60
    
    if currentTime - lastPaycheck < cooldownSeconds then
        return
    end
    
    payCheckTimers[playerId] = currentTime
    
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        if not user then return end
        local user_id = user.getIdentifier()

        MySQL.Async.fetchScalar("SELECT salary FROM characters INNER JOIN jobs ON characters.job = jobs.job_name WHERE identifier = @username", { ['@username'] = user_id}, function(result)
            local salary = result or 2
            user.addMoney(salary)
            
            local message = result and result > 0 and "Payday: " .. salary .. "$" or "Unemployment Compensation: " .. salary .. "$"
            TriggerClientEvent("redemrp_notification:start", _source, message, 5, "success")
        end)
    end)
end)

AddEventHandler('redemrp:playerDropped', function()
    local _source = source
    local playerId = GetPlayerIdentifier(_source, 0)
    if playerId and payCheckTimers[playerId] then
        payCheckTimers[playerId] = nil
    end
end)
