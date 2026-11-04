# Marca: cores, fontes, logos e tom de voz

Fonte: describe das operações de brand board (03/11/2026) e uso real pela Atlas em 05/10/2026 (`docs/navegacao-crm/mcp-atlas-crm.md`). A tela fica em Configurações > Brand Boards (`marketing/brand-boards`), no grupo Outras configurações (conferido em 03/11/2026); o endereço começa com `marketing/`, mas o item não está no menu Marketing.

## Onde a marca é usada

Construtor de formulários, pesquisas e quizzes, e-mails e páginas puxam as cores do kit padrão. Trocar o kit padrão muda o que aparece de novo nesses construtores.

## Receita: acrescentar ou trocar uma cor sem perder as outras

1. `list-design-kits` e pegue o kit com `isDefault: true`.
2. `get-design-kit`. Copie todas as cores: para cada uma, `{ id, value: <hex>, label }`.
3. Mude só o que o cliente pediu: troque `value` de uma, ou acrescente uma nova sem `id`.
4. dryRun de `update-design-kit` só com `colors` (lista completa).
5. Mostre a lista final (nome e hex) e peça aprovação simples.
6. Execute e confira com `get-design-kit`.

Trocar a fonte: mande a fonte atual com o mesmo `id` e o `font` novo (troca no lugar). Acrescentar uma segunda fonte: mande a atual com `id` e a nova sem `id`.

Mesmo jeito para `fonts` (`{ id, font, fallback, label }`) e `logos` (`{ id, url, label }`). Logo novo precisa de URL pública; subir arquivo é na Mídia (skill `atlas-sites-e-blog`).

## Kit a partir do site

`create-design-kit` com `type: url` e `url` do site do cliente puxa a marca do site. Crie como kit novo, mostre o resultado e só depois pergunte se vira padrão (`set-default-design-kit`).

## Tom de voz

- `list-brand-voices` para achar o tom padrão, depois `get-brand-voice` para ler as respostas atuais.
- `update-brand-voice` com **todas** as `answers` atuais e só as pedidas trocadas (nome da marca, tom, público, dores, promessa, valores, diferencial, chamada para ação).
- Escreva as respostas com o cliente, curtas e no jeito dele. Mostre o texto final antes de salvar.
