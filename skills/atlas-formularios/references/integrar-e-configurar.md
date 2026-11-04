# Integrar, redirecionar, notificar e configurar

## Colocar o formulário no site

| Onde vai aparecer | Como |
| --- | --- |
| Página feita no Atlas CRM (funil ou site) | Elemento de formulário nativo do construtor de páginas, escolhendo o formulário. Skill `atlas-sites-e-blog` |
| Site externo (WordPress, Wix, código próprio) | Menu do formulário > **Compartilhar**: copiar o código de incorporação e colar no site |
| Link direto (bio, WhatsApp, e-mail) | Menu do formulário > **Compartilhar** > link |

- Pesquisa: aba **Integrar** do editor (mesmas abas do formulário: "Incorporar", "Compartilhar", "E-mail", "Conexões"; conferido em 03/11/2026). Quiz: botão **Integrar** ou **Compartilhar** do construtor `(a conferir no navegador)`.
- Formulário dentro de iframe em site externo: a origem (UTM) pode não chegar como esperado. Ver skill `atlas-rastreamento`.
- Colar código em site externo é tarefa do cliente ou de quem cuida do site. Entregue o código e o passo a passo; não peça senha do site.

## Depois do envio

- Formulário: editor > aba **Configurações** > bloco "Ao enviar" ("Mensagem" ou redirecionar para URL) (conferido em 03/11/2026).
- Pesquisa: **Configurações > Ao enviar**: Mensagem, Redirecionar para URL ou Confirmação.
- Redirecionar para WhatsApp: `https://wa.me/55DDDNUMERO?text=` com o texto codificado. Confirme o número com o cliente.
- Redirecionar para agenda: `/widget/bookings/<slug>` (plural). Skill `atlas-agenda` para o link certo.
- Mudar o destino de um formulário que já está no ar é **aprovação reforçada** (`CONFIRMO PUBLICAÇÃO`).

## Avisar quando alguém preencher

Dois caminhos:
1. **Notificação do próprio formulário ou pesquisa**: editor > aba **Notificações** > "Notificação por e-mail" (conferido em 03/11/2026; os campos dentro da opção não foram abertos, `(a conferir no navegador)`). Bom para avisar a equipe. A mesma aba tem "Resposta automática", que manda e-mail para quem respondeu: é mensagem a contato real, `CONFIRMO ENVIO`.
2. **Automação** com gatilho Formulário enviado e ação de notificação interna: skill `atlas-automacoes`. Melhor quando precisa de condição (só se respondeu X) ou WhatsApp para a equipe.

**Padrão**: aviso simples por e-mail para a equipe, use o caminho 1 (a aba existe na tela). Precisa de condição, WhatsApp para a equipe ou o cliente está no Codex sem navegador: caminho 2 (automação), que tem passo a passo fechado.

Níveis de aprovação: ligar notificação num formulário que já está no ar é mudança em algo publicado, `CONFIRMO PUBLICAÇÃO`; num formulário que ainda não está no ar (só o criado nesta conversa e ainda não colocado em página, link ou anúncio; todo formulário que já existia conta como no ar, regra 10 do SKILL.md), aprovação simples. Ativar a automação é publicar ou ativar: confirmação própria na skill `atlas-automacoes`. Mensagem para quem respondeu é mensagem a contato real: aprovação reforçada, e é das skills `atlas-automacoes` ou `atlas-conversas-e-disparos`.

## Campo de origem

- O elemento **Origem** (Source) grava um valor fixo como origem do contato em cada envio, sem aparecer para quem responde (documentação do fornecedor).
- No link, `?source=valor` substitui o valor do construtor naquele envio. Um formulário serve para várias campanhas.
- UTM é outra coisa (atribuição): skill `atlas-rastreamento`.

## Configurações gerais de formulários

Ver `telas.md`, seção Configurações gerais. Mexa só no formulário pedido, por **Gerenciar formulários individuais**.

## Novidades da plataforma (LevelUp 2026)

Fonte: post oficial do fornecedor sobre o LevelUp Day 2026, de 27/10/2026, lido em 03/11/2026. Só o que é desta área. Os nomes podem aparecer diferentes na tela em português:

- Disponível: detecção de erro em tempo real e dicas de configuração em formulários, pesquisas e quizzes.
- Disponível: elemento nativo de quiz dentro do construtor de páginas.
- Anunciado sem data clara: experiência unificada de Integrar em formulários, pesquisas e quizzes.
- Beta fechado: formulário que cria oportunidade, empresa ou objeto personalizado sem contato.

Não prometa nada desta lista ao cliente sem ver a opção na tela da conta dele.
