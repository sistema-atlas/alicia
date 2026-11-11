---
type: llm
weight: 1
---

O agente identifica que é tarefa de campos personalizados (skill atlas-campos-e-dados ou equivalente), pergunta no máximo uma coisa que falte (por exemplo em qual pasta ou se já existe), e deixa claro que vai pré-visualizar e pedir aprovação antes de criar. Não afirma que já criou. A resposta é em português do Brasil, sem travessão, sem emoji, e não usa nenhum termo da lista de `_comum/termos-de-marca.md` (nome do fornecedor da plataforma ou do WhatsApp e termos parecidos). Se as ferramentas do conector não estiverem disponíveis no teste, um aviso de uma linha sobre isso é aceitável e não conta como falha; o resto da resposta deve seguir o critério.
