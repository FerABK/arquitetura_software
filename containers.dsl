workspace {
    model {
        
        passageiro = person "Passageiro" "Usuário que solicita corridas e realiza pagamentos."

        motorista = person "Motorista" "Prestador de serviço que recebe solicitações de corrida e realiza o transporte."

      
        sistemaCorrida = softwareSystem "Sistema de Corridas" "Gerencia solicitações de viagens, correspondência de rotas e faturamento." {

            appPassageiro = container "Aplicativo do Passageiro" "Interface mobile para solicitar viagens e acompanhar corridas." "Flutter / iOS / Android" "Mobile App"

            appMotorista = container "Aplicativo do Motorista" "Interface mobile para receber solicitações e gerenciar corridas." "Flutter / iOS / Android" "Mobile App"

            apiGateway = container "API Gateway / Backend" "Centraliza as regras de negócio, geolocalização, matching de corridas e faturamento." "Go / Node.js" "Backend API"

            bancoDados = container "Banco de Dados" "Armazena dados de usuários, histórico de viagens, pagamentos e coordenadas físicas." "PostgreSQL + PostGIS" "Database"
        }

       
        gatewayPagamento = softwareSystem "Gateway de Pagamento" "Processa transações financeiras de cartões de crédito e Pix." "External"

        servicoMapas = softwareSystem "Serviço de Mapas" "Fornece mapas, rotas, distância e tempo estimado de viagem." "External"

        servicoVerificacao = softwareSystem "Serviço de Verificação" "Fornece informações de score e antecedentes dos prestadores." "External"

     
        passageiro -> appPassageiro "Solicita corridas e acompanha viagens usando"

        motorista -> appMotorista "Gerencia cadastro e corridas usando"

        
        appPassageiro -> apiGateway "Faz requisições e envia localização via" "JSON/HTTPS e WebSockets"

        appMotorista -> apiGateway "Recebe solicitações e envia respostas via" "JSON/HTTPS e WebSockets"

        apiGateway -> bancoDados "Lê e grava dados em" "SQL/TCP"

        apiGateway -> gatewayPagamento "Dispara cobranças e processa pagamentos em" "JSON/HTTPS"

        apiGateway -> servicoMapas "Consulta rotas e distância em" "JSON/HTTPS"

        apiGateway -> servicoVerificacao "Consulta score e antecedentes em" "JSON/HTTPS"
    }

    views {
      
        container sistemaCorrida "Containers_Corrida" {
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

            element "Backend API" {
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
