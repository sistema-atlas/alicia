# Telas: sites, funis, blog, mídia, domínios e QR

Endereço base: `https://crm.atlasoficial.com/v2/location/<locationId>/`. Se o cliente acessa por outro domínio, use o da aba dele. Confirme o nome da conta na tela.

Fonte: mapeamento real da área Sites na conta Atlas em 05/10/2026 e 07/10/2026 (docs de navegação do projeto), mais a documentação do fornecedor onde indicado, e conferência somente leitura de 03/11/2026 (`fabrica/telas-conferidas.md` e `telas-conferidas-2.md`), marcada (conferido em 03/11/2026). `(a conferir no navegador)` marca caminho não visto na tela.

## Como a área se comporta

- Cada aba leva 10 a 15 segundos para carregar. Antes disso aparece esqueleto cinza.
- Menus de três pontinhos não fecham com Esc: clique em área vazia. Um Esc seguido de clique já caiu em "Duplicar".
- No construtor de páginas, **digitar com o foco fora de um campo dispara atalhos** (abre painéis, muda o caminho da etapa). Clique no campo e confira o foco antes de digitar.
- Uma aba do CRM por vez. Aba em segundo plano congela.

## Mapa

| Tela | Endereço direto | Menu |
| --- | --- | --- |
| Funis | `funnels-websites/funnels` | Sites (abre em Funis) |
| Sites | `funnels-websites/websites` | Sites > Sites |
| Lojas | `funnels-websites/stores` | Sites > Lojas |
| Webinars | `funnels-websites/webinars` | Sites > Webinars |
| Analytics das páginas | `analytics` | Sites > Analytics |
| Blogs | `blogs` | Sites > Blogs |
| SEO (oferta paga) | `seo` | Sites > SEO |
| WordPress (oferta paga) | `wordpress` | Sites > WordPress |
| Widget de chat | `funnels-websites/chat-widget` (conferido em 03/11/2026) | Sites > Widget de chat |
| Códigos QR | `qr-codes` | Sites > Códigos QR |
| Domínios e redirecionamentos | `settings/domain` (conferido em 03/11/2026) | Configurações > Domínios e Redirecionamentos de URL (ou engrenagem no fim da barra de Sites) |
| Marca da conta (cores, fontes, logo) | `marketing/brand-boards` (conferido em 03/11/2026) | Configurações > Brand Boards (fica no menu de Configurações; ao cliente diga "marca da conta") |
| Mídia | `media-storage` (link exato no `uiUrl` do `fetch-media-content`) (conferido em 03/11/2026) | Mídia Drive |
| Portal do cliente | `funnels-websites/client-portal/dashboard` | Sites > Portal do cliente (skill `atlas-cursos-e-comunidade`) |

Prints em `prints/`: `02-funis-novo-funil.jpg`, `08-blogs.jpg`, `20-seo-titulo-descricao-imagem.jpg`, `21-codigos-qr.jpg`, `22-dominios.jpg`, `23-redirecionamentos-url.jpg`.

## Funis e Sites

- Lista com Nome, Última atualização e Etapas (ou Páginas de site).
- **Novo funil** (ou **Novo website**) abre "Criar novo funil" com três caminhos: **A partir do zero** (nome e construtor vazio), **Desenvolver com AI** (gera tudo por IA), **A partir de modelos** (biblioteca de modelos prontos).
- Botão roxo **Desenvolver com AI** no topo leva direto ao caminho de IA.
- Ícone de pasta, alternar visão, pesquisa.
- Dentro do funil (conferido em 03/11/2026): abas "Etapas", "Estatísticas", "Vendas", "Segurança", "Eventos", "SEO e AEO", "Configurações".
- Aba **Configurações** (`funnels-websites/funnels/<funnelId>/settings`) (conferido em 03/11/2026): "Detalhes de Funil" (Nome, Domínio, "conectar domínio", Caminho, "URL do favicon"), "Rastreamento e scripts" ("Código de rastreamento do cabeçalho", "Código de rastreamento do corpo", "Widget de chat"), "Pagamentos e finalização da compra", "Desempenho e conformidade", "SEO e AEO", "Funil acesso", "Excluir funil"; botão "Salvar". "Excluir funil" só com pedido expresso e `CONFIRMO EXCLUSÃO`.
- Etapa (`funnels-websites/funnels/<funnelId>/steps/<stepId>/overview`) (conferido em 03/11/2026): abas "Visão geral", "Produtos", "Publicando"; "Editar", "Iniciar teste A/B", "Criar variação", "Excluir etapa do funil", "Clonar etapa do funil".

## Etapa e construtor de página

Visto na conta Atlas em 07/10/2026 (funil de links curtos):
- Página vazia não salva ("Nenhuma seção encontrada"): adicione uma seção.
- Ícone **SEO e otimização** na barra de cima do construtor: Conteúdo (título, descrição) e Imagens (imagem de prévia).
- Código do cabeçalho da página: ícone de código no construtor (campos de código do cabeçalho e do rodapé; nomes em inglês na documentação, não use com o cliente).
- Caminho da página: **Etapa > Publicando > URL da etapa > Atualizar etapa**.
- Clonar etapa copia o SEO; o código de rastreamento da página **não** é copiado (documentação) e precisa ser conferido em cada clone.
- O painel "Pergunte à IA" pode abrir sozinho: feche no X.

## Blogs

- Cartões: Total de postagens, Sites de blog publicados, Visitantes por semana.
- **Crie um blog**, **Novo site de blog**, engrenagem de configurações do blog.
- Tabela: Site do blog, Status, Descrição, Última atualização.
- Botão flutuante de Feedback envia mensagem ao fornecedor. Não usar.

## Domínios e redirecionamentos

- Abas "Domínios" e "Redirecionamentos de URL"; botões "Compra/ Transferir domínios", "+ Conectar um domínio", "Pesquisar domínios" (conferido em 03/11/2026).
- **Domínios internos** (comprados pelo CRM) e **Domínios externos** (DNS fora). Cada domínio lista subdomínios e produtos conectados (Domínio de marca, E-mail, Portal do cliente, Funil/Site).
- Botões que mexem em DNS ou cobrança: Compra/Transferir, Conectar um domínio, Gerenciar. Só com aprovação reforçada.
- Página padrão e página 404 do domínio: Domínios > Gerenciar > editar subdomínio.
- **Redirecionamentos de URL**: Adicionar um redirecionamento, pesquisa por origem, período e contagem de cliques. Pelo MCP é mais rápido.

## Códigos QR

- **Gerar código QR**, Recursos de QR, atualizar, relatórios, importar, pasta.
- Grade ou lista, Filtrar, pesquisa, **Selecionar** para ações em massa.
- Cada QR: **Editar**, **Copiar link**, **Analytics**.
- Tipos em "Gerar código QR" > etapa "Escolher tipo" `(conferido em 04/11/2026 na conta Demo)`: "URL", "Revisar link", "Ligação", "SMS", "E-mail", "Pagamento", "WhatsApp", "Funil", "website", "Formulário", "Pesquisa", "Questionário", "Cartão de perfil", "Cartão V", "Cartão de visita", "Apps", "Calendário". Etapas seguintes: "Informações adicionais" e "Cor e formato do QR". Endereço da área: `qr-codes`.

## Widget de chat

- Lista "Widgets de chat" (conferido em 03/11/2026): abas "Biblioteca" e "Insights"; "+ Novo" cria outro; coluna "Tipo de chat"; menu da linha "Editar", "Clonar", "Excluir".
- Configuração (`funnels-websites/chat-widget/builder/<widgetId>`) (conferido em 03/11/2026): topo "Voltar", "Obtenha para WordPress", "Obter código", "Salvar"; abas "Estilo" (tipo de chat, "Posicionamento do widget"), "Janela de chat" ("Título & introdução", "Botões interativos", horário comercial, "Proteção contra spam"), "Mensagens" ("Idioma"), "Agente" ("Conversation AI", "Agentes conectados").
- Para pôr o chat num funil do CRM: aba Configurações do funil > "Rastreamento e scripts" > "Widget de chat" (conferido em 03/11/2026). O construtor de página não tem elemento de chat: a busca por "chat" em "Inserir Elemento" não acha nada (conferido em 04/11/2026 na conta Demo); use o "Widget de chat" das configurações do funil ou do site (no site, aba "Configurações" > "Rastreamento e scripts" > "Widget de chat", conferido em 04/11/2026). Em site externo: "Obter código" no widget e colar no site.

## Botões proibidos sem aprovação reforçada

- Botão de contratar o SEO pago, com valor mensal (assinatura paga): `CONFIRMO COBRANÇA`.
- "Ativar WordPress" (hospedagem paga).
- Compra de domínio.
- Portal do cliente: "Ative para todos" no modal do novo layout. Para fechar, "Talvez mais tarde".
