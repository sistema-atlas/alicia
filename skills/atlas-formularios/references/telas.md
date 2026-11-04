# Telas: formulários, pesquisas e quizzes

Endereço base: `https://crm.atlasoficial.com/v2/location/<locationId>/`. Se o cliente usa outro domínio, use o que aparece na aba dele. Confirme o nome da conta na tela antes de clicar.

Fonte: mapeamento real da conta Atlas em 05/10/2026 e 07/10/2026 (docs de navegação do projeto) e conferência somente leitura de 03/11/2026 (`fabrica/telas-conferidas.md` e `telas-conferidas-2.md`). (conferido em 03/11/2026) marca o que foi visto nessa conferência. Onde está marcado `(a conferir no navegador)`, o caminho veio da documentação do fornecedor e não foi visto na tela.

## Como a área se comporta

- Cada aba leva de 10 a 15 segundos para carregar (medido na conta Atlas em 05/10/2026, guia de navegação de Sites). Espere o esqueleto cinza sumir.
- Os construtores rodam dentro de um iframe de outra origem: não dá para ler o DOM nem o texto do construtor. Trabalhe por print e clique.
- As subabas de Formulários (Analíticos, Envios, Configurações) também ficam no iframe: clique pela posição na tela.
- Menus de três pontinhos não fecham com Esc. Clique numa área vazia. Um Esc seguido de clique já caiu em "Duplicar".
- Trabalhe com uma aba do CRM só. Aba em segundo plano congela.

## Mapa

| Tela | Endereço direto | Cliques a partir do menu |
| --- | --- | --- |
| Lista de formulários | `form-builder/main` (conferido em 03/11/2026) | Sites > Formulários |
| Editor de formulário | `form-builder-v2/<formId>` (conferido em 03/11/2026) | Formulários > menu da linha > Editar |
| Envios de formulário | `form-builder/main`, subaba Envios | Formulários > Envios |
| Analíticos de formulário | subaba Analíticos | Formulários > Analíticos |
| Configurações gerais de formulários | subaba Configurações | Formulários > Configurações |
| Lista de pesquisas | `survey-builder/main` (conferido em 03/11/2026) | Sites > Pesquisas (botões "Funcionalidades da pesquisa", "Create survey") |
| Editor de pesquisa | `survey-builder-v2/<surveyId>` (conferido em 03/11/2026) | Pesquisas > menu da linha > Editar |
| Lista de quizzes | `quiz-builder/main` (conferido em 03/11/2026) | Sites > Testes (título "Questionários"; abas "Todos os questionários", "Envios", "Configurações"; botão "Create quiz") |
| Editor de quiz | `quiz-builder-v2/<quizId>` (conferido em 04/11/2026 na conta Demo); a lista é `quiz-builder/main` | Testes > abrir o quiz, ou "Create quiz" > "Começar do zero" ou "A partir de modelos" > "Criar" |
| Marca da conta (cores, fontes e logo) | `marketing/brand-boards` (conferido em 03/11/2026) | Configurações > Brand Boards (fica no menu de Configurações; ao cliente diga "marca da conta") |
| Mídia | `media-storage` (conferido em 03/11/2026) | Mídia Drive (o link exato vem em `uiUrl` do `fetch-media-content`) |

Prints: `prints/13-formularios-lista.jpg`, `prints/14-formularios-menu-acoes.jpg`, `prints/17-formularios-configuracoes.jpg`, `prints/05-adicionar-campos-de-objeto.jpg`, `prints/12-condicoes-pular-para.jpg`, `prints/15-css-personalizado.jpg`.

## Lista de formulários

- Abas "Todos os formulários", "Analíticos", "Envios", "Configurações" (conferido em 03/11/2026).
- Topo: "Recursos do formulário", pasta, **Criar formulário**, pesquisa, alternar visão.
- Menu de cada linha (conferido em 03/11/2026): Editar, Pré-visualizar, Exibir envio, Duplicar, Compartilhar (código de incorporação e link), Upload para modelos de formulários, Mover para a pasta, Excluir.
- Duplicar e Excluir pedem aprovação. Excluir: só com pedido expresso, aprovação reforçada.

## Envios

- Seletor de formulário, contador "Total envios", intervalo de datas (padrão últimos 30 dias).
- Colunas configuráveis e botão **Exportar**. Exportar só com pedido do cliente: sai com dados pessoais.
- Prefira ler envios pelo MCP (`get-forms-submissions`).

## Configurações gerais de formulários

Valem para todos os formulários da conta. Cada item tem **Ativar todos**, **Desativar tudo** e **Gerenciar formulários individuais**. Nada muda sem **Salvar alterações**.

| Item | O que faz |
| --- | --- |
| Criar chat ao enviar | Cria uma conversa para cada envio |
| Gerar documento de envio | PDF do envio anexado ao contato |
| Contato fixo | Preenche os dados de quem volta no mesmo navegador |
| Salvar progresso | Pergunta antes de a pessoa sair da página |
| Ativar fuso horário | Captura o fuso de quem envia |
| Fonte compatível com GDPR | Não carrega fontes do Google |

Mude só pelo **Gerenciar formulários individuais**, no formulário pedido. "Ativar todos" e "Desativar tudo" ficam proibidos sem aprovação reforçada (`CONFIRMO MASSA`).

## Editor de formulário (por dentro)

- Topo (conferido em 03/11/2026): "Voltar", "Recomendações", "Pré-visualizar", **Salvar**; abas "Editar", "Configurações", "Integrar", "Envios", "Notificações", "Analytics".
- Botão "+" ("Adicionar elemento do formulário") abre o painel "Elemento do formulário" com abas **Adição rápida** e **Adicionar campos de objeto** (use sempre esta para gravar no contato; seletor "Contact", campo com a chave, ex.: `contact.first_name`) (conferido em 03/11/2026).
- Configuração do campo: clicar no campo > engrenagem, abas "Conteúdo" ("Rótulo", "Placeholder", "Rótulo curto", "Chave de consulta", "Largura do campo", "Obrigatório", "Configurações avançadas") e "Opções" ("Rótulo de opção", lixeira por opção) (conferido em 03/11/2026).
- Aba "Configurações" (conferido em 03/11/2026): "Ao enviar" ("Mensagem" ou redirecionar), "ID do pixel do Facebook", "Eventos do pixel do Facebook", chaves como "Criar chat ao enviar" e "Salve o progresso dos formulários".
- Aba "Integrar" (conferido em 03/11/2026): "Incorporar", "Compartilhar", "E-mail", "Conexões". Aba "Notificações" (conferido em 03/11/2026): "Notificação por e-mail", "Resposta automática" (campos internos no formulário a conferir no navegador; no editor de quiz, mesmo nome de aba, conferido em 04/11/2026 na conta Demo: "Notificação por e-mail" tem "Assunto", "E-mail (Para)", "Responder ao e-mail", "Nome do remetente"; "Resposta automática" tem "Assunto", "Responder ao e-mail", "Nome do remetente"; os dois com "Cancelar" e "Salvar").
- **Estilos e Opções**: ícone no canto superior direito da barra do construtor. Abas Estilos (Layout, Cores), Temas, Avançado (CSS personalizado).
- Nome: lápis ao lado do título. **Salvar** no topo.
- Detalhes: `construtor-formularios.md`.

## Editor de pesquisa (por dentro)

- **Estilos > Layout > "Uma pergunta de cada vez"**.
- **Estilos > Rodapé**: textos de Anterior, Próximo e Enviar.
- Mesmas abas do editor de formulário; canvas por "Slide 1", "Slide 2", "Adicionar slide" (conferido em 03/11/2026).
- **Configurações > Ao enviar**: Mensagem, "Redirecionar para URL" ou Confirmação. Aviso na tela: "A lógica condicional terá precedência sobre a mensagem/ redirecionamento aqui" (conferido em 03/11/2026).
- Engrenagem do slide: "Nome do slide", "Posição do slide", "Pular para" (padrão "Próximo Slide (Padrão)") (conferido em 03/11/2026). Ícone de condições ao lado do + no topo: lógica condicional.
- **Estilos & Opções > Avançado > CSS personalizado**.
- Detalhes: `pesquisas-uma-por-tela.md`.

## Editor de quiz (por dentro)

Mapeado pela documentação do fornecedor e conferido em 04/11/2026 na conta Demo, num quiz de teste ("Teste Alicia quiz"). A conta Atlas não tem quiz.
- Abas "Editar", "Configurações", "Integrar", "Envios", "Notificações"; no topo, "Voltar", o nome com lápis, "Recomendações", "Pré-visualizar" e "Salvar" `(conferido em 04/11/2026 na conta Demo)`.
- Faixas de pontuação: aba "Configurações" > bloco "Ao enviar" > "Editar página de resultados" > tela "Personalizar página de resultados" > botão "Configuração Níveis de Pontuação" (também pela aba "Editar" > "Modelo de página de resultados" > "Editar Modelo") `(conferido em 04/11/2026 na conta Demo)`.
- Publicar: aba **Integrar** (fica entre as abas do topo, não no canto): menu "Incorporar", "Compartilhar", "Conexões"; em "Incorporar em", "Funis", "Sites" e "Incorporar código" `(conferido em 04/11/2026 na conta Demo)`.
- Detalhes: `quizzes.md`.

## Link público

- Formulário: `https://<domínio da conta>/widget/form/<formId>`.
- Pesquisa: `https://<domínio da conta>/widget/survey/<surveyId>`.
- O domínio certo é o que aparece em Compartilhar ou Integrar. Entregue ao cliente sempre esse link, nunca invente domínio.
- Na conta Atlas, o domínio de marca é `links.atlasoficial.com`. Cada cliente tem o seu.
