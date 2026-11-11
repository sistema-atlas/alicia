# Copiar configuração de uma unidade para outra

Origem = conta A (só leitura). Destino = conta B (onde se cria). Toda chamada leva o `locationId` da conta em que age.

## Passo a passo comum

1. Confirme A e B pelo nome (`list_locations`). Se o cliente disse "a outra unidade" e há mais de duas, pergunte qual.
2. Leia o item em A e o mesmo tipo em B (operações em `operacoes.md`).
3. Compare pelo nome normalizado: minúsculas, sem acento, sem espaço extra, hífen e espaço iguais. Para campo, compare também o objeto (contato ou oportunidade) e o tipo.
4. Monte três listas: **vai ser criado em B**, **já existe em B** (fica de fora), **não dá pelo conector** (vai para o navegador).
5. `dryRun: true` com o `locationId` de B, um item por chamada.
6. Aprovação:

```
Vou criar na conta <Nome de B>, copiando da conta <Nome de A>:
- <item 1>
- <item 2>
Já existem em <Nome de B> e ficam de fora: <itens>
Não dá por aqui (navegador): <itens>
Pré-visualização conferida, nada foi alterado ainda.

Responda SIM para eu fazer, ou diga o que mudar.
```

   Mais de uma conta de destino, ou mais de 20 itens: use a aprovação reforçada com `CONFIRMO MASSA` e liste cada conta com a quantidade dela ("Unidade Batel: 6 tags; Unidade Água Verde: 4 tags; Unidade Portão: 6 tags").
7. Execute conta por conta, item por item, com `idempotencyKey` que tenha a conta e o item.
8. Leia de novo em B e entregue o que foi criado. Se um item falhar, pare naquela conta, diga qual falhou e pergunte se segue.

## Pegadinhas por tipo

| Tipo | Como copiar | Cuidado |
| --- | --- | --- |
| Campo sem opções (texto, número, data, arquivo) | `get-custom-fields` em A; `locations.create-custom-field` em B com `name`, `dataType`, `model`, `placeholder` | A chave (`fieldKey`) em B é gerada de novo a partir do nome; mensagens e automações de B usam a chave de B. Leia depois de criar. A pasta (grupo) do campo em A não vai junto: o campo chega fora da pasta e se organiza pela tela em B |
| Campo de lista (`SINGLE_OPTIONS`, `MULTIPLE_OPTIONS`, `RADIO`, `CHECKBOX`) | **Navegador** em B, já com as opções lidas em A (`picklistOptions`) | O conector não manda opções. Entregue a lista de opções pronta para colar |
| Valor personalizado | `get-custom-values` em A; `create-custom-value` em B | Endereço, telefone, link de agenda e nome da unidade mudam por unidade. Pergunte o valor de B para cada um que pareça da unidade |
| Tag | `get-location-tags` nas duas; `create-tag` em B | A tag é só o nome. Quem usa a tag (automação, filtro) não vai junto |
| Agenda | `get-calendars` em A; `create-calendar` em B | `teamMembers` com usuários **de B** (pergunte quem atende em B ou peça à skill `atlas-conta-e-equipe` para listar). `formId`, `groupId`, `slug`, `widgetSlug`, `pixelId`, `alertEmail` e o link de redirecionamento de A não servem em B: tire ou troque. Endereço de atendimento (`locationConfigurations`) e imagem de capa também são de A: pergunte os de B. Crie com `isActive: false` (rascunho) e peça para conferir antes de ligar. Lembretes e notificações não vão juntos |
| Modelo de e-mail | `list-email-templates` e `get-email-template` em A; `create-email-template` em B | Só modelos `html` ou `text`, e só se o conteúdo puder ser lido (a leitura traz um link de arquivo, não o texto). Não mostre ao cliente os links de arquivo da leitura (`editorContentUrl`, `previewUrl`). Se não der, ou se o modelo é do construtor visual: navegador. Remetente (`fromEmail`) de A pode não estar liberado em B |
| Perguntas da base de conhecimento | `listAllKnowledgeBasesPaginated` e `list` em A; base existente ou `createKnowledgeBase` em B; `create` em B | Compare pela pergunta. Resposta com dado da unidade A (endereço, horário, preço) deve ser revisada pelo cliente antes |
| Produto e preço | `products.list-invoices` e `list-prices-for-product` em A; `create-product` e `create-price-for-product` em B | Mostre nome, valor e moeda de cada preço. Criar produto não cobra ninguém. Imagem: o link de A pode ficar fora do ar se A apagar a mídia; avise |

## O que não vai pelo conector

Ver `telas.md`. Resumo para o cliente: "Funil e etapas, automações, páginas, formulários e painéis não consigo criar daqui. Posso fazer pelo seu navegador ou te passo o passo a passo." Para os que têm cópia pronta na tela, diga que a opção pode aparecer só para a equipe da Atlas.

## Contatos

Contatos são dados pessoais e pertencem a cada unidade. Só copie ou mova com pedido expresso do cliente, nunca como parte de "deixar as unidades iguais".

Antes de qualquer leitura de contatos para copiar, diga:

```
Cada unidade responde pelos dados dos seus contatos (LGPD). Copiar contatos de <A> para <B> faz a unidade <B> passar a ter esses dados pessoais. Só siga se houver base legal para isso (por exemplo, o contato pediu atendimento na outra unidade).
```

Depois:

1. Pergunte quais contatos (filtro claro: tag, lista, período). Nunca "todos" sem filtro.
2. Conte em A com `search-contacts-advanced` (`pageLimit: 1`, leia `total`).
3. Aprovação reforçada, mesmo para poucos:

```
ATENÇÃO: esta ação altera muitos registros e leva dados pessoais para outra unidade.
Conta de origem: <Nome de A>   Conta de destino: <Nome de B>
O que: copiar contatos (nome, e-mail, telefone e campos que existem em B)
Quantidade: <n>   Exemplos: <3 primeiros nomes>
Não vão juntos: conversas, notas, tarefas, agendamentos, pagamentos, arquivos
Contato que já existe em B é atualizado com o que for enviado; as tags dele ficam e as tags de A são somadas depois
Dá para desfazer: em parte (apagando em B, um por um)

Para confirmar, responda exatamente: CONFIRMO MASSA
```

4. `dryRun` de um contato de exemplo com `upsert-contact` na conta B, **sem o campo `tags`** (ele substitui todas as tags de quem já existe em B). Execute em lotes, conta B só. Tags depois, em B, com `add-tags` ou `contacts.create-association` (`type: add`), seguindo a regra 10 do SKILL.md sobre automações.
5. **Mover** (tirar de A depois) é outra ação: segue a skill `atlas-contatos`, `CONFIRMO EXCLUSÃO`, um por vez. Ofereça manter em A.
6. Pedido do próprio titular dos dados (o contato quer cópia ou exclusão): não execute, passe para uma pessoa da Atlas (regra 8 de segurança).
