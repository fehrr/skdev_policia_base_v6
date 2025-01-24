Citizen.CreateThread(function()
    if IsDuplicityVersion() then
        local Tunnel = module("vrp","lib/Tunnel")
        local Proxy = module("vrp","lib/Proxy")
        local vRP = Proxy.getInterface("vRP")
        local vRPClient = Tunnel.getInterface("vRP")

        function Querybase(param1,param2,param3)
            if baseatual == "creativev6" then
                return vRP.Query(param1,param2)
            else
                return vRP.query(param1,param2,param3)
            end
        end

        function Preparebase(param1,param2)
            if baseatual == "creativev6" then
                vRP.Prepare(param1,param2)
            else
                vRP.prepare(param1,param2)
            end
        end

        function Passportbase(source)
            if baseatual == "creativev6" then
                return vRP.Passport(source)
            else
                return vRP.getUserId(source)
            end
        end

        function HasPermissionbase(user_id,permission,indexpermissao)
            if baseatual == "creativev6" then
                return vRP.HasPermission(user_id,permission,indexpermissao)
            else
                return vRP.hasPermission(user_id, permission)
            end
        end

        function Getusersbase()
            if baseatual == "creativev6" then
                return vRP.Players()
            elseif baseatual == "creativev5" then
                return vRP.userList()
            elseif baseatual == "creativev4" then
                return vRP.userList()
            elseif baseatual == "creativev1" then
                return vRP.userList()
            else
                return vRP.getUsers()
            end
        end

        function Getusersbypermissionsbase(permission)
            if baseatual == "vrpex" then
                return vRP.getUsersByPermission(permission)
            end
            if baseatual == "creativev1" then
                local tableList = {}
                for user_id,source in pairs(vRP.userList()) do
                    if vRP.hasPermission(user_id, permission) then
                        table.insert(tableList, user_id)
                    end
                end
                return tableList
            end
            if baseatual == "creativev2" then
                local tableList = {}
                for user_id,source in pairs(vRP.getUsers()) do
                    if vRP.hasPermission(user_id, permission) then
                        table.insert(tableList, user_id)
                    end
                end
                return tableList
            end
            if baseatual == "creativev3" then
                local tableList = {}
                for user_id,source in pairs(vRP.getUsers()) do
                    if vRP.hasPermission(user_id, permission) then
                        table.insert(tableList, user_id)
                    end
                end
                return tableList
            end
            if baseatual == "creativev4" then
                local tableList = {}
                for user_id,source in pairs(vRP.userList()) do
                    if vRP.hasPermission(user_id, permission) then
                        table.insert(tableList, user_id)
                    end
                end
                return tableList
            end
            if baseatual == "creativev5" then
                return vRP.getUsersByPermission(permission)
            end
            if baseatual == "creativev6" then
                local tableList = {}
                for user_id,source in pairs(vRP.Players()) do
                    local Passport = vRP.Passport(source)
                    if vRP.HasPermission(Passport,permission) then
                        table.insert(tableList, Passport)
                    end
                end
                return tableList
            end
        end

        function Identitybase(user_id)
            if baseatual == "creativev6" then
                local identidadePlayer = vRP.Identity(user_id)
                if identidadePlayer then
                    return {name = identidadePlayer.name, name2 = identidadePlayer.name2, phone = identidadePlayer.phone, registration = "N/A", age = 18}
                end
            end
            if baseatual == "creativev5" then
                local identidadePlayer = vRP.userIdentity(user_id)
                if identidadePlayer then
                    return {name = identidadePlayer.name, name2 = identidadePlayer.name2, phone = identidadePlayer.phone, registration = identidadePlayer.serial, age = identidadePlayer.age or 18}
                end
            end
            if baseatual == "creativev4" then
                local identidadePlayer = vRP.userIdentity(user_id)
                if identidadePlayer then
                    return {name = identidadePlayer.name, name2 = identidadePlayer.name2, phone = identidadePlayer.phone, registration = identidadePlayer.serial, age = identidadePlayer.age or 18}
                end
            end
            if baseatual == "creativev3" then
                local identidadePlayer = vRP.userIdentity(user_id)
                if identidadePlayer then
                    return {name = identidadePlayer.name, name2 = identidadePlayer.name2, phone = identidadePlayer.phone, registration = identidadePlayer.serial, age = identidadePlayer.age or 18}
                end
            end
            if baseatual == "creativev2" then
                local identidadePlayer = vRP.getUserIdentity(user_id)
                if identidadePlayer then
                    return {name = identidadePlayer.name, name2 = identidadePlayer.name2, phone = identidadePlayer.phone, registration = identidadePlayer.serial, age = identidadePlayer.age or 18}
                end
            end
            if baseatual == "creativev1" then
                local identidadePlayer = vRP.userIdentity(user_id)
                if identidadePlayer then
                    return {name = identidadePlayer.name, name2 = identidadePlayer.name2, phone = identidadePlayer.phone, registration = identidadePlayer.serial, age = identidadePlayer.age or 18}
                end
            end
            if baseatual == "vrpex" then
                local identidadePlayer = vRP.getUserIdentity(user_id)
                if identidadePlayer then
                    return {name = identidadePlayer.name, name2 = identidadePlayer.firstname, phone = identidadePlayer.phone, registration = identidadePlayer.registration, age = identidadePlayer.age or 18}
                end
            end
        end

        function Getusersourcebase(user_id)
            if baseatual == "creativev6" then
                return vRP.Source(user_id)
            else
                return vRP.getUserSource(user_id)
            end
        end

        function Vehiclenamebase(vehicle)
            if baseatual == "creativev6" then
                return VehicleName(vehicle)
            elseif baseatual == "creativev5" or baseatual == "creativev4" or baseatual == "creativev1" then
                return vehicleName(vehicle)
            elseif baseatual == "creativev3" or baseatual == "creativev2" or baseatual == "vrpex" then
                return vRP.vehicleName(vehicle) 
            end
        end

        function Sendwebhookbase(webhook,message)
            PerformHttpRequest(webhook, function(err, text, headers) end, "POST", json.encode({content = message}), { ["Content-Type"] = "application/json" })
        end

        function Getinventorybase(user_id)
            if baseatual == "creativev6" then
                return vRP.Inventory(user_id)
            elseif baseatual == "creativev5" or baseatual == "creativev4" or baseatual == "creativev1" then
                return vRP.userInventory(user_id)
            elseif baseatual == "vrpex" or baseatual == "creativev3" or baseatual == "creativev2" then
                return vRP.getInventory(user_id)
            end
        end

        function Itemnamelistbase(itemname)
            if baseatual == "creativev6" or baseatual == "creativev5" or baseatual == "creativev4" or baseatual == "creativev1" then
                return itemName(itemname)
            else
                return vRP.itemNameList(itemname)
            end
        end

        function Trygetinventorybase(user_id,item,amount)
            if baseatual == "creativev6" then
                return vRP.TakeItem(user_id,item,amount)
            else
                return vRP.tryGetInventoryItem(user_id,item,amount)
            end
        end

        function Getmoneybase(user_id)
            if baseatual == "creativev6" then
                local Source = vRP.Source(user_id)
                return vRP.GetBank(Source)
            elseif baseatual == "creativev1" or baseatual == "creativev2" or baseatual == "creativev3" or baseatual == "creativev4" or baseatual == "creativev5" then
                return vRP.getBank(user_id)
            else
                return vRP.getMoney(user_id)
            end
        end

        function Getbankmoneybase(user_id)
            if baseatual == "creativev6" then
                local Source = vRP.Source(user_id)
                return vRP.GetBank(Source)
            elseif baseatual == "creativev1" or baseatual == "creativev2" or baseatual == "creativev3" or baseatual == "creativev4" or baseatual == "creativev5" then
                return vRP.getBank(user_id)
            else
                return vRP.getBankMoney(user_id)
            end
        end

        function Setmoneybase(user_id,amount)
            if baseatual == "creativev6" then
                local Source = vRP.Source(user_id)
                local Bank = vRP.GetBank(Source)
                vRP.RemoveBank(user_id,parseInt(Bank))
                vRP.GiveBank(user_id,parseInt(amount))
            elseif baseatual == "creativev1" or baseatual == "creativev2" or baseatual == "creativev3" or baseatual == "creativev4" or baseatual == "creativev5" then
                local Bank = vRP.getBank(user_id)
                vRP.delBank(user_id,parseInt(Bank),"Private")
                vRP.addBank(user_id,parseInt(amount),"Private")
            else
                return vRP.setMoney(user_id,parseInt(amount))
            end
        end

        function Setbankmoneybase(user_id,amount)
            if baseatual ~= "vrpex" then
                Setmoneybase(user_id,amount)
            else
                return vRP.setBankMoney(user_id,parseInt(amount))
            end
        end

        function Kickbase(source,reason)
            if baseatual == "creativev6" then
                return vRP.Kick(source,reason)
            else
                return vRP.kick(source,reason)
            end
        end

        function Setbanbase(user_id,boolean)
            if baseatual == "creativev6" then
                if boolean then
                    local Source = vRP.Source(user_id)
                    local Identity = vRP.Identities(Source)
                    vRP.Query("banneds/InsertBanned",{license = Identity, time = 10000000})
                else
                    local Source = vRP.Source(user_id)
                    local Identity = vRP.Identities(Source)
                    vRP.Query("banneds/RemoveBanned",{license = Identity})
                end
            elseif baseatual == "creativev5" then
                if boolean then
                    local identity = vRP.userIdentity(user_id)
                    vRP.execute("banneds/insertBanned",{ steam = identity["steam"], time = 10000000 })
                else
                    local identity = vRP.userIdentity(user_id)
                    vRP.execute("banneds/removeBanned",{ steam = identity["steam"] })
                end
            elseif baseatual == "creativev4" then
                if boolean then
                    local identity = vRP.userIdentity(user_id)
                    vRP.execute("banneds/insertBanned",{ steam = identity["steam"], days = 10000000 })
                else
                    local identity = vRP.userIdentity(user_id)
                    vRP.execute("banneds/removeBanned",{ steam = identity["steam"] })
                end
            elseif baseatual == "creativev3" then
                if boolean then
                    local identity = vRP.getUserIdentity(user_id)
                    vRP.execute("vRP/set_banned",{ steam = tostring(identity.steam), banned = 1 })
                else
                    local identity = vRP.getUserIdentity(user_id)
                    vRP.execute("vRP/set_banned",{ steam = tostring(identity.steam), banned = 0 })
                end
            elseif baseatual == "creativev2" then
                if boolean then
                    local identity = vRP.getUserIdentity(user_id)
                    vRP.execute("vRP/set_banned",{ steam = tostring(identity.steam), banned = 1 })
                else
                    local identity = vRP.getUserIdentity(user_id)
                    vRP.execute("vRP/set_banned",{ steam = tostring(identity.steam), banned = 0 })
                end
            elseif baseatual == "creativev1" then
                if boolean then
                    local identity = vRP.userIdentity(user_id)
                    vRP.execute("banneds/insertBanned",{ steam = identity["steam"], days = 10000000 })
                else
                    local identity = vRP.userIdentity(nuser_id)
                    vRP.execute("banneds/removeBanned",{ steam = identity["steam"] })
                end
            else
                if boolean then
                    vRP.setBanned(user_id,1)
                else
                    vRP.setBanned(user_id,0)
                end
            end
            return true
        end

        function Getinventoryweightbase(user_id)
            if baseatual == "creativev6" then
                return vRP.InventoryWeight(user_id)
            elseif baseatual == "creativev5" then
                return vRP.inventoryWeight(user_id)
            elseif baseatual == "creativev4" then
                return vRP.inventoryWeight(user_id)
            elseif baseatual == "creativev3" then
                return vRP.computeInvWeight(user_id)
            elseif baseatual == "creativev2" then
                return vRP.computeInvWeight(user_id)
            elseif baseatual == "creativev1" then
                return vRP.inventoryWeight(user_id)
            else
                return vRP.getInventoryWeight(user_id)
            end
        end

        function Getinventorymaxweightbase(user_id)
            if baseatual == "creativev6" then
                return vRP.GetWeight(user_id)
            elseif baseatual == "creativev5" then
                return vRP.getWeight(user_id)
            elseif baseatual == "creativev4" then
                return vRP.getBackpack(user_id)
            elseif baseatual == "creativev3" then
                return vRP.getBackpack(user_id)
            elseif baseatual == "creativev2" then
                return vRP.getBackpack(user_id)
            elseif baseatual == "creativev1" then
                return vRP.getBackpack(user_id)
            else
                return vRP.getInventoryMaxWeight(user_id)
            end
        end

        function Getitemweightbase(itemname)
            if baseatual == "creativev6" then
                return itemWeight(itemname)
            elseif baseatual == "creativev5" then
                return itemWeight(itemname)
            elseif baseatual == "creativev4" then
                return itemWeight(itemname)
            elseif baseatual == "creativev3" then
                return vRP.itemWeightList(itemname)
            elseif baseatual == "creativev2" then
                return vRP.itemWeightList(itemname)
            elseif baseatual == "creativev1" then
                return itemWeight(itemname)
            else
                return vRP.getItemWeight(itemname)
            end
        end

        function Giveinventoryitembase(user_id,itemname,amount)
            if baseatual == "creativev6" then
                return vRP.GiveItem(user_id,itemname,amount)
            else
                return vRP.giveInventoryItem(user_id,itemname,amount)
            end
            return true
        end

        function Trygetinventoryitembase(user_id,itemname,amount)
            if baseatual == "creativev6" then
                return vRP.TakeItem(user_id,itemname,amount)
            else
                return vRP.tryGetInventoryItem(user_id,itemname,amount)
            end
        end

        function Getamountofitembase(user_id,itemname)
            if baseatual == "creativev6" then
                return vRP.ItemAmount(user_id,itemname)
            elseif baseatual == "creativev5" then
                return vRP.getInventoryItemAmount(user_id,itemname)
            elseif baseatual == "creativev4" then
                return vRP.getInventoryItemAmount(user_id,itemname)
            elseif baseatual == "creativev3" then
                return vRP.getInventoryItemAmount(user_id,itemname)
            elseif baseatual == "creativev2" then
                return vRP.getInventoryItemAmount(user_id,itemname)
            elseif baseatual == "creativev1" then
                return vRP.getInventoryItemAmount(user_id,itemname)
            else
                return vRP.getInventoryItemAmount(user_id,itemname)
            end
        end

        function Updateidentitybase(tabela)
            if baseatual == "creativev6" then
                if tabela["name"] ~= nil then
                    vRP.UpgradeNames(tabela["user_id"],tabela["name"],tabela["firstname"])
                end
                if tabela["phone"] ~= nil then
                    vRP.UpgradePhone(tabela["user_id"],tabela["phone"])
                end
            elseif baseatual == "creativev5" then
                if tabela["name"] ~= nil then
                    vRP.upgradeNames(tabela["user_id"],tabela["name"],tabela["firstname"])
                end
                if tabela["phone"] ~= nil then
                    vRP.upgradePhone(tabela["user_id"],tabela["phone"])
                end
            elseif baseatual == "creativev4" then
                Querybase("skdev/updtidentity",tabela,"execute")
            elseif baseatual == "creativev3" then
                Querybase("skdev/updtidentity",tabela,"execute")
            elseif baseatual == "creativev2" then
                Querybase("skdev/updtidentity",tabela,"execute")
            elseif baseatual == "creativev1" then
                Querybase("skdev/updtidentity",tabela,"execute")
            else
                Querybase("skdev/updtidentity",tabela,"execute")
            end
        end

        function Getuserdatabase(user_id,key)
            if baseatual == "creativev6" then
                return vRP.UserData(user_id,key)
            elseif baseatual == "creativev5" then
                return vRP.userData(user_id,key)
            elseif baseatual == "creativev4" then
                return vRP.userData(user_id,key)
            elseif baseatual == "creativev3" then
                return vRP.getUData(user_id,key)
            elseif baseatual == "creativev2" then
                return vRP.getUData(user_id,key)
            elseif baseatual == "creativev1" then
                return vRP.userData(user_id,key)
            else
                return vRP.getUData(user_id,key)
            end
        end

        function Setuserdatabase(user_id,key,data)
            if baseatual == "creativev6" then
                vRP.Query("playerdata/SetData",{ Passport = user_id, dkey = key, dvalue = data })
            elseif baseatual == "creativev5" then
                vRP.execute("playerdata/setUserdata",{ user_id = user_id, key = key, value = data })
            elseif baseatual == "creativev4" then
                vRP.execute("playerdata/setUserdata",{ user_id = user_id, key = key, value = data })
            elseif baseatual == "creativev3" then
                vRP.setUData(user_id,key,value)
            elseif baseatual == "creativev2" then
                vRP.setUData(user_id,key,data)
            elseif baseatual == "creativev1" then
                vRP.execute("playerdata/setUserdata",{ user_id = user_id, key = key, value = data })
            else
                vRP.setUData(user_id,key,data)
            end
        end

        function Teleportebase(source,x,y,z)
            local GetPlayerPed = GetPlayerPed(source)
            SetEntityCoords(GetPlayerPed, x + 1.0E-4, y + 1.0E-4, z + 1.0E-4, false, false, false, false)
        end

        function Getnearestplayerbase(source,distance)
            if baseatual == "creativev6" then
                return vRPClient.ClosestPed(source,distance)
            elseif baseatual == "creativev5" then
                return vRPClient.nearestPlayer(source,distance)
            elseif baseatual == "creativev4" then
                return vRPClient.nearestPlayer(source,distance)
            elseif baseatual == "creativev3" then
                return vRPClient.nearestPlayer(source,distance)
            elseif baseatual == "creativev2" then
                return vRPClient.nearestPlayer(source,distance)
            elseif baseatual == "creativev1" then
                return vRPClient.nearestPlayer(source,distance)
            else
                return vRPClient.getnearestplayer(source,distance)
            end
        end

        function Setarmourbase(source,armour)
            local GetPlayerPed = GetPlayerPed(source)
            SetPedArmour(GetPlayerPed,armour)
        end
    else
        local Tunnel = module("vrp","lib/Tunnel")
        local Proxy = module("vrp","lib/Proxy")
        local vRP = Proxy.getInterface("vRP")

        function Deletarobjetobase()
            if baseatual == "creativev6" then
                vRP._Destroy()
            elseif baseatual == "creativev5" then
                vRP._removeObjects()
            elseif baseatual == "creativev4" then
                vRP._removeObjects()
            elseif baseatual == "creativev3" then
                vRP._removeObjects()
            elseif baseatual == "creativev2" then
                vRP._removeObjects()
            elseif baseatual == "creativev1" then
                vRP._removeObjects()
            else
                vRP._DeletarObjeto()
            end
        end

        function Carregarobjetobase(dict,anim,prop,flag,hand,pos1,pos2,pos3,pos4,pos5,pos6)
            if baseatual == "creativev6" then
                vRP._CreateObjects(dict,anim,prop,flag,hand,pos1,pos2,pos3,pos4,pos5,pos6)
            elseif baseatual == "creativev5" then
                vRP._createObjects(dict,anim,prop,flag,hand,pos1,pos2,pos3,pos4,pos5,pos6)
            elseif baseatual == "creativev4" then
                vRP._createObjects(dict,anim,prop,flag,hand,pos1,pos2,pos3,pos4,pos5,pos6)
            elseif baseatual == "creativev3" then
                vRP._createObjects(dict,anim,prop,flag,hand,pos1,pos2,pos3,pos4,pos5,pos6)
            elseif baseatual == "creativev2" then
                vRP._createObjects(dict,anim,prop,flag,hand,pos1,pos2,pos3,pos4,pos5,pos6)
            elseif baseatual == "creativev1" then
                vRP._createObjects(dict,anim,prop,flag,hand,pos1,pos2,pos3,pos4,pos5,pos6)
            else
                vRP._CarregarObjeto(dict,anim,prop,flag,hand,pos1,pos2,pos3,pos4,pos5,pos6)
            end
        end
    end
end)