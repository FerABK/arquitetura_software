workspace {https://playground.structurizr.com/static/bootstrap-icons/palette.svg
    model {
        # Personas (Usuários)
        passageiro = person "Passageiro" "Usuário que solicita corridas e realiza pagamentos."

        motorista = person "Motorista" "Prestador de serviço que se cadastra, recebe solicitações e realiza corridas."

        # Sistema Principal
        sistemaCorrida = softwareSystem "Sistema de Corridas" "Gerencia solicitações de viagens, correspondência de rotas, faturamento e repasses aos motoristas."

        # Sistemas Externos
        gatewayPagamento = softwareSystem "Gateway de Pagamento" "Processa transações financeiras de cartões de crédito e Pix." "External"

        servicoMapas = softwareSystem "Serviço de Mapas" "Fornece mapas, rotas, distância e tempo estimado de viagem." "External"

        servicoVerificacao = softwareSystem "Serviço de Verificação" "Fornece informações de score e antecedentes dos prestadores." "External"

        # Relacionamentos
        passageiro -> sistemaCorrida "Solicita corridas, acompanha o trajeto e realiza pagamentos"

        motorista -> sistemaCorrida "Cadastra-se, recebe solicitações, aceita ou recusa corridas e realiza viagens"

        sistemaCorrida -> gatewayPagamento "Envia cobranças e processa pagamentos eletrônicos"

        sistemaCorrida -> servicoMapas "Consulta rotas, distância e tempo de viagem"

        sistemaCorrida -> servicoVerificacao "Consulta score e antecedentes dos prestadores"

        gatewayPagamento -> passageiro "Envia confirmação de cobrança"
    }

    views {
        systemContext sistemaCorrida "Contexto_Corrida" {
            include *
            autolayout lr
        }

        styles {
            element "External" {
                background #999999
                color #ffffff
            }
        }

        theme default
    }
}
