# Relatórios de anúncios (Meta e Google)

Só leitura. Operações em `operacoes.md`, domínio `ad-publishing`.

## Antes de ler

1. A conta de anúncios precisa estar **conectada ao gerenciador de anúncios da conta** na Atlas. Sem isso, `fb-get-reporting` responde 422 "Ad Account not found for location" (visto na conta de teste em 03/11/2026).
2. A sessão do Facebook precisa estar válida. Sessão vencida responde 422 "Session invalidated" (visto em `fb-get-pixels`). Peça para o cliente reconectar o Facebook na tela de integrações.
3. `fb-get-ad-accounts` (`type: INTEGRATION`) mostra as contas que o login do Facebook enxerga e se estão ligadas (`integrationConnected`).

## Leitura padrão de um período

| Pergunta | Chamada |
| --- | --- |
| Quanto gastei e quantos resultados no Meta | `fb-get-reporting` com `fields: ["spend","impressions","clicks","results","conversions"]`, `type`, datas |
| Por campanha | `fb-get-reporting-list` com `listType: campaigns` |
| Por conjunto ou anúncio | `fb-get-reporting-list` com `listType: adsets` ou `ads` e `campaignId` |
| Uma campanha com leads do CRM | `fb-get-campaign-reporting` (campanha publicada) |
| Google Ads | `google-get-reporting` (`cost_micros` dividido por 1.000.000), `google-get-reporting-list`, `google-get-campaign-reporting` |

Use `type: INTEGRATION` para conta ligada pela integração; `AD_MANAGER` para campanhas criadas no gerenciador de anúncios do próprio CRM. Se uma der vazio, tente a outra uma vez.

## Contas que não fecham

- Totais do Meta: CPM, CTR e frequência vêm somados. Recalcule a partir de gasto, cliques e impressões.
- `cost_per_result` e `cost_per_conversion` vêm 0. Use `costPerConversion` e `costPerResultBreakdown` (vistos na projeção da resposta). `costPerResult` só depois de confirmado numa conta conectada. Sem eles, calcule gasto / resultados e diga que é cálculo.
- Custo por lead do CRM: gasto do período dividido pelos contatos atribuídos à campanha (atribuição com `utmCampaign` ou `leads` do `fb-get-campaign-reporting`). Diga qual base usou.

## Criar ou mexer em anúncio

Não é desta skill. Criar, alterar orçamento, publicar ou pausar campanha gasta dinheiro do cliente: só com pedido expresso, `CONFIRMO COBRANÇA` repetindo conta, orçamento e objetivo, e de preferência com uma pessoa da Atlas acompanhando. Novidades anunciadas no LevelUp 2026 (post oficial de 27/10/2026) no gerenciador de anúncios, como sincronização nos dois sentidos com o Meta, não mudam essa regra.
