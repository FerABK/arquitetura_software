workspace {
    model {
        motorista = person "Motorista" "Prestador que recebe solicitações e realiza corridas."

        sistemaCorrida = softwareSystem "Sistema de Corridas" "Plataforma de transporte." {

            appMotorista = container "App Motorista" "Aplicativo para receber solicitações e gerenciar corridas." "Flutter / React Native" "Mobile App" {

                group "Camada de Apresentação" {
                    telaSolicitacoes = component "Tela de Solicitações" "Exibe as corridas disponíveis e permite aceitar ou recusar solicitações." "Flutter Widget"

                    telaCorrida = component "Tela de Corrida" "Exibe os detalhes e o andamento da viagem." "Flutter Widget"

                    telaPerfil = component "Tela de Perfil" "Exibe os dados do motorista e sua categoria de serviço." "Flutter Widget"
                }

                group "Camada de Aplicação" {
                    gerenciadorCorridas = component "Gerenciador de Corridas" "Controla a aceitação, recusa e atualização do estado das corridas." "Dart Service"

                    gerenciadorLocalizacao = component "Gerenciador de Localização" "Obtém e envia a posição GPS do motorista durante o serviço." "Dart Service"

                    gerenciadorPerfil = component "Gerenciador de Perfil" "Controla as informações do cadastro do motorista." "Dart Service"
                }

                group "Camada de Infraestrutura" {
                    clienteApi = component "Cliente da API" "Realiza a comunicação HTTP e WebSocket com o backend." "Dio / WebSockets"
                }
            }

            apiGateway = container "API Gateway / Load Balancer" "Recebe e encaminha as requisições dos aplicativos." "API Gateway"

            servicoAutenticacao = container "Serviço de Autenticação" "Gerencia cadastro e validação de acesso." "Node.js / NestJS"

            servicoMatching = container "Serviço de Matching de Corridas" "Localiza motoristas disponíveis e compatíveis com solicitações." "Node.js / NestJS"

            servicoGeolocalizacao = container "Serviço de Geolocalização GPS" "Gerencia posições dos usuários." "Go (Golang)"
        }

        motorista -> appMotorista "Utiliza o aplicativo"

        motorista -> telaSolicitacoes "Visualiza solicitações em"
        motorista -> telaCorrida "Acompanha a viagem em"
        motorista -> telaPerfil "Consulta seus dados em"

        telaSolicitacoes -> gerenciadorCorridas "Aceita ou recusa corridas usando"
        telaCorrida -> gerenciadorCorridas "Atualiza o andamento da viagem usando"
        telaPerfil -> gerenciadorPerfil "Consulta os dados do perfil usando"

        gerenciadorCorridas -> clienteApi "Envia operações de corrida por"
        gerenciadorLocalizacao -> clienteApi "Envia coordenadas GPS por"
        gerenciadorPerfil -> clienteApi "Envia consultas de perfil por"

        clienteApi -> apiGateway "Envia requisições e recebe atualizações" "HTTPS / WebSockets"

        apiGateway -> servicoAutenticacao "Encaminha operações de autenticação"
        apiGateway -> servicoMatching "Encaminha atualizações de corridas"
        apiGateway -> servicoGeolocalizacao "Encaminha dados de localização"
    }

    views {
        component appMotorista "Componentes_App_Motorista" {
            include *
            autolayout lr
        }

        styles {
            element "Mobile App" {
                shape MobileDevicePortrait
                background #05d5ff
                color #000000
            }

            element "Component" {
                background #85bb65
                color #000000
            }
        }

        theme default
    }
}
