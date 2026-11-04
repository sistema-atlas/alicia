# Calendários: tipos, configuração e horário

## Qual tipo escolher (valores de `calendarType` do describe)

| O cliente diz | Tipo | Observação |
| --- | --- | --- |
| "Só eu atendo" | `personal` | Exatamente um membro da equipe |
| "Quem estiver livre atende" | `round_robin` | Rodízio entre membros. `eventType`: `RoundRobin_OptimizeForAvailability` (prioriza disponibilidade) ou `RoundRobin_OptimizeForEqualDistribution` (divide igual) |
| "A reunião precisa de duas pessoas juntas" | `collective` | Só mostra horário em que todos estão livres |
| "Aula ou turma com várias vagas" | `class_booking` | `appointmentPerSlot` vira número de vagas |
| "Evento com data marcada" | `event` | Horário via `createCalendarSchedule` |
| "O cliente escolhe o serviço e o profissional" | `service_booking` | Usa o catálogo de serviços |

## Campos que o cliente entende

| Pedido | Campo |
| --- | --- |
| "Consulta de 30 minutos" | `slotDuration: 30`, `slotDurationUnit: "mins"` |
| "Horários de meia em meia hora" | `slotInterval: 30` |
| "15 minutos de folga depois" | `slotBuffer: 15` |
| "10 minutos antes para preparar" | `preBuffer: 10` |
| "No máximo 8 por dia" | `appointmentPerDay: 8` |
| "Só pode marcar com 4 horas de antecedência" | `allowBookingAfter: 4`, `allowBookingAfterUnit: "hours"` |
| "Agenda aberta para os próximos 30 dias" | `allowBookingFor: 30`, `allowBookingForUnit: "days"` |
| "Já confirma sozinho" | `autoConfirm: true` |
| "O cliente pode remarcar / cancelar pelo link" | `allowReschedule`, `allowCancellation` |
| "Reunião pelo Google Meet" | `locationConfigurations: [{"kind":"google_conference"}]` (precisa do Google conectado, pelo navegador) |
| "Atendimento no endereço da clínica" | `locationConfigurations: [{"kind":"physical","location":"<endereço>"}]` |
| "O cliente escolhe 30 ou 60 minutos" | `durationOptions` (até 3, uma padrão) |
| "Deixa desligado por enquanto" | `isActive: false` |

## Horário de atendimento

Primeiro o tipo do calendário (`calendarType` em `get-calendars`).

**Calendário `event`:** `getCalendarSchedule`, depois `createCalendarSchedule` (primeira vez) ou `updateCalendarSchedule`.

**Os outros tipos (a maioria das contas):** o horário é da pessoa da equipe.
1. `getAllSchedules` com o `userId` do membro do calendário.
2. Veja qual horário tem o `calendarId` em `calendarIds`.
3. Diga ao cliente quantos e quais calendários usam aquele horário. Exemplo real da conta Atlas: "Work Hours" vale para 6 calendários (Mapa Estratégico, as três Tutorias, Reuniões de Suporte e Apresentação).
4. Se todos devem mudar: `updateSchedule` com as `rules` novas (aprovação simples com antes e depois).
5. Se só um deve mudar: `createSchedule` com o horário novo e esse `calendarId`, depois `remove-calendar-from-schedule` do horário antigo (nessa ordem, para o calendário não ficar sem horário).
6. Confira com `getScheduleById` e `get-slots`.

Formato das regras:

```json
{
  "rules": [
    {"type": "wday", "day": "monday", "intervals": [{"from": "08:00", "to": "12:00"}, {"from": "13:30", "to": "18:00"}]},
    {"type": "wday", "day": "saturday", "intervals": [{"from": "08:00", "to": "12:00"}]},
    {"type": "date", "date": "2026-12-24", "intervals": [{"from": "08:00", "to": "12:00"}]}
  ],
  "timezone": "America/Sao_Paulo"
}
```

- Dia sem regra = sem atendimento. `rules` enviado substitui as regras do horário: mande a semana inteira.
- Para um período fora (viagem, feriado), prefira bloqueio curto (`create-block-slot`) a mexer no horário fixo.

## "Não aparece horário no link"

Ordem de checagem (artigo "why-appointment-time-slots-are-missing-on-your-calendar" da fonte do fornecedor trata do tema):
1. Calendário ativo (`isActive`)?
2. Tem horário de atendimento no dia (horário da pessoa em `getAllSchedules`, ou `getCalendarSchedule` se for `event`)?
3. Antecedência mínima (`allowBookingAfter`) e janela (`allowBookingFor`) deixam o dia aparecer?
4. Limite por dia (`appointmentPerDay`) já atingido?
5. Bloqueio no período (`get-blocked-slots` só naquele dia)?
6. Agenda externa conectada ocupando o horário (navegador)?
7. Rode `get-slots` no período para ver o que o sistema oferece.
