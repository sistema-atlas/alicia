# Checklist de conta nova

Para o cliente que acabou de entrar e pergunta "por onde começo?". Mostre como plano numerado (formato de `aprovacao.md`), um item por vez, e chame a skill de cada etapa. Implantação completa feita pela Atlas ("monta tudo para mim") vai para o suporte humano.

Antes: `get-location` para ver o que já está preenchido. Marque como feito o que já existe.

| # | Etapa | Como conferir pelo MCP | Quem faz | Skill |
| --- | --- | --- | --- | --- |
| 1 | Dados da empresa: nome, endereço, site, e-mail, telefone, fuso e moeda | `get-location` (`business`, `timezone`, `currency`) | Tela Configurações > Perfil da empresa (`settings/company`) | `atlas-conta-e-equipe` |
| 2 | Marca: logo, cores, fontes e tom de voz | `get-design-kit`, `list-brand-voices` | MCP | `atlas-conta-e-equipe` |
| 3 | Equipe: usuários e permissões por função | tela Configurações > Usuários (`settings/users`) | Tela (senha do usuário) | `atlas-conta-e-equipe` |
| 4 | Domínio do site e das páginas | tela Domínios (`settings/domain`) | Tela, DNS com o cliente | `atlas-sites-e-blog` |
| 5 | Domínio de envio de e-mail | tela `settings/smtp_service` | Tela, DNS com o cliente | `atlas-email-marketing` |
| 6 | WhatsApp conectado | tela `settings/whatsapp` | Tela, o cliente lê o QR ou faz o login da Meta | `atlas-conversas-e-disparos` |
| 7 | Outros canais: Instagram, Facebook, e-mail pessoal | `get-account` (redes conectadas) | Tela | `atlas-conversas-e-disparos`, `atlas-social-e-reputacao` |
| 8 | Funil de vendas com as etapas | `get-pipelines` | MCP e tela | `atlas-funil-e-vendas` |
| 9 | Campos personalizados do negócio | `get-custom-fields` | MCP | `atlas-campos-e-dados` |
| 10 | Agenda (horários, duração, lembretes) | `get-calendars` | Tela e MCP | `atlas-agenda` |
| 11 | Formulário de captação ligado ao contato | `get-forms` | Tela | `atlas-formularios` |
| 12 | Importar contatos | `search-contacts-advanced` com `pageLimit: 1` (ler `total`) | Tela | `atlas-contatos` |
| 13 | Automações básicas (boas-vindas, lembrete de agenda) | (a conferir) | Tela | `atlas-automacoes` |
| 14 | Rastreamento de origem (UTM, pixel) | origem dos leads | Tela | `atlas-rastreamento` |
| 15 | Integração de pagamento, se cobra pelo CRM | tela `payments/integrations`; `list-transactions` com `altType` e `limit: 1` | Tela, login do cliente | `atlas-cobrancas-e-contratos` |
| 16 | Painel do mês | (sem MCP) | Tela | `atlas-relatorios-e-dashboards` |

Ordem recomendada: 1, 2, 3, 6, 8, 9, 10, 11, 12, 14, 13, 4, 5, 7, 15, 16. Canais e funil antes de automação, porque a automação depende deles.

Cada etapa que envia mensagem, publica, cobra ou dá acesso pede confirmação própria na hora, mesmo com o plano aprovado.
