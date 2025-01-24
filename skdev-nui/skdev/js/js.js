let idconsulta = 0;
let idapreender = 0;
let infracoes = [];
let tempoprisaoatual = 0;
let tempoprisaoatualreal = 0;
let multavaloratual = 0;
let multavaloratualreal = 0;
let multamaxima = 0;
let tempomaximo = 0;
function GerenciarMenu(menu) {
    if (menu) {
        if (menu === "Inicio") {
            $(".menu2").html("");

            $(".menu2").css("animation","none");
            void $(".menu2")[0].offsetWidth;
            $(".menu2").css("animation","menu2aparecer 2s forwards");

            $(".botao_menu1").removeAttr("menuativo");
            $(".buttonmenu1").attr("menuativo","");

            $.post(`https://${GetParentResourceName()}/menuprincipal`, JSON.stringify({}), (data) => {
                $(".menu2").html(`
                <div class="informacoes_menu2">
					<div class="informacao_menu2">
						<h2>POLICIAIS<br>EM PATRULHA</h2>
						<h3>${data.policiaispatrulha}</h3>
					</div>
					<div class="informacao_menu2">
						<h2>PRISÕES<br>REALIZADAS</h2>
						<h3>${data.prisoesrealizadas}</h3>
					</div>
					<div class="informacao_menu2">
						<h2>MULTAS<br>APLICADAS</h2>
						<h3>${data.multasaplicadas}</h3>
					</div>
					<div class="informacao_menu2">
						<h2>BOLETINS<br>REGISTRADOS</h2>
						<h3>${data.boletinsregistrados}</h3>
					</div>
				</div>

                <div class="muralavisos_menu2">
					<h2>MURAL DE AVISOS</h2>
					<div class="containermuralavisos">
					</div>
					<div class="chatmuralavisos">
					</div>
				</div>
                `);

                if (data.muralpermissao) {
                    $(".chatmuralavisos").html(`
                        <input type="text" class="chatinput">
                        <div class="imgchat" onclick="enviarAviso()">
                            <img src="./skdev/img/send.png" draggable="false">
                        </div>
                    `);
                };

                const tabelaAvisos = data.tabela;
                for (let i = tabelaAvisos.length - 1; i >= 0; i--) {
                    const texto = tabelaAvisos[i];
                    const index = i;

                    if (texto.meuaviso) {
                        const append = `
                        <div class="avisochat">
                            <div>
                                <div class="idaviso">
                                    <h3>ID: ${texto.idoficial}</h3>
                                </div>
                                <div class="nome_aviso">
                                    <h3>${texto.nomeoficial}</h3>
                                </div>
                            </div>
                            <div>
                                <div class="anunciochat">
                                    <h3>${texto.avisotexto}</h3>
                                </div>
                                <div class="excluiranuncio" onclick="excluirAviso("${texto.aviso}",this)">
                                    <img src="./skdev/img/trash.png" draggable="false">
                                </div>
                            </div>
                        </div>
                        `
    
                        $(".containermuralavisos").append(append);
                    } else {
                        const append = `
                        <div class="avisochat">
                            <div>
                                <div class="idaviso">
                                    <h3>ID: ${texto.idoficial}</h3>
                                </div>
                                <div class="nome_aviso">
                                    <h3>${texto.nomeoficial}</h3>
                                </div>
                            </div>
                            <div>
                                <div class="anunciochat">
                                    <h3>${texto.avisotexto}</h3>
                                </div>
                            </div>
                        </div>
                        `
    
                        $(".containermuralavisos").append(append);
                    }
                }

                $(".nomedooficial h2").html(data.nome);
                $(".cargodooficial h2").html(data.cargo);
            });
        }
        if (menu === "AtualizarAvisos") {
            $.post(`https://${GetParentResourceName()}/menuprincipal`, JSON.stringify({}), (data) => {
                $(".containermuralavisos").html("");

                const tabelaAvisos = data.tabela;
                for (let i = tabelaAvisos.length - 1; i >= 0; i--) {
                    const texto = tabelaAvisos[i];
                    const index = i;

                    if (texto.meuaviso) {
                        const append = `
                        <div class="avisochat">
                            <div>
                                <div class="idaviso">
                                    <h3>ID: ${texto.idoficial}</h3>
                                </div>
                                <div class="nome_aviso">
                                    <h3>${texto.nomeoficial}</h3>
                                </div>
                            </div>
                            <div>
                                <div class="anunciochat">
                                    <h3>${texto.avisotexto}</h3>
                                </div>
                                <div class="excluiranuncio" onclick="excluirAviso('${texto.avisotexto}',this)">
                                    <img src="./skdev/img/trash.png" draggable="false">
                                </div>
                            </div>
                        </div>
                        `

                        $(".containermuralavisos").append(append);
                    } else {
                        const append = `
                        <div class="avisochat">
                            <div>
                                <div class="idaviso">
                                    <h3>ID: ${texto.idoficial}</h3>
                                </div>
                                <div class="nome_aviso">
                                    <h3>${texto.nomeoficial}</h3>
                                </div>
                            </div>
                            <div>
                                <div class="anunciochat">
                                    <h3>${texto.avisotexto}</h3>
                                </div>
                            </div>
                        </div>
                        `

                        $(".containermuralavisos").append(append);
                    }
                };
            });
        }
        if (menu === "Consulta") {
            $(".menu2").html("");

            $(".menu2").css("animation","none");
            void $(".menu2")[0].offsetWidth;
            $(".menu2").css("animation","menu2aparecer 2s forwards");

            $(".botao_menu1").removeAttr("menuativo");
            $(".buttonmenu2").attr("menuativo","");
            
            $(".menu2").html(`
            <div class="consultardiv">
                <h2>DIGITE O ID A SER CONSULTADO!</h2>
                <img src="./skdev/img/search1.png" draggable="false" class="imgconsulta">
                <input type="text" class="consultainput">
                <button class="consultarbutton" onclick="consultarID()">CONSULTAR</button>
            </div>
            `);
        }
        if (menu === "ConsultaFeita") {
            let valorConsulta = $(".consultainput").val();
            valorConsulta = Number(valorConsulta)

            $.post(`https://${GetParentResourceName()}/consultarid`, JSON.stringify({passaporte: valorConsulta}), (data) => {
                if (data.status) {
                    $(".menu2").html("");
        
                    $(".menu2").css("animation","none");
                    void $(".menu2")[0].offsetWidth;
                    $(".menu2").css("animation","menu2aparecer 2s forwards");
        
                    $(".botao_menu1").removeAttr("menuativo");
                    $(".buttonmenu2").attr("menuativo","");
    
                    $(".menu2").html(`
                    <div class="informacoesusuariodiv1">
                        <div class="bolinhaperfil_infousua" onclick="baterFoto(${data.passaporte})">
                            <img src="./skdev/img/camera1.png" draggable="false">
                        </div>

                        <div>
                            <div class="informacaousariodiv">
                                <h2>NOME COMPLETO</h2>
                                <h3>${data.nome}</h3>
                            </div>
                            <div class="informacaousariodiv">
                                <h2>PASSAPORTE</h2>
                                <h3>${data.passaporte}</h3>
                            </div>
                            <div class="informacaousariodiv">
                                <h2>REGISTRO</h2>
                                <h3>${data.registro}</h3>
                            </div>
                            <div class="informacaousariodiv">
                                <h2>IDADE</h2>
                                <h3>${data.idade}</h3>
                            </div>
                        </div>
                        <div>
                            <div class="informacaousariodiv statusProcurado">
                                <h2>STATUS PROCURADO</h2>
                                <h3>${data.procurado}</h3>
                            </div>
                            <div class="informacaousariodiv statusPortedearma">
                                <h2>STATUS PORTE DE ARMAS</h2>
                                <h3>${data.portedearma}</h3>
                            </div>
                            <button class="button_informacaousuario" onclick="alterarstatusProcurado()">ALTERAR STATUS PROCURADO</button>
                            <button class="button_informacaousuario" onclick="alterarstatusPortedearmas()">ALTERAR STATUS PORTE</button>
                        </div>
                    </div>

                    <div class="informacoesusuariodiv2">
                        <div style="display: flex;gap: 4vw;">
                            <button onclick="GerenciarMenu('multasconsulta')">MULTAS & APREENSÕES</button>
                            <button onclick="GerenciarMenu('veiculosconsulta')">VEICULOS</button>
                        </div>

                        <div>
                            <div class="multasClass">
                                <div class="multas1">
                                    <h2>TIPO</h2>
                                    <h3>NOME DO OFICIAL</h3>
                                    <h4>DETALHES</h4>
                                </div>

                                <div class="multas2">
                                </div>
                            </div>
                        </div>
                    </div>
                    `);

                    if (data.imagen) {
                        if (data.imagen != undefined) {
                            $(".bolinhaperfil_infousua img").attr("src",data.imagen)
                            $(".bolinhaperfil_infousua img").css("width","20vw")
                        }
                    }

                    const tabela = data.tabela;

                    $(".multas2").html("")
                    tabela.forEach((texto,index) => {
                        const append = `
                        <div class="multadiv">
                            <h2>${texto.tipo}</h2>
                            <h3>${texto.oficial}</h3>
                            <button onclick="multasapreensoes(${data.passaporte},${index + 1},'${texto.tipo}')">VER DETALHES</button>
                        </div>
                        `

                        $(".multas2").append(append)
                    });

                    idconsulta = Number(data.passaporte)
                }
            })
        }
        if (menu === "multasconsulta") {
            $.post(`https://${GetParentResourceName()}/consultarid`, JSON.stringify({passaporte: idconsulta}), (data) => {
                if (data.status) {
                    $(".informacoesusuariodiv2").html(`
                    <div style="display: flex;gap: 4vw;">
                        <button onclick="GerenciarMenu('multasconsulta')">MULTAS & APREENSÕES</button>
                        <button onclick="GerenciarMenu('veiculosconsulta')">VEICULOS</button>
                    </div>

                    <div>
                        <div class="multasClass">
                            <div class="multas1">
                                <h2>TIPO</h2>
                                <h3>NOME DO OFICIAL</h3>
                                <h4>DETALHES</h4>
                            </div>

                            <div class="multas2">
                            </div>
                        </div>
                    </div>
                    `);

                    const tabela = data.tabela;

                    $(".multas2").html("")
                    tabela.forEach((texto,index) => {
                        const append = `
                        <div class="multadiv">
                            <h2>${texto.tipo}</h2>
                            <h3>${texto.oficial}</h3>
                            <button onclick="multasapreensoes(${data.passaporte},${index + 1},'${texto.tipo}')">VER DETALHES</button>
                        </div>
                        `

                        $(".multas2").append(append)
                    });
                }
            })
        }
        if (menu === "veiculosconsulta") {
            $.post(`https://${GetParentResourceName()}/consultarveiculosid`, JSON.stringify({passaporte: idconsulta}), (data) => {
                if (data.status) {
                    $(".informacoesusuariodiv2").html(`
                    <div style="display: flex;gap: 4vw;">
                        <button onclick="GerenciarMenu('multasconsulta')">MULTAS & APREENSÕES</button>
                        <button onclick="GerenciarMenu('veiculosconsulta')">VEICULOS</button>
                    </div>

					<div class="veiculosClass">
						<div class="veiculospl">
						</div>
					</div>
                    `);

                    const tabela = data.tabela;
                    const localimagens = data.localimgs;

                    $(".veiculospl").html("")
                    tabela.forEach((texto,index) => {
                        const append = `
                        <div class="veiculopldiv">
                            <h2>${texto.nomedoveiculo}</h2>
                            <img src="${localimagens}/${texto.veiculo}.png" draggable="false">
                            <button onclick="apreenderveiculo('${texto.veiculo}',${idconsulta})"><img src="./skdev/img/cuff1.png" draggable="false"> APREENDER</button>
                        </div>
                        `

                        $(".veiculospl").append(append)
                    });
                }
            })
        }
        if (menu === "Apreender") {
            $(".menu2").html("");

            $(".menu2").css("animation","none");
            void $(".menu2")[0].offsetWidth;
            $(".menu2").css("animation","menu2aparecer 2s forwards");

            $(".botao_menu1").removeAttr("menuativo");
            $(".buttonmenu3").attr("menuativo","");

            $(".menu2").html(`
            <div class="consultardiv">
                <h2>DIGITE O ID A SER APREENDIDO!</h2>
                <img src="./skdev/img/search1.png" draggable="false" class="imgconsulta">
                <input type="text" class="consultainput inputIdApreendido">
                <button class="consultarbutton" onclick="GerenciarMenu('ApreenderInfos')">APREENDER</button>
            </div>
            `);
        }
        if (menu === "ApreenderInfos") {
            let valorConsulta = $(".inputIdApreendido").val();
            valorConsulta = Number(valorConsulta)
            infracoes = []

            $.post(`https://${GetParentResourceName()}/consultarapreender`, JSON.stringify({passaporte: valorConsulta}), (data) => {
                if (data.status) {
                    $(".menu2").html("");
                    
                    $(".menu2").css("animation","none");
                    void $(".menu2")[0].offsetWidth;
                    $(".menu2").css("animation","menu2aparecer 2s forwards");
                    
                    $(".botao_menu1").removeAttr("menuativo");
                    $(".buttonmenu3").attr("menuativo","");

                    tempoprisaoatual = 0;
                    multavaloratual = 0;

                    tempomaximo = data.tempomaximo
                    multamaxima = data.multamaxima
                    $(".menu2").html(`
                    <div class="informacoesusuariodiv1" style="height: 30% !important;">
                        <div class="bolinhaperfil_infousua" onclick="baterFoto(${data.passaporte})">
                            <img src="./skdev/img/camera1.png" draggable="false">
                        </div>

                        <div>
                            <div class="informacaousariodiv">
                                <h2>NOME COMPLETO</h2>
                                <h3>${data.nome}</h3>
                            </div>
                            <div class="informacaousariodiv">
                                <h2>PASSAPORTE</h2>
                                <h3>${data.passaporte}</h3>
                            </div>
                        </div>
                        <div style="justify-content: center !important;padding-top: 0vw !important;">
                            <div class="informacaousariodiv">
                                <h2>REGISTRO</h2>
                                <h3>${data.registro}</h3>
                            </div>
                            <div class="informacaousariodiv">
                                <h2>IDADE</h2>
                                <h3>${data.idade}</h3>
                            </div>
                        </div>
                    </div>

                    <div class="informacoesusuariodiv2" style="justify-content: flex-start;height: 80% !important;margin-top: -2vw !important;">
                        <h2 style="font-family: 'Montserrat',sans-serif;font-size: 1.2vw;font-weight: 700;color: #fff;">INFRAÇÕES COMETIDAS</h2>
                        <div class="SelectInfracoes">
                            <select onchange="selecionarinfracoes()">
                                <option value="selecionar">SELECIONE ALGUMA OPÇÃO</option>
                            </select>
                            <img src="./skdev/img/arrow2.png" draggable="false">
                        </div>
                        <div class="divinfracoes">
                        </div>

                        <div class="reducoes">
                            <h2>REDUÇÃO DE MULTA</h2>
                            <div>
                                <input type="range" value="0" min="0" max="100" step="1" class="reducaomultaApreender" oninput="reducaoMultaApreender()">
                                <h3 class="reducaomultah3">0%</h3>
                            </div>
                        </div>
                        <div class="reducoes">
                            <h2>REDUÇÃO DE TEMPO</h2>
                            <div>
                                <input type="range" value="0" min="0" max="100" step="1" class="reducaotempoApreender" oninput="reducaoTempoApreender()">
                                <h3 class="reducaotempoh3">0%</h3>
                            </div>
                        </div>

                        <div class="ocorrido">
                            <h2>DESCRIÇÃO DO OCORRIDO</h2>
                            <input type="text" class="descricaoocorrido">
                        </div>

                        <h5 class="tempodeprisao">TEMPO DE PRISÃO: 0 MESES</h5>
                        <h6 class="valordamulta">VALOR DA MULTA: 0 R$</h6>

                        <button class="botaocriacao" onclick="apreenderCidadao(${data.passaporte})">APREENDER</button>
                    </div>
                    `);

                    if (data.imagen) {
                        if (data.imagen != undefined) {
                            $(".bolinhaperfil_infousua img").attr("src",data.imagen)
                            $(".bolinhaperfil_infousua img").css("width","20vw")
                        }
                    }

                    const tabelaInfracoes = data.tabela;
                    tabelaInfracoes.forEach((texto,index) => {
                        const append = `<option tempopreso="${texto.tempopreso}" valormulta="${texto.multa}" crime="${texto.crime}" index="${index}">${texto.crime}</option>`

                        $(".SelectInfracoes select").append(append);
                    });

                    idapreender = Number(data.passaporte)
                }
            })
        }
        if (menu === "Multar") {
            $(".menu2").html("");

            $(".menu2").css("animation","none");
            void $(".menu2")[0].offsetWidth;
            $(".menu2").css("animation","menu2aparecer 2s forwards");

            $(".botao_menu1").removeAttr("menuativo");
            $(".buttonmenu4").attr("menuativo","");

            $(".menu2").html(`
            <div class="consultardiv">
                <h2>DIGITE O ID A SER MULTADO!</h2>
                <img src="./skdev/img/search1.png" draggable="false" class="imgconsulta">
                <input type="text" class="consultainput inputIdApreendido">
                <button class="consultarbutton" onclick="GerenciarMenu('MultarInfos')">MULTAR</button>
            </div>
            `);
        }
        if (menu === "MultarInfos") {
            let valorConsulta = $(".inputIdApreendido").val();
            valorConsulta = Number(valorConsulta)
            infracoes = []

            $.post(`https://${GetParentResourceName()}/consultarmultar`, JSON.stringify({passaporte: valorConsulta}), (data) => {
                if (data.status) {
                    $(".menu2").html("");

                    $(".menu2").css("animation","none");
                    void $(".menu2")[0].offsetWidth;
                    $(".menu2").css("animation","menu2aparecer 2s forwards");

                    $(".botao_menu1").removeAttr("menuativo");
                    $(".buttonmenu4").attr("menuativo","");

                    multavaloratual = 0;

                    multamaxima = data.multamaxima
                    $(".menu2").html(`
                    <div class="informacoesusuariodiv1" style="height: 30% !important;">
                        <div class="bolinhaperfil_infousua" onclick="baterFoto(${data.passaporte})">
                            <img src="./skdev/img/camera1.png" draggable="false">
                        </div>

                        <div>
                            <div class="informacaousariodiv">
                                <h2>NOME COMPLETO</h2>
                                <h3>${data.nome}</h3>
                            </div>
                            <div class="informacaousariodiv">
                                <h2>PASSAPORTE</h2>
                                <h3>${data.passaporte}</h3>
                            </div>
                        </div>
                        <div style="justify-content: center !important;padding-top: 0vw !important;">
                            <div class="informacaousariodiv">
                                <h2>REGISTRO</h2>
                                <h3>${data.registro}</h3>
                            </div>
                            <div class="informacaousariodiv">
                                <h2>IDADE</h2>
                                <h3>${data.idade}</h3>
                            </div>
                        </div>
                    </div>

                    <div class="informacoesusuariodiv2" style="justify-content: flex-start;height: 80% !important;margin-top: -2vw !important;">
                        <h2 style="font-family: 'Montserrat',sans-serif;font-size: 1.2vw;font-weight: 700;color: #fff;">INFRAÇÕES COMETIDAS</h2>
                        <div class="SelectInfracoes">
                            <select onchange="selecionarinfracoesmultar()">
                                <option value="selecionar">SELECIONE ALGUMA OPÇÃO</option>
                            </select>
                            <img src="./skdev/img/arrow2.png" draggable="false">
                        </div>
                        <div class="divinfracoes">
                        </div>

                        <div class="reducoes">
                            <h2>REDUÇÃO DE MULTA</h2>
                            <div>
                                <input type="range" value="0" min="0" max="100" step="1" class="reducaomulta" oninput="reducaoMulta()">
                                <h3 class="reducaomultah3">0%</h3>
                            </div>
                        </div>

                        <div class="ocorrido">
                            <h2>DESCRIÇÃO DO OCORRIDO</h2>
                            <input type="text" class="descricaoocorrido">
                        </div>

                        <h6 class="valordamulta">VALOR DA MULTA: 0 R$</h6>

                        <button class="botaocriacao" onclick="multarCidadao(${data.passaporte})">MULTAR</button>
                    </div>
                    `);

                    if (data.imagen) {
                        if (data.imagen != undefined) {
                            $(".bolinhaperfil_infousua img").attr("src",data.imagen)
                            $(".bolinhaperfil_infousua img").css("width","20vw")
                        }
                    }

                    const tabelaInfracoes = data.tabela;
                    tabelaInfracoes.forEach((texto,index) => {
                        const append = `<option valormulta="${texto.multa}" crime="${texto.crime}" index="${index}">${texto.crime}</option>`

                        $(".SelectInfracoes select").append(append);
                    });

                    idapreender = Number(data.passaporte)
                }
            })
        }
        if (menu === "Procurados") {
            $.post(`https://${GetParentResourceName()}/consultarprocurados`, JSON.stringify({}), (data) => {
                if (data.status) {
                    $(".menu2").html("");

                    $(".menu2").css("animation","none");
                    void $(".menu2")[0].offsetWidth;
                    $(".menu2").css("animation","menu2aparecer 2s forwards");

                    $(".botao_menu1").removeAttr("menuativo");
                    $(".buttonmenu5").attr("menuativo","");

                    $(".menu2").html(`
                    <div class="individuoprocurados">
                        <h2>MURAL INDIVIDUOS PROCURADOS</h2>
                        <div>
                        </div>
                    </div>

                    <div class="veiculosprocurados">
                        <h2>MURAL VEICULOS PROCURADOS</h2>
                        <div>
                        </div>
                    </div>
                    `);

                    const tabelaPlayer = data.tabelaPlayer;
                    tabelaPlayer.forEach((texto,index) => {
                        const append = `
                        <div class="procuradoidiv">
                            <h2>Nome do Requerente: ${texto.nomerequerente}</h2>
                            <h2>Nome do Oficial: ${texto.nomedooficial}</h2>
                            <h2>Razão do procurado: ${texto.razaoprocurado}</h2>
                            <h2>Tempo do procurado: ${texto.dataprocurado}</h2>
                            <button onclick="procuradocidadaodetalhes(${texto.timestamp})">VER DETALHES</button>
                        </div>
                        `
                        
                        $(".individuoprocurados>div:nth-of-type(1)").append(append)
                    });

                    const tabelaVeiculos = data.tabelaVeiculos;
                    tabelaVeiculos.forEach((texto,index) => {
                        const append = `
						<div class="procuradovdiv">
							<h2>Modelo do veiculo: ${texto.modeloveiculo}</h2>
							<h2>Nome do Oficial: ${texto.nomedooficial}</h2>
							<h2>Razão do procurado: ${texto.razaoprocurado}</h2>
							<h2>Tempo do procurado: ${texto.dataprocurado}</h2>
							<button onclick="procuradoveiculodetalhes(${texto.timestamp})">VER DETALHES</button>
						</div>
                        `
                        
                        $(".veiculosprocurados>div:nth-of-type(1)").append(append)
                    });

                }
            })
        }
        if (menu === "ProcuradosAtualizar") {
            $.post(`https://${GetParentResourceName()}/consultarprocurados`, JSON.stringify({}), (data) => {
                if (data.status) {
                    $(".individuoprocurados>div:nth-of-type(1)").html("");
                    $(".veiculosprocurados>div:nth-of-type(1)").html("");

                    const tabelaPlayer = data.tabelaPlayer;
                    tabelaPlayer.forEach((texto,index) => {
                        const append = `
                        <div class="procuradoidiv">
                            <h2>Nome do Requerente: ${texto.nomerequerente}</h2>
                            <h2>Nome do Oficial: ${texto.nomedooficial}</h2>
                            <h2>Razão do procurado: ${texto.razaoprocurado}</h2>
                            <h2>Tempo do procurado: ${texto.dataprocurado}</h2>
                            <button onclick="procuradocidadaodetalhes(${texto.timestamp})">VER DETALHES</button>
                        </div>
                        `
                        
                        $(".individuoprocurados>div:nth-of-type(1)").append(append)
                    });

                    const tabelaVeiculos = data.tabelaVeiculos;
                    tabelaVeiculos.forEach((texto,index) => {
                        const append = `
						<div class="procuradovdiv">
							<h2>Modelo do veiculo: ${texto.modeloveiculo}</h2>
							<h2>Nome do Oficial: ${texto.nomedooficial}</h2>
							<h2>Razão do procurado: ${texto.razaoprocurado}</h2>
							<h2>Tempo do procurado: ${texto.dataprocurado}</h2>
							<button onclick="procuradoveiculodetalhes(${texto.timestamp})">VER DETALHES</button>
						</div>
                        `
                        
                        $(".veiculosprocurados>div:nth-of-type(1)").append(append)
                    });

                }
            })
        }
        if (menu === "Boletins") {
            $(".menu2").html("");

            $(".menu2").css("animation","none");
            void $(".menu2")[0].offsetWidth;
            $(".menu2").css("animation","menu2aparecer 2s forwards");

            $(".botao_menu1").removeAttr("menuativo");
            $(".buttonmenu6").attr("menuativo","");

            $(".menu2").html(`
            <div class="consultardiv">
                <h2>SELECIONE O TIPO DE BOLETIN</h2>
                <div class="tipodeboletin">
                    <button onclick="GerenciarMenu('IndividuoBoletin')">INDIVIDUO</button>
                    <button onclick="GerenciarMenu('VeiculoBoletin')">VEICULO</button>
                </div>
            </div>
            `);
        }
        if (menu === "IndividuoBoletin") {
            $(".menu2").html("");

            $(".menu2").css("animation","none");
            void $(".menu2")[0].offsetWidth;
            $(".menu2").css("animation","menu2aparecer 2s forwards");

            $(".botao_menu1").removeAttr("menuativo");
            $(".buttonmenu6").attr("menuativo","");

            $(".menu2").html(`
            <div class="boletinsdiv">
                <div class="boletindiv">
                    <h2>NOME DO REQUERENTE E ID</h2>
                    <input type="text" placeholder="Ex: ERICK SILVA #519" class="nomedorequerente">
                </div>
                <div class="boletindiv">
                    <h2>CARACTERISTICAS DO INDIVIDUO</h2>
                    <input type="text" placeholder="Ex: CAMISETA VERMELHA, CHAPEU BRANCO..." class="caracteristicasindividuo">
                </div>
                <div class="boletindiv">
                    <h2>RAZÃO DO BOLETIN</h2>
                    <input type="text" placeholder="Ex: INDIVIDUO REALIZANDO ROUBOS" class="razaodoboletin">
                </div>
                <div class="boletindiv">
                    <h2>DESCRIÇÃO DO OCORRIDO</h2>
                    <input type="text" placeholder="Ex: FOI VISTO ROUBANDO NA PRAÇA POR UM CIDADÃO" class="descricaodoboletin">
                </div>

                <button onclick="confirmarBoletinIndividuo()">CONFIRMAR</button>
            </div>
            `);
        }
        if (menu === "VeiculoBoletin") {
            $(".menu2").html("");

            $(".menu2").css("animation","none");
            void $(".menu2")[0].offsetWidth;
            $(".menu2").css("animation","menu2aparecer 2s forwards");

            $(".botao_menu1").removeAttr("menuativo");
            $(".buttonmenu6").attr("menuativo","");

            $(".menu2").html(`
            <div class="boletinsdiv">
                <div class="boletindiv">
                    <h2>NOME DO REQUERENTE E ID</h2>
                    <input type="text" placeholder="Ex: ERICK SILVA #519" class="nomedorequerente">
                </div>
                <div class="boletindiv">
                    <h2>MODELO DO VEICULO</h2>
                    <input type="text" placeholder="Ex: Nissan GTR" class="modeloveiculo">
                </div>
                <div class="boletindiv">
                    <h2>COR DO VEICULO</h2>
                    <input type="text" placeholder="Ex: Vermelho Metálico" class="corveiculo">
                </div>
                <div class="boletindiv">
                    <h2>PLACA DO VEICULO</h2>
                    <input type="text" placeholder="Ex: FINAL 041" class="placaveiculo">
                </div>
                <div class="boletindiv">
                    <h2>RAZÃO DO BOLETIN</h2>
                    <input type="text" placeholder="Ex: VEICULO ROUBADO" class="razaoboletin">
                </div>
                <div class="boletindiv" style="margin-bottom: 4.3vw;">
                    <h2>DESCRIÇÃO DO OCORRIDO</h2>
                    <input type="text" placeholder="Ex: ROUBADO NA ÁREA DA PRAÇA ENQUANTO" class="descricaoboletin">
                </div>

                <button onclick="confirmarBoletinVeiculo()">CONFIRMAR</button>
            </div>
            `);
        }
        if (menu === "Arsenal") {
            $.post(`https://${GetParentResourceName()}/consultarArsenal`, JSON.stringify({}), (data) => {
                if (data.status) {
                    $(".menu2").html("");

                    $(".menu2").css("animation","none");
                    void $(".menu2")[0].offsetWidth;
                    $(".menu2").css("animation","menu2aparecer 2s forwards");

                    $(".botao_menu1").removeAttr("menuativo");
                    $(".buttonmenu7").attr("menuativo","");

                    $(".menu2").html(`
                    <div class="arsenaldiv">
                        <h3>ARSENAL</h3>
                        <button class="removerarmas" onclick="removerArmas()">REMOVER ARMAS</button>

                        <div class="containerarsenal">
                        </div>
                    </div>
                    `);

                    const tabela = data.tabela;
                    tabela.forEach((texto,index) => {
                        const permitido = texto.permitido

                        if (permitido) {
                            const append = `
                            <div class="armadiv">
                                <h2>${texto.nomearma}</h2>
                                <img src="./skdev/img/arsenalimgs/${texto.image}.png" draggable="false">
                                <div class="bolinhastatusarma">
                                    <img src="./skdev/img/confirm3.png" draggable="false">
                                </div>
                                <button class="equipararma" onclick="equiparArmas(${texto.arma})">EQUIPAR</button>
                            </div>
                            `
    
                            $(".containerarsenal").append(append)
                        } else {
                            const append = `
                            <div class="armadiv">
                                <h2>${texto.nomearma}</h2>
                                <img src="./skdev/img/arsenalimgs/${texto.image}.png" draggable="false">
                                <div class="bolinhastatusarma">
                                    <img src="./skdev/img/block3.png" draggable="false">
                                </div>
                                <button class="equipararma" onclick="equiparArmas(${texto.arma})">EQUIPAR</button>
                            </div>
                            `
    
                            $(".containerarsenal").append(append)
                        }
                    });
                }
            })
        }
    }
};

function excluirAviso(texto,div) {
    $.post(`https://${GetParentResourceName()}/excluirAviso`, JSON.stringify({texto: texto}), (data) => {});
};

function enviarAviso() {
    const textoAviso = $(".chatinput").val();
    $(".chatinput").val("")

    $.post(`https://${GetParentResourceName()}/enviarAviso`, JSON.stringify({texto: textoAviso}), (data) => {});
}

function consultarID() {
    let valor = $(".consultainput").val();
    valor = Number(valor)

    if (valor >= 0) {
        GerenciarMenu("ConsultaFeita");
    }
}

function multasapreensoes(passaporte,index,tipo) {
    if (tipo === "MULTA") {
        $.post(`https://${GetParentResourceName()}/multasinformacoes`, JSON.stringify({passaporte: passaporte, index: index}), (data) => {
            $(".menumodal2").css("display","none")
            $(".menumodal2").fadeIn(1000)
            $(".menumodal2").css("display","flex")
    
            $(".menumodal2").html(`
                <div class="divmodal2">
                    <h2>NOME DO OFICIAL</h2>
                    <h4>${data.nomeoficial}</h4>
                </div>
    
                <div class="divmodal2">
                    <h2>PASSAPORTE DO OFICIAL</h2>
                    <h4>${data.passaporteoficial}</h4>
                </div>
    
                <div class="divmodal2">
                    <h2>DATA DA MULTA</h2>
                    <h4>${data.data}</h4>
                </div>
    
                <div class="divmodal2">
                    <h2>DESCRIÇÃO DA MULTA</h2>
                    <h3>${data.descricao}</h3>
                </div>
    
                <div class="divmodal2 infracoesMulta">
                    <h2>INFRAÇÕES COMETIDAS</h2>
                    <div>
                    </div>
                </div>
    
                <div class="divmodal2">
                    <h2>REDUÇÃO DE MULTA: ${data.reducaomulta}%</h2>
                </div>
    
                <div class="divmodal2">
                    <h2>VALOR DA MULTA</h2>
                    <h4>${data.valormulta}</h4>
                </div>
    
                <button onclick="fecharmodal2()">FECHAR</button>
            `)

            const tabela = data.tabela;
            tabela.forEach((texto,index) => {
                const append = `<h5>${texto.infracao}</h5>`

                $(".infracoesMulta>div").append(append)
            });
        });
    } else if (tipo === "PRISÃO") {
        $.post(`https://${GetParentResourceName()}/prisoesinformacoes`, JSON.stringify({passaporte: passaporte, index: index}), (data) => {
            $(".menumodal2").css("display","none")
            $(".menumodal2").fadeIn(1000)
            $(".menumodal2").css("display","flex")
    
            $(".menumodal2").html(`
                <div class="divmodal2">
                    <h2>NOME DO OFICIAL</h2>
                    <h4>${data.nomeoficial}</h4>
                </div>
    
                <div class="divmodal2">
                    <h2>PASSAPORTE DO OFICIAL</h2>
                    <h4>${data.passaporteoficial}</h4>
                </div>
    
                <div class="divmodal2">
                    <h2>DATA DA PRISÃO</h2>
                    <h4>${data.data}</h4>
                </div>
    
                <div class="divmodal2">
                    <h2>DESCRIÇÃO DA PRISÃO</h2>
                    <h3>${data.descricao}</h3>
                </div>
    
                <div class="divmodal2 infracoesMulta">
                    <h2>INFRAÇÕES COMETIDAS</h2>
                    <div>
                    </div>
                </div>
    
                <div class="divmodal2">
                    <h2>REDUÇÃO DE MULTA: ${data.reducaomulta}%</h2>
                    <h2>REDUÇÃO DE TEMPO PRESO: ${data.reducaotempopreso}%</h2>
                </div>
    
                <div class="divmodal2">
                    <h2>VALOR DA MULTA</h2>
                    <h4>${data.valormulta}R$</h4>
                </div>
                <div class="divmodal2">
                    <h2>TEMPO PRESO</h2>
                    <h4>${data.tempopreso} Mêses</h4>
                </div>
    
                <button onclick="fecharmodal2()">FECHAR</button>
            `)

            const tabela = data.tabela;
            tabela.forEach((texto,index) => {
                const append = `<h5>${texto.infracao}</h5>`

                $(".infracoesMulta>div").append(append)
            });
        });
    }
}

function botaovoltarmenumodal() {
    $(".menumodal").css("display","none")
}

function fecharmodal2() {
    $(".menumodal2").fadeOut(1000)
}

function notificacaoLocal(aviso) {
    if ($(".notificacaousuario").css("display") === "none") {
        $(".notificacaousuario h2").html(aviso);
        $(".notificacaousuario").css("display","flex");
        
        const notificacao = $(".notificacaousuario")
        
        notificacao.one("animationend", function(event) {
            if (event.originalEvent.animationName === "notificacaousuarioAparecer") {
                $(".notificacaousuario").css("display","none");
            }
        });
    }
}

function apreenderveiculo(veiculo,passaporte) {
    if ($(".notificacaousuario").css("display") === "none") {
        $.post(`https://${GetParentResourceName()}/apreenderVeiculo`, JSON.stringify({veiculo: veiculo, passaporte: passaporte}), (data) => {
            if (data.status) {
                notificacaoLocal(`Apreendeu com sucesso o veiculo: ${veiculo}!`)
            }
        });
    }
}

function alterarstatusProcurado() {
    $(".menumodal").css("display","none")
    $(".menumodal").fadeIn(1000)
    $(".menumodal").css("display","flex")

    $.post(`https://${GetParentResourceName()}/statusprocurado`, JSON.stringify({passaporte: idconsulta}), (data) => {
        if (data.status) {
            $(".menumodal").html(`
            <div class="divmodal">
                <h2>MOTIVO PROCURAÇÃO</h2>
                <input type="text" class="motivoprocuracao" value="${data.motivo}">
            </div>
        
            <div style="display: flex;gap: 1vw;">
                <button onclick="fecharMenumodal()"><img src="./skdev/img/back.png" draggable="false"> VOLTAR</button>
                <button onclick="confirmarProcuracao()"><img src="./skdev/img/confirm.png" draggable="false"> CONFIRMAR</button>
            </div>
            `)
        } else {
            $(".menumodal").html(`
            <div class="divmodal">
                <h2>MOTIVO PROCURAÇÃO</h2>
                <input type="text" class="motivoprocuracao">
            </div>
        
            <div style="display: flex;gap: 1vw;">
                <button onclick="fecharMenumodal()"><img src="./skdev/img/back.png" draggable="false"> VOLTAR</button>
                <button onclick="confirmarProcuracao()"><img src="./skdev/img/confirm.png" draggable="false"> CONFIRMAR</button>
            </div>
            `)
        }
    });
}

function fecharMenumodal() {
    $(".menumodal").fadeOut(1000)
}

function confirmarProcuracao() {
    $(".menumodal").fadeOut(1000)
    let motivo = $(".motivoprocuracao").val();
    
    $.post(`https://${GetParentResourceName()}/confirmarProcuracao`, JSON.stringify({motivo: motivo, passaporte: idconsulta}), (data) => {
        if (data.status) {
            $(".statusProcurado h3").html("CIDADÃO PROCURADO !");
        }
    });
}

function alterarstatusPortedearmas() {
    $(".menumodal").css("display","none")
    $(".menumodal").fadeIn(1000)
    $(".menumodal").css("display","flex")

    $.post(`https://${GetParentResourceName()}/statusportedearmas`, JSON.stringify({passaporte: idconsulta}), (data) => {
        if (data.status) {
            $(".menumodal").html(`
            <div class="divmodal">
                <h2>NOME DA ARMA</h2>
                <input type="text" class="nomedaarmaportedearmas" value="${data.nomearma}">
            </div>
            <div class="divmodal">
                <h2>QUANTIDADE DE MUNIÇÕES</h2>
                <input type="text" class="quantidadedemunicoes" value="${data.quantidademunicoes}">
            </div>
        
            <div style="display: flex;gap: 1vw;">
                <button onclick="fecharMenumodal()"><img src="./skdev/img/back.png" draggable="false"> VOLTAR</button>
                <button onclick="confirmarPortedearmas()"><img src="./skdev/img/confirm.png" draggable="false"> CONFIRMAR</button>
            </div>
            `)
        } else {
            $(".menumodal").html(`
            <div class="divmodal">
                <h2>NOME DA ARMA</h2>
                <input type="text" class="nomedaarmaportedearmas">
            </div>
            <div class="divmodal">
                <h2>QUANTIDADE DE MUNIÇÕES</h2>
                <input type="text" class="quantidadedemunicoes">
            </div>

            <div style="display: flex;gap: 1vw;">
                <button onclick="fecharMenumodal()"><img src="./skdev/img/back.png" draggable="false"> VOLTAR</button>
                <button onclick="confirmarPortedearmas()"><img src="./skdev/img/confirm.png" draggable="false"> CONFIRMAR</button>
            </div>
            `)
        }
    });
}

function confirmarPortedearmas() {
    $(".menumodal").fadeOut(1000)
    let nomearma = $(".nomedaarmaportedearmas").val();
    let quantidadedemunicoes = $(".quantidadedemunicoes").val();
    
    $.post(`https://${GetParentResourceName()}/confirmarPortedearmas`, JSON.stringify({nomearma: nomearma, quantidadedemunicoes: quantidadedemunicoes, passaporte: idconsulta}), (data) => {
        if (data.status) {
            $(".statusPortedearma h3").html("CIDADÃO POSSUI PORTE");
        }
    });
}

function baterFoto(passaporte) {
    $('.policia').stop().fadeOut(1000);
    $.post(`https://${GetParentResourceName()}/tirarfoto`, JSON.stringify({passaporte: passaporte}), (data) => {
        const link = data.image
        if (link != undefined) {
            $(".bolinhaperfil_infousua img").attr("src",link)
            $(".bolinhaperfil_infousua img").css("width","20vw")
        }
        $('.policia').stop().fadeIn(1000);
        $('.policia').css("display","flex");
    });
}

function selecionarinfracoes() {
    const opcaoselecionada = $(".SelectInfracoes select option:selected");
    let tempopreso = opcaoselecionada.attr("tempopreso");
    tempopreso = Number(tempopreso)
    let valormulta = opcaoselecionada.attr("valormulta");
    valormulta = Number(valormulta)
    const crime = opcaoselecionada.attr("crime");
    let index = opcaoselecionada.attr("index");
    index = Number(index);
    const value = opcaoselecionada.attr("value");


    let reducaomulta = $(".reducaomultaApreender").val();
    reducaomulta = Number(reducaomulta)
    let reducaotempo = $(".reducaotempoApreender").val();
    reducaotempo = Number(reducaotempo)


    let existe = false;
    for (const number of infracoes) {
        if (number === index) {
            existe = true;
            break;
        }
    }

    if (value != "selecionar") {
        if (!existe) {
            const append = `
            <div class="infracao">
                <h2>${crime} | ${tempopreso} Mesês ${valormulta} $ Multa</h2>
                <img src="./skdev/img/remove2.png" draggable="false" onclick="removerinfracao(${index},this)" tempopreso="${tempopreso}" valormulta="${valormulta}">
            </div>
            `

            if (reducaomulta > 0) {
                multavaloratual = multavaloratual + (valormulta - (valormulta *  reducaomulta / 100))
            } else {
                multavaloratual = multavaloratual + valormulta
            }

            if (reducaotempo > 0) {
                tempoprisaoatual = tempoprisaoatual + (tempopreso - (tempopreso *  reducaotempo / 100))
            } else {
                tempoprisaoatual = tempoprisaoatual + tempopreso
            }

            if (multavaloratual >= multamaxima) {
                multavaloratual = multamaxima
            }
            if (tempoprisaoatual >= tempomaximo) {
                tempoprisaoatual = tempomaximo
            }

            if (multavaloratual <= 0) {
                multavaloratual = 0
            }
            if (tempoprisaoatual <= 0) {
                tempoprisaoatual = 0
            }

            $(".tempodeprisao").html(`TEMPO DE PRISÃO: ${tempoprisaoatual} MESES`)
            $(".valordamulta").html(`VALOR DA MULTA: ${multavaloratual} R$`)

            multavaloratualreal = multavaloratualreal + valormulta
            tempoprisaoatualreal = tempoprisaoatualreal + tempopreso

            if (multavaloratualreal >= multamaxima) {
                multavaloratualreal = multamaxima
            }
            if (tempoprisaoatualreal >= tempomaximo) {
                tempoprisaoatualreal = tempomaximo
            }

            if (multavaloratualreal <= 0) {
                multavaloratualreal = 0
            }
            if (tempoprisaoatualreal <= 0) {
                tempoprisaoatualreal = 0
            }

            $(".divinfracoes").append(append);
            infracoes.push(index);
        }
    }
}

function selecionarinfracoesmultar() {
    const opcaoselecionada = $(".SelectInfracoes select option:selected");
    let tempopreso = opcaoselecionada.attr("tempopreso");
    tempopreso = Number(tempopreso)
    let valormulta = opcaoselecionada.attr("valormulta");
    valormulta = Number(valormulta)
    const crime = opcaoselecionada.attr("crime");
    let index = opcaoselecionada.attr("index");
    index = Number(index);
    const value = opcaoselecionada.attr("value");


    let reducaomulta = $(".reducaomultaApreender").val();
    reducaomulta = Number(reducaomulta)


    let existe = false;
    for (const number of infracoes) {
        if (number === index) {
            existe = true;
            break;
        }
    }

    if (value != "selecionar") {
        if (!existe) {
            const append = `
            <div class="infracao">
                <h2>${crime} | ${valormulta} $ Multa</h2>
                <img src="./skdev/img/remove2.png" draggable="false" onclick="removerinfracaomultar(${index},this)" valormulta="${valormulta}">
            </div>
            `

            if (reducaomulta > 0) {
                multavaloratual = multavaloratual + (valormulta - (valormulta *  reducaomulta / 100))
            } else {
                multavaloratual = multavaloratual + valormulta
            }

            if (multavaloratual >= multamaxima) {
                multavaloratual = multamaxima
            }

            if (multavaloratual <= 0) {
                multavaloratual = 0
            }

            $(".valordamulta").html(`VALOR DA MULTA: ${multavaloratual} R$`)

            multavaloratualreal = multavaloratualreal + valormulta

            if (multavaloratualreal >= multamaxima) {
                multavaloratualreal = multamaxima
            }

            if (multavaloratualreal <= 0) {
                multavaloratualreal = 0
            }

            $(".divinfracoes").append(append);
            infracoes.push(index);
        }
    }
}

function removerinfracao(index,div) {
    let indexRemover = 0;
    let existe = false;
    for (let i = 0; i < infracoes.length; i++) {
        if (infracoes[i] === index) {
            indexRemover = i;
            existe = true;
            break;
        }
    }

    let tempopreso = $(div).attr("tempopreso");
    tempopreso = Number(tempopreso)
    let valormulta = $(div).attr("valormulta");
    valormulta = Number(valormulta)


    let reducaomulta = $(".reducaomultaApreender").val();
    reducaomulta = Number(reducaomulta)
    let reducaotempo = $(".reducaotempoApreender").val();
    reducaotempo = Number(reducaotempo)

    if (reducaomulta > 0) {
        multavaloratual = multavaloratual - (valormulta - (valormulta *  reducaomulta / 100))
    } else {
        multavaloratual = multavaloratual - valormulta
    }

    if (reducaotempo > 0) {
        tempoprisaoatual = tempoprisaoatual - (tempopreso - (tempopreso *  reducaotempo / 100))
    } else {
        tempoprisaoatual = tempoprisaoatual - tempopreso
    }

    if (multavaloratual <= 0) {
        multavaloratual = 0
    }
    if (tempoprisaoatual <= 0) {
        tempoprisaoatual = 0
    }
    $(".tempodeprisao").html(`TEMPO DE PRISÃO: ${tempoprisaoatual} MESES`)
    $(".valordamulta").html(`VALOR DA MULTA: ${multavaloratual} R$`)

    multavaloratualreal = multavaloratualreal - valormulta
    tempoprisaoatualreal = tempoprisaoatualreal - tempopreso

    if (multavaloratualreal >= multamaxima) {
        multavaloratualreal = multamaxima
    }
    if (tempoprisaoatualreal >= tempomaximo) {
        tempoprisaoatualreal = tempomaximo
    }

    if (multavaloratualreal <= 0) {
        multavaloratualreal = 0
    }
    if (tempoprisaoatualreal <= 0) {
        tempoprisaoatualreal = 0
    }

    if (existe) {
        $(div.parentNode).remove();
        infracoes.splice(indexRemover, 1);
    }
}

function removerinfracaomultar(index,div) {
    let indexRemover = 0;
    let existe = false;
    for (let i = 0; i < infracoes.length; i++) {
        if (infracoes[i] === index) {
            indexRemover = i;
            existe = true;
            break;
        }
    }

    let valormulta = $(div).attr("valormulta");
    valormulta = Number(valormulta)


    let reducaomulta = $(".reducaomultaApreender").val();
    reducaomulta = Number(reducaomulta)

    if (reducaomulta > 0) {
        multavaloratual = multavaloratual - (valormulta - (valormulta *  reducaomulta / 100))
    } else {
        multavaloratual = multavaloratual - valormulta
    }

    if (multavaloratual <= 0) {
        multavaloratual = 0
    }
    $(".valordamulta").html(`VALOR DA MULTA: ${multavaloratual} R$`)

    multavaloratualreal = multavaloratualreal - valormulta

    if (multavaloratualreal >= multamaxima) {
        multavaloratualreal = multamaxima
    }

    if (multavaloratualreal <= 0) {
        multavaloratualreal = 0
    }

    if (existe) {
        $(div.parentNode).remove();
        infracoes.splice(indexRemover, 1);
    }
}

function reducaoMultaApreender() {
    let valor = $(".reducaomultaApreender").val();
    valor = Number(valor)

    multavaloratual = Math.floor(multavaloratualreal - (multavaloratualreal * valor / 100))
    $(".valordamulta").html(`VALOR DA MULTA: ${multavaloratual} R$`)

    $(".reducaomultah3").html(valor+"%");
}

function reducaoMulta() {
    let valor = $(".reducaomulta").val();
    valor = Number(valor)

    multavaloratual = Math.floor(multavaloratualreal - (multavaloratualreal * valor / 100))
    $(".valordamulta").html(`VALOR DA MULTA: ${multavaloratual} R$`)

    $(".reducaomultah3").html(valor+"%");
}

function reducaoTempoApreender() {
    let valor = $(".reducaotempoApreender").val();
    valor = Number(valor)

    tempoprisaoatual = Math.floor(tempoprisaoatualreal - (tempoprisaoatualreal * valor / 100))
    $(".tempodeprisao").html(`TEMPO DE PRISÃO: ${tempoprisaoatual} MESES`)

    $(".reducaotempoh3").html(valor+"%");
}

function apreenderCidadao(passaporte) {
    const passaporteC = Number(passaporte)
    let reducaomulta = $(".reducaomultaApreender").val();
    reducaomulta = Number(reducaomulta)
    let reducaotempo = $(".reducaotempoApreender").val();
    reducaotempo = Number(reducaotempo)
    const descricao = $(".descricaoocorrido").val();

    $.post(`https://${GetParentResourceName()}/apreenderCidadao`, JSON.stringify({passaporte: passaporteC, crime: infracoes, reducaomulta: reducaomulta, reducaotempo: reducaotempo, descricao: descricao}), (data) => {
        if (data.status) {
            notificacaoLocal("ID: "+passaporteC+" Preso com sucesso!")
            GerenciarMenu("Inicio")
        } else {
            notificacaoLocal("Ocorreu um erro!, tente novamente!")
        }
    });
}

function multarCidadao(passaporte) {
    const passaporteC = Number(passaporte)
    let reducaomulta = $(".reducaomultaApreender").val();
    reducaomulta = Number(reducaomulta)
    const descricao = $(".descricaoocorrido").val();

    $.post(`https://${GetParentResourceName()}/multarCidadao`, JSON.stringify({passaporte: passaporteC, crime: infracoes, reducaomulta: reducaomulta, descricao: descricao}), (data) => {
        if (data.status) {
            notificacaoLocal("ID: "+passaporteC+" Multado com sucesso!")
            GerenciarMenu("Inicio")
        } else {
            notificacaoLocal("Ocorreu um erro!, tente novamente!")
        }
    });
}

function confirmarBoletinIndividuo() {
    const nomedorequerente = $(".nomedorequerente").val();
    const caracteristicasindividuo = $(".caracteristicasindividuo").val();
    const razaodoboletin = $(".razaodoboletin").val();
    const descricaodoboletin = $(".descricaodoboletin").val();

    $.post(`https://${GetParentResourceName()}/confirmarBoletinIndividuo`, JSON.stringify({nomedorequerente: nomedorequerente, caracteristicasindividuo : caracteristicasindividuo, razaodoboletin: razaodoboletin, descricaodoboletin: descricaodoboletin}), (data) => {
        if (data.status) {
            notificacaoLocal("Boletin registrado com sucesso!")
            GerenciarMenu("Inicio")
        } else {
            notificacaoLocal("Ocorreu um erro!, tente novamente!")
        }
    });
}

function confirmarBoletinVeiculo() {
    const nomedorequerente = $(".nomedorequerente").val();
    const modeloveiculo = $(".modeloveiculo").val();
    const corveiculo = $(".corveiculo").val();
    const placaveiculo = $(".placaveiculo").val();
    const razaoboletin = $(".razaoboletin").val();
    const descricaoboletin = $(".descricaoboletin").val();

    $.post(`https://${GetParentResourceName()}/confirmarBoletinVeiculo`, JSON.stringify({nomedorequerente: nomedorequerente, modeloveiculo: modeloveiculo, corveiculo: corveiculo, placaveiculo: placaveiculo, razaoboletin: razaoboletin, descricaoboletin: descricaoboletin}), (data) => {
        if (data.status) {
            notificacaoLocal("Boletin registrado com sucesso!")
            GerenciarMenu("Inicio")
        } else {
            notificacaoLocal("Ocorreu um erro!, tente novamente!")
        }
    });
}

function procuradocidadaodetalhes(timestamp) {
    const indexBoletin = Number(timestamp)

    $.post(`https://${GetParentResourceName()}/informacaoBoletinCidadao`, JSON.stringify({timestamp: indexBoletin}), (data) => {
        if (data.status) {
            $(".menumodal").css("display","none")
            $(".menumodal").fadeIn(1000)
            $(".menumodal").css("display","flex")

            $(".menumodal").html(`
            <div class="divmodal">
                <h2>NOME DO REQUERENTE E ID</h2>
                <h3>${data.nomerequerente}</h3>
            </div>
            <div class="divmodal">
                <h2>NOME DO OFICIAL</h2>
                <h3>${data.nomedooficial}</h3>
            </div>
            <div class="divmodal">
                <h2>CARACTERISTICAS INDIVIDUO</h2>
                <h3>${data.caracteristica}</h3>
            </div>
            <div class="divmodal">
                <h2>RAZÃO DO PROCURADO</h2>
                <h3>${data.razaoprocurado}</h3>
            </div>
            <div class="divmodal">
                <h2>DESCRIÇÃO DO BOLETIN</h2>
                <h3>${data.descricao}</h3>
            </div>
            <div class="divmodal">
                <h2>TEMPO SENDO PROCURADO</h2>
                <h3>${data.dataprocurado}</h3>
            </div>
        
            <div style="display: flex;gap: 1vw;">
                <button onclick="fecharMenumodal()"><img src="./skdev/img/back.png" draggable="false"> VOLTAR</button>
                <button onclick="removerBoletinCidadao(${indexBoletin})"><img src="./skdev/img/remove.png" draggable="false"> REMOVER</button>
            </div>
            `)
        } else {
            notificacaoLocal("Ocorreu um erro!, tente novamente!")
        }
    });
}

function procuradoveiculodetalhes(timestamp) {
    const indexBoletin = Number(timestamp)

    $.post(`https://${GetParentResourceName()}/informacaoBoletinVeiculo`, JSON.stringify({timestamp: indexBoletin}), (data) => {
        if (data.status) {
            $(".menumodal").css("display","none")
            $(".menumodal").fadeIn(1000)
            $(".menumodal").css("display","flex")

            $(".menumodal").html(`
            <div class="divmodal">
                <h2>MODELO DO VEICULO</h2>
                <h3>${data.modeloveiculo}</h3>
            </div>
            <div class="divmodal">
                <h2>PLACA DO VEICULO</h2>
                <h3>${data.placaveiculo}</h3>
            </div>
            <div class="divmodal">
                <h2>COR DO VEICULO</h2>
                <h3>${data.corveiculo}</h3>
            </div>
            <div class="divmodal">
                <h2>RAZÃO DO PROCURADO</h2>
                <h3>${data.razaoprocurado}</h3>
            </div>
            <div class="divmodal">
                <h2>DESCRIÇÃO DO BOLETIN</h2>
                <h3>${data.descricao}</h3>
            </div>
            <div class="divmodal">
                <h2>NOME DO REQUERENTE E ID</h2>
                <h3>${data.nomerequerente}</h3>
            </div>
        
            <div style="display: flex;gap: 1vw;">
                <button onclick="fecharMenumodal()"><img src="./skdev/img/back.png" draggable="false"> VOLTAR</button>
                <button onclick="removerBoletinVeiculo(${indexBoletin})"><img src="./skdev/img/remove.png" draggable="false"> REMOVER</button>
            </div>
            `)
        } else {
            notificacaoLocal("Ocorreu um erro!, tente novamente!")
        }
    });
}

function removerBoletinCidadao(timestamp) {
    const indexBoletin = Number(timestamp)

    $.post(`https://${GetParentResourceName()}/removerBoletinCidadao`, JSON.stringify({timestamp: indexBoletin}), (data) => {
        if (data.status) {
            notificacaoLocal("Boletin finalizado com sucesso!")
            fecharMenumodal()
        } else {
            notificacaoLocal("Ocorreu um erro!, tente novamente!")
        }
    });
}

function removerBoletinVeiculo(timestamp) {
    const indexBoletin = Number(timestamp)

    $.post(`https://${GetParentResourceName()}/removerBoletinVeiculo`, JSON.stringify({timestamp: indexBoletin}), (data) => {
        if (data.status) {
            notificacaoLocal("Boletin finalizado com sucesso!")
            fecharMenumodal()
        } else {
            notificacaoLocal("Ocorreu um erro!, tente novamente!")
        }
    });
}

function equiparArmas(index) {
    const indexArma = Number(index)

    $.post(`https://${GetParentResourceName()}/equiparArma`, JSON.stringify({index: indexArma}), (data) => {
        if (data.status) {
            notificacaoLocal("Você equipou com sucesso!")
        } else {
            notificacaoLocal("Parece que deu algum erro!")
        }
    });
}

function removerArmas() {
    $.post(`https://${GetParentResourceName()}/removerArmas`, JSON.stringify({}), (data) => {
        if (data.status) {
            notificacaoLocal("Você removeu todos os seus equipamentos com sucesso!")
        } else {
            notificacaoLocal("Parece que deu algum erro!")
        }
    });
}

window.addEventListener("message", (event) => {
    const data = event.data

    if (data.mostranuipolicia != undefined) {
        if (data.mostranuipolicia) {
            const intervaloOpacidade = setInterval(function() {
                const opacity = $(".policia").css("opacity");
                
                if (parseFloat(opacity) <= 1) {
                    clearInterval(intervaloOpacidade);
                    $('.policia').stop().fadeIn(1000);
                    $('.policia').css("display","flex");
                }
            }, 100);

            GerenciarMenu("Inicio");
        }
    }

    if (data.mostraraviso != undefined) {
        if (data.mostraraviso) {
            if ($(".avisopainel").css("display") === "none") {
                $(".avisopainel h2").html(data.aviso);
                $(".avisopainel").css("display","flex");

                const notificacao = $(".avisopainel")

                notificacao.one("animationend", function(event) {
                    if (event.originalEvent.animationName === "avisoAparecer") {
                        $(".avisopainel").css("display","none");
                    }
                });
            }
        }
    }

    if (data.atualizaravisos != undefined) {
        if (data.atualizaravisos) {
            GerenciarMenu("AtualizarAvisos");
        }
    }

    if (data.atualizarprocurados != undefined) {
        if (data.atualizarprocurados) {
            GerenciarMenu("ProcuradosAtualizar");
        }
    }
});

document.addEventListener("keyup", (event) => {
    if (event.isComposing || event.key === "Escape") {
        $(".menumodal").css("display","none")
        $(".menumodal2").css("display","none")
        funcaofechar();
    }
});

function funcaofechar() {
    const intervaloOpacidade = setInterval(function() {
        const opacity = $(".policia").css("opacity");

        if (parseFloat(opacity) >= 1) {
            clearInterval(intervaloOpacidade);
            $('.policia').stop().fadeOut(1000);
            $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}), (data) => {});
        }
    }, 100);
}