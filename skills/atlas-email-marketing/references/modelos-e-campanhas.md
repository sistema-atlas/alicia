# Modelos e campanhas

Fontes: descrições das operações do conector (03/11/2026) e temas da base de artigos da Atlas (modelos vs campanhas, pastas aninhadas, Brand Board em e-mails, estatísticas de campanha, rastreamento de cliques).

## Modelo ou campanha

- **Modelo**: o e-mail pronto para reaproveitar (newsletter, boas-vindas). Não envia nada.
- **Campanha**: um envio de um e-mail para um público, numa data. Pode nascer de um modelo (`templateId`).
- E-mail de automação usa modelo também, mas o envio é configurado na automação (skill `atlas-automacoes`).

## Estrutura de um bom e-mail

1. **Assunto**: o que a pessoa ganha ao abrir, curto e honesto.
2. **Texto de prévia** (`previewText`): completa o assunto. Aparece ao lado dele na caixa de entrada.
3. **Abertura** direta, dizendo quem fala.
4. **Corpo** curto, um assunto por e-mail.
5. **Uma chamada para ação** principal (botão), com link do domínio do cliente e UTM se ele usa (skill `atlas-rastreamento`).
6. **Rodapé** com nome da empresa, endereço e descadastro.

## Variáveis

- Campos do contato: `{{contact.first_name}}` (exemplo usado nas próprias operações do conector). Outros campos e valores personalizados: confira o nome do campo com a skill `atlas-campos-e-dados`.
- Use o nome só se a maioria dos contatos tiver o campo preenchido. Senão a frase fica "Olá ,".

## Marca no e-mail

1. Leia o kit padrão: `list-design-kits`, depois `get-design-kit`.
2. Use as cores (hex) e fontes do kit no HTML do modelo. Fonte web pode não aparecer em todo leitor: sempre com alternativa (`fallback`, ex.: `sans-serif`).
3. Logo: use a URL do logo do kit ou da Mídia.
4. Se o cliente quer mudar a marca: `update-design-kit` mandando a lista **completa** (itens antigos com `id` mais os novos). Mostre antes e depois.

## Criar um modelo pelo MCP

1. `list-email-templates` com `search` para não duplicar o nome.
2. Monte o HTML na conversa e mostre o texto ao cliente (não precisa mostrar o código inteiro, só o conteúdo e o visual descrito).
3. `create-email-template` em `dryRun` com `name`, `editorType: html`, `editorContent`, `subjectLine`, `previewText`, `parentFolderId` se houver pasta.
4. Aprovação simples. Execute com `idempotencyKey`.
5. Confira no editor pelo navegador, ou peça ao cliente para abrir o modelo no editor (Marketing > E-mails > Modelos, `marketing/emails/all` no domínio da conta). O `previewUrl` usa endereço técnico: não mostre ao cliente.

Para o construtor visual de blocos (arrastar e soltar), é pelo navegador.

## Organizar em pastas

1. `list-email-templates` com `include: folders` para ver as pastas.
2. `create-template-folder` para pasta nova (aprovação simples). Execute de verdade: o ID da pasta só existe depois de criada.
3. `update-email-template` com o `parentFolderId` real para mover (segunda aprovação simples; mais de 20 modelos: `CONFIRMO MASSA`). Criar e mover são duas aprovações, nesta ordem.

## Campanha do começo ao fim

1. Público: contatos por ID, uma tag ou um segmento de engajados. **Não existe "todos os contatos".** Se o cliente pedir todos, pergunte em uma pergunta só: uma tag que reúne o público (contagem com `atlas-contatos`) ou um segmento de engajados. Base sem permissão de envio: recuse e explique o risco de spam e bloqueio do domínio. IDs de tag com `get-location-tags`.
2. `userId` de quem pede: `get-location` uma vez (pega `companyId` e fuso), pergunte o e-mail de login e use `search-users`. Guarde na conversa.
3. `create-email-campaign` (rascunho) a partir do modelo, com `timeZone` da conta.
4. Teste para o e-mail do cliente (`CONFIRMO ENVIO`; passo a passo em `operacoes.md`, Envio de teste) e espere o ok dele.
5. `schedule-campaign` em `dryRun` com `scheduleType`, `emailMeta` (assunto, remetente, prévia), `recipients`, `scheduleConfig.sendAt`.
6. Aprovação reforçada:
```
ATENÇÃO: esta ação envia mensagem.
Conta: <conta>
O que: campanha "<nome>"
Quantidade: <n destinatários>   Exemplos: <3 primeiros nomes>
Remetente: <nome> <e-mail>   Assunto: <assunto>
Quando: <data e hora de Brasília>
Dá para desfazer: não, se for envio imediato (sai na hora, sem volta). Agendado: talvez pausar pela tela antes do horário (a conferir no navegador)

Para confirmar, responda exatamente: CONFIRMO ENVIO
```
Mais de 20 destinatários: peça `CONFIRMO MASSA` antes, com a quantidade.
7. Execute e confira com `get-email-campaign` (status `scheduled`).
8. Depois do envio: `get-campaign-stats` com `source: email-campaigns`. Para um balanço geral, olhe também `list-workflow-campaigns` e `list-bulk-action-campaigns` (e-mails de automação e de ação em massa).

## Teste A/B

`schedule-campaign` aceita `abTestConfig` (assunto ou conteúdo, duração, tamanho do teste, critério de vitória por abertura ou clique). Explique ao cliente o que cada campo faz antes de usar; os valores vêm dele.
