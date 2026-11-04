# Comparar unidades

Reaproveita as receitas da skill `atlas-relatorios-e-dashboards` (`references/calculos.md` e `references/entrega.md` daquela skill). Esta página só diz como repetir a mesma receita em várias contas.

## Regras

1. **Mesmo período em todas.** Pergunte o período se faltar (única pergunta). Datas no fuso de cada conta (`get-location` de cada uma). Se os fusos forem diferentes, diga na entrega.
2. **Mesma definição.** Cada número tem a mesma receita e a mesma data filtrada em todas as contas. Desconte os registros de teste em todas, do mesmo jeito.
3. **Funil certo em cada conta.** O funil de vendas tem id diferente em cada conta e às vezes nome diferente. Leia `get-pipelines` em cada uma; se o nome não for igual, pergunte qual é o de vendas daquela unidade.
4. **Uma conta por vez, na mesma ordem.** Rode todas as leituras de A, depois todas de B. Guarde só os totais.
5. **Só contagens e somas.** Nenhum nome, e-mail ou telefone.
6. Uma unidade sem agenda, sem funil ou sem origem preenchida: escreva "não medido" e o motivo, nunca 0.

## Entrega

```
Outubro de 2026 (01/10 a 31/10), unidades Centro e Batel

| Indicador | Centro | Batel |
| --- | --- | --- |
| Leads novos (data de criação) | 120 | 85 |
| Negócios criados no funil de vendas | 40 | 31 |
| Ganhos (data em que viraram ganho) | 12 | 9 |
| Valor ganho (R$) | 18.400 | 12.100 |
| Agendamentos (data da reunião) | 60 | 44 |
| Faltas | 9 | 4 |

Descontei 2 registros de teste no Centro e 0 no Batel.
```

Os números do exemplo são ilustrativos. Depois da tabela: 1 a 3 leituras práticas (ex.: "Batel converte menos leads em agendamento, mas falta menos"). Mais de 4 unidades: tabela com unidades nas linhas e indicadores nas colunas.

## Economia

Por conta: `get-location` (1), `get-pipelines` (1), contagens com `limit` 1 ou `pageLimit` 1. Agrupar por etapa ou por origem só quando o cliente pedir.
