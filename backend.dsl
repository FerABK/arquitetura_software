workspace {
    model {
        # Sistemas Externos
        gatewayPagamento = softwareSystem "Gateway de Pagamento" "Processa transações financeiras de cartões de crédito e Pix." "External"

        servicoMapas = softwareSystem "Serviço de Mapas" "Calcula rotas, distâncias e tempos de viagem." "External"

        servicoVerificacao = softwareSystem "Serviço de Verificação" "Fornece informações de score e antecedentes dos prestadores." "External"

        # Sistema Principal
        sistemaCorrida = softwareSystem "Sistema de Corridas" "Plataforma de gerenciamento de viagens." {

            bancoDados = container "Banco de Dados" "Armazena dados de usuários, prestadores, corridas, pagamentos e histórico de localização." "PostgreSQL + PostGIS" "Database"

            # Backend aberto em Componentes com Divisões Internas (Grupos)
            apiGateway = container "API Gateway / Backend" "Centraliza as regras de negócio, geolocalização e matching de corridas." "Go / Node.js" "Backend API" {

                # Grupo 1: Componentes expostos de API
                group "Camada de API / Entrada" {
                    controladorAutenticacao = component "Controlador de Autenticação" "Valida tokens de acesso e gerencia sessões de passageiros e motoristas." "Go Controller"

                    controladorCorrida = component "Controlador de Corridas" "Recebe pedidos de viagens, aceitações e recusas dos motoristas." "Go Controller"

                    controladorPagamento = component "Controlador de Pagamentos" "Recebe solicitações de cobrança e consulta de pagamentos." "Go Controller"
                }

                # Grupo 2: Regras de negócio internas
                group "Camada de Negócio / Core" {
                    motorMatching = component "Motor de Correspondência (Matching)" "Encontra prestadores disponíveis e aptos considerando proximidade, categoria e disponibilidade." "Go Service"

                    calculadorPreco = component "Calculador de Tarifas" "Calcula o preço estimado da corrida com base na distância, tempo e categoria do veículo." "Go Service"

                    gerenciadorCorrida = component "Gerenciador de Corridas" "Coordena o ciclo de vida das viagens, incluindo solicitações, aceitações, recusas e finalizações." "Go Service"

                    gerenciadorPagamento = component "Gerenciador de Pagamentos" "Controla pagamentos antecipados e organiza os repasses aos motoristas a cada dez dias." "Go Service"

                    gerenciadorLocalizacao = component "Gerenciador de Localização" "Recebe e atualiza as coordenadas de passageiros e motoristas." "Go Service"

                    gerenciadorCadastro = component "Gerenciador de Cadastro" "Controla o cadastro de passageiros e prestadores, incluindo a categoria e os dados dos veículos." "Go Service"
                }

                # Grupo 3: Persistência e Integração
                group "Camada de Persistência e Integração" {
                    repositorioUsuarios = component "Repositório de Usuários" "Consulta e grava os dados de passageiros e motoristas." "Repository"

                    repositorioCorridas = component "Repositório de Corridas" "Salva e consulta dados das corridas." "Repository"

                    repositorioPagamentos = component "Repositório de Pagamentos" "Registra cobranças e repasses financeiros." "Repository"

                    integracaoExterna = component "Integrações Externas" "Centraliza a comunicação com serviços de mapas, pagamentos e verificação de prestadores." "HTTP Client"
                }
            }
        }

        # Relacionamentos Internos do Backend (Da API para o Core)
        controladorAutenticacao -> gerenciadorCadastro "Solicita operações de cadastro"
        controladorAutenticacao -> repositorioUsuarios "Verifica credenciais em"

        controladorCorrida -> gerenciadorCorrida "Solicita processamento da corrida"

        gerenciadorCorrida -> calculadorPreco "Solicita cálculo de tarifa para"

        gerenciadorCorrida -> motorMatching "Dispara busca de prestador em"

        gerenciadorCorrida -> gerenciadorPagamento "Solicita processamento do pagamento"

        gerenciadorCorrida -> repositorioCorridas "Consulta e grava corridas"

        controladorPagamento -> gerenciadorPagamento "Solicita operações financeiras"

        gerenciadorPagamento -> repositorioPagamentos "Consulta e grava transações"

        gerenciadorCadastro -> repositorioUsuarios "Consulta e grava dados de usuários"

        gerenciadorLocalizacao -> repositorioUsuarios "Atualiza coordenadas dos prestadores"

        # Relacionamentos dos Componentes com Banco e Sistemas Externos
        repositorioUsuarios -> bancoDados "Lê e grava dados de usuários" "SQL/TCP"

        repositorioCorridas -> bancoDados "Lê e grava dados das corridas" "SQL/TCP"

        repositorioPagamentos -> bancoDados "Lê e grava dados financeiros" "SQL/TCP"

        motorMatching -> repositorioUsuarios "Busca prestadores por proximidade geográfica" "SQL/TCP"

        gerenciadorLocalizacao -> repositorioUsuarios "Atualiza localização dos prestadores"

        calculadorPreco -> integracaoExterna "Solicita distância e tempo de rota"

        gerenciadorPagamento -> integracaoExterna "Solicita processamento de pagamentos eletrônicos"

        gerenciadorCadastro -> integracaoExterna "Solicita verificação de prestadores"

        integracaoExterna -> gatewayPagamento "Efetua cobranças e consulta transações" "HTTPS"

        integracaoExterna -> servicoMapas "Consulta rotas e distância" "HTTPS"

        integracaoExterna -> servicoVerificacao "Consulta score e antecedentes" "HTTPS"
    }

    views {
        # Visualização de nível 3 (Componentes) do Backend
        component apiGateway "Componentes_Backend_Agrupados" {
            include *
            autolayout lr
        }

        styles {
            element "External" {
                background #999999
                color #ffffff
            }

            element "Database" {
                shape Cylinder
                background #112d4e
                color #ffffff
            }

            element "Component" {
                background #85bb65
                color #000000
            }
        }

        theme default
    }
}
