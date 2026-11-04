# Telas: cobranças, produtos e contratos

Endereço base: `https://crm.atlasoficial.com/v2/location/<locationId>/`. Se o cliente usa outro domínio, use o que aparece na aba dele. Confirme o nome da conta na tela antes de clicar.

Fonte: conferência na conta Atlas em 03/11/2026 (`fabrica/telas-conferidas.md`), só leitura. Onde diz "não aberto", o caminho está confirmado mas os botões internos não foram vistos.

| Tela | Endereço direto | Cliques a partir do menu | Estado |
| --- | --- | --- | --- |
| Pagamentos (faturas) | `payments/invoices` | Pagamentos > Faturas e estimativas > Todas as faturas | (conferido em 03/11/2026) |
| Faturas recorrentes | `payments/recurring-templates` | Faturas e estimativas > Faturas recorrentes | caminho (conferido em 03/11/2026) |
| Modelos de fatura | `payments/invoice-templates` | Faturas e estimativas > Modelos | caminho (conferido em 03/11/2026) |
| Orçamentos (estimativas) | `payments/v2/estimates` | Faturas e estimativas > Estimativas | caminho (conferido em 03/11/2026) |
| Arquivos e contratos | `payments/proposals-estimates` | Pagamentos > Arquivos e contratos > Todos os arquivos e contratos | (conferido em 03/11/2026) |
| Modelos de contrato | `payments/proposals-estimates/templates` | Arquivos e contratos > Modelos | caminho (conferido em 03/11/2026) |
| Pedidos | `payments/v2/orders` | Pagamentos > Pedidos | caminho (conferido em 03/11/2026) |
| Assinaturas | `payments/v2/subscriptions` | Pagamentos > Assinaturas | caminho (conferido em 03/11/2026) |
| Vendas (transações) | `payments/v2/transactions` | Pagamentos > Vendas | caminho (conferido em 03/11/2026) |
| Links de pagamento | `payments/v2/paymentlinks` | Pagamentos > Links de pagamento | caminho (conferido em 03/11/2026) |
| Produtos | `payments/products` | Pagamentos > Produtos | caminho (conferido em 03/11/2026) |
| Cupons | `payments/coupons` | Pagamentos > Coupons | caminho (conferido em 03/11/2026) |
| Configurações (recibos, impostos, notificações, envio) | `payments/settings/receipts` | Pagamentos > Configurações; menu à esquerda: Recibos, Impostos, Notificações, Envio e entrega, Cobranças diversas, Personalização do Link de Pagamento | (conferido em 03/11/2026) |
| Integrações de pagamento | `payments/integrations` | **só por URL** (não aparece na barra de Pagamentos) | (conferido em 03/11/2026) |
| Lojas | `funnels-websites/stores` | Sites > Lojas | visto em 05/10/2026 |

A barra de Pagamentos tem "Exportar como CSV".

## Conectar meio de pagamento

1. Abra `payments/integrations` direto pela URL.
2. A tela mostra "Integrações de pagamento" e "Configurar provedores". Provedor já ligado aparece com "Gerenciar"; os outros (PayPal, Mercado Pago e outros) com "Conectar".
3. O cliente clica em "Conectar" no provedor que quer e faz o login no site do provedor. O assistente nunca digita dados bancários nem aceita termos.
4. Ao voltar, confira se o provedor aparece como conectado.

## Criar modelo de contrato

1. Abra `payments/proposals-estimates/templates` (Pagamentos > Arquivos e contratos > Modelos).
2. Crie um modelo novo (botão de criar na tela; rótulo não conferido).
3. No editor: texto do contrato, campos que puxam dados do contato, bloco de assinatura e, se houver valor, bloco de produtos.
4. Salve como modelo. Não envie pela tela sem `CONFIRMO ENVIO`.
5. Confira pelo conector com `list-documents-contracts-templates` (`name`).

Os botões do editor não foram abertos na conferência: se o cliente estiver no Claude in Chrome, abra a tela junto e leia os rótulos antes de orientar.

## Impostos

Pagamentos > Configurações > Impostos (`payments/settings/receipts`, menu à esquerda). Mudança de imposto afeta todas as cobranças novas: aprovação simples, explicando o efeito.

## Reembolso

O cliente faz pela tela (Pagamentos > Vendas, abrir a venda). O assistente explica o caminho e confere depois por `list-transactions` (`amountRefunded`).
