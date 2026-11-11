# Páginas, funis e sites no construtor nativo

Princípio da Atlas: **a página mora na Atlas e qualquer pessoa da equipe do cliente consegue abrir e editar ali**. Por isso:

- Monte com elementos nativos: seção, linha, coluna, título, texto, imagem, botão, vídeo, formulário, agenda.
- Código personalizado só para o que o construtor não faz (script de rastreamento, um ajuste pontual de CSS). Página inteira de HTML colado fica fora do alcance de quem não programa.
- Antes de editar, leia a versão atual na tela. Nunca sobrescreva com um texto guardado na conversa sem comparar.

## Funil, site ou blog

| O cliente quer | Use | `type` no `getFunnels` |
| --- | --- | --- |
| Landing page, página de captura, página de obrigado, sequência de etapas | Funil | `funnel` |
| Site institucional com menu e várias páginas | Site | `website` |
| Blog | Blog (Sites > Blogs) | `blog` |

## Criar uma página nova

1. `getFunnels` com `name` para ver se já existe algo com esse nome.
2. `get-design-kit` (marca da conta: cores, fontes, logo) e `list-brand-voices` seguido de `get-brand-voice` (tom) para o jeito de escrever.
3. Briefing curto com o cliente, uma pergunta por vez: objetivo, público, oferta, chamada principal, o que acontece depois do clique.
4. Escreva a estrutura e os textos na conversa e peça SIM.
5. No navegador, Sites > Funis (ou Sites) > **Novo funil**:
   - **A partir de modelos** quando houver um modelo da conta ou da biblioteca parecido.
   - **Desenvolver com AI** para a primeira versão: cole o briefing e os textos aprovados. Avise antes que a IA da plataforma pode consumir créditos da conta e peça sim. Depois, ajuste no construtor e aplique a marca.
   - **A partir do zero** para página simples.
6. Ajuste seção por seção. Uma tela por vez.
7. Formulário: elemento de formulário nativo escolhendo um formulário existente (skill `atlas-formularios`).
8. SEO da etapa, caminho da URL e domínio (`dominios-seo-qr.md`).
9. Pré-visualize, depois peça `CONFIRMO PUBLICAÇÃO` e publique.
10. Abra o link público no computador e em largura de celular. Faça envio de teste do formulário só com sim.
11. `getFunnels` e `getPagesByFunnelId` para registrar IDs e confirmar que a etapa existe.

Na conta Atlas existe um site gerado por "Desenvolver com AI" (caminho base `/ai-generated-website`): o caminho nasce automático. Confira e ajuste o caminho antes de publicar.

## Editar uma página existente

1. `getFunnels` com `name` para achar o funil e a etapa.
2. Abra a etapa no construtor. Leia o que está lá.
3. Mostre ao cliente o antes e o depois do trecho que muda.
4. Página no ar: salvar e publicar a mudança pede `CONFIRMO PUBLICAÇÃO` (no construtor, o que é salvo pode ir direto ao ar). Rascunho que não está publicado: aprovação simples para salvar.
5. Conferir no link público.

## Seções reutilizáveis e modelos

- Cabeçalho, rodapé, prova social, bloco de formulário e chamada para WhatsApp se repetem: salve como seção reutilizável quando o construtor oferecer.
- O `getFunnels` mostra `globalSectionVersion` e `globalSectionsUrl` nos funis da Atlas, sinal de que seções globais existem. Se a edição numa seção global se espalha para todas as páginas: `(a conferir no navegador)` antes de prometer.
- Página pronta e aprovada pode virar modelo da conta para as próximas.

## Widget de chat na página

- `listChatWidget` para ver os widgets da conta.
- `getFunnels` traz `isChatWidgetLive` por funil.
- Colocar o chat: aba Configurações do funil > "Rastreamento e scripts" > "Widget de chat" (conferido em 03/11/2026). No construtor da página `(a conferir no navegador)`. Site externo: "Obter código" no widget e colar no site.
- Novidade anunciada no LevelUp 2026 (post oficial de 27/10/2026): elemento integrado de IA e widget de chat nos funis, sem data clara. Não prometa.

## Link curto com prévia no WhatsApp (página-ponte)

Redirecionamento comum (301) não mostra prévia: o WhatsApp lê as meta tags da página. Use uma etapa de funil:

1. Domínio conectado como **Funil/Site** (Configurações > Domínios). Nunca o domínio de marca.
2. Funil com uma etapa por link, com uma seção em branco.
3. SEO da etapa: título, descrição, imagem 1200x630 na Mídia.
4. Código do cabeçalho: `<script>window.location.replace('URL de destino com parâmetros');</script>` e `<style>html,body{background:<cor da marca>}</style>`.
5. Caminho: Etapa > Publicando > URL da etapa > Atualizar etapa. Publicar com `CONFIRMO PUBLICAÇÃO`.
6. Clones copiam o SEO, não o script: confira o script de cada clone.
7. Defina página padrão e 404 do domínio para uma etapa que leva ao site, para a raiz não abrir um dos links.
8. Teste: o robô do WhatsApp não roda JavaScript e lê as meta tags; a pessoa é redirecionada em 3 a 8 segundos (medido na conta Atlas em 07/10/2026).

## Conferência visual

- Computador e celular (janela estreita).
- Todos os botões e links levam ao destino certo.
- Formulário envia (com sim) e cai no contato.
- Título e descrição de SEO aparecem no código da página publicada.
