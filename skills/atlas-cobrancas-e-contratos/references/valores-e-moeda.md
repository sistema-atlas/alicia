# Valores e moeda: como ler e mostrar

Fonte: respostas reais da conta de teste da Atlas em 03/11/2026 e descrições das operações.

## Regra de ouro

| Onde | Campo | Unidade | Exemplo visto |
| --- | --- | --- | --- |
| Preço de produto | `amount` | reais cheios | `50` = R$ 50,00 |
| Item de fatura, orçamento, recorrência | `items[].amount` | mesma unidade do preço (valor cheio). Confira no dryRun e na prévia da fatura antes de enviar | `800` = R$ 800,00 |
| Oferta de curso | `amount` | reais cheios | `297` = R$ 297,00 |
| Transação | `amount` | reais cheios | `400` = R$ 400,00 |
| Transação, retrato do processador | `chargeSnapshot.amount` | **centavos** | `40000` = R$ 400,00. Não use |
| Cupom percentual | `discountValue` com `discountType: percentage` | por cento | `10` = 10% |
| Cupom em valor | `discountValue` com `discountType: amount` | reais cheios | `20` = R$ 20,00 |

## Moeda

- A conta tem uma moeda padrão em `get-location` > `location.currency` (na Atlas: `BRL`).
- Em criação, mande `currency: "BRL"` (maiúsculo) na fatura e em cada item. Os exemplos do conector vêm com `USD`: nunca copie.
- Em leitura, transações podem vir com `currency: "brl"` (minúsculo) e `currencyOptions: { code, symbol: "R$" }`. Trate como a mesma moeda.

## Como mostrar ao cliente

- Formato brasileiro: `R$ 1.500,00` (ponto no milhar, vírgula nos centavos).
- Sempre diga se é teste ou real (`liveMode`).
- Em soma de período, diga o período e a fonte: "R$ 4.380,00 em 19 transações aprovadas de 01/10 a 31/10, pela lista de transações" (exemplo ilustrativo, não é dado da conta).
- Some só `status: "succeeded"` e desconte `amountRefunded`.
