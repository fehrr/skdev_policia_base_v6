config = {}

baseatual = "creativev6" -- vrpex, creativev1,creativev2,creativev3,creativev4,creativev5,creativev6

config.localimagens = "" -- sem o / no final!!
config.permissao_patrulha = "PMRJ" -- permissão dos policiais que estão em patrulhamento

config.database_veiculos = {"vehicles","Passport","vehicle","arrest"} -- Parametros: [1] - Nome da tabela, [2] - Coluna de user id, [3] - Coluna do nome do veiculo, [4] - Coluna de detido

config.webhook_logs = "https://discord.com/api/webhooks/1243633971972014311/IqXWe5WSpu4C4TaUNwxCyOF8hALlPyBgjva9OHoVM1B0t35KeCvk8_ZiD1SgRvuFRX_n" -- logs do painel
config.webhook_imagens = "https://discord.com/api/webhooks/1243633887993794670/oBCCc_qqJPXM2jMAVndQrezTnAhMJSKQhnC1pwBLEmkQ3tXjEpcTKkz0puXa2zle2I_P"

config.tempo_maximo_prisao = 120 -- em minutos
config.multa_maxima_prisao = 1000000 -- multa máxima serve para apreensão e multar
config.tempo_minimo_caixas = 5 -- tempo minimo para reduzir tempo preso nas caixas
config.diminuir_tempo_caixas = 2 -- em minutos esse valor irá ser diminuido a cada caixa pega no presidio

config.pegar_caixas_cordenadas = {1691.59,2566.05,45.56}
config.entregar_caixas_cordenadas = {1669.51,2487.71,45.82}

config.cargos = { -- "avisar membros","apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"
    {
        nome_no_painel = "Chefe - PMRJ",
        permissao_ingame = "PMRJ",
        index_permissao = 1,

        permissoes_painel = {"avisar membros","apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Capitão - PMRJ",
        permissao_ingame = "PMRJ",
        index_permissao = 2,

        permissoes_painel = {"avisar membros","apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Tenente - PMRJ",
        permissao_ingame = "PMRJ",
        index_permissao = 3,

        permissoes_painel = {"apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Sargento - PMRJ",
        permissao_ingame = "PMRJ",
        index_permissao = 4,

        permissoes_painel = {"apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Corporal - PMRJ",
        permissao_ingame = "PMRJ",
        index_permissao = 5,

        permissoes_painel = {"apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Oficial - PMRJ",
        permissao_ingame = "PMRJ",
        index_permissao = 6,

        permissoes_painel = {"apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Cadete - PMRJ",
        permissao_ingame = "PMRJ",
        index_permissao = 7,

        permissoes_painel = {"apreender veiculos","alterar procurado","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Chefe - Prf",
        permissao_ingame = "Prf",
        index_permissao = 1,

        permissoes_painel = {"avisar membros","apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Capitão - Prf",
        permissao_ingame = "Prf",
        index_permissao = 2,

        permissoes_painel = {"avisar membros","apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Tenente - Prf",
        permissao_ingame = "Prf",
        index_permissao = 3,

        permissoes_painel = {"apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Sargento - Prf",
        permissao_ingame = "Prf",
        index_permissao = 4,

        permissoes_painel = {"apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Corporal - Prf",
        permissao_ingame = "Prf",
        index_permissao = 5,

        permissoes_painel = {"apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Oficial - Prf",
        permissao_ingame = "Prf",
        index_permissao = 6,

        permissoes_painel = {"apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Cadete - Prf",
        permissao_ingame = "Prf",
        index_permissao = 7,

        permissoes_painel = {"apreender veiculos","alterar procurado","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Chefe - Civil",
        permissao_ingame = "Civil",
        index_permissao = 1,

        permissoes_painel = {"avisar membros","apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Capitão - Civil",
        permissao_ingame = "Civil",
        index_permissao = 2,

        permissoes_painel = {"avisar membros","apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Tenente - Civil",
        permissao_ingame = "Civil",
        index_permissao = 3,

        permissoes_painel = {"apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Sargento - Civil",
        permissao_ingame = "Civil",
        index_permissao = 4,

        permissoes_painel = {"apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Corporal - Civil",
        permissao_ingame = "Civil",
        index_permissao = 5,

        permissoes_painel = {"apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Oficial - Civil",
        permissao_ingame = "Civil",
        index_permissao = 6,

        permissoes_painel = {"apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Cadete - Civil",
        permissao_ingame = "Civil",
        index_permissao = 7,

        permissoes_painel = {"apreender veiculos","alterar procurado","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Comando - BOPE",
        permissao_ingame = "BOPE",
        index_permissao = 1,

        permissoes_painel = {"avisar membros","apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Capitão - BOPE",
        permissao_ingame = "BOPE",
        index_permissao = 2,

        permissoes_painel = {"avisar membros","apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Tenente - BOPE",
        permissao_ingame = "BOPE",
        index_permissao = 3,

        permissoes_painel = {"apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Sargento - BOPE",
        permissao_ingame = "BOPE",
        index_permissao = 4,

        permissoes_painel = {"apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Cabo - BOPE",
        permissao_ingame = "BOPE",
        index_permissao = 5,

        permissoes_painel = {"apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Soldado - BOPE",
        permissao_ingame = "BOPE",
        index_permissao = 6,

        permissoes_painel = {"apreender veiculos","alterar procurado","alterar porte de armas","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4,5,6,7} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
    {
        nome_no_painel = "Aluno - BOPE",
        permissao_ingame = "BOPE",
        index_permissao = 7,

        permissoes_painel = {"apreender veiculos","alterar procurado","apreender cidadoes","fazer boletin","deletar boletins"},

        armamentos_permitidos = {1,2,3,4} -- na configuração de armamento tem os index que no caso são : [1] = {} você vai coloca separado por virgula os permitidos
    },
}

config.armamentos = { -- predefinições equipar: kitbasico,colete,nome_do_item
    [1] = {nomenopainel = "Kit Básico", equipar = "kitbasico", imagem = "kitbasico"},
    [2] = {nomenopainel = "Colete", equipar = "colete", imagem = "colete"},
    [3] = {nomenopainel = "Glock", equipar = "WEAPON_COMBATPISTOL", municoes = "WEAPON_PISTOL_AMMO", imagem = "glock"},
    [4] = {nomenopainel = "M4A4", equipar = "WEAPON_CARBINERIFLE", municoes = "WEAPON_RIFLE_AMMO", imagem = "m4a4"},
    [5] = {nomenopainel = "MPX", equipar = "WEAPON_CARBINERIFLE_MK2", municoes = "WEAPON_RIFLE_AMMO", imagem = "mpx"},
    [6] = {nomenopainel = "MP5", equipar = "WEAPON_SMG", municoes = "WEAPON_SMG_AMMO", imagem = "mp5"},
    [7] = {nomenopainel = "SHOTGUN", equipar = "WEAPON_PUMPSHOTGUN_MK2", municoes = "WEAPON_RIFLE_AMMO", imagem = "remington"},
}

config.crimes = {
    {crime="Abandono de Aeronave", tempopreso = 0, multa = 500000 },
    {crime="Danos a Terceiro/Patrimônio", tempopreso = 0, multa = 100000 },
    {crime="Pousar em local proibido", tempopreso = 0, multa = 400000 },
    {crime="Transporte de cargas ilícitas", tempopreso = 100, multa = 400000 },

    {crime="Condução Perigosa", tempopreso = 0, multa = 20000 },
    {crime="Conduzir veículos acima da velocidade permitida, acima: 100kmh", tempopreso = 0, multa = 10000 },
    {crime="Disputas de corridas ilegais", tempopreso = 25, multa = 50000 },
    {crime="Estacionar em local proibido", tempopreso = 0, multa = 10000 },
    {crime="Estacionar/Parar na contra mão", tempopreso = 0, multa = 25000 },
    {crime="Fuga de abordagem policial", tempopreso = 20, multa = 30000 },

    {crime="Ameaça", tempopreso = 30, multa = 30000 },
    {crime="Assalto a banco", tempopreso = 100, multa = 600000 },
    {crime="Assalto a caixinha", tempopreso = 15, multa = 35000 },
    {crime="Assalto a joalheria", tempopreso = 60, multa = 60000 },
    {crime="Assalto a loja", tempopreso = 60, multa = 100000 },
    {crime="Calúnia, Injúria & Difamação", tempopreso = 30, multa = 10000 },
    {crime="Desacato", tempopreso = 35, multa = 25000 },
    {crime="Desobediência", tempopreso = 25, multa = 15000 },
    {crime="Estelionato", tempopreso = 35, multa = 25000 },
    {crime="Extorsão", tempopreso = 15, multa = 15000 },
    {crime="Falsidade Ideológica", tempopreso = 20, multa = 7000 },
    {crime="Falso Testemunho", tempopreso = 25, multa = 27000 },
    {crime="Formação de quadrilha", tempopreso = 30, multa = 25000 },
    {crime="Furto", tempopreso = 15, multa = 15000 },
    {crime="Homicídio Culposo", tempopreso = 30, multa = 40000 },
    {crime="Homicídio Doloso", tempopreso = 70, multa = 90000 },
    {crime="Latrocínio", tempopreso = 70, multa = 100000 },
    {crime="Porte de armas brancas", tempopreso = 10, multa = 10000 },
    {crime="Porte ilegal de armas leves", tempopreso = 25, multa = 25000 },
    {crime="Porte ilegal de armas médicas", tempopreso = 35, multa = 40000 },
    {crime="Porte ilegal de armas pesadas", tempopreso = 45, multa = 50000 },
    {crime="Porte ilegal de dinheiro sujo", tempopreso = 25, multa = 30000 },
    {crime="Porte ilegal de itens ilegais", tempopreso = 10, multa = 3000 },
    {crime="Porte ilegal de munições", tempopreso = 10, multa = 15000 },
    {crime="Roubo", tempopreso = 30, multa = 50000 },
    {crime="Roubo a residência", tempopreso = 25, multa = 70000 },
    {crime="Sequestro", tempopreso = 60, multa = 50000 },
    {crime="Tentativa de homicídio", tempopreso = 70, multa = 40000 },
    {crime="Tentativa de suborno", tempopreso = 35, multa = 50000 },
    {crime="Tráfico de Armas", tempopreso = 30, multa = 60000 },
    {crime="Tráfico de Drogas", tempopreso = 20, multa = 10000 },
    {crime="Uso de equipamento balístico", tempopreso = 0, multa = 35000 },
    {crime="Ocultação facial", tempopreso = 0, multa = 30000 },

    {crime="Corrupção Passiva", tempopreso = 60, multa = 200000 },
    {crime="Portar armamanto fora da patente", tempopreso = 25, multa = 12000 },
    {crime="Vazamento de informações confidênciais", tempopreso = 160, multa = 250000 },
    {crime="Abandono de VTR", tempopreso = 0, multa = 10000 },
    {crime="Caixa 2", tempopreso = 30, multa = 250000 },
}