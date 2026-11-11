# WhatsApp da Atlas (integração de WhatsApp dentro do CRM)

**Só se a conta usar a integração de WhatsApp da Atlas.** Para o cliente é sempre "integração de WhatsApp da Atlas" ou "WhatsApp da Atlas". Nunca diga o nome da empresa que fornece a integração, nem se o cliente perguntar ("é a integração de WhatsApp da Atlas, mantida pela Atlas"). Fontes: skill interna da Atlas de cadastro de templates (outubro de 2026), envio real pelo conector (04/11/2026) e conferência do painel na conta Atlas, somente leitura (04/11/2026).

## 1. Qual WhatsApp esta conta usa?

Faça antes de qualquer ação de WhatsApp e guarde a resposta na conversa. Não repita a cada pedido.

### Roteiro de verificação

1. **Conversas pelo conector** (leitura, `limit: 1`):
   - `search-conversation` com `lastMessageType: TYPE_CUSTOM_SMS`. Se `total` for maior que 0, abra uma com `get-messages` (`limit: 1`). Sinais da integração: `messageType: TYPE_CUSTOM_SMS`; `conversationProviderId` de provedor personalizado (não é o do WhatsApp nativo); `meta.marketplace.appName` preenchido com o nome do app da integração (sempre em maiúsculas; não mostre ao cliente); texto que termina com `Source: <nome do número>`; em `search-conversation`, `lastChannelAccount` com o nome do app da integração, que não é um canal nativo.
   - `search-conversation` com `lastMessageType: TYPE_WHATSAPP`. Se `total` for maior que 0, a conta usa (ou já usou) o **WhatsApp nativo oficial** do CRM.
2. **Menu lateral** (navegador, se precisar): botão de WhatsApp logo acima de Configurações (na conta Atlas se chama "WhatsApp Atlas"; o nome varia por conta). Existe: a conta tem a integração. Não existe: não tem.
3. **Oficial ou não** (só na integração): no painel, tela "Escolha a instância", o selo ao lado do nome de cada número. "API QR" é não oficial. O número oficial tem selo de API oficial e aba Templates (skill interna da Atlas; na conta Atlas os 3 números são "API QR", então o selo oficial não foi visto nesta conferência). Dentro do número, a etiqueta ao lado do nome mostra "WhatsApp QR" no não oficial.
4. **WhatsApp nativo** (se o passo 1 não decidiu): Configurações > WhatsApp (`settings/whatsapp`). Conectado mostra o número; sem conexão mostra só a apresentação.
5. **Não deu para saber**: uma pergunta ao cliente: "O WhatsApp da sua conta está ligado pela integração de WhatsApp da Atlas ou pelo WhatsApp oficial do próprio CRM?"

### Resultado

| Resultado | Como fica |
| --- | --- |
| Nativo oficial | Só conversas `TYPE_WHATSAPP`, sem o botão no menu lateral |
| Integração com número oficial | Botão no menu; o número tem selo de API oficial e aba Templates |
| Integração não oficial | Botão no menu; o número tem selo "API QR" |
| Nenhum | Nenhuma conversa de WhatsApp, sem botão e `settings/whatsapp` sem conexão. Não há como enviar WhatsApp: ofereça falar com o suporte da Atlas para conectar |

Conta com as duas coisas (nativo e integração): pergunte por qual o cliente quer enviar, uma vez.

## 2. Caminho por ação

| Ação | Nativo oficial | Integração, número oficial | Integração, número não oficial |
| --- | --- | --- | --- |
| Enviar texto para um contato | Conector: `send-a-new-message` `type: WhatsApp` e o `conversationProviderId` da última mensagem da equipe. Janela de 24 horas | Conector: `type: SMS`, `contactId` e o `conversationProviderId` da conversa da integração. Janela de 24 horas | Conector: igual ao oficial, sem janela |
| Enviar escolhendo o número | Só existe o número conectado | Conector: primeiro um envio só com `#sw|N`, espera de 10 segundos, depois o texto (seção 3) | Conector: igual |
| Botões e listas | Não pelo comando. Só template com botões | Conector: comandos de `lista-e-botoes.md`, dentro da janela | Conector: comandos de `lista-e-botoes.md` |
| Template oficial | Tela da conversa ou automação (`whatsapp-oficial.md`) | Automação com dois nós de SMS (seção 5). Pelo conector, o mesmo par `#sw|N` e `#template|...` em dois envios, com 10 segundos entre eles: formato do nó de SMS, ainda não testado pelo conector; faça antes um envio de teste para o número do cliente | Não dá: número não oficial não tem template |
| Agendar para um contato | Conector: `scheduledTimestamp` | Não dá pelo conector nem pelo painel. Automação com "Esperar" até o horário e o envio da integração (`atlas-automacoes`) | Igual ao oficial |
| Agendar em grupo | Não dá: o nativo não manda para grupo | Não dá: grupos só existem no número não oficial | Painel: seção 4.1 |
| Mensagem recorrente em grupo | Não dá | Não dá | Painel: seção 4.2 |
| Campanha em massa | Automação ou ação em massa da lista, pela trava | Automação com template aprovado, pela trava | Painel: aba Disparos (seção 4.3) ou automação, pela trava |
| Criar ou listar grupos | Não dá | Não dá | Painel: aba Grupos (seção 4.4) |
| Ver status do número | Configurações > WhatsApp | Painel: card do número (seção 4.5) | Painel: card do número (seção 4.5) |

O conector não lista números, grupos, campanhas nem mensagens programadas da integração. No futuro a Atlas pode ligar um conector próprio de WhatsApp; até lá, o que não está na coluna "Conector" é painel.

## 3. Enviar pelo conector

- `send-a-new-message` com `type: "SMS"`, `contactId` e `conversationProviderId` igual ao `lastMessageConversationProviderId` da conversa. Confirmado com envio real em 04/11/2026: resposta 201, `get-message` com `messageType: TYPE_CUSTOM_SMS` e `status: delivered`.
- Sem `#sw`, sai pelo número já ligado à conversa, que o conector não mostra. O texto que termina com `Source: <nome do número>` diz por qual número a conversa passou (só aparece se "Mostrar de qual número veio" estiver ligado no número).
- **Escolher o número:** um envio só com `#sw|N`, **espera de pelo menos 10 segundos** e depois o texto, do mesmo jeito (testado em 04/11/2026 com `#sw|2`, os dois entregues). Sem a espera, o texto sai pelo número que estava ativo antes da troca: em 11/11/2026, na conta da Atlas, uma mensagem enviada menos de 1 segundo depois do `#sw|2` saiu por outro número. Cada texto tem o seu próprio `#sw|N` e a sua espera, mesmo que um envio anterior já tenha trocado. N é a **Ref.** do número, que aparece no painel ao lado do telefone, no topo da tela do número ("Ref. 2"). Na conta Atlas: suporte e lembretes saem pela Ref. 2.
- Número de envio confirmado com o cliente (nome do número e telefone com o meio mascarado) antes do `CONFIRMO ENVIO`, que vale para os dois envios.
- **`#attcontato`:** um envio só com `#attcontato` atualiza o contato no CRM com nome e foto. Não manda mensagem para o contato e não troca o número, então **não precisa de espera** antes nem depois. Uso típico: logo depois do `#sw|N` na automação de troca de ramal (AUT01 da Atlas: `#sw|N`, grava o ramal no contato, `#attcontato`). A espera de 10 segundos vale só entre `#sw|N` e uma mensagem que o contato vai receber.

Comandos da integração, em um envio de SMS cada:

| Comando | O que faz | Espera |
| --- | --- | --- |
| `#sw|N` | Troca o número que envia para a Ref. N | 10 segundos antes da próxima mensagem para o contato |
| `#attcontato` | Atualiza nome e foto do contato no CRM | Nenhuma |
| `#template|nome|PARAM_1` | Envia template oficial (seção 5) | Precisa do `#sw|N` e da espera antes |
| `#bt|...`, `#list|...` e os outros de `lista-e-botoes.md` | Botões e listas | Precisam do `#sw|N` e da espera antes |

## 4. Painel da integração (navegador)

Conferido em 04/11/2026 na conta Atlas, só leitura. Endereço: `custom-menu-link/<id>` dentro da conta (o id muda por conta; chegue pelo menu). O conteúdo fica dentro de um quadro na página: use print da tela, a leitura de texto da página não alcança.

Caminho: menu lateral, botão de WhatsApp acima de Configurações. Abre **"Escolha a instância"** ("N instâncias nesta subconta"), um card por número com nome, selo ("API QR"), telefone e situação ("Conectada"). Clique no card.

Tela do número: nome do número, situação ("Conectada há N dias"), etiqueta ("WhatsApp QR"), telefone, "Ref. N", botão "Reiniciar" (não clique) e as abas **Visão geral**, **IA**, **Voice**, **Grupos**, **Disparos**, **Configurações**. Voltar: "< Instâncias" no topo.

Regras do painel:
- Nunca abra, copie nem mostre o bloco "Dados para integração" da Visão geral (chave de acesso, servidor, ID): é credencial e o endereço do servidor é domínio técnico. Não clique no olho que revela a chave.
- Não clique em "Reiniciar", "Mostrar no CRM", "Ligar a v2", interruptores de Configurações, "Criar grupo", "Adicionar", "Enviar agora", "Agendar mensagem" ou "Continuar" sem a confirmação da ação (seção 6).
- Foto ou arquivo hospedado fora do domínio da conta não vai para o cliente. Descreva o caminho da tela.

### 4.1 Agendar mensagem em grupo (uma vez)
1. Aba **Grupos**. Ache o grupo em "Buscar grupo..." e clique nele. O painel da direita mostra o nome, o número de participantes e o ID do grupo; o selo "Só admins enviam" quer dizer que só administradores mandam mensagem.
2. Aba **Programadas** do grupo (filtros "Agendadas", "Recorrentes", "Histórico") e **Nova mensagem neste grupo**. Ou, no topo da aba Grupos, **Mensagens programadas**.
3. Formulário "Nova mensagem programada": **Para quais grupos** (o grupo já vem marcado; "+ grupo" soma outros), **Mensagem**, anexos (Imagem, Vídeo, Áudio, Documento), **Mencionar todos**.
4. **Quando**: "Agora", "Uma vez" ou "Repetir". Para agendar: "Uma vez", data (dd/mm/aaaa) e hora. A tela avisa: a data precisa estar pelo menos 1 minuto no futuro. Confira com o cliente que a hora é de Brasília; a tela não mostra o fuso.
5. Pré-visualização no chat e `CONFIRMO ENVIO`. Só então **Agendar mensagem**.
6. Conferir: a mensagem aparece em Mensagens programadas, filtro "Agendadas".

### 4.2 Mensagem recorrente em grupo
Mesmo formulário, **Quando: Repetir**: hora, **Frequência** ("Diária", "Semanal", "Mensal"), **Termina em (opcional)** e **Limite de envios (opcional)**. A tela diz que começa no próximo horário que bater com a frequência. Na aprovação, diga a frequência, a primeira data e até quando vai. `CONFIRMO ENVIO`, depois **Agendar mensagem**. Acompanhar em Mensagens programadas, filtro "Recorrentes". Mais de 20 envios previstos ou mais de um grupo grande: `CONFIRMO MASSA` antes.

Mensagens programadas tem ainda "Histórico" e "Em lote".

### 4.3 Campanha (disparo em massa)
Aba **Disparos** > **Criar disparo**. Assistente em 5 etapas: "Básico" (nome da campanha), "Remetentes" (números que enviam), "Mensagem" (texto livre e variações), "Público" (quem vai receber), "Revisar e enviar". O resumo da direita mostra tipo de envio ("WhatsApp por QR"), números, mensagem, contatos e estimativa de mensagens. A tela diz que nada é enviado antes da última etapa. Sair: **Cancelar**.
- Sempre pela trava (`trava-de-disparo.md`): inventário, links, teste, confirmação do cliente, `CONFIRMO MASSA` e `CONFIRMO ENVIO`.
- A etapa "Remetentes" deixa somar outros números para revezar. Use um número só, a não ser que o cliente peça, e avise que número não oficial pode ser bloqueado por disparo mal feito: público com opt-in, poucos contatos por vez, horário comercial.

### 4.4 Grupos
Aba **Grupos**: lista com "Buscar grupo...", contagem de grupos, atualizar, "Mostrar no CRM", "Selecionar", "Mensagens programadas" e **Criar grupo**. No detalhe do grupo: "Participantes" ("Adicionar pessoas", "Adicionar", "CSV") e "Programadas". Criar grupo e adicionar pessoas avisa gente real: `CONFIRMO ENVIO` com nome do grupo, número que cria e participantes (quantidade e 3 exemplos mascarados). Mais de 20 pessoas: `CONFIRMO MASSA` antes.

### 4.5 Status do número
No card de "Escolha a instância": "Conectada" ou outra situação; na tela do número, "Conectada há N dias". A tela avisa: desativada é sem link ativo (fale com quem administra a conta); desconectada abre normalmente e a conexão é feita lá dentro. Número desconectado: não envie, avise na primeira linha e mande para `atlas-suporte` ou o suporte da Atlas. Não gere QR nem reconecte pelo assistente.

### 4.6 Outras abas (só para explicar)
- **IA**: funil de atendimento com agentes ("Editar agentes", "Ligar a v2", horário). Agente que responde sozinho é da `atlas-agentes-ia` e ligar é ação reforçada.
- **Configurações**: "Comportamento no CRM" (transcrever áudios, descrever imagens, resumir PDFs, "Receber mensagens de grupo", "Mostrar de qual número veio", "Marcar como API Oficial", link global, ignorar números e grupos), "Número e responsável" (tag aplicada às conversas do número, usuário responsável, "Trocar o número sozinho": quando o cliente escreve para este número, a conversa passa a responder por ele), "Gatilhos", "Alertas e extras", "Voz com IA", "Chaves de IA", "SMS", "Webhook", "Proxy", "Resumo de conversas". Não mude nada aqui pelo assistente: "Webhook" e "Proxy" podem cortar a chegada das mensagens no CRM.
- **Templates** e etiquetas: a aba Templates só existe no número oficial (seção 5). Etiquetas não apareceram como aba no número não oficial conferido.

## 5. Template no número oficial

Template oficial só existe no número da API oficial. No número não oficial, nunca salve nem crie template: avise o cliente. Se aparecer aviso de acesso vencendo ou número que pode ficar indisponível, avise na primeira linha: o envio pode parar.

### Cadastrar
1. Aba **Templates**. Busque o nome para não duplicar.
2. **+ Criar template**. Preencha: nome (minúsculas e sublinhado), idioma Português (Brasil), categoria, cabeçalho (só se pedido), corpo com as quebras de linha, um "Exemplo para {{n}}" por variável, rodapé e botões (só se pedidos).
3. Confira a prévia contra o texto aprovado.
4. Mostre o template completo ao cliente e espere o ok digitado. "Enviar para aprovação da Meta" é envio à Meta: só com o ok.
5. Está enviado quando a lista mostra o template "Em análise". Antes disso, não diga que subiu.
6. A Meta pode mudar a categoria. Confira a etiqueta depois e avise.

Erros conhecidos: "Acesso negado para enfileirar templates nesta instância": cancele, recarregue, volte ao número oficial e preencha do zero. Tela travada: espere e tente de novo; depois de 2 tentativas, recarregue e recomece. Formulário pela metade: comece do zero.

### Enviar numa automação
Três passos em sequência:
1. Nó de SMS `#sw|N`: escolhe o número que envia (N é a Ref. do número oficial). Confirme o número com o cliente e confira no envio de teste.
2. "Esperar" de **10 segundos**. Obrigatório: sem ele, o template sai pelo número que estava ativo antes da troca.
3. Nó de SMS `#template|nome_do_template|PARAM_1|PARAM_2`: cada `PARAM_n` é o `{{n}}` do corpo, na mesma ordem. Troque por campo do contato (`{{contact.first_name}}`) ou valor personalizado (`{{custom_values...}}`). Sem variável: só `#template|nome_do_template`.

Para conferir o formato: Templates > clicar no template > **Copiar comando**. Com duas ou mais variáveis o formato ainda não foi visto na prática: confira no "Copiar comando" antes.

- O template só sai depois de **Aprovado**. Em análise ou rejeitado: automação fica em rascunho.
- Antes de publicar, a trava (`trava-de-disparo.md`). Montar a automação é da `atlas-automacoes`.

## 6. Confirmações (valem em qualquer caminho)

- Toda mensagem a contato ou grupo real: `CONFIRMO ENVIO`, uma por envio, com canal ("WhatsApp da Atlas"), número de envio (nome e telefone mascarado), destino (contato ou grupo), texto final exato, data e hora de Brasília e, no número oficial, se a janela de 24 horas estará aberta.
- Mais de 20 contatos, grupo com mais de 20 pessoas em campanha, ou recorrência: `CONFIRMO MASSA` antes do `CONFIRMO ENVIO`.
- Número de envio não confirmado pelo cliente: escreva "Número de envio: não confirmado" e não peça `CONFIRMO ENVIO`.
- No painel, o clique final (Agendar mensagem, Enviar agora, Revisar e enviar, Criar grupo, Adicionar) só depois da palavra exata. "Ok", "pode", "manda" não valem.
