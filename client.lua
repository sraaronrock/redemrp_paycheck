local timeout = Config.minutes * 60000

Citizen.CreateThread(function ()
	while true do
	Citizen.Wait(timeout)
		TriggerServerEvent('paycheck:salary')
	end
end)
