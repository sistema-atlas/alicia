# Posts no planejador social

Fonte: descrições das operações `create-post`, `edit-post`, `get-account`, filas e comunidade no conector (03/11/2026).

## Antes de montar

1. `get-account`: quais contas existem, quais grupos (ex.: "Redes da empresa"). Use os `id` das contas. **Bloqueie** conta com `isExpired: true`, com `expire` no passado ou com `expire` antes do horário do post: peça reconexão pela tela.
2. `userId` de quem publica: pergunte o e-mail de login uma vez, `get-location` (`companyId`) e `search-users`. Guarde na conversa.
3. Mídia: arquivo da conta (`fetch-media-content`) ou enviado pelo cliente (`upload-media-content`, bytes exatos). Instagram, reel e YouTube exigem mídia.
4. Data e hora: o cliente fala em horário de Brasília. Converta para ISO com fuso (ex.: `2026-11-07T18:00:00-03:00`) e repita em horário de Brasília na aprovação.

## Uma legenda ou uma por rede

- Uma chamada `create-post` com várias contas usa a mesma legenda e corta no limite da rede mais curta (Bluesky 300, Threads 500, Pinterest 800, Google 1.500, Instagram e TikTok 2.200, LinkedIn 3.000, Facebook 63.206).
- Legenda longa: um post por rede, cada um com só as contas daquela rede.
- A mídia não é cortada do mesmo jeito: cada rede publica até o próprio máximo.

## Tipos

| Tipo | Regra |
| --- | --- |
| `post` | Feed, todas as redes |
| `story` | Instagram e Facebook, some em 24 horas, sem legenda |
| `reel` | Instagram, Facebook, TikTok, YouTube; exatamente 1 vídeo; grupo de Facebook não aceita |

Detalhes por rede vão nos objetos próprios (`instagramPostDetails`, `youtubePostDetails` com título, `tiktokPostDetails` com privacidade, `pinterestPostDetails` com quadro, `gmbPostDetails` para o Google com tipo e botão).

## Status

| Status | O que faz | Aprovação |
| --- | --- | --- |
| `draft` | Salva sem publicar | Simples |
| `scheduled` | Publica sozinho na `scheduleDate` | `CONFIRMO PUBLICAÇÃO` |
| `published` | Publica agora | `CONFIRMO PUBLICAÇÃO` |
| `in_review` | Manda para aprovação interna de um usuário (`postApprovalDetails.approver`) | Simples |

## Aprovação reforçada de post

```
ATENÇÃO: esta ação publica.
Conta: <conta>
O que: post <tipo> em <redes e nomes das contas>
Legenda: "<texto final>"
Mídia: <nome do arquivo>
Quando: <agora | data e hora de Brasília>
Dá para desfazer: em parte (dá para apagar depois, mas quem viu, viu)

Para confirmar, responda exatamente: CONFIRMO PUBLICAÇÃO
```

## Conferir

`get-post` com o ID que voltou: `scheduled` ou `published` está certo; `failed` avise na hora com o motivo que vier. Para a semana: `get-posts` com `type: scheduled` e datas (consulta: sem aprovação). Para mostrar o post no ar, use o `previewLink` (link público na rede).

## Filas (posts recorrentes)

1. Precisa de uma categoria (criar categoria: navegador).
2. `createQueue` com `categoryId`, horários (`dayOfWeek` número e `time` "HH:MM") e `userId`. Nasce em rascunho. O describe não diz qual número é domingo: depois de criar, confira na tela os dias e corrija com `updateQueue` se precisar.
3. `createQueueItem` com `directToQueue: true` para cada post. Em fila ativa, cada item publica no próximo horário: `CONFIRMO PUBLICAÇÃO`.
4. Ativar (`updateQueue` com `status: active`) publica sozinho nos horários: `CONFIRMO PUBLICAÇÃO`.
5. Pausar (`status: paused`) protege: aprovação simples.

## Comunidade

1. `get-account`: ache a conta com `platform: community` (cada canal é uma conta).
2. `get-community-users` com esse `accountId`: escolha o membro que publica.
3. `create-post` com `communityPostDetails`: `title`, `postAsUser: { "<accountId>": { "id": "<contactId>", "name": "<nome>" } }`.
4. `notifyAllGroupMembers: true` avisa todos os membros: pergunte antes e trate como envio (`CONFIRMO ENVIO` além do `CONFIRMO PUBLICAÇÃO`).
