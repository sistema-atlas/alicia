# Reputação: avaliações do Google, pedidos e avaliações de produto

Fontes: artigos de reputação da base completa da central de ajuda (pedido de avaliação, integração com o Perfil da Empresa no Google, personalização das mensagens de pedido por SMS e e-mail, contestação de avaliação do Google, QR code da página de avaliação, ação de pedido de avaliação nas automações e agendador de posts do Perfil da Empresa). Os caminhos de tela foram conferidos em 03/11/2026 (`references/telas.md`); a versão traduzida dos artigos é genérica, então os passos dentro de cada tela continuam (a conferir no navegador). E o conector (03/11/2026). O conector não tem operação de avaliações do Google nem de pedido de avaliação: tudo isso é navegador ou automação.

## O que o cliente quer e o caminho

| Pedido | Caminho |
| --- | --- |
| "Quantas avaliações eu tenho, qual a nota?" | Navegador, Reputação, visão geral |
| "Responde essa avaliação" | Navegador, Reputação > Avaliações (`reputation/reviews`), com `CONFIRMO PUBLICAÇÃO` |
| "Pede avaliação para quem foi atendido hoje" | Navegador (um contato) ou automação com a ação de pedido de avaliação (vários) |
| "Muda a mensagem do pedido de avaliação" | Navegador, Reputação > Configurações (`reputation/settings`) |
| "Quero um QR code para pedir avaliação no balcão" | Navegador (QR ligado à página de avaliação) |
| "Essa avaliação é falsa, dá para tirar?" | Navegador, contestação no Google |
| "Posta uma novidade no meu perfil do Google" | MCP `create-post` com a conta `platform: google` (`postagens.md`) |
| "Aprova as avaliações dos produtos da loja" | MCP `get-product-reviews` e `update-product-review` |

## Antes de tudo: o perfil do Google está ligado?

- `get-account` mostra a conta com `platform: google` quando o Perfil da Empresa está conectado ao planejador. Isso indica a conexão para posts.
- Para avaliações, a integração fica em Configurações > Integrações (`settings/lc-integrations`, caminho conferido em 03/11/2026; o bloco do Google dentro da tela está (a conferir no navegador)). Se não estiver conectada, o cliente conecta com o login dele do Google.

## Responder avaliação

Boas práticas (artigo `how-to-send-review-requests`): tom humano e específico, não automatizar resposta sem revisar o contexto, olhar as negativas rápido.

Roteiro de resposta:
- **Positiva**: agradeça pelo nome (se aparece na avaliação), cite algo específico que a pessoa disse, convide a voltar.
- **Negativa**: agradeça o retorno, reconheça sem discutir, diga o que vai fazer, ofereça contato direto (telefone ou WhatsApp da empresa). Nunca exponha dado do cliente final nem detalhe de atendimento (em saúde, nem confirme que a pessoa é paciente).
- Curta. Sem copiar e colar a mesma resposta em todas.

Fluxo: escrever no chat, cliente aprova, `CONFIRMO PUBLICAÇÃO`, publicar na tela, conferir.

## Pedido de avaliação

- É mensagem a contato real (SMS, WhatsApp ou e-mail). Um contato: `CONFIRMO ENVIO`. Vários: automação com a trava de disparo (`atlas-conversas-e-disparos`, `references/trava-de-disparo.md`), `CONFIRMO MASSA` e `CONFIRMO ENVIO`.
- WhatsApp oficial fora da janela de 24 horas precisa de template aprovado. Pedido de avaliação sobre um atendimento específico tende a ser utilidade; com oferta junto vira marketing (`templates-whatsapp.md` da skill de conversas).
- Melhor momento: logo depois do atendimento ou da entrega, enquanto a experiência está fresca.
- Regras do Google (oriente o cliente): não oferecer brinde ou desconto em troca de avaliação e não pedir só para quem ficou satisfeito.
- Pela automação: gatilho (atendimento concluído, fatura paga, tag) e a ação de pedido de avaliação. Montagem: `atlas-automacoes`.

## Contestar avaliação

- Só faz sentido para avaliação que viola as regras do Google (spam, ofensa, conflito de interesse, conteúdo fora do assunto).
- Quem decide é o Google. Não prometa remoção.
- Passos de tela: (a conferir no navegador).

## Avaliações de produto (loja da Atlas)

1. `get-reviews-count` com `altType: location` para ver quantas por status.
2. `get-product-reviews` com filtros (`rating`, datas, `productId`) e `limit` pequeno.
3. Aprovar ou responder: `update-product-review` em `dryRun` com `altId` (o `locationId`), `altType`, `productId`, `status`, `reply`. Aprovar mostra na loja e responder é público: `CONFIRMO PUBLICAÇÃO`.
4. Muitas de uma vez: `bulk-update-product-review`, com `CONFIRMO MASSA` acima de 20.
5. Apagar avaliação: só com pedido expresso, item por item, `CONFIRMO EXCLUSÃO`. Apagar avaliação negativa verdadeira prejudica a confiança da loja: diga isso ao cliente.
