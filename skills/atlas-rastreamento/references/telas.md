# Telas: rastreamento e relatórios de origem

Endereço base: `https://crm.atlasoficial.com/v2/location/<locationId>/`. Confirme o nome da conta na tela.

Fontes: mapeamento da conta Atlas (05/10/2026 e 07/10/2026) e documentação oficial do fornecedor consultada em 03/11/2026 (artigos "adicionar código de rastreamento a funis e sites", "pixel de evento de funil e API de Conversões", "Google Analytics 4 em funis e sites", "origem da atribuição", "relatório de origem do lead", "rastreamento externo"). Nomes de botão em português podem diferir da documentação: onde não foi visto na tela, está `(a conferir no navegador)`.

## Mapa

| Tela | Endereço ou caminho | Visto na tela? |
| --- | --- | --- |
| Lista de funis | `funnels-websites/funnels` | Sim |
| Lista de sites | `funnels-websites/websites` | Sim |
| Configurações do funil ou site (código do cabeçalho e do corpo para o funil inteiro) | `funnels-websites/funnels/<funnelId>/settings`: abrir o funil > aba **Configurações** > bloco "Rastreamento e scripts" > "Código de rastreamento do cabeçalho" e "Código de rastreamento do corpo"; botão "Salvar" | `(conferido em 03/11/2026)` (funil); site `(conferido em 04/11/2026)`: `funnels-websites/websites/<siteId>/settings`, aba "Configurações", mesmo bloco "Rastreamento e scripts" com os dois códigos e "Widget de chat", botão "Salvar" |
| Código de uma página só | construtor da página > ícone de código > código do cabeçalho e código do rodapé (na documentação, em inglês: Header Tracking e Footer Tracking; não use com o cliente). Página não tem campo de corpo | Sim (cabeçalho, 07/10/2026) |
| Pixel do Facebook na pesquisa | editor da pesquisa > Configurações > Pixel do Facebook (evento na página e no envio) | Sim (07/10/2026) |
| Pixel no formulário | editor do formulário > aba "Configurações" > "ID do pixel do Facebook" e "Eventos do pixel do Facebook" ("Exibição na página", "No envio do formulário") | `(conferido em 03/11/2026)` |
| Analytics das páginas | `analytics` (Sites > Analytics) | Sim |
| Atribuição de um contato | Contatos > abrir o contato > lateral esquerda, "Todos os campos" > bloco "Contato": "Fonte de contato", "Subfonte", "Referência da fonte"; no centro, abas "Conversas" e "Atividade" | campos `(conferido em 04/11/2026)`; o cartão com dados de atribuição `(a conferir no navegador)`: não apareceu no contato aberto, que veio do WhatsApp sem origem rastreada; conferir num contato vindo de formulário |
| Relatório de origem do lead | Painel de controle (`dashboard`) > "Editar painel" > aba "Widget" > "Pesquisar widgets". A conta Atlas já tem o widget "Relatório de fonte de leads" num painel. Ao cliente, diga "relatório de origem do lead". **O modo edição salva sozinho**: cada widget adicionado já fica no ar, peça aprovação antes (regra 7b da `atlas-relatorios-e-dashboards`) | `(conferido em 03/11/2026)` |
| Relatório de atribuição | `reporting/attribution`: Relatórios > aba "Relatório de atribuição" | `(conferido em 03/11/2026)` (interior não aberto) |
| Rastreamento externo (site fora do CRM) | Configurações > Rastreamento externo, `settings/external-tracking` | `(conferido em 03/11/2026)` |
| Gerenciador de anúncios | menu Marketing > Gerenciador de anúncios, `marketing/ad-manager/home` | `(conferido em 03/11/2026)` |

Prints em `prints/`: `21-codigo-cabecalho-redirecionamento.jpg` (campo de código do cabeçalho de uma página), `07-analytics.jpg` (Sites > Analytics).

## Sites > Analytics (visto em 05/10/2026)

- Filtros: tipo (Funis), item, período (padrão últimos 14 dias), Filtro avançado.
- Cartões: Visualizações de página, Inscrições, Vendas, Taxa de conversão.
- Tabelas: visualizações (total e únicas), tempo médio, saída antes de 30 s, por funil, IPs, navegadores, dispositivos, países, **canal de tráfego e fonte/mídia**, engajamento de vídeo.
- Não há operação no MCP para estes números. Leia pela tela.

## Relatório de origem do lead (documentação)

- Widget de painel. Mostra por origem: total de leads, abertos, ganhos, perdidos, abandonados, e valores (com permissão).
- Filtros: funil e responsável, origem e atribuição, tags, valor, campos personalizados, datas de criação e de mudança de status.
- **Conta oportunidades, não contatos únicos.** Oportunidade sem origem aparece como N/A. Agrupa pela origem da oportunidade; UTM entra como filtro extra.
- Montar painel: skill `atlas-relatorios-e-dashboards`.
