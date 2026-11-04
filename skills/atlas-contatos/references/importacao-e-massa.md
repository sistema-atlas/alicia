# Importação de planilha e ações em massa

## Qual caminho usar para importar

| Situação | Caminho |
| --- | --- |
| Planilha com qualquer tamanho, cliente quer o jeito oficial | **Navegador**: Contatos > Importar (passo a passo em `telas.md`). Recomendado |
| Poucas linhas (até 20) que o cliente colou na conversa | MCP `upsert-contact`, uma por vez, aprovação simples por lote pequeno |
| Mais de 20 linhas e o cliente insiste em fazer pela conversa | MCP `upsert-contact` em lotes, aprovação reforçada `CONFIRMO MASSA` |

O MCP não tem operação de importação de contatos (conferido em 03/11/2026). A tela de importação tem mapeamento de colunas, regra de criar ou atualizar, lista inteligente e consentimento. Prefira ela.

## Preparar a planilha (vale para os dois caminhos)

1. Uma linha por contato. Primeira linha com o nome das colunas.
2. Colunas mínimas: nome, telefone ou e-mail. Úteis: origem, responsável, tags, campos personalizados.
3. Telefone no formato `+55DDDNÚMERO` (ver `higiene-e-duplicados.md`). Corrija antes de subir.
4. Tire linhas repetidas por telefone e e-mail.
5. Coluna que não tem campo na conta: crie o campo antes (skill `atlas-campos-e-dados`).
6. Confirme com o cliente que esses contatos autorizaram receber contato da empresa.

## Upsert em lotes pela conversa

1. Leia a planilha e mostre: total de linhas, quantas sem telefone e sem e-mail, quantas com telefone fora do padrão. Nada de listar dados pessoais.
2. Corrija o que der (formato de telefone) e mostre 3 exemplos já corrigidos, mascarados (ex.: `+55 41 9****-0000`).
3. Avise: o upsert atualiza contato que já existe (pelo e-mail ou telefone, conforme a regra da conta). Dados novos sobrescrevem os antigos nos campos enviados.
4. **Não mande `tags` no upsert**: em contato existente, ele apaga as tags atuais. Depois do upsert, aplique a tag do lote com a operação de tags em massa.
5. Pergunte se alguma automação começa quando contato é criado. Contato novo pode disparar mensagem.
6. Aprovação reforçada:

```
ATENÇÃO: esta ação altera muitos registros.
Conta: <nome>
O que: criar ou atualizar contatos a partir da planilha
Quantidade: <n> linhas em <k> lotes
Exemplos: <3 exemplos mascarados>
Dá para desfazer: em parte (contatos novos podem ser apagados um a um; dados sobrescritos não voltam)

Para confirmar, responda exatamente: CONFIRMO MASSA
```

7. Rode um lote por vez, guardando para cada linha: criado (`new: true`), atualizado ou erro. Sem gravar dado pessoal em arquivo.
8. Se vier 429, espere e diminua o lote (ver `_comum/conector.md`). Se o mesmo erro aparecer duas vezes, pare e mostre.
9. No fim: aplique a tag do lote (ex.: `importacao-2026-11`) com `contacts.create-association` tipo `add`, em lotes.
10. Confira pela busca com filtro da tag: o `total` tem que bater com criados mais atualizados.

## Tamanho do lote

- O describe de `add-remove-contact-from-business` limita a 50 ids por chamada. Para as outras operações em massa o describe não informa limite.
- Regra desta skill: lotes de até 50 contatos por chamada e uma chamada por vez. Não é limite da plataforma, é prudência para conferir erro por lote.
- Não há limite de chamadas por minuto documentado no conector. Se aparecer 429, pare, espere e retome com lote menor.

## Tags em massa

1. Monte o grupo com `search-contacts-advanced` (filtro claro) e leia o `total`.
2. Pergunte se alguma automação começa com essa tag (skill `atlas-automacoes`).
3. Acima de 20 contatos: aprovação reforçada `CONFIRMO MASSA`, com a quantidade, o nome exato da tag e 3 exemplos mascarados.
4. Pegue os ids paginando com `searchAfter` (`pageLimit: 100`). Pare quando a página vier com menos itens que o `pageLimit` ou quando a soma de itens lidos chegar ao `total`. Nunca passe de 10 páginas sem avisar o cliente e pedir para seguir.
5. `contacts.create-association` com `type: add` (ou `remove`), lotes de até 50 ids.
6. Some `succeeded` e `errorCount` de cada lote.
7. Confira: busca pela tag, `total` deve subir (ou descer) no número esperado.

Tirar todas as tags de um grupo (`removeAllTags: true`) é exclusão em massa: `CONFIRMO EXCLUSÃO`, e só com pedido expresso.

## Apagar em massa

Não faça pelo MCP. Pela tela há seleção em massa. Restaurar excluídos não está disponível nas telas conferidas (03/11/2026): não prometa desfazer. Ofereça no lugar marcar com uma tag (ex.: `arquivado`) e tirar das automações, sem apagar. Se o cliente quiser apagar mesmo assim, sugira antes marcar os contatos com uma tag de revisão para o cliente conferir. Um contato isolado pode ser apagado pelo MCP com `CONFIRMO EXCLUSÃO`.
