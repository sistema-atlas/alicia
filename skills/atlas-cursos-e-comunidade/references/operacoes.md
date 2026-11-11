# Operações do MCP: cursos, comunidade e portal

Todas conferidas com `describe_operation` em 03/11/2026. Leituras executadas de verdade na conta de teste da Atlas; escritas só com `dryRun: true`. Passe sempre `locationId` no `execute_operation`.

As operações do domínio `courses` dizem "Send Version: v3". O conector aplica o cabeçalho `Version`; não passe cabeçalho manual. Na conta de teste as leituras funcionaram sem nada extra.

Nomes do conector: curso = `product` (`productId`), módulo = `category` (`categoryId`), aula = `lesson` (`lessonId`), oferta = `offer` (`offerId`).

## Leitura (faz direto)

### list-courses
- Lista cursos. GET `/courses/products`.
- Parâmetros: `limit` (1 a 50, texto), `cursor`, `search` (título, sem diferenciar maiúsculas).
- Resposta: `{ products: [{ id, title, description, posterImage, commentPrivacy, libraryOrder, customizations: { instructorName, instructorTitle, instructorBio, templateId, heroTextAlignment, ... }, createdAt, updatedAt }], nextCursor }`.
- Teste na conta Atlas: 1 curso, `templateId: "NeoClassic"`.

### list-categories
- Módulos de um curso. GET `/courses/products/{productId}/categories`.
- Parâmetro: `productId` (obrigatório).
- Resposta: `{ categories: [{ id, title, description, parentCategory, visibility, posterImage, sequenceNo, dripDays, metadata: { dripDate }, commentPermission, lockedBy, lockedByCategory }] }`.
- `parentCategory` preenchido = submódulo. `sequenceNo` começa em 0 na conta de teste.

### list-lessons
- Aulas. GET `/courses/products/{productId}/lessons`.
- Parâmetros: `productId` (obrigatório), `categoryId` (opcional). Sem `categoryId` o servidor lê módulo por módulo (mais lento): passe o módulo sempre que souber.
- Resposta: `{ lessons: [{ id, title, description (HTML), categoryId, visibility, sequenceNo, contentType, contentId, commentStatus, commentPermission, lockedByPost, lockedByCategory, certificateTemplateId, metaData }] }`.
- Teste: módulo com 5 aulas, uma em `draft`. A lista vem em ordem **decrescente** de `sequenceNo` (4 a 0): ordene antes de mostrar.

### get-lesson-quiz e get-quiz-questions
- `get-lesson-quiz`: quiz de uma aula (`productId`, `lessonId`). **404 `RESOURCE_NOT_FOUND` quer dizer que a aula ainda não tem quiz**: não é erro, siga para criar.
- `get-quiz-questions`: perguntas (`productId`, `quizId`). Leia antes de trocar perguntas.

### list-assessments
- Entregas de quiz e tarefa. GET `/courses/products/{productId}/assessments`.
- Parâmetros: `productId`, `pageNumber`, `pageSize` (1 a 50), `status` (`processing`, `passed`, `failed`).
- Resposta: `{ assessments: [{ id, contactId, lessonId, quizId, assignmentId, attempt, score, status, submission, submissionType, feedback }], totalCount }`.

### list-offers e get-offer
- `get-offer` (`offerId`) foi vista na busca; `list-offers` foi executada.
- Ofertas da conta inteira (não filtra por curso). GET `/courses/offers`. Parâmetros: `limit`, `cursor`, `search`, `visibility`.
- Pegadinha do describe: ofertas padrão (as que a tela cria sozinha ao liberar um curso) **não aparecem** e `get-offer` delas devolve 404.
- Teste na conta Atlas: 0 ofertas listadas, embora o curso exista e o portal tenha usuários. Ou seja, o acesso atual veio pela oferta padrão.

### list-enrollments
- Contatos com acesso a um curso. GET `/courses/products/{productId}/enrollments`.
- Parâmetros: `productId`, `limit` (1 a 50), `cursor`.
- Resposta: `{ enrollments: [{ contactId, productId, userId, createdAt }], nextCursor }`. Não traz e-mail nem progresso.
- Teste na conta Atlas: lista vazia. Não confie nela como número total de alunos do portal; ela lê compras e liberações registradas para o curso. Para "quantos alunos", diga de onde veio o número.

### list-completions
- Aulas concluídas. GET `/courses/products/{productId}/completions`.
- Com `contactId`: aulas concluídas daquele aluno (`completedAt`, `lessonId`). Sem `contactId`: resumo por aluno, paginado (`pageNumber`, `pageSize` 1 a 50).

### list-bulk-progress
- Progresso de um contato em vários cursos. GET `/courses/progress`. Obrigatórios: `contactId`, `productIds` (separados por vírgula, no máximo 50).
- Resposta: `{ products: [{ id, progress, completedLessons, totalLessons }] }`.
- `totalLessons` conta só aulas publicadas (teste: 4, com 5 aulas na lista e 1 em rascunho). Ao responder, diga "de 4 aulas publicadas".

### list-category-progress
- Progresso de um contato por módulo. GET `/courses/products/{productId}/categories/progress`. Obrigatórios: `productId`, `contactId`. Resposta `{ categories: [{ categoryId, progress }] }` (conferida pelo testador em 03/11/2026).

### get-account (comunidade)
- Contas conectadas ao planejador social, incluindo canais da comunidade. GET `/social-media-posting/{locationId}/accounts`.
- Resposta grande (todas as redes conectadas, sem filtro por plataforma). Leia uma vez e guarde o `id` do canal.
- Canal de comunidade vem com `platform: "community"`, `type: "group"` e `meta: { groupId, groupName, groupSlug, channelSlug, type: "PUBLIC" ou "PRIVATE" }`.
- Teste na conta Atlas: 1 canal de comunidade conectado (canal de avisos do grupo da Atlas). Canal que não aparece aqui não recebe post pelo MCP: conecte na tela (ver `telas.md`).

### get-community-users
- Membros que podem publicar em um canal. GET `/social-media-posting/{locationId}/community/accounts/{accountId}/users`.
- Parâmetros: `accountId` (o `id` da conta de comunidade em `get-account`), `limit` (até 100), `pageNo`, `searchText` (2 letras ou mais).
- Só volta membro ativo com papel no grupo. O `contactId` dele vai em `communityPostDetails.postAsUser`.

### validate-community-user-membership
- Confere se um contato ainda pode publicar (`groupId` de `meta.groupId`, `contactId`). Use antes de agendar post.

## Escrita (dryRun, aprovação)

Todas: kind `write`, `requiresApproval: true`, `idempotencyKey` obrigatório.

### create-course
- POST `/courses/products`. Obrigatório: `title`.
- **Não tem campo de visibilidade.** O curso não nasce em rascunho; o conteúdo (módulos, aulas, ofertas) é que nasce em `draft`.
- Opcionais: `description`, `posterImage` (URL), `commentPrivacy` (`public`, `instructorOnly`, `publicAndInstructor`), `libraryOrder`, `customizations` (`instructorName`, `instructorTitle`, `instructorBio`, `instructorHeadshot`, `heroImage`, `logoImage`, `templateId`, `heroTextAlignment`, ...), `customCss`, `customJs`.
- Não aceita `locationId` no corpo.

### update-course
- PUT `/courses/products/{productId}`. Mesmos campos, todos opcionais.

### create-category (módulo)
- POST `/courses/products/{productId}/categories`. Obrigatório: `title`.
- Opcionais: `description`, `visibility` (`draft` padrão, `published`, `locked`, `drip`), `sequenceNo`, `posterImage`, `parentCategory` (vira submódulo; só um nível), `dripDays` e `metadata: { dripUnit: days|hours, dripDate }` para gotejamento, `lockedBy` (aula publicada que destrava) e `lockedByCategory`, `commentPermission`.
- Regra do describe: `visibility: locked` exige `lockedBy`, `lockedByCategory` ou os dois.
- dryRun montou a requisição (não valida no servidor) em 03/11/2026: resolve para POST com `locationId` na query.

### update-category
- PUT `/courses/products/{productId}/categories/{categoryId}`. Path `productId` e `categoryId`; corpo com os mesmos campos do create, todos opcionais (`visibility`: `draft`, `published`, `locked`, `drip`). kind write, `requiresApproval`, `idempotencyKey` obrigatório (describe de 03/11/2026).
- Uso principal: despublicar módulo (`visibility: draft`) em vez de apagar (regra 8 do SKILL.md).

### create-lesson e update-lesson
- POST `/courses/products/{productId}/lessons`. Obrigatórios: `title`, `categoryId`.
- Opcionais: `description` (HTML), `visibility` (`draft`, `published`, `locked`), `sequenceNo`, `contentType` (`video`, `assignment`, `quiz`, `audio`, `funnel`), `contentId`, `posterImage`, `commentPermission`, `lockedByPost`, `lockedByCategory`, `certificateTemplateId`, `metaData`.
- `update-lesson` (PUT `.../lessons/{lessonId}`): sem `categoryId` a aula fica no módulo atual.
- Vídeo: o MCP não sobe o vídeo da aula. O campo `contentId` aponta para mídia já existente; subir e escolher o vídeo é pela tela.

### sequence-lessons
- Reordena aulas de um módulo. PUT `.../categories/{categoryId}/lessons/sequence`. Corpo: `ids` (todas as aulas na ordem nova). Resposta `{ ok }`.

### create-lesson-quiz
- POST `.../lessons/{lessonId}/quiz`. Obrigatório: `title`. Opcionais: `requiredPassingGrade`, `passingGrade` (0 a 100), `passMessage`, `failMessage`.

### upsert-quiz-questions
- PUT `.../quizzes/{quizId}/questions`. Corpo: `questions: [{ id?, title, questionType: single|multiple, sequenceNumber, options: [{ title, isCorrect }], explanation }]`.
- O nome no catálogo é "Replace Quiz Questions": mande a lista completa. Pergunta que não for enviada pode sumir (a conferir; trate como substituição).

### create-lesson-assignment
- Tarefa de entrega na aula. POST `.../lessons/{lessonId}/assignment`. Corpo: `title` (obrigatório), `introduction`, `confirmMessage`, `ungradedAssignment` (conferido pelo testador em 03/11/2026).

### create-offer e update-offer
- POST `/courses/offers`. Obrigatórios: `title`, `productIds` (cursos da oferta).
- `type`: só os valores do enum: `free` (padrão), `onetime`, `subscription`. O texto do describe cita `multiple`, mas ele **não está no enum**: o dryRun aceita (não valida) e a execução real pode dar 422. Parcelado: tela. Para pago: `amount` (em reais, unidade cheia, ex.: 297), `currency` (`BRL`), `interval` e `intervalCount` (assinatura), `trialDays`, `setupFee`.
- `visibility`: `draft` (padrão) ou `published`. `isLivePaymentMode`: padrão `false` (modo de teste). `coupons`, `accessDate`, `daysOfAccess`.
- Pegadinha: oferta paga só cobra com integração de pagamento ativa na conta. Oferta paga é nível dinheiro.

### create-enrollment (liberar acesso)
- POST `/courses/enrollments`. Corpo: `contactId`, `offerId`.
- Resposta `{ alreadyEnrolled, contactId, offerId }` (200 se já tinha, 201 se liberou agora). Não devolve senha nem link de login.
- Liberação pelo conector não conta como venda nos relatórios de receita da área de membros.
- Oferta padrão devolve 404. Sem oferta própria, a liberação é pela tela.

### delete-enrollment (tirar acesso)
- DELETE `/courses/enrollments`. Corpo: `contactId`, `offerId`. kind `delete`, `destructiveHint: true`.
- Revoga todos os cursos da mesma oferta.
- Oferta padrão devolve 404: acesso dado pela tela só é tirado pela tela (Assinaturas).

### create-post (comunidade)
- POST `/social-media-posting/{locationId}/posts`. Para comunidade: `accountIds` com o `id` do canal, `type: "post"`, `summary` (texto), `media` (até 4 itens), `status` (`draft`, `scheduled` com `scheduleDate`, ou publicação), `communityPostDetails: { title, postAsUser: { <accountId>: { id: <contactId do membro>, name } }, notifyAllGroupMembers }`.
- `title` e `postAsUser` são obrigatórios quando o post não é rascunho.
- Uma chamada com várias redes corta o texto pelo limite mais curto. Para comunidade, mande uma chamada só com o canal da comunidade.
- Use `status: draft` (rascunho) ou `scheduled` com `scheduleDate` (agendado). O valor que publica na hora não foi confirmado: para "publicar agora", agende para alguns minutos à frente ou publique pela tela.
- O nome do canal pode vir em inglês (na Atlas o canal de avisos se chama `Announcements`). Mostre o nome real ao confirmar.
- Detalhes do planejador social: skill `atlas-social-e-reputacao`.

### create-comment (comunidade)
- POST `/social-media-posting/comments/{platform}` com `platform: community`. Corpo: `parentId` (id do post para comentário, id do comentário para resposta), `isParentThread`, `content` (até 8000 caracteres na comunidade), `mentions`, `notifyAllGroupMembers` (padrão `false`; `true` avisa o grupo todo). Responder comentário de aluno é mensagem a pessoa real: aprovação reforçada.

## Exclusão (só com pedido expresso, CONFIRMO EXCLUSÃO)

- `delete-course` (`productId`), `delete-lesson` (`productId`, `lessonId`), `delete-offer` (`offerId`): conferidas. kind `delete`, `destructiveHint: true`, resposta 204.
- `delete-quiz` (`productId`, `quizId`): vista na busca; rode `describe_operation` antes.

## O que o MCP não faz (navegador)

- Subir vídeo ou arquivo da aula, certificados.
- Criar grupo de comunidade, canal, níveis, eventos, banir membro.
- Conectar canal da comunidade ao planejador social.
- Portal do cliente: domínio, identidade visual, idioma, e-mail de lembrete, link mágico, convite, enviar e-mail de login.
