# Objetos personalizados e ligações entre registros

## Objetos que toda conta tem

Lidos com `get-object-by-location-id` na conta da Atlas em 03/11/2026: contato (`contact`), oportunidade (`opportunity`) e empresa (`business`). Objetos personalizados aparecem na mesma lista com chave `custom_objects.<nome>`.

Quando sugerir um objeto personalizado: quando a mesma pessoa tem várias coisas do mesmo tipo, cada uma com seus dados. Exemplos: pets de um tutor, imóveis de um proprietário, veículos de um associado. Se for uma informação só por pessoa, é campo no contato.

Criar o objeto: navegador (esta conexão não tem permissão para a operação de criação). Depois de criado, o MCP cuida de campos, pastas e registros.

## Registros

- Buscar: `search-object-records` com `schemaKey`, `pageLimit` e `page: 1`. `query` busca nos campos pesquisáveis, no formato `campo:valor`.
- Criar: `create-object-record` com `properties` usando as chaves dos campos do objeto (leia com `get-object-schema-by-key` e `fetchProperties: true`).
- Campos pesquisáveis: `update-custom-object` com `searchableProperties` (lista de chaves).

## Ligações

Uma ligação tem um **tipo** (associação) e várias **relações** (cada par de registros ligado).

Tipos que já vieram na conta da Atlas (`find-associations`):

| Chave | Liga | Origem |
| --- | --- | --- |
| `OPPORTUNITIES_CONTACTS_ASSOCIATION` | Contato principal com oportunidade | do sistema |
| `BUSINESSES_CONTACTS_ASSOCIATION` | Empresa com contato | do sistema |
| `OPPORTUNITIES_CONTACTS_ADDITIONAL_ASSOCIATION` | Contatos adicionais numa oportunidade | criada na conta |
| `BUSINESSES_OPPORTUNITIES_ASSOCIATION` | Empresa com oportunidade | criada na conta |

Cada conta pode ter outros. Sempre leia `find-associations` antes.

Passos para ligar dois registros:
1. `find-associations` e escolha o `id` do tipo certo.
2. `create-relation` com `associationId`, `firstRecordId` (registro do primeiro objeto do tipo) e `secondRecordId`. A ordem importa: siga `firstObjectKey` e `secondObjectKey` do tipo.
3. Confira com `get-relations-by-record-id` (`limit` e `skip` obrigatórios).

Contato com empresa tem atalho: `add-remove-contact-from-business` na skill `atlas-contatos`.

Criar tipo novo: `associations.create-association`. O describe diz que hoje aceita contato com contato, contato com objeto personalizado e empresa com contato.

Apagar um tipo (`delete-association`) apaga todas as relações feitas com ele. Aprovação reforçada, só com pedido expresso.

Fonte do fornecedor para limites de ligações: artigo "Association Limits" (só título disponível; nenhum número citado aqui).
