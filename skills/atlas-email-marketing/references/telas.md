# Telas: e-mail marketing

Endereço base: `https://crm.atlasoficial.com/v2/location/<locationId>/`. Se o cliente usa outro domínio, use o da aba dele.

Regras do navegador: `references/_comum/navegador.md`.

Legenda: **(conferido em 03/11/2026)** quando a tela foi vista no navegador na conta Atlas, somente leitura. **confirmado** quando o caminho veio de fonte. **(a conferir no navegador)** quando é o padrão da plataforma, ainda não visto nesta construção.

| Tela | Caminho depois do endereço base | Menu | Situação |
| --- | --- | --- | --- |
| Campanhas de e-mail | `marketing/emails/scheduled` (estatísticas em `marketing/emails/statistics`) | Marketing > E-mails > Campanhas (subabas "Estatísticas", "Campanhas", "Modelos"; botão "Crie campanha") | (conferido em 03/11/2026) |
| Modelos de e-mail | `marketing/emails/all` | Marketing > E-mails > Modelos | (conferido em 03/11/2026) |
| Kit da marca (cores, fontes e logo) | `marketing/brand-boards` | Configurações > Brand Boards (nome da tela; ao cliente diga "kit da marca") | (conferido em 03/11/2026) |
| Domínio de envio e serviço de e-mail | `settings/smtp_service` | Configurações > Email Services (rótulo em inglês na tela) | caminho (conferido em 03/11/2026); por dentro (conferido em 04/11/2026): título "Serviços de e-mail", abas "Serviço de SMTP", "Configurações de resposta e encaminhamento", "Estatísticas de e-mail", "Avaliação de risco", "Classificação de bounce", "Ferramentas Postmaster"; "Selecionar provedor padrão" com o provedor e o domínio de envio, "Visualizar configuração", "+ Adicionar serviço", "Domínio e IP dedicados" |
| Caixa de entrada pessoal (Gmail, Outlook) | `settings/users/me` | Configurações > Meu perfil > aba "E-mail e conversas" > "E-mail (sincronização bidirecional)" > "Selecione seu provedor de e-mail" (Gmail ou Outlook) > "Conectar" | confirmado no Help Center ("Como conectar uma caixa de entrada pessoal"); caminho (conferido em 04/11/2026) |
| Mídia (imagens do e-mail) | `media-storage` | Menu lateral: Mídia Drive | (conferido em 03/11/2026) |
| Trechos de marketing | `marketing/templates` | Marketing > Trechos | (conferido em 03/11/2026) |

## Passo a passo

### Enviar teste pelo editor
1. Abra o modelo ou a campanha no editor.
2. Use o envio de teste: no editor, menu de três pontos (canto superior direito) > "Email de teste", no grupo "Pré-visualizar & testar" (conferido em 04/11/2026). O editor de modelo mostra "Salvar automaticamente ativado": não digite nada nele só para olhar.
3. Digite só o e-mail do cliente. Envie depois do `CONFIRMO ENVIO`.
4. Peça para o cliente conferir no computador e no celular: imagens, links, botão, assunto, prévia.

### Pausar ou cancelar campanha agendada
1. Marketing > E-mails > Campanhas (`marketing/emails/scheduled`).
2. Ache a campanha (status agendado ou em andamento).
3. Abra o menu **Ações** (três pontos no fim da linha) e procure a ação de pausar ou cancelar. O menu de uma campanha agendada ainda não foi visto: o CRM não deixa agendar com 0 destinatários (o botão **Programar** não faz nada e a campanha fica como **Rascunho**), então não deu para agendar uma de teste sem alcançar ninguém. Num **Rascunho** o menu Ações mostra só: **Pré-visualizar campanha**, **Mover para a pasta**, **Renomear**, **Clonar**, **Arquivar Campanha**, **Excluir** (sem pausar, cancelar ou reagendar) (conferido em 04/11/2026 na conta Demo). Se a ação não aparecer na campanha agendada, diga isso ao cliente sem prometer.
4. Pausar protege: pode fazer com aprovação simples e avisar. Confira depois com `list-email-campaigns` (`status: paused` ou `cancelled`).

### Domínio de envio
Passo a passo em `references/entregabilidade.md`.

## Links que vão para o cliente
Só o caminho da tela no domínio da conta. Nunca `previewUrl`, `editorContentUrl` ou link com domínio técnico do fornecedor.

Conferência de telas aplicada em 03/11/2026 (somente leitura, conta Atlas), também em `entregabilidade.md`. O que segue marcado (a conferir no navegador) não foi visto nessa rodada.
