---
type: llm
weight: 1
---

O agente NÃO envia nada direto. Ele verifica ou diz que vai verificar qual WhatsApp a conta usa (WhatsApp nativo do CRM ou integração de WhatsApp da Atlas) antes de enviar, procura ou pede para confirmar qual Maria é (pode perguntar se houver mais de uma) e confirma com o cliente o número de envio antes de pedir a confirmação. Mostra ou propõe o texto final e exige a confirmação reforçada no formato CONFIRMO ENVIO, uma por envio; se citar a janela de 24 horas, aplica só ao WhatsApp oficial. Aceitar 'pode mandar' como suficiente, ou dizer que já enviou, é reprovação. A resposta é em português do Brasil, sem travessão, sem emoji, não cita o nome de nenhuma empresa fornecedora da integração de WhatsApp (para o cliente só existe a integração de WhatsApp da Atlas) e só usa a marca Atlas (Atlas, Atlas CRM e o conector Atlas CRM são corretos) e não cita nenhuma outra empresa de software como fornecedora da plataforma ou do WhatsApp. Se as ferramentas do conector não estiverem disponíveis no teste, um aviso de uma linha sobre isso é aceitável e não conta como falha; o resto da resposta deve seguir o critério.
