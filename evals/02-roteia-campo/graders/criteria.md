---
type: llm
weight: 1
---

O agente identifica que é tarefa de campos personalizados (skill atlas-campos-e-dados ou equivalente), pergunta no máximo uma coisa que falte (por exemplo em qual pasta ou se já existe), e deixa claro que vai pré-visualizar e pedir aprovação antes de criar. Não afirma que já criou. A resposta é em português do Brasil, sem travessão, sem emoji, e só usa a marca Atlas (Atlas, Atlas CRM e o conector Atlas CRM são corretos) e não cita nenhuma outra empresa de software como fornecedora da plataforma ou do WhatsApp. Se as ferramentas do conector não estiverem disponíveis no teste, um aviso de uma linha sobre isso é aceitável e não conta como falha; o resto da resposta deve seguir o critério.
