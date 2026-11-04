# Operações de campos e dados (verificadas)

Conferidas com `search_operations` e `describe_operation` em 03/11/2026, na conta de teste da Atlas. "Testada" quer dizer leitura executada de verdade; escritas só com `dryRun: true`.

"dryRun montado" quer dizer só que a requisição foi montada. O dryRun não valida o corpo (`authorizationVerified: false`): campo desconhecido passa. Use apenas campos que aparecem no describe.

Nunca mostre ao cliente links técnicos das respostas. Link para o cliente só de `telas.md`.

Todas pedem `locationId`. Escrita exige `idempotencyKey`. Legenda: **L** leitura, **S** aprovação simples, **R** aprovação reforçada.

## Campos de contato e oportunidade (domínio locations)

| operationId | O que faz | Obrigatórios | Campos que importam | Aprovação |
| --- | --- | --- | --- | --- |
| `get-custom-fields` | Lista campos. Testada | nenhum | `model`: `contact`, `opportunity` ou `all`. Itens: `id`, `name`, `fieldKey` (ex.: `opportunity.prioridade`), `dataType`, `picklistOptions`, `parentId` (pasta), `position` | L |
| `get-custom-field` | Um campo | `id` (aceita o id ou a chave, ex.: `contact.first_name`) | resposta em `customField` | L |
| `locations.create-custom-field` | Cria campo sem opções | `name`, `dataType` | `model` (`contact` ou `opportunity`), `placeholder`, `position`, `acceptedFormat`, `isMultipleFile` e `maxNumberOfFiles` (arquivo), `textBoxListOptions` (só `TEXTBOX_LIST`), `optionDisplayType`, `urlValidation`, `dateTimeValidation`, `userFieldConfig` | S |
| `locations.update-custom-field` | Edita campo | `id`, `name` | `placeholder`, `position`, regras de validação. **Não tem `dataType`** (tipo não muda) | S; R se o campo já tem dados em muitos registros |
| `locations.delete-custom-field` | Apaga campo e o dado guardado nele | `id` | nenhum | R `CONFIRMO EXCLUSÃO` |

Tipos (`dataType`) aceitos: `TEXT`, `LARGE_TEXT`, `NUMERICAL`, `PHONE`, `MONETORY`, `CHECKBOX`, `SINGLE_OPTIONS`, `MULTIPLE_OPTIONS`, `FLOAT`, `TIME`, `DATE`, `TEXTBOX_LIST`, `FILE_UPLOAD`, `SIGNATURE`, `RADIO`, `URL`, `DATE_TIME`, `USER`, `RICH_TEXT`. O describe avisa: `URL`, `USER`, `TIME`, `DATE_TIME` e `RICH_TEXT` são experimentais por enquanto. Prefira os outros.

Pegadinhas:
- **Opções de lista (`SINGLE_OPTIONS`, `MULTIPLE_OPTIONS`, `RADIO`, `CHECKBOX`)**: o describe de `locations.create-custom-field` não tem campo de opções. Campos do corpo, exatamente: `name`, `dataType`, `placeholder`, `acceptedFormat`, `isMultipleFile`, `maxNumberOfFiles`, `textBoxListOptions`, `position`, `model`, `urlValidation`, `dateTimeValidation`, `userFieldConfig`, `optionDisplayType`. A documentação pública da API (página de campos personalizados de locations, lida em 03/11/2026) confirma: `options` e `picklistOptions` só aparecem na resposta. Campo de lista de contato ou oportunidade: crie pelo navegador (`telas.md`), já com as opções. Depois confira com `get-custom-fields` (`picklistOptions`). Nunca mande `options` aqui.
- `locations.update-custom-field`: mesmos campos menos `dataType`; só `name` é obrigatório. Também não muda opções.
- `textBoxListOptions` serve só para `TEXTBOX_LIST` (caixas de texto com rótulo), não para lista de opções.
- `acceptedFormat` (sem s) neste domínio; no domínio custom-fields é `acceptedFormats`.
- A chave (`fieldKey`) é gerada do nome sem acento. Leia a chave depois de criar.
- Exemplo de corpo válido (campo de texto):

```json
{"name": "CPF", "dataType": "TEXT", "model": "contact"}
```

## Campos de empresa e objetos personalizados (domínio custom-fields)

O describe diz: "só suporta objetos personalizados e empresa hoje". Para contato e oportunidade, use o domínio locations acima.

| operationId | O que faz | Obrigatórios | Campos | Aprovação |
| --- | --- | --- | --- | --- |
| `get-custom-fields-by-object-key` | Campos e pastas de um objeto | `objectKey` (ex.: `business` ou `custom_objects.pet`) | resposta: `fields`, `folders` | L |
| `get-custom-field-by-id` | Um campo ou pasta | `id` (id real, nunca a chave) | | L |
| `custom-fields.create-custom-field` | Cria campo | `showInForms`, `dataType`, `fieldKey`, `objectKey`, `parentId` (pasta) | `name`, `description`, `placeholder`, `options` (`[{key, label}]`), `acceptedFormats`, `maxFileLimit`, `allowCustomOption` | S |
| `custom-fields.update-custom-field` | Edita campo | `id`, `showInForms` | `name`, `options`. **`options` substitui a lista inteira** e não remove opção: mande todas | S; R se o campo tem dados |
| `custom-fields.delete-custom-field` | Apaga campo | `id` | | R `CONFIRMO EXCLUSÃO` |
| `create-custom-field-folder` | Cria pasta | `objectKey`, `name` | | S |
| `update-custom-field-folder` | Renomeia pasta | `id`, `name` | | S |
| `delete-custom-field-folder` | Apaga pasta | `id` | | R `CONFIRMO EXCLUSÃO` |

Tipos aceitos neste domínio: `TEXT`, `LARGE_TEXT`, `NUMERICAL`, `PHONE`, `MONETORY`, `CHECKBOX`, `SINGLE_OPTIONS`, `MULTIPLE_OPTIONS`, `DATE`, `TEXTBOX_LIST`, `FILE_UPLOAD`, `RADIO`, `EMAIL`.

Formato da chave: o describe mostra `custom_object.<objeto>.<campo>` num lugar e `custom_objects.<objeto>.<campo>` no exemplo. Leia a chave real do objeto com `get-object-by-location-id` e siga o mesmo prefixo.

## Valores personalizados

| operationId | O que faz | Obrigatórios | Aprovação |
| --- | --- | --- | --- |
| `get-custom-values` | Lista. Testada. Itens: `id`, `name`, `fieldKey` (já vem pronto, ex.: `{{ custom_values.link_agenda }}`), `value` | nenhum | L |
| `get-custom-value` | Um valor | `id` | L |
| `create-custom-value` | Cria | `name`, `value` | S |
| `update-custom-value` | Muda nome e valor. **Manda os dois** | `id`, `name`, `value` | R sempre que o valor atual não estiver vazio: ele pode aparecer em mensagens e páginas que esta skill não enxerga. Mostre valor antigo e novo. S se estiver vazio |
| `delete-custom-value` | Apaga | `id` | R `CONFIRMO EXCLUSÃO` |

A chave em `fieldKey` perde acento e cedilha (testado: "Último número de ticket" virou `ltimo_nmero_de_ticket`). Use a chave como veio.

## Contar antes de apagar um campo

| Objeto | Como contar | Testado |
| --- | --- | --- |
| Contato | `search-contacts-advanced` com `{"pageLimit": 1, "filters": [{"field": "customFields.<id do campo>", "operator": "exists"}]}`; leia `total` | Sim, 03/11/2026 |
| Oportunidade | `search-opportunity` não filtra por campo. Leia os cards com `status: all`, `limit: 100`, contando os que têm o `id` do campo em `customFields`. Pare quando `meta.nextPage` vier vazio, a página trouxer menos que `limit` ou a soma chegar a `meta.total`. Mais de 10 páginas: avise antes | Leitura de `customFields` testada; a contagem completa não |
| Empresa e objetos | `search-object-records` paginando e olhando `properties` | Não testado |

Se não der para contar (erro, conta grande demais), a aprovação reforçada diz: "não consegui contar quantos registros têm valor; trate como se todos tivessem".

## Tags da conta

| operationId | O que faz | Obrigatórios | Aprovação |
| --- | --- | --- | --- |
| `get-location-tags` | Lista todas as tags. Testada. Itens: `id`, `name` | nenhum | L |
| `get-tag-by-id` | Uma tag | `tagId` | L |
| `create-tag` | Cria tag | `name` | S |
| `update-tag` | Renomeia | `tagId`, `name` | R `CONFIRMO MASSA` se a tag está em mais de 20 contatos; S até 20 |
| `delete-tag` | Apaga a tag da conta | `tagId` | R `CONFIRMO EXCLUSÃO` |

Quantos contatos têm a tag (antes de `update-tag` e `delete-tag`): `search-contacts-advanced` com `{"pageLimit": 1, "filters": [{"field": "tags", "operator": "contains", "value": "<tag>"}]}` e leia `total` (operação da skill `atlas-contatos`, testada). Mostre o número na aprovação.

Para pôr ou tirar tag de contatos, use a skill `atlas-contatos`.

## Objetos e registros

| operationId | O que faz | Obrigatórios | Aprovação |
| --- | --- | --- | --- |
| `get-object-by-location-id` | Lista objetos da conta (contato, oportunidade, empresa e personalizados). Testada | nenhum | L |
| `get-object-schema-by-key` | Estrutura de um objeto | `key` (ex.: `custom_objects.pet`); `fetchProperties: true` traz os campos | L |
| `update-custom-object` | Muda rótulos, descrição e campos pesquisáveis | `key`, `searchableProperties` | S |
| `search-object-records` | Busca registros | `schemaKey`, `pageLimit`, e `page` ou `searchAfter` | L |
| `get-record-by-id` | Um registro | `schemaKey`, `id` | L |
| `create-object-record` | Cria registro | `schemaKey`, `properties` (chave do campo: valor) | S |
| `update-object-record` | Edita registro | `schemaKey`, `id` | S |
| `delete-object-record` | Apaga registro | `schemaKey`, `id` | R `CONFIRMO EXCLUSÃO` |

Registro aceita `owners` (máximo 1) e `followers` (máximo 10), conforme o describe.

## Tipos de ligação (associações)

| operationId | O que faz | Obrigatórios | Aprovação |
| --- | --- | --- | --- |
| `find-associations` | Lista tipos de ligação. Testada | `limit`, `skip` | L |
| `get-association-by-ID` | Um tipo | `associationId` | L |
| `associations.create-association` | Cria tipo novo (contato com contato, contato com objeto, empresa com contato) | `key`, `firstObjectKey`, `firstObjectLabel`, `secondObjectKey`, `secondObjectLabel` | S |
| `update-association` | Muda os rótulos | `associationId`, `firstObjectLabel`, `secondObjectLabel` | S |
| `delete-association` | Apaga o tipo **e todas as ligações feitas com ele** | `associationId` | R `CONFIRMO EXCLUSÃO` |

Ligar dois registros (`create-relation`) e ver ligações (`get-relations-by-record-id`): `references/objetos-e-ligacoes.md`.

## Escondido por permissão nesta conexão

| O quê | Como apareceu | Plano B |
| --- | --- | --- |
| Criar objeto personalizado novo | Busca no domínio objects com `kind: write` respondeu `scopeFilteredCount: 1` em 03/11/2026. O nome da operação não aparece | Navegador (telas.md), ou reconectar o Atlas CRM dando todas as permissões |
| Outras do domínio custom-fields e objects | Busca ampla respondeu `scopeFilteredCount: 6` | Se uma tarefa não achar operação, use o navegador |

Domínio locations (campos, valores, tags): busca respondeu `scopeFilteredCount: 1`, fora das operações desta skill.
