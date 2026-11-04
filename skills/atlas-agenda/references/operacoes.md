# Operações do MCP: agenda

Todas conferidas com `describe_operation` em 03/11/2026 (revisão v2 no mesmo dia). Leituras executadas só na conta de teste da Atlas (`get-calendars`, `get-slots`, `get-event-notification`, `getAllSchedules`). Escritas só com `dryRun: true` (testado `create-block-slot`). O `dryRun` devolve `authorizationVerified: false`: a pré-visualização não garante que a conta aceita.

Datas: escritas em ISO 8601 com fuso (`2026-11-20T14:00:00-03:00`). Leituras de período (`get-calendar-events`, `get-blocked-slots`, `get-slots`, `get-service-bookings`) em milissegundos.

## Calendários

### get-calendars (read)
- Lista todos os calendários. Query opcional: `groupId`, `showDrafted` (padrão verdadeiro).
- Resposta: `calendars[]` com `id`, `name`, `calendarType`, `slug`/`widgetSlug`, `teamMembers`, `slotDuration`, `slotInterval`, `slotBuffer`, `allowBookingAfter`, `allowBookingFor`, `appointmentPerDay`, `autoConfirm`, `allowReschedule`, `allowCancellation`, `isActive`, `notes`, `description` e outros.
- Economia: a resposta é grande (descrições em HTML). Não mostre descrição em HTML. Resuma: nome, tipo (`calendarType`), duração, ativo. Guarde o `calendarType`: ele decide como mudar o horário.

### get-calendar (read)
- Um calendário. Obrigatório: `calendarId`.

### get-groups (read)
- Grupos de calendário. Sem parâmetros. Resposta: `groups[]` com `id`, `name`, `slug`, `isActive`.

### create-calendar (write, aprovação simples)
- Obrigatório: `name`.
- Campos que importam: `calendarType` (`round_robin`, `event`, `class_booking`, `collective`, `service_booking`, `personal`), `teamMembers[]` (`userId`, `priority` 0, 0.5 ou 1, `isPrimary`, `locationConfigurations`), `slotDuration` + `slotDurationUnit` (`mins`, `hours`), `slotInterval`, `slotBuffer`, `preBuffer`, `appointmentPerSlot`, `appointmentPerDay`, `allowBookingAfter` + unidade (antecedência mínima), `allowBookingFor` + unidade (quanto tempo à frente), `autoConfirm`, `allowReschedule`, `allowCancellation`, `locationConfigurations[]` (`kind`: `custom`, `zoom_conference`, `google_conference`, `inbound_call`, `outbound_call`, `physical`, `booker`, `ms_teams_conference`; `location`), `durationOptions[]` (até 3, exatamente uma padrão), `eventTitle` (padrão `{{contact.name}}`), `formId`, `notes`, `isActive` (falso = rascunho).
- Pegadinhas do describe: membros obrigatórios em rodízio, coletivo, turma e serviço; pessoal com exatamente um membro. `notifications` está obsoleto: use as operações de notificação. `openHours` e `availabilities` são legado: use as de disponibilidade. Recorrência (`enableRecurring`) só com um membro.
- Recomendação: crie com `isActive: false`, configure horário e lembretes, e ative depois com aprovação.
- Exemplo do describe: `{"name":"My Booking Calendar","slug":"my-booking-calendar","calendarType":"personal","slotDuration":30,"slotDurationUnit":"mins"}`

### update-calendar (write, aprovação simples)
- Obrigatório: `calendarId` (path). Mesmos campos do create, todos opcionais. Mande só o que muda.
- Pegadinha: `teamMembers` enviado substitui a lista. Leia antes e mande a lista completa.

### delete-calendar (delete, `CONFIRMO EXCLUSÃO`)
- Obrigatório: `calendarId`. Sem lixeira pelo MCP. Antes, mostre quantos agendamentos futuros existem e ofereça desativar (`update-calendar` com `isActive: false`), que não apaga nada.

## Disponibilidade (horário de atendimento)

Primeiro veja o `calendarType` (`get-calendars`). O caminho muda conforme o tipo.

### Calendário do tipo `event`
- `getCalendarSchedule` (read): path `calendarId`. Em calendário de outro tipo responde 400 "is not an event calendar" (testado no Onboarding, que é `personal`, em 03/11/2026).
- `createCalendarSchedule` (write, simples): path `calendarId`; corpo obrigatório `rules[]` e `timezone`.
- `updateCalendarSchedule` (write, simples): path `calendarId`; só os campos enviados mudam.
- `rules[]`: `type` (`wday` ou `date`), `day` (`monday` ... `sunday`) ou `date` (`AAAA-MM-DD`), `intervals[]` (`{"from":"08:00","to":"18:00"}`); `timezone` IANA (`America/Sao_Paulo`).
- O dryRun dessas operações não confere o tipo do calendário: confira você antes.

### Os outros tipos (`personal`, `round_robin`, `collective`, `class_booking`, `service_booking`): horário por pessoa
- `getAllSchedules` (read): obrigatório `userId`; opcionais `calendarId`, `limit` (até 500), `skip`. Resposta testada: `schedules[]` com `id`, `name`, `userId`, `calendarIds[]`, `rules[]`, `timezone`. Na conta Atlas o usuário dono tinha 2 horários: "Work Hours" ligado a 6 calendários e "Onboarding 14h e 16h" ligado a 1.
- `getScheduleById` (read): path `id`. Use para conferir depois de mudar.
- `updateSchedule` (write, simples): path `id`; corpo opcional `name`, `rules`, `timezone` (só o enviado muda; `rules` enviado substitui as regras). Atenção: vale para **todos** os calendários em `calendarIds`. Diga quantos e quais antes.
- `createSchedule` (write, simples): obrigatórios `name`, `timezone`, `userId`; opcionais `rules`, `calendarIds`. Use quando só um calendário deve ter horário diferente.
- `add-calendar-to-schedule` (write, simples): path `id` (horário) e `calendarId`. Sem corpo.
- `remove-calendar-from-schedule` (delete, simples com aviso): path `id` e `calendarId`. Solta o calendário daquele horário; se ele ficar sem horário, some da agenda. Ligue ao novo horário antes de soltar do antigo.
- `deleteSchedule` (delete, `CONFIRMO EXCLUSÃO`): path `id`. "Não pode ser desfeito" (describe). Só com pedido expresso.

## Horários livres e agenda do período

### get-slots (read)
- Path: `calendarId`. Query obrigatória: `startDate`, `endDate` (milissegundos; intervalo máximo de 31 dias). Opcionais: `timezone`, `userId`, `userIds`, `duration` (precisa bater com uma das durações ativas).
- Resposta testada: objeto por data, `{"2026-11-06":{"slots":["2026-11-06T16:00:00-03:00"]}}`, mais `traceId`. Datas sem vaga não aparecem.

### get-calendar-events (read)
- Período curto: só o dia ou a semana pedida, e com `calendarId` quando souber.
- Query obrigatória: `startTime`, `endTime` (milissegundos). Um de `calendarId`, `userId` ou `groupId` é obrigatório.
- Resposta: `events[]` com `id`, `title`, `startTime`, `endTime`, `appointmentStatus`, `contactId`, `assignedUserId`, `calendarId`, `isRecurring`, `masterEventId`.

### get-appointments-for-contact (read)
- Path: `contactId`. Resposta: `events[]`.

### get-appointment (read)
- Path: `eventId` (ou ID de ocorrência de série).

### get-blocked-slots (read)
- Mesmos parâmetros de `get-calendar-events`.
- Período curto sempre. Um teste com período longo trouxe 603 itens (cerca de 364 mil caracteres). Para conferir um bloqueio, leia só o dia dele.

## Agendamentos

### create-appointment (write)
- Obrigatórios: `calendarId`, `contactId`, `startTime`.
- Opcionais que importam: `endTime`, `title`, `appointmentStatus` (`new`, `confirmed`, `cancelled`, `showed`, `noshow`, `invalid`, `completed`, `active`), `assignedUserId`, `description`, `address`, `meetingLocationType`, `meetingLocationId`, `overrideLocationConfig`, `toNotify` (padrão verdadeiro; falso = "as automações não rodam"), `ignoreFreeSlotValidation`, `ignoreDateRange`, `rrule` (só vale com `ignoreFreeSlotValidation: true`).
- Aprovação: reforçada `CONFIRMO ENVIO` se `toNotify` verdadeiro; simples se falso.

### edit-appointment (write)
- Path: `eventId` (ocorrência) ou `masterEventId` (série). Campos iguais ao create, todos opcionais.
- Remarcar: `startTime` e `endTime`. Cancelar: `appointmentStatus: "cancelled"`. Marcar presença: `showed` ou `noshow`.
- Pegadinha: `showed` ou `noshow` com `toNotify` verdadeiro pode disparar automação que envia mensagem (ex.: no-show). Verifique com a `atlas-automacoes` se existe; se existir, `CONFIRMO ENVIO`, ou use `toNotify: false`.
- Aprovação: como no create.

### delete-event (delete, `CONFIRMO EXCLUSÃO`)
- Path: `eventId`. Corpo vazio `{}`. Serve para agendamento e bloqueio. Prefira cancelar.

### Notas do agendamento
- `get-appointment-notes` (read): path `appointmentId`; query obrigatória `limit` (até 20) e `offset`.
- `create-appointment-note` (write, simples): path `appointmentId`; corpo `body` (até 5.000 caracteres), `userId` opcional.
- `update-appointment-note` (write, simples): path `appointmentId` e `noteId`; corpo `body`.
- `delete-appointment-note` (delete, `CONFIRMO EXCLUSÃO`): path `appointmentId` e `noteId` (o caminho e o exemplo do describe pedem os dois).

## Bloqueios

### create-block-slot (write, simples)
- Período curto e definido (o dia ou as horas pedidas). Afastamento longo: confirme início e fim com o cliente antes.
- Corpo: `calendarId` (obrigatório no describe), ou `assignedUserId`, nunca os dois; `startTime`, `endTime`, `title`.
- Testado com `dryRun`: monta `POST /calendars/events/block-slots` com `locationId` no corpo.

### edit-block-slot (write, simples)
- Path: `eventId`. Mesmo corpo.

## Serviços

### get-services-catalog (read)
- Query opcional: `isPrivate`, `serviceCategoryId`. Resposta: `services[]` com nome, duração, preço (`payment`), equipe (`staff`), variações.

### create-service-catalog (write, simples)
- Obrigatórios: `name`, `slug`, `staff[]` (`{"id":"<userId>"}`, ao menos um).
- Opcionais: `description`, `serviceDuration` + `serviceDurationUnit`, `preBuffer`, `postBuffer`, `payment` (`amount`, `deposit`, `depositType` `percentage` ou `amount`; moeda vem da configuração global de serviços), `isPrivate`, `formId`, `variations[]`, `eventColor`, `coverImage`, `serviceCategoryId`.

### update-service-catalog (write, simples)
- Path: `serviceId`. Pegadinha: `variations` vazio apaga todas as variações; para mudar uma, mande com `id`.

### delete-service-catalog (delete, `CONFIRMO EXCLUSÃO`)
- Path: `serviceId`. Prefira `update-service-catalog` com `isPrivate: true` para tirar do ar sem apagar.

### get-service-bookings (read)
- Query obrigatória: `startTime`, `endTime` (milissegundos, como texto). Opcionais `serviceLocationId`, `timezone`.
- Criar, alterar e apagar reserva de serviço não estão mapeados nesta skill. Use `create-appointment` para marcar; reserva de serviço só depois de `search_operations` e `describe_operation` na hora.

## Notificações (confirmações e lembretes)

Ver `notificacoes.md` para quando usar cada uma.

### get-event-notification (read)
- Path: `calendarId`. Query: `isActive`, `deleted`, `limit` (padrão 100), `skip`.
- Resposta testada: lista com `_id`, `channel`, `notificationType`, `receiverType`, `isActive`, `isDefault`, `selectedUsers`. No calendário Onboarding da Atlas vieram 2 avisos padrão no aplicativo para o responsável (agendado e confirmado).

### find-event-notification (read)
- Path: `calendarId`, `notificationId`. Resposta: a notificação com `channel`, `notificationType`, `receiverType`, `beforeTime`, `afterTime`, `body`, `subject`, `isActive`.

### create-event-notification (write)
- Path: `calendarId`. Pelo describe, o corpo é uma **lista** (uma ou várias notificações, todas do mesmo calendário).
- Pegadinha vista no teste v1 (03/11/2026): no `dryRun`, mandando a lista em `params.body`, o conector montou o corpo como `{"body":[...]}` em vez da lista. Isso não foi confirmado com escrita real. Por isso: depois de criar, **sempre** confira com `get-event-notification` (canal, tipo, `beforeTime`, texto). Se vier diferente ou não aparecer, desligue na hora com `update-event-notification` (`isActive: false`), avise o cliente e faça pelo navegador (Notificações e Políticas do editor do calendário, telas.md).
- Campos: `receiverType` (`contact`, `guest`, `assignedUser`, `emails`, `phoneNumbers`, `business`), `channel` (`email`, `inApp`, `sms`, `whatsapp`), `notificationType` (`booked`, `confirmation`, `cancellation`, `reminder`, `followup`, `reschedule`), `isActive`, `templateId`, `subject`, `body`, `beforeTime[]` (lembrete: `{"timeOffset":1,"unit":"hours"}`), `afterTime[]` (acompanhamento), `selectedUsers`, `additionalEmailIds`, `additionalPhoneNumbers`, `fromAddress`, `fromName`, `fromNumber`.
- Aprovação: para `receiverType: contact` ou `guest`, reforçada `CONFIRMO ENVIO` (vai mandar mensagem a cada agendamento). Para a equipe, simples.

### update-event-notification (write)
- Path: `calendarId`, `notificationId`. Mesmos campos. `deleted: true` faz exclusão lógica. `isActive: false` desliga.

### delete-event-notification (delete, `CONFIRMO EXCLUSÃO`)
- Path: `calendarId`, `notificationId`. Prefira `isActive: false`.

## Fora desta skill

Grupos de calendário (criar, editar, apagar) e recursos (salas e equipamentos) existem no catálogo, mas não estão mapeados aqui. Se o cliente pedir, rode `search_operations` com `domains: ["calendars"]`, `limit: 5`, e `describe_operation` antes de usar.
