RegisterServerEvent('paycheck:salary')
AddEventHandler('paycheck:salary', function()
	local _source = source
	local salary_base = 2 --Default salary
	
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user) 
		local user_id = user.getIdentifier()

		MySQL.Async.fetchScalar("SELECT salary FROM characters INNER JOIN jobs ON characters.job = jobs.job_name WHERE identifier = @username", { ['@username'] = user_id}, function(result)
			if result == nil or result == '' then
				user.addMoney((salary_base))
				TriggerClientEvent("redemrp_notification:start", _source, "Unemployment Compensation: " .. salary_base .."$", 5, "success")
			else 
				user.addMoney((result))
				TriggerClientEvent("redemrp_notification:start", _source, "Payday: " .. result .."$", 5, "success")
			end
		end)
 	end)
end)
