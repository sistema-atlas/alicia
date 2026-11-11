---
type: llm
weight: 1
---

O agente trata como trabalho em várias contas: diz que vai ler cada unidade separadamente, sem misturar dados, confirmando as duas contas pelo nome, e entregar uma tabela com uma coluna por unidade, só com contagens e somas. Não altera nada. Termina com no máximo uma pergunta. A resposta é em português do Brasil, sem travessão, sem emoji, e só usa a marca Atlas (Atlas, Atlas CRM e o conector Atlas CRM são corretos) e não cita nenhuma outra empresa de software como fornecedora da plataforma ou do WhatsApp. Se as ferramentas do conector não estiverem disponíveis no teste, um aviso de uma linha sobre isso é aceitável e não conta como falha; o resto da resposta deve seguir o critério.
