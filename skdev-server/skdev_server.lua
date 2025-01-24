local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")
local vCLIENT = Tunnel.getInterface("skdev_policia")
local vRPClient = Tunnel.getInterface("vRP")

skdev = {}
Tunnel.bindInterface("skdev_policia",skdev)

CreateThread(function()
    Preparebase("skdev/informacao1", [[CREATE TABLE IF NOT EXISTS skdev_tabletpolicia_perfil(
        oficial varchar(250) NOT NULL DEFAULT "",
        prisoesrealizadas varchar(250) NOT NULL DEFAULT "",
        multasaplicadas varchar(250) NOT NULL DEFAULT "",
        boletinsregistrados varchar(250) NOT NULL DEFAULT ""
    )]])
    Querybase("skdev/informacao1",nil,"execute")

    Preparebase("skdev/informacao2", [[CREATE TABLE IF NOT EXISTS skdev_tabletpolicia_cidadao(
        cidadao varchar(250) NOT NULL DEFAULT "",
        dados varchar(50000) NOT NULL DEFAULT ""
    )]])
    Querybase("skdev/informacao2",nil,"execute")

    Preparebase("skdev/informacao3", [[CREATE TABLE IF NOT EXISTS skdev_tabletpolicia_boletins(
        tipo varchar(250) NOT NULL DEFAULT "",
        boletin varchar(250) NOT NULL DEFAULT "",
        dados varchar(50000) NOT NULL DEFAULT ""
    )]])
    Querybase("skdev/informacao3",nil,"execute")

    Preparebase("skdev/informacaoOficial","SELECT * FROM skdev_tabletpolicia_perfil WHERE oficial = @user_id")
    Preparebase("skdev/replaceDadosOficial","REPLACE INTO skdev_tabletpolicia_perfil(oficial,prisoesrealizadas,multasaplicadas,boletinsregistrados) VALUES(@user_id,@prisoesrealizadas,@multasaplicadas,@boletinsregistrados)")
    Preparebase("skdev/updateDadosOficial","UPDATE skdev_tabletpolicia_perfil SET prisoesrealizadas = @prisoesrealizadas, multasaplicadas = @multasaplicadas, boletinsregistrados = @boletinsregistrados WHERE oficial = @user_id")
    Preparebase("skdev/informacaoCidadao","SELECT * FROM skdev_tabletpolicia_cidadao WHERE cidadao = @user_id")
    Preparebase("skdev/veiculosCidadao","SELECT * FROM "..config.database_veiculos[1].." WHERE "..config.database_veiculos[2].." = @user_id")
    Preparebase("skdev/apreenderveiculoCidadao","UPDATE "..config.database_veiculos[1].." SET "..config.database_veiculos[4].." = @valor WHERE "..config.database_veiculos[2].." = @user_id AND "..config.database_veiculos[3].." = @vehicle")
    Preparebase("skdev/inserirdadoscidadao","INSERT INTO skdev_tabletpolicia_cidadao(cidadao,dados) VALUES(@user_id,@valor)")
    Preparebase("skdev/updatedadoscidadao","UPDATE skdev_tabletpolicia_cidadao SET dados = @valor WHERE cidadao = @user_id")

    Preparebase("skdev/informacaoBoletins","SELECT * FROM skdev_tabletpolicia_boletins WHERE boletin = @boletin")
    Preparebase("skdev/informacaoBoletinsAll","SELECT * FROM skdev_tabletpolicia_boletins")
    Preparebase("skdev/insertBoletins","INSERT INTO skdev_tabletpolicia_boletins(tipo,boletin,dados) VALUES(@tipo,@boletin,@dados)")
    Preparebase("skdev/deleteBoletins","DELETE FROM skdev_tabletpolicia_boletins WHERE boletin = @boletin")
end)

local avisosPainel = {}

function skdev.permissaopolicia()
    local source = source
    local user_id = Passportbase(source)

    for k,v in pairs(config.cargos) do
        local indexPermissionv6 = 0
        if v.index_permissao then
            indexPermissionv6 = v.index_permissao
        end
        if HasPermissionbase(user_id, v.permissao_ingame, indexPermissionv6) then
            return true
        end
    end

    return false
end

function verificarPermissaoPolicial(user_id,permissao)
    local user_id = parseInt(user_id)

    for k,v in pairs(config.cargos) do
        local indexPermissionv6 = 0
        if v.index_permissao then
            indexPermissionv6 = v.index_permissao
        end
        if HasPermissionbase(user_id, v.permissao_ingame, indexPermissionv6) then
            for b,c in pairs(v.permissoes_painel) do
                if c ~= nil then
                    if c == permissao then
                        return true
                    end
                end
            end
        end
    end

    return false
end

function informacaoOficialLocal(user_id,consulta)
    local user_id = parseInt(user_id)

    local query = Querybase("skdev/informacaoOficial",{user_id = user_id},"query")
    if #query > 0 then
        if query[1][tostring(consulta)] ~= nil then
            return query[1][tostring(consulta)]
        end
    end

    return 0
end

function skdev.menuinicial()
    local source = source
    local user_id = Passportbase(source)

    local nome = "Individuo Indigente"
    local cargo = "Recruta"
    local policiaispatrulha = #Getusersbypermissionsbase(config.permissao_patrulha)
    local prisoesrealizadas = parseInt(informacaoOficialLocal(user_id,"prisoesrealizadas"))
    local multasaplicadas = parseInt(informacaoOficialLocal(user_id,"multasaplicadas"))
    local boletinsregistrados = parseInt(informacaoOficialLocal(user_id,"boletinsregistrados"))
    local muralpermissao = verificarPermissaoPolicial(user_id,"avisar membros")
    local tabela = {}

    local identity = Identitybase(user_id)
    if identity ~= nil then
        nome = identity.name.." "..identity.name2
    end

    for k,v in pairs(avisosPainel) do
        if parseInt(v.idoficial) == user_id then
            tabela[#tabela+1] = {idoficial = v.idoficial, nomeoficial = v.nomeoficial, avisotexto = v.aviso, meuaviso = true}
        else
            tabela[#tabela+1] = {idoficial = v.idoficial, nomeoficial = v.nomeoficial, avisotexto = v.aviso, meuaviso = false}
        end
    end

    for k,v in pairs(config.cargos) do
        if cargo == "Recruta" then
            local indexPermissionv6 = 0
            if v.index_permissao then
                indexPermissionv6 = v.index_permissao
            end
            if HasPermissionbase(user_id, v.permissao_ingame, indexPermissionv6) then
                cargo = v.nome_no_painel
            end
        end
    end

    return nome, cargo, policiaispatrulha, prisoesrealizadas, multasaplicadas, boletinsregistrados, muralpermissao, tabela
end

function skdev.enviaraviso(texto)
    local source = source
    local user_id = Passportbase(source)

    if verificarPermissaoPolicial(user_id,"avisar membros") then
        local identity = Identitybase(user_id)

        avisosPainel[#avisosPainel+1] = {aviso = texto, idoficial = 1, nomeoficial = identity.name.." "..identity.name2}

        local dataAtual = os.date("%H") .. ":" .. os.date("%M") .. " " .. os.date("%d") .. "/" .. os.date("%m") .. "/" .. os.date("%Y")
        local webhook = "[TABLET POLICIAL - AVISOS]\n[ID OFICIAL]: "..user_id.."\n[AVISO]: "..texto.."\n[DATA]: "..dataAtual..""
        Sendwebhookbase(config.webhook_logs,"```ini\n"..webhook.."```")

        local policiais = Getusersbypermissionsbase(config.permissao_patrulha)
        for k,v in pairs(policiais) do
            local pSource = Getusersourcebase(parseInt(v))
            if pSource then
                vCLIENT.notificacao(pSource,"Um Oficial acabou de realizar um aviso!, vá até o tablet para saber mais!")
                vCLIENT.atualizaravisos(pSource)
            end
        end
    end
end

function skdev.excluirAviso(texto)
    local source = source
    local user_id = Passportbase(source)

    if verificarPermissaoPolicial(user_id,"avisar membros") then
        for k,v in pairs(avisosPainel) do
            if v.aviso == texto then
                if parseInt(v.idoficial) == user_id then
                    table.remove(avisosPainel,parseInt(k))

                    local policiais = Getusersbypermissionsbase(config.permissao_patrulha)
                    for k,v in pairs(policiais) do
                        local pSource = Getusersourcebase(parseInt(v))
                        if pSource then
                            vCLIENT.atualizaravisos(pSource)
                        end
                    end

                    break
                end
            end
        end
    end
end

function skdev.consultarid(passaporte)
    local source = source
    local user_id = Passportbase(source)
    
    local status = false
    local nome = ""
    local imagen = ""
    local passaporte = parseInt(passaporte)
    local registro = ""
    local idade = 18
    local procurado = "NÃO PROCURADO"
    local portedearma = "SEM PORTE"
    local tabela = {}

    local identity = Identitybase(passaporte)
    if identity ~= nil then
        status = true
        nome = identity.name.." "..identity.name2
        registro = identity.registration
        idade = identity.age
    end

    local query = Querybase("skdev/informacaoCidadao",{user_id = passaporte},"query")
    if #query > 0 then
        if query[1].dados ~= nil then
            if #query[1].dados > 0 then
                local decode = json.decode(query[1].dados)
    
                if decode.imagen ~= nil then
                    imagen = decode.imagen
                end
                if decode.procurado ~= nil then
                    if #decode.procurado > 0 then
                        procurado = "CIDADÃO PROCURADO !"
                    end
                end
                if decode.portedearma ~= nil then
                    if #decode.portedearma > 0 then
                        portedearma = "CIDADÃO POSSUI PORTE"
                    end
                end
                if decode.historicocrimes ~= nil then
                    if #decode.historicocrimes > 0 then
                        for b,c in pairs(decode.historicocrimes) do
                            tabela[#tabela+1] = {tipo = c.tipo, oficial = c.policial}
                        end
                    end
                end
            end
        end
    end

    return status, nome, imagen, passaporte, registro, idade, procurado, portedearma, tabela
end

function dataFormatada(timestamp)
    local timestamp = os.date("*t", timestamp)
    local dia = timestamp.day
    local mes = timestamp.month
    local ano = timestamp.year
    local hora = timestamp.hour
    local minuto = timestamp.min

    return string.format("%02d/%02d/%04d %02d:%02d", dia, mes, ano, hora, minuto)
end

function skdev.multasinformacoes(passaporte,index)
    local source = source
    local user_id = Passportbase(source)

    local passaporte = parseInt(passaporte)
    local index = parseInt(index)

    local nomeoficial = ""
    local passaporteoficial = ""
    local data = ""
    local descricao = ""
    local reducaomulta = 0
    local valormulta = 0
    local tabela = {}

    local query = Querybase("skdev/informacaoCidadao",{user_id = passaporte},"query")
    if #query > 0 then
        if query[1].dados ~= nil then
            local decode = json.decode(query[1].dados)

            if decode.historicocrimes ~= nil then
                if #decode.historicocrimes > 0 then
                    local infracoes = decode.historicocrimes[index].infracoes

                    if #decode.historicocrimes[index].infracoes > 0 then
                        for k,v in pairs(decode.historicocrimes[index].infracoes) do
                            tabela[#tabela+1] = {infracao = v.infracaotexto}
                        end
                    end

                    nomeoficial = decode.historicocrimes[index].policial
                    passaporteoficial = decode.historicocrimes[index].passaporte
                    data = dataFormatada(parseInt(decode.historicocrimes[index].data))
                    descricao = decode.historicocrimes[index].descricao
                    reducaomulta = decode.historicocrimes[index].reducaomulta
                    valormulta = decode.historicocrimes[index].valormulta
                end
            end
        end
    end

    return nomeoficial, passaporteoficial, data, descricao, reducaomulta, valormulta, tabela
end

function skdev.prisoesinformacoes(passaporte,index)
    local source = source
    local user_id = Passportbase(source)

    local passaporte = parseInt(passaporte)
    local index = parseInt(index)

    local nomeoficial = ""
    local passaporteoficial = ""
    local data = ""
    local descricao = ""
    local reducaomulta = 0
    local reducaotempopreso = 0
    local valormulta = 0
    local tempopreso = 0
    local tabela = {}

    local query = Querybase("skdev/informacaoCidadao",{user_id = passaporte},"query")
    if #query > 0 then
        if query[1].dados ~= nil then
            local decode = json.decode(query[1].dados)

            if decode.historicocrimes ~= nil then
                if #decode.historicocrimes > 0 then
                    local infracoes = decode.historicocrimes[index].infracoes

                    if #decode.historicocrimes[index].infracoes > 0 then
                        for k,v in pairs(decode.historicocrimes[index].infracoes) do
                            tabela[#tabela+1] = {infracao = v.infracaotexto}
                        end
                    end

                    nomeoficial = decode.historicocrimes[index].policial
                    passaporteoficial = decode.historicocrimes[index].passaporte
                    data = dataFormatada(parseInt(decode.historicocrimes[index].data))
                    descricao = decode.historicocrimes[index].descricao
                    reducaomulta = decode.historicocrimes[index].reducaomulta
                    reducaotempopreso = decode.historicocrimes[index].reducaotempopreso
                    tempopreso = decode.historicocrimes[index].tempopreso
                    valormulta = decode.historicocrimes[index].valormulta
                end
            end
        end
    end


    return nomeoficial, passaporteoficial, data, descricao, reducaomulta, reducaotempopreso, valormulta, tempopreso, tabela
end

function skdev.consultarveiculosid(passaporte)
    local source = source
    local user_id = Passportbase(source)

    local passaporte = parseInt(passaporte)
    local tabela = {}
    local status = false

    local query = Querybase("skdev/veiculosCidadao",{user_id = passaporte},"query")
    if #query > 0 then
        for k,v in pairs(query) do
            if Vehiclenamebase(v.vehicle) ~= nil then
                tabela[#tabela+1] = {nomedoveiculo = Vehiclenamebase(v.vehicle), veiculo = v.vehicle}
            else
                tabela[#tabela+1] = {nomedoveiculo = v.vehicle, veiculo = v.vehicle}
            end
        end
    end

    if #tabela > 0 then
        status = true
    end

    return tabela, status
end

function skdev.apreenderVeiculo(veiculo,passaporte)
    local source = source
    local user_id = Passportbase(source)

    local passaporte = parseInt(passaporte)

    if verificarPermissaoPolicial(user_id,"apreender veiculos") then
        local dataAtual = os.date("%H") .. ":" .. os.date("%M") .. " " .. os.date("%d") .. "/" .. os.date("%m") .. "/" .. os.date("%Y")
        local webhook = "[TABLET POLICIAL - APREENDER VEICULOS]\n[ID OFICIAL]: "..user_id.."\n[PASSAPORTE VEICULO]: "..passaporte.."\n[VEICULO]: "..veiculo.."\n[DATA]: "..dataAtual..""
        Sendwebhookbase(config.webhook_logs,"```ini\n"..webhook.."```")

        Querybase("skdev/apreenderveiculoCidadao",{vehicle = veiculo, user_id = passaporte, valor = 1},"execute")
        return true
    end

    return false
end

function skdev.statusprocurado(passaporte)
    local source = source
    local user_id = Passportbase(source)
    
    local status = false
    local passaporte = parseInt(passaporte)
    local motivo = ""

    local query = Querybase("skdev/informacaoCidadao",{user_id = passaporte},"query")
    if #query > 0 then
        if query[1].dados ~= nil then
            if #query[1].dados > 0 then
                local decode = json.decode(query[1].dados)
    
                if decode.procurado ~= nil then
                    if #decode.procurado > 0 then
                        status = true
                        motivo = decode.procurado[1].motivo
                    end
                end
            end
        end
    end

    return status, motivo
end

function skdev.confirmarProcuracao(passaporte,motivo)
    local source = source
    local user_id = Passportbase(source)
    
    local status = false
    local passaporte = parseInt(passaporte)
    local tabela = {}

    if verificarPermissaoPolicial(user_id,"alterar procurado") then
        local query = Querybase("skdev/informacaoCidadao",{user_id = passaporte},"query")
        if #query > 0 then
            if query[1].dados ~= nil then
                if #query[1].dados > 0 then
                    local decode = json.decode(query[1].dados)
        
                    if decode.procurado ~= nil then
                        if #decode.procurado > 0 then
                            decode.procurado[1] = {motivo = motivo}
                            tabela = decode
                            Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                        else
                            decode.procurado = {{motivo = motivo}}
                            tabela = decode
                            Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                        end
                    else
                        decode.procurado = {{motivo = motivo}}
                        tabela = decode
                        Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                    end
                else
                    tabela = {procurado = {{motivo = motivo}}}
                    Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                end
            else
                tabela = {procurado = {{motivo = motivo}}}
                Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
            end
        else
            tabela = {procurado = {{motivo = motivo}}}
            Querybase("skdev/inserirdadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
        end

        local dataAtual = os.date("%H") .. ":" .. os.date("%M") .. " " .. os.date("%d") .. "/" .. os.date("%m") .. "/" .. os.date("%Y")
        local webhook = "[TABLET POLICIAL - ALTERAR PROCURADO]\n[ID OFICIAL]: "..user_id.."\n[PASSAPORTE PROCURADO]: "..passaporte.."\n[MOTIVO]: "..motivo.."\n[DATA]: "..dataAtual..""
        Sendwebhookbase(config.webhook_logs,"```ini\n"..webhook.."```")

        status = true
    end

    return status
end

function skdev.statusportedearmas(passaporte)
    local source = source
    local user_id = Passportbase(source)
    
    local status = false
    local passaporte = parseInt(passaporte)
    local nomearma = ""
    local quantidademunicoes = 0

    local query = Querybase("skdev/informacaoCidadao",{user_id = passaporte},"query")
    if #query > 0 then
        if query[1].dados ~= nil then
            if #query[1].dados > 0 then
                local decode = json.decode(query[1].dados)

                if decode.portedearma ~= nil then
                    if #decode.portedearma > 0 then
                        status = true
                        nomearma = decode.portedearma[1].nomearma
                        quantidademunicoes = parseInt(decode.portedearma[1].quantidademunicoes)
                    end
                end
            end
        end
    end

    return status, nomearma, quantidademunicoes
end

function skdev.confirmarPortedearmas(passaporte,nomearma,quantidadedemunicoes)
    local source = source
    local user_id = Passportbase(source)
    
    local status = false
    local passaporte = parseInt(passaporte)
    local quantidadedemunicoes = parseInt(quantidadedemunicoes)
    local tabela = {}

    if verificarPermissaoPolicial(user_id,"alterar porte de armas") then
        local query = Querybase("skdev/informacaoCidadao",{user_id = passaporte},"query")
        if #query > 0 then
            if query[1].dados ~= nil then
                if #query[1].dados > 0 then
                    local decode = json.decode(query[1].dados)
        
                    if decode.portedearma ~= nil then
                        if #decode.portedearma > 0 then
                            decode.portedearma[1] = {nomearma = nomearma, quantidademunicoes = quantidadedemunicoes}
                            tabela = decode
                            Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                        else
                            decode.portedearma = {{nomearma = nomearma, quantidademunicoes = quantidadedemunicoes}}
                            tabela = decode
                            Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                        end
                    else
                        decode.portedearma = {{nomearma = nomearma, quantidademunicoes = quantidadedemunicoes}}
                        tabela = decode
                        Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                    end
                else
                    tabela = {portedearma = {{nomearma = nomearma, quantidademunicoes = quantidadedemunicoes}}}
                    Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                end
            else
                tabela = {portedearma = {{nomearma = nomearma, quantidademunicoes = quantidadedemunicoes}}}
                Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
            end
        else
            tabela = {portedearma = {{nomearma = nomearma, quantidademunicoes = quantidadedemunicoes}}}
            Querybase("skdev/inserirdadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
        end

        local dataAtual = os.date("%H") .. ":" .. os.date("%M") .. " " .. os.date("%d") .. "/" .. os.date("%m") .. "/" .. os.date("%Y")
        local webhook = "[TABLET POLICIAL - ALTERAR PORTE DE ARMAS]\n[ID OFICIAL]: "..user_id.."\n[PASSAPORTE PORTE]: "..passaporte.."\n[NOME DA ARMA]: "..nomearma.."\n[MUNIÇÕES]: "..quantidadedemunicoes.."\n[DATA]: "..dataAtual..""
        Sendwebhookbase(config.webhook_logs,"```ini\n"..webhook.."```")

        status = true
    end

    return status
end

function skdev.enviarimagencidadao(passaporte,link)
    local source = source
    local user_id = Passportbase(source)

    local passaporte = parseInt(passaporte)
    local tabela = {}

    if verificarPermissaoPolicial(user_id,"alterar procurado") then
        local query = Querybase("skdev/informacaoCidadao",{user_id = passaporte},"query")
        if #query > 0 then
            if query[1].dados ~= nil then
                if #query[1].dados > 0 then
                    local decode = json.decode(query[1].dados)

                    if decode.imagen ~= nil then
                        decode.imagen = tostring(link)
                        tabela = decode
                        Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                    else
                        decode.imagen = tostring(link)
                        tabela = decode
                        Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                    end
                else
                    tabela = {imagen = tostring(link)}
                    Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                end
            else
                tabela = {imagen = tostring(link)}
                Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
            end
        else
            tabela = {imagen = tostring(link)}
            Querybase("skdev/inserirdadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
        end
    end
end

function skdev.apreenderCidadao(passaporte,crimes,descricao,reducaomulta,reducaotempo)
    local source = source
    local user_id = Passportbase(source)

    local passaporte = parseInt(passaporte)
    local reducaomulta = parseInt(reducaomulta)
    local reducaotempo = parseInt(reducaotempo)
    local passaporteSource = Getusersourcebase(passaporte)

    local identity = Identitybase(user_id)

    local infracoesTable = {}

    local jogadorPerto = false

    if passaporte ~= user_id then
        if verificarPermissaoPolicial(user_id,"apreender cidadoes") then
            local tempoPreso = 0
            local multaAplicar = 0
        
            local crimesCometidos = {}
            local crimesTabela = config.crimes
        
            for k,v in pairs(crimes) do
                if v ~= nil then
                    table.insert(crimesCometidos,v + 1)
                end
            end
    
            for k,v in pairs(crimes) do
                if v ~= nil then
                    if config.crimes[parseInt(v + 1)] ~= nil then
                        infracoesTable[#infracoesTable+1] = {infracaotexto = config.crimes[parseInt(v + 1)].crime}
                    end
                end
            end
        
            local tempoMaximo = parseInt(config.tempo_maximo_prisao)
            local multaMaxima = parseInt(config.multa_maxima_prisao)
        
            for k,v in pairs(crimesCometidos) do
                if crimesTabela[v] ~= nil then
                    local tempoTBL = parseInt(crimesTabela[v].tempopreso)
                    if tempoTBL ~= nil then
                        if reducaotempo > 0 then
                            tempoPreso = parseInt(tempoPreso + (tempoTBL - (tempoTBL * reducaotempo / 100)))
                        else
                            tempoPreso = tempoPreso + tempoTBL
                        end
        
                        if (tempoPreso >= tempoMaximo) then
                            tempoPreso = tempoMaximo
                        end
                        if (tempoPreso <= 0) then
                            tempoPreso = 0
                        end
                    end
        
                    local multaTBL = parseInt(crimesTabela[v].multa)
                    if multaTBL ~= nil then
                        if reducaomulta > 0 then
                            multaAplicar = parseInt(multaAplicar + (multaTBL - (multaTBL * reducaomulta / 100)))
                        else
                            multaAplicar = multaAplicar + multaTBL
                        end
        
                        if (multaAplicar >= multaMaxima) then
                            multaAplicar = multaMaxima
                        end
                        if (multaAplicar <= 0) then
                            multaAplicar = 0
                        end
                    end
                end
            end
    
            local jogadorPertoPolicial = Getnearestplayerbase(source,10)
            if jogadorPertoPolicial then
                local sourceP = parseInt(jogadorPertoPolicial)
                if sourceP then
                    local userP = Passportbase(sourceP)
                    if userP then
                        if userP == passaporte then
                            jogadorPerto = true
                        end
                    end
                end
            end
    
            if jogadorPerto then
                local valorPrisao = Getuserdatabase(passaporte,"vRP:Prisao")
                local tempoPrisao = 0
                if valorPrisao == "" then
                    tempoPrisao = 0
                else
                    if type(valorPrisao) == "string" then
                        tempoPrisao = json.decode(valorPrisao) or 0
                    else
                        tempoPrisao = parseInt(valorPrisao)
                    end
                end
                local TempoPresoTBL = parseInt(tempoPrisao)
    
                if TempoPresoTBL > 0 then
                    Setuserdatabase(passaporte,"vRP:Prisao",json.encode(TempoPresoTBL + tempoPreso))
                else
                    Setuserdatabase(passaporte,"vRP:Prisao",json.encode(tempoPreso))
                end
    
                local valorMulta = Getuserdatabase(passaporte,"vRP:Multas")
                local tempoMulta = 0
                if valorMulta == "" then
                    tempoMulta = 0
                else
                    if type(valorMulta) == "string" then
                        tempoMulta = json.decode(valorMulta) or 0
                    else
                        tempoMulta = parseInt(valorMulta)
                    end
                end
                local TempoMultaTBL = parseInt(tempoMulta)
    
                if TempoMultaTBL > 0 then
                    Setuserdatabase(passaporte,"vRP:Multas",json.encode(TempoMultaTBL + multaAplicar))
                else
                    Setuserdatabase(passaporte,"vRP:Multas",json.encode(multaAplicar))
                end
    
                vCLIENT.prenderjogador(passaporteSource,true)
                Teleportebase(passaporteSource,1680.1,2513.0,46.5)
                prenderjogador(passaporte)
    
                TriggerClientEvent("removealgemas",passaporteSource)
    
                local query = Querybase("skdev/informacaoCidadao",{user_id = passaporte},"query")
                if #query > 0 then
                    if query[1].dados ~= nil then
                        if #query[1].dados > 0 then
                            local decode = json.decode(query[1].dados)
                
                            if decode.historicocrimes ~= nil then
                                if #decode.historicocrimes > 0 then
                                    decode.historicocrimes[#decode.historicocrimes+1] = {infracoes = infracoesTable, policial = identity.name.." "..identity.name2, passaporte = user_id, data = os.time(), descricao = descricao, reducaomulta = reducaomulta, reducaotempopreso = reducaotempo, tempopreso = tempoPreso, valormulta = multaAplicar, tipo = "PRISÃO"}
                                    tabela = decode
                                    Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                                else
                                    decode.historicocrimes = {{infracoes = infracoesTable, policial = identity.name.." "..identity.name2, passaporte = user_id, data = os.time(), descricao = descricao, reducaomulta = reducaomulta, reducaotempopreso = reducaotempo, tempopreso = tempoPreso, valormulta = multaAplicar, tipo = "PRISÃO"}}
                                    tabela = decode
                                    Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                                end
                            else
                                decode.historicocrimes = {{infracoes = infracoesTable, policial = identity.name.." "..identity.name2, passaporte = user_id, data = os.time(), descricao = descricao, reducaomulta = reducaomulta, reducaotempopreso = reducaotempo, tempopreso = tempoPreso, valormulta = multaAplicar, tipo = "PRISÃO"}}
                                tabela = decode
                                Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                            end
                        else
                            tabela = {historicocrimes = {{infracoes = infracoesTable, policial = identity.name.." "..identity.name2, passaporte = user_id, data = os.time(), descricao = descricao, reducaomulta = reducaomulta, reducaotempopreso = reducaotempo, tempopreso = tempoPreso, valormulta = multaAplicar, tipo = "PRISÃO"}}}
                            Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                        end
                    else
                        tabela = {historicocrimes = {{infracoes = infracoesTable, policial = identity.name.." "..identity.name2, passaporte = user_id, data = os.time(), descricao = descricao, reducaomulta = reducaomulta, reducaotempopreso = reducaotempo, tempopreso = tempoPreso, valormulta = multaAplicar, tipo = "PRISÃO"}}}
                        Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                    end
                else
                    tabela = {historicocrimes = {{infracoes = infracoesTable, policial = identity.name.." "..identity.name2, passaporte = user_id, data = os.time(), descricao = descricao, reducaomulta = reducaomulta, reducaotempopreso = reducaotempo, tempopreso = tempoPreso, valormulta = multaAplicar, tipo = "PRISÃO"}}}
                    Querybase("skdev/inserirdadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                end
    
                local prisoesrealizadas = parseInt(informacaoOficialLocal(user_id,"prisoesrealizadas"))
                local multasaplicadas = parseInt(informacaoOficialLocal(user_id,"multasaplicadas"))
                local boletinsregistrados = parseInt(informacaoOficialLocal(user_id,"boletinsregistrados"))
    
                local queryLocal = Querybase("skdev/informacaoOficial",{user_id = user_id},"query")
                if #queryLocal > 0 then
                    Querybase("skdev/updateDadosOficial",{user_id = user_id, prisoesrealizadas = prisoesrealizadas + 1, multasaplicadas = multasaplicadas + 1, boletinsregistrados = boletinsregistrados},"execute")
                else
                    Querybase("skdev/replaceDadosOficial",{user_id = user_id, prisoesrealizadas = prisoesrealizadas + 1, multasaplicadas = multasaplicadas + 1, boletinsregistrados = boletinsregistrados},"execute")
                end
    
                local dataAtual = os.date("%H") .. ":" .. os.date("%M") .. " " .. os.date("%d") .. "/" .. os.date("%m") .. "/" .. os.date("%Y")
                local webhook = "[TABLET POLICIAL - APREENDER CIDADÃO]\n[ID OFICIAL]: "..user_id.."\n[PASSAPORTE APREENDIDO]: "..passaporte.."\n[DESCRIÇÃO]: "..descricao.."\n[TEMPO PRESO]: "..tempoPreso.."\n[VALOR DA MULTA]: "..multaAplicar.."\n[DATA]: "..dataAtual..""
                Sendwebhookbase(config.webhook_logs,"```ini\n"..webhook.."```")
    
                return true
            end
        end
    end

    return false
end

local playerspawn = "vrpex"
if baseatual == "vrpex" then
    playerspawn = "vRP:playerSpawn"
else
    playerspawn = "playerConnect"
end


AddEventHandler(playerspawn,function(user_id,source)
	local source = source
    local user_id = user_id
    
	if source then
		SetTimeout(1000, function()
			local value = Getuserdatabase(user_id,"vRP:Prisao")
            local tempo = -1
            if value == "" then
                tempo = -1
            else
                if type(value) == "string" then
                    tempo = json.decode(value) or -1
                else
                    tempo = parseInt(value)
                end
            end

			if tempo == -1 then
				return false
			end

			if tempo > 0 then
				Teleportebase(source,1680.1,2513.0,46.5)
				prenderjogador(user_id)
                vCLIENT.prenderjogador(source,true)
			end
		end)
	end
end)

function prenderjogador(target_id)
    local user_id = parseInt(target_id)
	local source = Getusersourcebase(user_id)

	if source then
		SetTimeout(30000, function()
			local value = Getuserdatabase(user_id,"vRP:Prisao")
            local tempo = 0
            if value == "" then
                tempo = 0
            else
                if type(value) == "string" then
                    tempo = json.decode(value) or 0
                else
                    tempo = parseInt(value)
                end
            end
            local tempopreso = parseInt(tempo)

			if tempopreso >= 1 then
				Setuserdatabase(user_id,"vRP:Prisao",json.encode(tempopreso - 1))

				prenderjogador(user_id)
				TriggerClientEvent("Notify",source,"importante","Ainda vai passar <b>"..tempopreso.." meses</b> preso.")
			elseif tempopreso <= 0 then
                vCLIENT.prenderjogador(source,false)
				Teleportebase(source,1850.5,2604.0,45.5)

				Setuserdatabase(user_id,"vRP:Prisao",json.encode(-1))

				TriggerClientEvent("Notify",source,"importante","Sua sentença terminou, esperamos não ve-lo novamente.")
			end
		end)
	end
end
 
function skdev.diminuirpenapresidio()
	local source = source
	local user_id = Passportbase(source)

	local value = Getuserdatabase(user_id,"vRP:Prisao")
    local tempo = 0
    if value == "" then
        tempo = 0
    else
        if type(value) == "string" then
            tempo = json.decode(value) or 0
        else
            tempo = parseInt(value)
        end
    end
    local tempopreso = parseInt(tempo)

    local tempominimo = parseInt(config.tempo_minimo_caixas)
    local tempodiminuir = parseInt(config.diminuir_tempo_caixas)

    if tempopreso >= tempominimo then
        Setuserdatabase(user_id,"vRP:Prisao",json.encode(tempopreso - tempodiminuir))

        TriggerClientEvent("Notify",source,"importante","Sua pena foi reduzida em <b>"..tempodiminuir.." meses</b>, continue o trabalho.")
    else
        TriggerClientEvent("Notify",source,"importante","Atingiu o limite da redução de pena, não precisa mais trabalhar.")
    end
end

function skdev.multarCidadao(passaporte,crimes,descricao,reducaomulta)
    local source = source
    local user_id = Passportbase(source)

    local passaporte = parseInt(passaporte)
    local reducaomulta = parseInt(reducaomulta)
    local passaporteSource = Getusersourcebase(passaporte)

    local identity = Identitybase(user_id)

    local infracoesTable = {}

    local jogadorPerto = false

    if passaporte ~= user_id then
        if verificarPermissaoPolicial(user_id,"apreender cidadoes") then
            local multaAplicar = 0
        
            local crimesCometidos = {}
            local crimesTabela = config.crimes
        
            for k,v in pairs(crimes) do
                if v ~= nil then
                    table.insert(crimesCometidos,v + 1)
                end
            end

            for k,v in pairs(crimes) do
                if v ~= nil then
                    if config.crimes[parseInt(v + 1)] ~= nil then
                        infracoesTable[#infracoesTable+1] = {infracaotexto = config.crimes[parseInt(v + 1)].crime}
                    end
                end
            end

            local multaMaxima = parseInt(config.multa_maxima_prisao)
        
            for k,v in pairs(crimesCometidos) do
                if crimesTabela[v] ~= nil then
                    local multaTBL = parseInt(crimesTabela[v].multa)
                    if multaTBL ~= nil then
                        if reducaomulta > 0 then
                            multaAplicar = parseInt(multaAplicar + (multaTBL - (multaTBL * reducaomulta / 100)))
                        else
                            multaAplicar = multaAplicar + multaTBL
                        end
        
                        if (multaAplicar >= multaMaxima) then
                            multaAplicar = multaMaxima
                        end
                        if (multaAplicar <= 0) then
                            multaAplicar = 0
                        end
                    end
                end
            end

            local valorMulta = Getuserdatabase(passaporte,"vRP:Multas")
            local tempoMulta = 0
            if valorMulta == "" then
                tempoMulta = 0
            else
                if type(valorMulta) == "string" then
                    tempoMulta = json.decode(valorMulta) or 0
                else
                    tempoMulta = parseInt(valorMulta)
                end
            end
            local TempoMultaTBL = parseInt(tempoMulta)

            if TempoMultaTBL > 0 then
                Setuserdatabase(passaporte,"vRP:Multas",json.encode(TempoMultaTBL + multaAplicar))
            else
                Setuserdatabase(passaporte,"vRP:Multas",json.encode(multaAplicar))
            end

            local query = Querybase("skdev/informacaoCidadao",{user_id = passaporte},"query")
            if #query > 0 then
                if query[1].dados ~= nil then
                    if #query[1].dados > 0 then
                        local decode = json.decode(query[1].dados)

                        if decode.historicocrimes ~= nil then
                            if #decode.historicocrimes > 0 then
                                decode.historicocrimes[#decode.historicocrimes+1] = {infracoes = infracoesTable, policial = identity.name.." "..identity.name2, passaporte = user_id, data = os.time(), descricao = descricao, reducaomulta = reducaomulta, valormulta = multaAplicar, tipo = "MULTA"}
                                tabela = decode
                                Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                            else
                                decode.historicocrimes = {{infracoes = infracoesTable, policial = identity.name.." "..identity.name2, passaporte = user_id, data = os.time(), descricao = descricao, reducaomulta = reducaomulta, valormulta = multaAplicar, tipo = "MULTA"}}
                                tabela = decode
                                Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                            end
                        else
                            decode.historicocrimes = {{infracoes = infracoesTable, policial = identity.name.." "..identity.name2, passaporte = user_id, data = os.time(), descricao = descricao, reducaomulta = reducaomulta, valormulta = multaAplicar, tipo = "MULTA"}}
                            tabela = decode
                            Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                        end
                    else
                        tabela = {historicocrimes = {{infracoes = infracoesTable, policial = identity.name.." "..identity.name2, passaporte = user_id, data = os.time(), descricao = descricao, reducaomulta = reducaomulta, valormulta = multaAplicar, tipo = "MULTA"}}}
                        Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                    end
                else
                    tabela = {historicocrimes = {{infracoes = infracoesTable, policial = identity.name.." "..identity.name2, passaporte = user_id, data = os.time(), descricao = descricao, reducaomulta = reducaomulta, valormulta = multaAplicar, tipo = "MULTA"}}}
                    Querybase("skdev/updatedadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
                end
            else
                tabela = {historicocrimes = {{infracoes = infracoesTable, policial = identity.name.." "..identity.name2, passaporte = user_id, data = os.time(), descricao = descricao, reducaomulta = reducaomulta, valormulta = multaAplicar, tipo = "MULTA"}}}
                Querybase("skdev/inserirdadoscidadao",{user_id = passaporte, valor = json.encode(tabela)},"execute")
            end

            local prisoesrealizadas = parseInt(informacaoOficialLocal(user_id,"prisoesrealizadas"))
            local multasaplicadas = parseInt(informacaoOficialLocal(user_id,"multasaplicadas"))
            local boletinsregistrados = parseInt(informacaoOficialLocal(user_id,"boletinsregistrados"))

            local queryLocal = Querybase("skdev/informacaoOficial",{user_id = user_id},"query")
            if #queryLocal > 0 then
                Querybase("skdev/updateDadosOficial",{user_id = user_id, prisoesrealizadas = prisoesrealizadas, multasaplicadas = multasaplicadas + 1, boletinsregistrados = boletinsregistrados},"execute")
            else
                Querybase("skdev/replaceDadosOficial",{user_id = user_id, prisoesrealizadas = prisoesrealizadas, multasaplicadas = multasaplicadas + 1, boletinsregistrados = boletinsregistrados},"execute")
            end

            local dataAtual = os.date("%H") .. ":" .. os.date("%M") .. " " .. os.date("%d") .. "/" .. os.date("%m") .. "/" .. os.date("%Y")
            local webhook = "[TABLET POLICIAL - MULTAR CIDADÃO]\n[ID OFICIAL]: "..user_id.."\n[PASSAPORTE MULTADO]: "..passaporte.."\n[DESCRIÇÃO]: "..descricao.."\n[VALOR DA MULTA]: "..multaAplicar.."\n[DATA]: "..dataAtual..""
            Sendwebhookbase(config.webhook_logs,"```ini\n"..webhook.."```")

            return true
        end
    end

    return false
end

function skdev.consultarprocurados()
    local source = source
    local user_id = Passportbase(source)

    local status = true
    local tabelaPlayer = {}
    local tabelaVeiculos = {}

    local allBoletins = Querybase("skdev/informacaoBoletinsAll",nil,"query")
    if #allBoletins > 0 then
        for b,c in pairs(allBoletins) do
            local dados = json.decode(c.dados)

            if c.tipo == "CIDADAO" then
                tabelaPlayer[#tabelaPlayer+1] = {nomerequerente = dados.nomerequerente, nomedooficial = dados.nomedooficial, razaoprocurado = dados.razaoprocurado, descricao = dados.descricao, dataprocurado = dataFormatada(dados.dataprocurado), caracteristica = dados.caracteristica, timestamp = parseInt(c.boletin)}
            end

            if c.tipo == "VEICULO" then
                tabelaVeiculos[#tabelaVeiculos+1] = {nomerequerente = dados.nomerequerente, nomedooficial = dados.nomedooficial, razaoprocurado = dados.razaoprocurado, descricao = dados.descricao, dataprocurado = dataFormatada(dados.dataprocurado), modeloveiculo = dados.modeloveiculo, corveiculo = dados.corveiculo, placaveiculo = dados.placaveiculo, timestamp = parseInt(c.boletin)}
            end
        end
    end

    return status, tabelaPlayer, tabelaVeiculos
end

function skdev.confirmarBoletinIndividuo(nomedorequerente,caracteristicasindividuo,razaodoboletin,descricaodoboletin)
    local source = source
    local user_id = Passportbase(source)

    local identity = Identitybase(user_id)

    if verificarPermissaoPolicial(user_id,"fazer boletin") then
        Querybase("skdev/insertBoletins",{tipo = "CIDADAO", boletin = os.time(), dados = json.encode({nomerequerente = nomedorequerente, nomedooficial = identity.name.." "..identity.name2, razaoprocurado = razaodoboletin, descricao = descricaodoboletin, dataprocurado = os.time(), caracteristica = caracteristicasindividuo})},"execute")

        local policiais = Getusersbypermissionsbase(config.permissao_patrulha)
        for k,v in pairs(policiais) do
            local pSource = Getusersourcebase(parseInt(v))
            if pSource then
                vCLIENT.notificacao(pSource,"Um Oficial acabou de registrar um boletin, vá ao tablet para saber mais!")
                vCLIENT.atualizarprocurados(pSource)
            end
        end

        return true
    end

    return false
end

function skdev.confirmarBoletinVeiculo(nomedorequerente, modeloveiculo, corveiculo, placaveiculo, razaoboletin, descricaoboletin)
    local source = source
    local user_id = Passportbase(source)

    local identity = Identitybase(user_id)

    if verificarPermissaoPolicial(user_id,"fazer boletin") then
        Querybase("skdev/insertBoletins",{tipo = "VEICULO", boletin = os.time(), dados = json.encode({nomerequerente = nomedorequerente, nomedooficial = identity.name.." "..identity.name2, razaoprocurado = razaoboletin, descricao = descricaoboletin, dataprocurado = os.time(), modeloveiculo = modeloveiculo, corveiculo = corveiculo, placaveiculo = placaveiculo})},"execute")

        local policiais = Getusersbypermissionsbase(config.permissao_patrulha)
        for k,v in pairs(policiais) do
            local pSource = Getusersourcebase(parseInt(v))
            if pSource then
                vCLIENT.notificacao(pSource,"Um Oficial acabou de registrar um boletin, vá ao tablet para saber mais!")
                vCLIENT.atualizarprocurados(pSource)
            end
        end

        return true
    end

    return false
end

function skdev.consultarboletincidadao(timestamp)
    local source = source
    local user_id = Passportbase(source)

    local status = false
    local timestamp = parseInt(timestamp)

    local nomerequerente = ""
    local nomedooficial = ""
    local caracteristica = ""
    local razaoprocurado = ""
    local descricao = ""
    local dataprocurado = ""

    local allBoletins = Querybase("skdev/informacaoBoletinsAll",nil,"query")
    if #allBoletins > 0 then
        for b,c in pairs(allBoletins) do
            local dados = json.decode(c.dados)

            if parseInt(c.boletin) == timestamp then
                nomerequerente = dados.nomerequerente
                nomedooficial = dados.nomedooficial
                caracteristica = dados.caracteristica
                razaoprocurado = dados.razaoprocurado
                descricao = dados.descricao
                dataprocurado = dataFormatada(dados.dataprocurado)

                status = true
            end
        end
    end

    return status, nomerequerente, nomedooficial, caracteristica, razaoprocurado, descricao, dataprocurado
end

function skdev.consultarboletinveiculo(timestamp)
    local source = source
    local user_id = Passportbase(source)

    local status = false
    local timestamp = parseInt(timestamp)

    local nomerequerente = ""
    local nomedooficial = ""
    local modeloveiculo = ""
    local corveiculo = ""
    local placaveiculo = ""
    local razaoprocurado = ""
    local descricao = ""
    local dataprocurado = ""

    local allBoletins = Querybase("skdev/informacaoBoletinsAll",nil,"query")
    if #allBoletins > 0 then
        for b,c in pairs(allBoletins) do
            local dados = json.decode(c.dados)

            if parseInt(c.boletin) == timestamp then
                nomerequerente = dados.nomerequerente
                nomedooficial = dados.nomedooficial
                modeloveiculo = dados.modeloveiculo
                corveiculo = dados.corveiculo
                placaveiculo = dados.placaveiculo
                razaoprocurado = dados.razaoprocurado
                descricao = dados.descricao
                dataprocurado = dataFormatada(dados.dataprocurado)

                status = true
            end
        end
    end

    return status, nomerequerente, nomedooficial, modeloveiculo, corveiculo, placaveiculo, razaoprocurado, descricao, dataprocurado
end

function skdev.removerBoletinCidadao(timestamp)
    local source = source
    local user_id = Passportbase(source)

    local status = false
    local timestamp = parseInt(timestamp)

    if verificarPermissaoPolicial(user_id,"deletar boletins") then
        Querybase("skdev/deleteBoletins",{boletin = timestamp},"execute")

        local policiais = Getusersbypermissionsbase(config.permissao_patrulha)
        for k,v in pairs(policiais) do
            local pSource = Getusersourcebase(parseInt(v))
            if pSource then
                vCLIENT.atualizarprocurados(pSource)
            end
        end

        status = true
    end

    return status
end

function skdev.removerBoletinVeiculo(timestamp)
    local source = source
    local user_id = Passportbase(source)

    local status = false
    local timestamp = parseInt(timestamp)

    if verificarPermissaoPolicial(user_id,"deletar boletins") then
        Querybase("skdev/deleteBoletins",{boletin = timestamp},"execute")

        local policiais = Getusersbypermissionsbase(config.permissao_patrulha)
        for k,v in pairs(policiais) do
            local pSource = Getusersourcebase(parseInt(v))
            if pSource then
                vCLIENT.atualizarprocurados(pSource)
            end
        end

        status = true
    end

    return status
end

function permissaoPegarArma(user_id,index)
    local user_id = parseInt(user_id)

    for k,v in pairs(config.cargos) do
        local indexPermissionv6 = 0
        if v.index_permissao then
            indexPermissionv6 = v.index_permissao
        end
        if HasPermissionbase(user_id, v.permissao_ingame, indexPermissionv6) then
            for b,c in pairs(v.armamentos_permitidos) do
                if c ~= nil then
                    if parseInt(c) == index then
                        return true
                    end
                end
            end
        end
    end

    return false
end

function skdev.consultarArsenal()
    local source = source
    local user_id = Passportbase(source)

    local armamentos = config.armamentos

    local tabela = {}

    if #armamentos > 0 then
        for k,v in pairs(armamentos) do
            tabela[#tabela+1] = {nomearma = v.nomenopainel, arma = k,image = v.imagem, permitido = permissaoPegarArma(user_id,parseInt(k))}
        end

        return true,tabela
    end

    return false,false
end

function skdev.equiparArma(indexArma)
    local source = source
    local user_id = Passportbase(source)

    local arma = parseInt(indexArma)
    local armamentos = config.armamentos

    local status = false

    if permissaoPegarArma(user_id,arma) then
        if armamentos[arma].equipar == "kitbasico" then
            Setarmourbase(source,100)
            if Getinventoryweightbase(user_id) < Getinventorymaxweightbase(user_id) and (Getitemweightbase("radio") + Getinventoryweightbase(user_id)) < Getinventorymaxweightbase(user_id) then
                Giveinventoryitembase(user_id,"radio",1)
            end
            Giveinventoryitembase(user_id,"WEAPON_STUNGUN",1)

        elseif armamentos[arma].equipar == "colete" then
            Setarmourbase(source,100)

        else
            Giveinventoryitembase(user_id,armamentos[arma].equipar,1)
            Giveinventoryitembase(user_id,armamentos[arma].municoes,1)
        end

        local dataAtual = os.date("%H") .. ":" .. os.date("%M") .. " " .. os.date("%d") .. "/" .. os.date("%m") .. "/" .. os.date("%Y")
        local webhook = "[TABLET POLICIAL - ARSENAL]\n[ID OFICIAL]: "..user_id.."\n[ARMA]: "..armamentos[arma].equipar.."\n[MUNIÇÃO]: "..parseInt(armamentos[arma].municoes).."\n[DATA]: "..dataAtual..""
        Sendwebhookbase(config.webhook_logs,"```ini\n"..webhook.."```")

        status = true
    end

    return status
end

function skdev.removerArmas()
    local source = source
    local user_id = Passportbase(source)

    local arma = parseInt(indexArma)
    local armamentos = config.armamentos

    local status = false

    for k,v in pairs(armamentos) do
        if v.equipar ~= nil or v.equipar ~= "" then
            local amountitem = Getamountofitembase(user_id,v.equipar)
            if amountitem > 0 then
                Trygetinventoryitembase(user_id,v.equipar,parseInt(amountitem))
            end
        end
        if v.municoes ~= nil or v.municoes ~= "" then
            local amountitem = Getamountofitembase(user_id,v.municoes)
            if amountitem > 0 then
                Trygetinventoryitembase(user_id,v.municoes,parseInt(amountitem))
            end
        end
    end
    status = true

    return status
end