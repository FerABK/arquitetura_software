workspace {
    model {
        # Personas
        passageiro = person "Passageiro" "Usuário que solicita corridas e realiza pagamentos."

        motorista = person "Motorista" "Prestador de serviço que recebe solicitações e realiza o transporte."

        # Sistema Principal
        sistemaCorrida = softwareSystem "Sistema de Corridas" "Plataforma de gerenciamento de viagens." {

            # Aplicativo do Passageiro aberto em Componentes (L3)
            appPassageiro = container "Aplicativo do Passageiro" "Interface mobile para solicitar viagens." "Flutter / Mobile" "Mobile App" {

                group "Camada de Apresentação" {
                    telaHome = component "Tela Inicial / Mapa" "Exibe a localização atual e permite digitar o destino." "Flutter Widget"

                    telaCorridaPassageiro = component "Tela de Corrida" "Exibe informações e atualizações da corrida em andamento." "Flutter Widget"

                    telaPagamento = component "Tela de Pagamento" "Permite selecionar a forma de pagamento e visualizar o valor da corrida." "Flutter Widget"
                }

                group "Camada de Aplicação" {
                    gerenciadorCorridasPassageiro = component "Gerenciador de Corridas" "Controla as solicitações e o acompanhamento das viagens." "Dart Service"

                    gerenciadorLocalizacaoPassageiro = component "Gerenciador de Localização" "Captura as coordenadas de GPS do smartphone." "Core Location / Android GPS"

                    gerenciadorPagamento = component "Gerenciador de Pagamento" "Controla a seleção e o envio da forma de pagamento." "Dart Service"
                }

                group "Camada de Infraestrutura" {
                    clienteApiPassageiro = component "Cliente API (HTTP/WS)" "Gerencia a conexão de rede e envia dados para o backend." "Dio / WebSockets"
                }
            }

            # Aplicativo do Motorista aberto em Componentes (L3)
            appMotorista = container "Aplicativo do Motorista" "Interface mobile para receber solicitações e gerenciar corridas." "Flutter / Mobile" "Mobile App" {

                group "Camada de Apresentação" {
                    telaSolicitacoes = component "Tela de Solicitações" "Exibe as corridas disponíveis e permite aceitar ou recusar solicitações." "Flutter Widget"

                    telaCorridaMotorista = component "Tela de Corrida" "Exibe os detalhes e o andamento da viagem." "Flutter Widget"

                    telaPerfil = component "Tela de Perfil" "Exibe os dados do motorista e sua categoria de serviço." "Flutter Widget"
                }

                group "Camada de Aplicação" {
                    gerenciadorCorridasMotorista = component "Gerenciador de Corridas" "Controla a aceitação, recusa justificada e atualização do estado das corridas." "Dart Service"

                    gerenciadorLocalizacaoMotorista = component "Gerenciador de Localização" "Captura e envia a posição GPS do motorista durante o serviço." "Core Location / Android GPS"

                    gerenciadorPerfil = component "Gerenciador de Perfil" "Controla as informações do cadastro e a disponibilidade do motorista." "Dart Service"
                }

                group "Camada de Infraestrutura" {
                    clienteApiMotorista = component "Cliente API (HTTP/WS)" "Gerencia a conexão de rede e envia dados para o backend." "Dio / WebSockets"
                }
            }

            # Backend e Banco de Dados
            apiGateway = container "API Gateway / Backend" "Centraliza as regras de negócio e o processamento das corridas." "Go / Node.js" "Backend API"

            bancoDados = container "Banco de Dados" "Armazena dados de usuários e histórico de viagens." "PostgreSQL + PostGIS" "Database"
        }

        # Sistemas Externos
        gatewayPagamento = softwareSystem "Gateway de Pagamento" "Processa transações financeiras." "External"

        servicoMapas = softwareSystem "Serviço de Mapas" "Calcula rotas e fornece mapas." "External"

        # Relacionamentos dos Usuários com os Componentes Internos dos Aplicativos
        passageiro -> telaHome "Visualiza o mapa e insere o destino em"

        motorista -> telaSolicitacoes "Visualiza solicitações em"

        # Relacionamentos Internos do Aplicativo do Passageiro
        telaHome -> gerenciadorLocalizacaoPassageiro "Busca a posição atual do GPS em"

        telaHome -> gerenciadorCorridasPassageiro "Solicita uma corrida ao"

        telaCorridaPassageiro -> gerenciadorCorridasPassageiro "Consulta o andamento da viagem com"

        telaPagamento -> gerenciadorPagamento "Seleciona a forma de pagamento com"

        gerenciadorCorridasPassageiro -> clienteApiPassageiro "Envia solicitações por"

        gerenciadorPagamento -> clienteApiPassageiro "Envia dados de pagamento por"

        gerenciadorLocalizacaoPassageiro -> clienteApiPassageiro "Envia coordenadas por"

        clienteApiPassageiro -> apiGateway "Envia requisições e abre WebSockets para" "HTTPS/WS"

        # Relacionamentos Internos do Aplicativo do Motorista
        telaSolicitacoes -> gerenciadorCorridasMotorista "Aceita ou recusa corridas usando"

        telaCorridaMotorista -> gerenciadorCorridasMotorista "Atualiza o andamento da viagem usando"

        telaPerfil -> gerenciadorPerfil "Consulta os dados do perfil usando"

        gerenciadorCorridasMotorista -> clienteApiMotorista "Envia operações de corrida por"

        gerenciadorLocalizacaoMotorista -> clienteApiMotorista "Envia coordenadas GPS por"

        gerenciadorPerfil -> clienteApiMotorista "Envia consultas de perfil por"

        clienteApiMotorista -> apiGateway "Envia requisições e abre WebSockets para" "HTTPS/WS"

        # Relacionamentos Globais de Infraestrutura
        apiGateway -> bancoDados "Lê e grava dados em" "SQL/TCP"

        apiGateway -> gatewayPagamento "Efetua cobranças prévias usando" "HTTPS"

        apiGateway -> servicoMapas "Consulta rotas em" "HTTPS"
    }

    views {
        # Visualização de nível 3 do Aplicativo do Passageiro
        component appPassageiro "Componentes_App_Passageiro" {
            include *
            autolayout lr
        }

        # Visualização de nível 3 do Aplicativo do Motorista
        component appMotorista "Componentes_App_Motorista" {
            include *
            autolayout lr
        }

        styles {
            element "External" {
                background #999999
                color #ffffff
            }

            element "Mobile App" {
                shape MobileDevicePortrait
                background #05d5ff
                color #000000
            }

            element "Component" {
                background #85bb65
                color #000000
            }

            element "Database" {
                shape Cylinder
                background #112d4e
                color #ffffff
            }
        }

        theme default
    }
}
