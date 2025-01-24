local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")
local vSERVER = Tunnel.getInterface("skdev_policia")

skdev = {}
Tunnel.bindInterface("skdev_policia",skdev)

RegisterCommand("policiatablet", function(source,args,rawcmd)
    if vSERVER.permissaopolicia() then
        SendNUIMessage({mostranuipolicia = true})
        SetNuiFocus(true, true)
    end
end)

RegisterNUICallback("close", function(data,cb)
    SetNuiFocus(false, false)
    DestroyMobilePhone()
end)

RegisterNUICallback("menuprincipal", function(data,cb)
    local nome, cargo, policiaispatrulha, prisoesrealizadas, multasaplicadas, boletinsregistrados, muralpermissao, tabela = vSERVER.menuinicial()

    cb({nome = nome, cargo = cargo, policiaispatrulha = policiaispatrulha, prisoesrealizadas = prisoesrealizadas, multasaplicadas = multasaplicadas, boletinsregistrados = boletinsregistrados, muralpermissao = muralpermissao, tabela = tabela})
end)

RegisterNUICallback("enviarAviso", function(data,cb)
    local texto = data.texto

    vSERVER.enviaraviso(texto)
end)

function skdev.notificacao(texto)
    SendNUIMessage({mostraraviso = true, aviso = texto})
end

function skdev.atualizaravisos()
    SendNUIMessage({atualizaravisos = true})
end

RegisterNUICallback("excluirAviso", function(data,cb)
    local texto = data.texto

    vSERVER.excluirAviso(texto)
end)

RegisterNUICallback("consultarid", function(data,cb)
    local passaporte = parseInt(data.passaporte)
    local status, nome, imagen, passaporte, registro, idade, procurado, portedearma, tabela = vSERVER.consultarid(passaporte)

    cb({status = status, nome = nome, imagen = imagen, passaporte = passaporte, registro = registro, idade = idade, procurado = procurado, portedearma = portedearma, tabela = tabela})
end)

RegisterNUICallback("multasinformacoes", function(data,cb)
    local passaporte = parseInt(data.passaporte)
    local index = parseInt(data.index)

    local nomeoficial, passaporteoficial, data, descricao, reducaomulta, valormulta, tabela = vSERVER.multasinformacoes(passaporte,index)

    cb({nomeoficial = nomeoficial, passaporteoficial = passaporteoficial, data = data, descricao = descricao, reducaomulta = reducaomulta, valormulta = valormulta, tabela = tabela})
end)

RegisterNUICallback("prisoesinformacoes", function(data,cb)
    local passaporte = parseInt(data.passaporte)
    local index = parseInt(data.index)

    local nomeoficial, passaporteoficial, data, descricao, reducaomulta, reducaotempopreso, valormulta, tempopreso, tabela = vSERVER.prisoesinformacoes(passaporte,index)

    cb({nomeoficial = nomeoficial, passaporteoficial = passaporteoficial, data = data, descricao = descricao, reducaomulta = reducaomulta, reducaotempopreso = reducaotempopreso, valormulta = valormulta, tempopreso = tempopreso, tabela = tabela})
end)

RegisterNUICallback("consultarveiculosid", function(data,cb)
    local passaporte = parseInt(data.passaporte)
    local tabela, status = vSERVER.consultarveiculosid(passaporte)

    cb({status = status, tabela = tabela, localimgs = ""})
end)

RegisterNUICallback("apreenderVeiculo", function(data,cb)
    local veiculo = data.veiculo
    local passaporte = parseInt(data.passaporte)

    if vSERVER.apreenderVeiculo(veiculo,passaporte) then
        cb({status = true})
    else
        cb({status = false})
    end
end)

RegisterNUICallback("statusprocurado", function(data,cb)
    local passaporte = parseInt(data.passaporte)
    local status, motivo = vSERVER.statusprocurado(passaporte)

    cb({status = status, motivo = motivo})
end)

RegisterNUICallback("confirmarProcuracao", function(data,cb)
    local passaporte = parseInt(data.passaporte)
    local motivo = data.motivo

    if vSERVER.confirmarProcuracao(passaporte,motivo) then
        cb({status = true})
    end
end)

RegisterNUICallback("statusportedearmas", function(data,cb)
    local passaporte = parseInt(data.passaporte)
    local status, nomearma, quantidademunicoes = vSERVER.statusportedearmas(passaporte)

    cb({status = status, nomearma = nomearma, quantidademunicoes = quantidademunicoes})
end)

RegisterNUICallback("confirmarPortedearmas", function(data,cb)
    local passaporte = parseInt(data.passaporte)
    local nomearma = data.nomearma
    local quantidadedemunicoes = data.quantidadedemunicoes
    
    if vSERVER.confirmarPortedearmas(passaporte,nomearma,quantidadedemunicoes) then
        cb({status = true})
    end
end)

ClearPhoto = N_0xd801cc02177fa3f1
RegisterNUICallback("tirarfoto", function(data,cb)
    local passaporte = parseInt(data.passaporte)
    DestroyMobilePhone()
    CreateMobilePhone(0)
    CellCamActivate(true, true)
    SetNuiFocus(false, false)

    local cameraativa = true
    while cameraativa do
		Citizen.Wait(0)

		if IsControlJustPressed(0, 194) or IsControlJustPressed(0, 202) and cameraativa then
			DestroyMobilePhone()
			CellCamActivate(false, false)
			cameraativa = false
		end

		if IsControlJustPressed(0, 176) or IsControlJustPressed(0, 191) and cameraativa then
            exports["screenshot-basic"]:requestScreenshotUpload(tostring(config.webhook_imagens), "files[]", function(data)
                local image = json.decode(data)

                DestroyMobilePhone()
                CellCamActivate(false, false)
                ClearPhoto()
                cameraativa = false

                if image then
                    vSERVER.enviarimagencidadao(passaporte,image.attachments[1].proxy_url)
                end

                SetNuiFocus(true, true)
                if image then
                    cb({image = image.attachments[1].proxy_url})
                else
                    cb({image = nil})
                end
            end)
		end

		if cameraativa then
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(19)
			HideHudAndRadarThisFrame()
		end
	end
end)

RegisterNUICallback("consultarapreender", function(data,cb)
    local passaporte = parseInt(data.passaporte)
    local status, nome, imagen, passaporte, registro, idade, procurado, portedearma,_ = vSERVER.consultarid(passaporte)
    local tabela = {}

    for k,v in pairs(config.crimes) do
        tabela[#tabela+1] = {tempopreso = v.tempopreso, multa = v.multa, crime = v.crime.." R$"..v.multa.." "..v.tempopreso.." Mêses"}
    end

    cb({status = status, nome = nome, imagen = imagen, passaporte = passaporte, registro = registro, idade = idade, procurado = procurado, portedearma = portedearma, tabela = tabela, tempomaximo = config.tempo_maximo_prisao, multamaxima = config.multa_maxima_prisao})
end)

RegisterNUICallback("apreenderCidadao", function(data,cb)
    local passaporte = parseInt(data.passaporte)
    local crimes = data.crime
    local descricao = data.descricao
    local reducaomulta = parseInt(data.reducaomulta)
    local reducaotempo = parseInt(data.reducaotempo)

    if vSERVER.apreenderCidadao(passaporte,crimes,descricao,reducaomulta,reducaotempo) then
        cb({status = true})
    else
        cb({status = false})
    end
end)

local prisioneiro = false
local reducaopenal = false

function skdev.prenderjogador(status)
	prisioneiro = status
	reducaopenal = false

	local ped = PlayerPedId()

	if prisioneiro then
		SetEntityInvincible(ped,false)
		FreezeEntityPosition(ped,true)
		SetEntityVisible(ped,false,false)

		SetTimeout(10000, function()
			SetEntityInvincible(ped,false)
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true,false)
		end)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		if prisioneiro then
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1700.5,2605.2,45.5,true)

			if distance >= 150 then
				SetEntityCoords(PlayerPedId(),1680.1,2513.0,45.5)
				TriggerEvent("Notify","importante","O agente penitenciário encontrou você tentando escapar.")
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local skotimizar = 1000

		if prisioneiro then
			skotimizar = 500

            local coords1 = config.pegar_caixas_cordenadas
            local coords2 = config.entregar_caixas_cordenadas

			local distance1 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),coords1[1],coords1[2],coords1[3],true)
			local distance2 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),coords2[1],coords2[2],coords2[3],true)
            local _,groundz1 = GetGroundZFor_3dCoord(coords1[1],coords1[2],coords1[3],true)
            local _,groundz2 = GetGroundZFor_3dCoord(coords2[1],coords2[2],coords2[3],true)

			if GetEntityHealth(PlayerPedId()) <= 101 then
				reducaopenal = false
                Deletarobjetobase()
			end

			if distance1 <= 100 and not reducaopenal then
                skotimizar = 5
                DrawMarker(23, coords1[1], coords1[2], groundz1+0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 130, false, true, false, false)
                DrawText3D(coords1[1], coords1[2], groundz1+1.3,'~w~MENTALIZE ~r~"E"~w~ PARA PEGAR A CAIXA!')
                
				if IsControlJustPressed(0,38) and distance1 <= 1.2 then
                    reducaopenal = true
                    ResetPedMovementClipset(PlayerPedId(),0)
                    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
                    Carregarobjetobase("anim@heists@box_carry@","idle","hei_prop_heist_box",50,28422)
				end
			end

			if distance2 <= 100 and reducaopenal then
                skotimizar = 5
                DrawMarker(23, coords2[1], coords2[2], groundz2+0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 130, false, true, false, false)
                DrawText3D(coords2[1], coords2[2], groundz2+1.3,'~w~MENTALIZE ~r~"E"~w~ PARA ENTREGAR A CAIXA!')

				if IsControlJustPressed(0,38) and distance2 <= 1.2 then
                    reducaopenal = false
                    vSERVER.diminuirpenapresidio()
                    Deletarobjetobase()
				end
			end
		end

		Citizen.Wait(skotimizar)
	end
end)

Citizen.CreateThread(function()
	while true do
		local skotimizar = 1000

		if reducaopenal then
			skotimizar = 5
			BlockWeaponWheelThisFrame()
			DisableControlAction(0,21,true)
			DisableControlAction(0,22,true)
			DisableControlAction(0,24,true)
			DisableControlAction(0,25,true)
			DisableControlAction(0,29,true)
			DisableControlAction(0,32,true)
			DisableControlAction(0,33,true)
			DisableControlAction(0,34,true)
			DisableControlAction(0,35,true)
			DisableControlAction(0,56,true)
			DisableControlAction(0,58,true)
			DisableControlAction(0,73,true)
			DisableControlAction(0,75,true)
			DisableControlAction(0,140,true)
			DisableControlAction(0,141,true)
			DisableControlAction(0,142,true)
			DisableControlAction(0,143,true)
			DisableControlAction(0,166,true)
			DisableControlAction(0,167,true)
			DisableControlAction(0,170,true)
			DisableControlAction(0,177,true)
			DisableControlAction(0,182,true)
			DisableControlAction(0,187,true)
			DisableControlAction(0,188,true)
			DisableControlAction(0,189,true)
			DisableControlAction(0,190,true)
			DisableControlAction(0,243,true)
			DisableControlAction(0,245,true)
			DisableControlAction(0,246,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,263,true)
			DisableControlAction(0,264,true)
			DisableControlAction(0,268,true)
			DisableControlAction(0,269,true)
			DisableControlAction(0,270,true)
			DisableControlAction(0,271,true)
			DisableControlAction(0,288,true)
			DisableControlAction(0,289,true)
			DisableControlAction(0,303,true)
			DisableControlAction(0,311,true)
			DisableControlAction(0,344,true)
		end

		Citizen.Wait(skotimizar)
	end
end)

function DrawText3D(x,y,z,text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.58, 0.58)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 0, 0, 0, 0)
end

RegisterNUICallback("consultarmultar", function(data,cb)
    local passaporte = parseInt(data.passaporte)
    local status, nome, imagen, passaporte, registro, idade, procurado, portedearma,_ = vSERVER.consultarid(passaporte)
    local tabela = {}

    for k,v in pairs(config.crimes) do
        tabela[#tabela+1] = {tempopreso = v.tempopreso, multa = v.multa, crime = v.crime.." R$"..v.multa}
    end

    cb({status = status, nome = nome, imagen = imagen, passaporte = passaporte, registro = registro, idade = idade, procurado = procurado, portedearma = portedearma, tabela = tabela, tempomaximo = config.tempo_maximo_prisao, multamaxima = config.multa_maxima_prisao})
end)

RegisterNUICallback("multarCidadao", function(data,cb)
    local passaporte = parseInt(data.passaporte)
    local crimes = data.crime
    local descricao = data.descricao
    local reducaomulta = parseInt(data.reducaomulta)

    if vSERVER.multarCidadao(passaporte,crimes,descricao,reducaomulta) then
        cb({status = true})
    else
        cb({status = false})
    end
end)

RegisterNUICallback("consultarprocurados", function(data,cb)
    local status, tabelaPlayer, tabelaVeiculos = vSERVER.consultarprocurados()
    
    cb({status = status, tabelaPlayer = tabelaPlayer, tabelaVeiculos = tabelaVeiculos})
end)

RegisterNUICallback("confirmarBoletinIndividuo", function(data,cb)
    local nomedorequerente = data.nomedorequerente
    local caracteristicasindividuo = data.caracteristicasindividuo
    local razaodoboletin = data.razaodoboletin
    local descricaodoboletin = data.descricaodoboletin

    if vSERVER.confirmarBoletinIndividuo(nomedorequerente,caracteristicasindividuo,razaodoboletin,descricaodoboletin) then
        cb({status = true})
    else
        cb({status = false})
    end
end)

RegisterNUICallback("confirmarBoletinVeiculo", function(data,cb)
    local nomedorequerente = data.nomedorequerente
    local modeloveiculo = data.modeloveiculo
    local corveiculo = data.corveiculo
    local placaveiculo = data.placaveiculo
    local razaoboletin = data.razaoboletin
    local descricaoboletin = data.descricaoboletin

    if vSERVER.confirmarBoletinVeiculo(nomedorequerente, modeloveiculo, corveiculo, placaveiculo, razaoboletin, descricaoboletin) then
        cb({status = true})
    else
        cb({status = false})
    end
end)

RegisterNUICallback("informacaoBoletinCidadao", function(data,cb)
    local boletinTimestamp = parseInt(data.timestamp)
    local status, nomerequerente, nomedooficial, caracteristica, razaoprocurado, descricao, dataprocurado = vSERVER.consultarboletincidadao(boletinTimestamp)

    cb({status = status, nomerequerente = nomerequerente, nomedooficial = nomedooficial, caracteristica = caracteristica, razaoprocurado = razaoprocurado, descricao = descricao, dataprocurado = dataprocurado})
end)

RegisterNUICallback("informacaoBoletinVeiculo", function(data,cb)
    local boletinTimestamp = parseInt(data.timestamp)
    local status, nomerequerente, nomedooficial, modeloveiculo, corveiculo, placaveiculo, razaoprocurado, descricao, dataprocurado = vSERVER.consultarboletinveiculo(boletinTimestamp)

    cb({status = status, nomerequerente = nomerequerente, nomedooficial = nomedooficial, modeloveiculo = modeloveiculo, corveiculo = corveiculo, placaveiculo = placaveiculo, razaoprocurado = razaoprocurado, descricao = descricao, dataprocurado = dataprocurado})
end)

function skdev.atualizarprocurados()
    SendNUIMessage({atualizarprocurados = true})
end

RegisterNUICallback("removerBoletinCidadao", function(data,cb)
    local boletinTimestamp = parseInt(data.timestamp)

    if vSERVER.removerBoletinCidadao(boletinTimestamp) then
        cb({status = true})
    else
        cb({status = false})
    end
end)

RegisterNUICallback("removerBoletinVeiculo", function(data,cb)
    local boletinTimestamp = parseInt(data.timestamp)

    if vSERVER.removerBoletinVeiculo(boletinTimestamp) then
        cb({status = true})
    else
        cb({status = false})
    end
end)

RegisterNUICallback("consultarArsenal", function(data,cb)
    local status, tabela = vSERVER.consultarArsenal()

    cb({status = status, tabela = tabela})
end)

RegisterNUICallback("equiparArma", function(data,cb)
    local index = parseInt(data.index)
    local status = vSERVER.equiparArma(index)

    cb({status = status})
end)

RegisterNUICallback("removerArmas", function(data,cb)
    local status = vSERVER.removerArmas()

    cb({status = status})
end)