# Blog

## Primeiro blog

Sem blog na conta, crie pelo navegador: Sites > Blogs > **Novo site de blog**, com aprovação. Layout e design do blog também são pela tela. Depois, `get-blogs` para pegar o `blogId`.

## Post novo (MCP)

1. `get-blogs` (pegar `blogId`). Guarde.
2. `get-all-categories-by-location` e `get-all-blog-authors-by-location` (`limit: 50`, `offset: 0`). Guarde IDs. Categoria ou autor que não existe: crie pela tela, com o cliente.
3. Tom: `list-brand-voices` e depois `get-brand-voice` do item padrão ou escolhido (o conteúdo do tom só vem no `get-brand-voice`). `get-design-kit` só se o post tiver elemento visual de marca (capa feita agora, por exemplo).
4. Escreva o post na conversa: título, resumo curto (vira a descrição de SEO), corpo, slug sem acento e com hífen, categoria, autor, imagem de capa com texto alternativo. Mostre ao cliente e ajuste.
5. `check-url-slug-exists` com o slug. `exists: true`: proponha outro.
6. Capa: se a imagem não está na Mídia, `upload-media-content` (aprovação). Use a `url` devolvida em `imageUrl`.
7. `create-blog-post` com `dryRun: true` e **`status: DRAFT`**. Mostre o resumo. Aprovação simples. Execute com `idempotencyKey`.
8. Confira com `get-blog-post` (`status: DRAFT`, `searchTerm` com o slug).
9. Peça ao cliente para ver a prévia no editor do blog (ou abra pelo navegador).
10. Publicar ou agendar: `update-blog-post` com o corpo inteiro e `status: PUBLISHED` (ou `SCHEDULED` com `scheduledAt`), só com `CONFIRMO PUBLICAÇÃO`.
11. Abra o post publicado no endereço do blog e confira capa, título, formatação e links.

## Editar post

- `update-blog-post` é PUT: o que não for enviado pode se perder. Leia o post antes: `get-blog-post` (com `searchTerm` e `status: ALL`) para os metadados e `get-blog-post-by-id` para o `rawHTML`, `tags`, `author` e `canonicalLink` (a lista não traz esses três; sem eles o PUT apaga) (devolve post publicado; para rascunho, se o corpo não vier, peça ao cliente para conferir no editor e não envie PUT sem o corpo atual).
- Reenvie **todos os campos atuais**: `blogId`, `rawHTML`, `status`, `title`, `description`, `urlSlug`, `imageUrl`, `imageAltText`, `categories`, `author`, `tags`, `canonicalLink`, `publishedAt`. Mude só o que o cliente pediu.
- Se o título muda, proponha também o `imageAltText` novo (ele costuma citar o título).
- Compare o dryRun com o post lido, campo por campo, antes de pedir aprovação.
- Mudar slug de post publicado quebra links antigos: proponha um redirecionamento (`create-redirect`) e trate como publicação.
- Qualquer mudança em post publicado ou agendado é publicação: `CONFIRMO PUBLICAÇÃO`, mostrando antes e depois. Mudança em rascunho: aprovação simples.

## HTML do corpo

- Use `h2`, `h3`, `p`, `ul`, `ol`, `a`, `img`, `blockquote`. Sem `h1` no corpo (o título já é o `h1` da página).
- Imagens do corpo também da Mídia da conta.
- Sem script, sem iframe de origem desconhecida.
- Português correto, frases curtas, sem travessão.

## Apagar ou arquivar

- Preferir `status: ARCHIVED` ou rascunho a apagar. `DELETED` só com pedido expresso e `CONFIRMO EXCLUSÃO`.

## Estado da conta de teste (03/11/2026)

1 blog ("Blog da Atlas"), 3 posts publicados, sem categorias nos posts lidos. A verificação de slug de um post existente devolveu `exists: true, reason: post`.
