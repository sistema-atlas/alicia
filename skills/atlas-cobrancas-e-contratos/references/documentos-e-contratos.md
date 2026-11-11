# Documentos e contratos

Fonte: descrições das operações do domínio de documentos e contratos (03/11/2026). Na conta de teste da Atlas não havia modelo nem documento.

## Como funciona

1. O **modelo** (proposta, contrato, orçamento) é montado na tela da Atlas, com campos que puxam dados do contato e da oportunidade, área de assinatura e, se quiser, produtos com valor.
2. O assistente **lista** os modelos (`list-documents-contracts-templates`) e **envia** um modelo para um contato (`send-documents-contracts-template`), opcionalmente ligado a uma oportunidade (`opportunityId`).
3. O andamento é lido em `list-documents-contracts`: `draft`, `sent`, `viewed`, `completed`, `accepted`, e o pagamento em `paymentStatus`.

## Receita: "manda o contrato para o cliente assinar"

1. `list-documents-contracts-templates` com `name` para achar o modelo. Mais de um parecido: pergunte qual.
2. Ache o contato (`references/_comum/achar-contato.md`). Se houver negócio aberto, pegue o `opportunityId` (skill `atlas-funil-e-vendas`).
3. `userId` de quem envia: `references/operacoes.md` > "Como achar o userId".
4. dryRun com `templateId`, `contactId`, `userId`, `sendDocument: true`.
5. Aprovação reforçada `CONFIRMO ENVIO` mostrando modelo, contato, e-mail que recebe e se há valor a pagar (se houver, também `CONFIRMO COBRANÇA`).
6. Depois: `list-documents-contracts` com `query` pelo nome para confirmar `status: sent`.

## O que não dá pelo conector

- Criar ou editar o modelo, mudar cláusulas, posicionar assinatura: tela (passo a passo em `references/telas.md` > Criar modelo de contrato).
- Assinar pelo cliente: nunca.
- Redirecionar depois de assinar e e-mails de aviso da equipe: configuração do modelo na tela (a conferir no navegador).
