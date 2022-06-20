frameworkObject = nil

function ExecuteSql(query)
    local IsBusy = true
    local result = nil
    if Config.Mysql == "oxmysql" then
        if MySQL == nil then
            exports.oxmysql:execute(query, function(data)
                result = data
                IsBusy = false
            end)
        else
            MySQL.query(query, {}, function(data)
                result = data
                IsBusy = false
            end)
        end
    elseif Config.Mysql == "mysql-async" then
        MySQL.Async.fetchAll(query, {}, function(data)
            result = data
            IsBusy = false
        end)
    end
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end

local function tPrint(tbl, indent)
    indent = indent or 0
    if type(tbl) == 'table' then
        for k, v in pairs(tbl) do
            local tblType = type(v)
            local formatting = ("%s ^3%s:^0"):format(string.rep("  ", indent), k)

            if tblType == "table" then
                print(formatting)
                tPrint(v, indent + 1)
            elseif tblType == 'boolean' then
                print(("%s^1 %s ^0"):format(formatting, v))
            elseif tblType == "function" then
                print(("%s^9 %s ^0"):format(formatting, v))
            elseif tblType == 'number' then
                print(("%s^5 %s ^0"):format(formatting, v))
            elseif tblType == 'string' then
                print(("%s ^2'%s' ^0"):format(formatting, v))
            else
                print(("%s^2 %s ^0"):format(formatting, v))
            end
        end
    else
        print(("%s ^0%s"):format(string.rep("  ", indent), tbl))
    end
end

RegisterServerEvent('codem-craft:sendItem')
AddEventHandler('codem-craft:sendItem', function(a, b, c, d, e, f)
 
        local src = source
        frameworkObject = GetFrameworkObject()
        local xPlayer = frameworkObject.Functions.GetPlayer(src)
        local identifier = xPlayer.PlayerData.citizenid
        local time = os.time()
        local deneme = json.decode(d)
        local success = true

        local devam = true
        for k, v in pairs(deneme) do
            local slots = frameworkObject.Player.GetSlotsByItem(xPlayer.PlayerData.items, v.name)
            if slots[1] then
                for _, slot in pairs(slots) do
                    if xPlayer.PlayerData.items[slot].amount >= tonumber(v.amount) then
						
                    else
                        devam = false
						TriggerClientEvent("codem-cyberhud:Notify123", src, Config.Notifications["error"]["message"],
						Config.Notifications["error"]["type"], Config.Notifications["error"]["time"])
                    end
                end
            else
				devam = false
			end
        end
				
        if devam then
			-- REMOVER ITEMS
			for k, v in pairs(deneme) do
					xPlayer.Functions.RemoveItem(v.name, tonumber(v.amount), false)
			end
		
            TriggerClientEvent("codem-cyberhud:Notify123", src, Config.Notifications["success"]["message"],
                Config.Notifications["success"]["type"], Config.Notifications["success"]["time"])
            local data = ExecuteSql(
                "INSERT INTO `codem_craft` (`identifier`,`weaponname`,`weapontime`,`weaponlabel`,`itemTime`,`images`) VALUES ('" ..
                    identifier .. "','" .. a .. "','" .. b .. "','" .. c .. "','" .. time .. "','" .. e .. "')")

            --local item = ExecuteSql("SELECT * FROM players WHERE citizenid = '" .. identifier .. "'")
			local craftxp = xPlayer.PlayerData.metadata["craftxp"]
			if craftxp == nil then craftxp = 0 end
			xPlayer.Functions.SetMetaData("craftxp", craftxp + f)
        
         end

end)
RegisterServerEvent('codem-craft:addItem')
AddEventHandler('codem-craft:addItem', function(a, b)
   
        local src = source
        frameworkObject = GetFrameworkObject()
        local xPlayer = frameworkObject.Functions.GetPlayer(src)

		local item = ExecuteSql("SELECT * FROM codem_craft WHERE id = '" .. b .. "'")
        if item[1] then
			xPlayer.Functions.AddItem(item[1].weaponname, 1)
			ExecuteSql("DELETE FROM `codem_craft` WHERE `id` = '" .. b .. "'")
			TriggerClientEvent('codem-craft:refreshPageAwating', src)
		end


end)

Citizen.CreateThread(function()
    frameworkObject = GetFrameworkObject()
   

        frameworkObject.Functions.CreateCallback('codem-craft:getData', function(source, cb)
            local xPlayer = frameworkObject.Functions.GetPlayer(source)
            local identifier = xPlayer.PlayerData.citizenid

            local item = ExecuteSql("SELECT * FROM codem_craft WHERE identifier = '" .. identifier .. "'")
            if item then
                cb(item)
            end
        end)



        frameworkObject.Functions.CreateCallback('codem-craft:getxP', function(source, cb)
            local xPlayer = frameworkObject.Functions.GetPlayer(source)
            local identifier = xPlayer.PlayerData.citizenid
            local time = os.time()
			
			local craftxp = xPlayer.PlayerData.metadata["craftxp"]
			if craftxp == nil then craftxp = 0 end
            cb(craftxp, time)
        end)


        frameworkObject.Functions.CreateCallback('codem-craft:items', function(source, cb)
            local src = source
            local xPlayer = frameworkObject.Functions.GetPlayer(src)

            local item = xPlayer.PlayerData.items

            cb(item)
        end)
end)

