workspace {
    model {
        passageiro = person "Passageiro" "Usuário que solicita corridas e realiza pagamentos."

        sistemaCorrida = softwareSystem "Sistema de Corridas" "Plataforma de gerenciamento de viagens." {

            appPassageiro = container "Aplicativo do Passageiro" "Interface mobile para solicitar viagens." "Flutter / Mobile" "Mobile App" {

                group "Camada de Apresentação" {
                    telaHome = component "Tela Inicial / Mapa" "Exibe a localização atual e permite digitar o destino." "Flutter Widget"

                    telaCorrida = component "Tela de Corrida" "Exibe informações e atualizações da corrida em andamento." "Flutter Widget"

                    telaPagamento = component "Tela de Pagamento" "Permite selecionar a forma de pagamento e visualizar o valor da corrida." "Flutter Widget"
                }

                group "Camada de Aplicação" {
                    gerenciadorCorridas = component "Gerenciador de Corridas" "Controla as solicitações e o acompanhamento das viagens." "Dart Service"

                    gerenciadorLocalizacao = component "Gerenciador de Localização" "Captura as coordenadas de GPS do smartphone." "Dart Service"

                    gerenciadorPagamento = component "Gerenciador de Pagamento" "Controla a seleção e o envio da forma de pagamento." "Dart Service"
                }

                group "Camada de Infraestrutura" {
                    clienteApi = component "Cliente da API" "Realiza a comunicação com o backend." "Dio / WebSockets"
                }
            }

            apiGateway = container "API Gateway / Backend" "Centraliza as regras de negócio e o processamento das corridas." "Go / Node.js" "Backend API"

            bancoDados = container "Banco de Dados" "Armazena dados de usuários, viagens e pagamentos." "PostgreSQL + PostGIS" "Database"
        }

        gatewayPagamento = softwareSystem "Gateway de Pagamento" "Processa transações financeiras." "External"

        servicoMapas = softwareSystem "Serviço de Mapas" "Calcula rotas e fornece mapas." "External"

        passageiro -> telaHome "Visualiza o mapa e informa o destino"

        telaHome -> gerenciadorLocalizacao "Obtém a localização atual"

        telaHome -> gerenciadorCorridas "Solicita uma corrida"

        telaCorrida -> gerenciadorCorridas "Acompanha a corrida"

        telaPagamento -> gerenciadorPagamento "Seleciona a forma de pagamento"

        gerenciadorCorridas -> clienteApi "Envia solicitações de corrida"

        gerenciadorLocalizacao -> clienteApi "Envia localização"

        gerenciadorPagamento -> clienteApi "Envia dados de pagamento"

        clienteApi -> apiGateway "Envia requisições" "HTTPS / WebSockets"

        apiGateway -> bancoDados "Lê e grava dados" "SQL"

        apiGateway -> gatewayPagamento "Processa pagamentos" "HTTPS"

        apiGateway -> servicoMapas "Consulta rotas e distâncias" "HTTPS"
    }

    views {
        component appPassageiro "Componentes_App_Passageiro" {
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