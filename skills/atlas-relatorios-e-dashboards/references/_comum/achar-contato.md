# Como achar um contato

Vale para todas as skills que precisam de um contato ("o João", "a Maria da clínica"). Testado na conta Atlas em 03/11/2026.

## Ordem de busca

1. **Tem e-mail ou telefone?** Use `get-duplicate-contact` com `email` ou `number` (telefone no formato +55DDDNÚMERO). Mande o valor como está, **sem codificar** (`+` e `@` normais): codificado, a busca responde que não existe. É a busca exata e também acha telefone extra do contato. Resposta `contact: null` quer dizer que não existe. É o padrão de todas as skills; `lookup-contact` também existe, mas não é usado aqui, para haver um caminho só.
2. **Só tem o nome?** Use `search-contacts-advanced` com o nome em minúsculas e operador `eq`:

```json
{"pageLimit": 5, "filters": [
  {"field": "firstNameLowerCase", "operator": "eq", "value": "joão"},
  {"field": "lastNameLowerCase", "operator": "eq", "value": "silva"}
]}
```

   Sem sobrenome, use só o primeiro filtro. O campo da página é `pageLimit`, não `limit`. A resposta traz `total`.
3. **Evite `contains` para nome.** Ele é solto: na conta Atlas, `contains "luc"` trouxe 51 contatos. Se precisar, confirme pelo nome completo antes de usar o resultado.

## Resultado

| Encontrou | O que fazer |
| --- | --- |
| 1 contato | Confirme com o cliente pelo nome completo e mais um dado que ele reconheça (empresa, cidade ou final do telefone com 4 dígitos) |
| 2 a 5 | Liste nome completo e um dado de diferença de cada um, e pergunte qual |
| Mais de 5 | Peça um dado a mais (sobrenome, e-mail ou telefone) |
| Nenhum | Diga que não achou, mostre como procurou e pergunte se quer criar (skill `atlas-contatos`) |

Nunca mostre a lista inteira de contatos nem e-mail e telefone completos de quem o cliente não pediu.

## Empresa

Para achar uma empresa (cadastro de empresa), veja a skill `atlas-contatos`, que tem as operações de empresa.
