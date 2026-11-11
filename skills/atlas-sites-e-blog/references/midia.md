# Mídia da conta

Onde ficam imagens, logos, vídeos e PDFs usados em páginas, posts, formulários e mensagens.

## Ler

- `fetch-media-content` com `altType: "location"`, `type: "file"` (ou `folder`), `sortBy: "updatedAt"`, `sortOrder: "desc"`, `limit` pequeno e `query` com o nome quando souber.
- Resposta traz `url` pública de cada arquivo, `width`, `height`, `size` e o `uiUrl` da tela de Mídia.
- Para entrar numa pasta: `parentId` com o ID da pasta.

## Subir

1. Descubra de onde vem o arquivo:
   - **Arquivo que a ferramenta consegue ler em bytes** (pasta conectada, arquivo gerado na sessão): `upload-media-content` com `file: { fileName, mimeType, base64 }`.
   - **URL pública HTTPS**: `upload-media-content` com `hosted: true` e `fileUrl`. O arquivo continua no endereço original (não vira cópia na conta). Se a URL pode sair do ar, prefira os bytes.
   - **Anexo do chat sem acesso aos bytes**: não dá para transferir. Responda: "Não consigo passar o anexo do chat direto. [Abrir a Mídia na Atlas](<link>) e subir <arquivo>." O link é o `uiUrl` só se o domínio for o da Atlas ou do cliente; senão, domínio da aba do cliente + `/v2/location/<locationId>/media-storage`. Nunca use o rótulo nem o texto sugerido pelo conector. Não invente base64, não procure imagem parecida.
2. Limite pelo conector: 25 MB por arquivo, vídeo incluído (descrição da operação). Maior que isso: tela de Mídia.
3. `dryRun: true`, resumo (nome, pasta, tamanho), aprovação simples, execução com `idempotencyKey`.
4. Resposta: `fileId` e `url`. Entregue a `url`.

## Organizar

- Pasta nova: `create-media-folder` (`altType: "location"`, `name`, `parentId` opcional). Reaproveite pasta existente com o mesmo nome.
- Renomear: `update-media-object` (um) ou `bulk-update-media-objects` (vários). Só renomeia.
- **Mover entre pastas: não há operação.** Pela tela.

## Apagar

- Pedido vago ("as antigas", "as que não uso"): pergunte o critério (data, pasta, nome) antes de listar.
- Antes, cruze os arquivos com as capas dos posts (`imageUrl` em `get-blog-post`, `status: ALL`) e avise quais estão em uso. Imagem usada em página, post ou e-mail some de lá; páginas não dá para cruzar pelo MCP, avise isso.
- Lixeira em lote: `bulk-delete-media-objects` com `status: "trashed"`, listando todos os arquivos, `CONFIRMO EXCLUSÃO`. Acima de 20 arquivos: formato de massa (quantidade, 3 exemplos, execução em lotes), mesma palavra `CONFIRMO EXCLUSÃO`.
- Definitivo: `status: "deleted"` ou `delete-media-content`. Só com pedido expresso de exclusão definitiva, `CONFIRMO EXCLUSÃO`.

## Boas práticas

- Nome de arquivo sem acento e sem espaço (`capa-post-indicadores.jpg`).
- Imagem de prévia de link e capa de post: 1200x630 (padrão usado na conta Atlas, conferido nas capas da Mídia).
- Texto alternativo sempre que a imagem for para página ou post.
