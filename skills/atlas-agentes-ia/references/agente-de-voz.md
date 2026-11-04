# Agente de voz

Tudo pelo conector (domínio voice-ai), conferido em 03/11/2026.

## Montagem segura

1. `voice-ai.create-agent` **sem** `inboundNumber` e **sem** `numberPoolId`:
   - `agentName` (até 40), `businessName`, `language: "pt-BR"`, `timezone: "America/Sao_Paulo"`
   - `welcomeMessage` (até 190 caracteres), ex.: "Olá, você ligou para a Clínica Exemplo. Como posso ajudar?"
   - `agentPrompt` com o mesmo modelo de `agente-de-conversa.md` (personalidade, objetivo, regras), adaptado para fala: frases curtas, sem listas, confirmar nome e telefone.
   - `maxCallDuration` entre 180 e 900 s (padrão 300)
   - `agentWorkingHours` se não atende 24 horas
   - `sendPostCallNotificationTo` para a equipe saber das ligações
   - `isAgentAsBackupDisabled: true` (não ser usado como reserva até ser ligado)
2. Ações com `voice-ai.create-action`: transferência para humano (`CALL_TRANSFER`), agendamento (`APPOINTMENT_BOOKING`), base (`KNOWLEDGE_BASE`), coleta de dados (`DATA_EXTRACTION`). Transferência e SMS pedem `CONFIRMO ENVIO`.
3. Teste: ligação de teste pelo próprio CRM (tela do agente, a conferir no navegador). Depois `get-call-logs` com `callType: "TRIAL"` para ler resumo e ações executadas.
4. Ligar: `patch-agent` com `inboundNumber` (número da conta, ver `atlas-conversas-e-disparos`) e, se o cliente quiser, `isAgentAsBackupDisabled: false`, só com `CONFIRMO PUBLICAÇÃO`.

## Leitura de ligações

- `get-call-logs` com `agentId`, período (`startDate` e `endDate` juntos, em milissegundos) e `pageSize` pequeno.
- Entregue contagens e resumos. Transcrição é conversa de terceiros: não copie para fora da conversa.

## Pegadinhas do describe

- `language` padrão é `en-US`: sempre mande `pt-BR`.
- `translation.enabled` só se o idioma não for `en-US`.
- `callEndWorkflowIds` (até 10) coloca o contato em automação no fim da ligação: veja o que ela envia.
- O padrão de `isAgentAsBackupDisabled` é falso: o agente pode ser usado como reserva e atender ligação real sem número próprio. Por isso a skill cria com `true` e só muda para falso com `CONFIRMO PUBLICAÇÃO`.
