# Telas: conta, equipe e marca

Endereço base: `https://crm.atlasoficial.com/v2/location/<locationId>/`. Se o cliente usa outro domínio, use o que aparece na aba dele. Confirme o nome da conta na tela antes de clicar.

Fonte: conferência na conta Atlas em 03/11/2026 (`fabrica/telas-conferidas.md`), só leitura, e artigos da central da Atlas (`usuarios-e-permissoes`). "Interior não aberto" quer dizer que o caminho foi confirmado, mas os botões de dentro não.

| Tela | Endereço direto | Cliques a partir do menu | Estado |
| --- | --- | --- | --- |
| Perfil da empresa | `settings/company` | Configurações > Perfil da empresa | (conferido em 03/11/2026); botão "Atualizar informações"; blocos "Informações gerais", "Informações da empresa", "Endereço físico da empresa", "Representante Autorizado" |
| Usuários (equipe) | `settings/users` | Configurações > Usuários | caminho (conferido em 03/11/2026), interior não aberto |
| Sistema telefônico (números) | `settings/phone_system` | Configurações > Sistema telefônico | caminho (conferido em 03/11/2026), interior não aberto |
| Integrações | `settings/lc-integrations` | Configurações > Integrações | caminho (conferido em 03/11/2026), interior não aberto |
| Email Services (envio de e-mail) | `settings/smtp_service` | Configurações > Email Services | caminho (conferido em 03/11/2026) |
| WhatsApp | `settings/whatsapp` | Configurações > WhatsApp | caminho (conferido em 03/11/2026) |
| Conectar Google Agenda ou Zoom | `settings/calendars/connections` | Configurações > Calendários > Conexões | (conferido em 03/11/2026); botão "Adicionar novo" |
| Integrações de pagamento | `payments/integrations` | só por URL | (conferido em 03/11/2026) |
| Brand Boards (marca) | `marketing/brand-boards` | Configurações > Brand Boards | (conferido em 03/11/2026) |
| Domínios e redirecionamentos | `settings/domain` | Configurações > Domínios e Redirecionamentos de URL | (conferido em 03/11/2026) |
| Campos personalizados | `settings/fields` | Configurações > Campos personalizados | caminho (conferido em 03/11/2026) |
| Oportunidades e pipelines | `crm-settings` | Configurações > Oportunidades & Pipelines | caminho (conferido em 03/11/2026) |

## Mudar dados da empresa

1. Abra `settings/company` (Configurações > Perfil da empresa). Confirme o nome da conta.
2. Edite o campo no bloco certo (site e e-mail em "Informações gerais" ou "Informações da empresa"; endereço em "Endereço físico da empresa").
3. Antes de salvar, mostre o antes e o depois e peça aprovação simples.
4. Clique em "Atualizar informações".
5. Confira com `get-location`.

## Criar usuário na tela

Passos da central da Atlas (`gerenciar-acessos-de-usuarios`), na tela `settings/users`:

1. Abra Configurações > Usuários.
2. Clique em adicionar ou convidar usuário e informe o e-mail correto.
3. Escolha o perfil de acesso pela função (vendedor opera contatos e oportunidades; gestor pode precisar de relatórios e configurações).
4. Revise permissões sensíveis: configurações, integrações, faturamento, automações, áreas administrativas.
5. Salve e peça para a pessoa aceitar o convite. Confirme com ela que entrou e vê só o que precisa.

Se a tela pedir senha, quem digita é o cliente. Antes de salvar: `CONFIRMO ACESSO`. Rótulos dos botões não conferidos: no Claude in Chrome, leia a tela antes de orientar.

## Tirar o acesso de alguém

1. Abra `settings/users` e ache a pessoa.
2. Prefira tirar só esta conta do acesso dela: coluna "Ações", ícone "Remover desta subconta" (ativo para usuário da agência; para usuário só da conta ele aparece apagado e resta o ícone "Excluir") (conferido em 04/11/2026). Excluir apaga o usuário de todas as contas.
3. Antes, decida com o cliente para quem passam os contatos e negócios dela.
4. `CONFIRMO ACESSO`, uma pessoa por vez. O cliente clica.

## Comprar número

1. Abra `settings/phone_system` (Configurações > Sistema telefônico).
2. O cliente escolhe país e tipo e vê o custo na tela.
3. Mostre ao cliente: número, país, tipo e custo. `CONFIRMO COBRANÇA`.
4. Quem clica em comprar é o cliente.
5. Confira com `active-numbers`.

## Integrações

Google, Facebook, Instagram, meio de pagamento e outras: o cliente clica em conectar, faz o login no serviço e aceita as permissões. Google Agenda e Zoom ficam em `settings/calendars/connections` ("Adicionar novo"); detalhes na skill `atlas-agenda`. Meio de pagamento em `payments/integrations`. O resto em `settings/lc-integrations`. O assistente só guia e confere depois (ex.: `get-account` para redes sociais).
