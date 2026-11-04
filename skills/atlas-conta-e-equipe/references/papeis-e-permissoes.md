# Papéis e permissões

Fonte: artigos da central da Atlas `usuarios-e-permissoes/gerenciar-acessos-de-usuarios` e `perfis-e-permissoes`, e campos de `get-user` e `update-user`.

## Papéis

| Papel | No conector | Para quem |
| --- | --- | --- |
| Administrador | `role: admin` | Dono, gestor que configura a conta |
| Usuário | `role: user` | Vendedor, atendente, operação |

Boas práticas da central da Atlas: perfis por função, não por pessoa; comece com menos permissão e amplie quando precisar; revise quando alguém muda de cargo ou sai; não compartilhe login.

## Permissões que mais importam

| O cliente diz | Campo em `permissions` |
| --- | --- |
| "ver só os leads dele" | `assignedDataOnly: true` |
| "não mexer em configurações" | `settingsEnabled: false` |
| "não ver pagamentos" | `paymentsEnabled: false`, `invoiceEnabled: false`, `refundsEnabled: false`, `recordPaymentEnabled: false` |
| "não criar automação" | `workflowsEnabled: false` ou `workflowsReadOnly: true` |
| "não fazer disparo em massa" | `bulkRequestsEnabled: false`, `campaignsEnabled: false` |
| "não ver o painel" | `dashboardStatsEnabled: false` |
| "não exportar" | `exportPaymentsEnabled: false` (pagamentos); exportação de contatos pela tela (a conferir no navegador) |
| "não ver o funil" | `opportunitiesEnabled: false` |
| "acessar cursos e comunidade" | `membershipEnabled`, `communitiesEnabled` |

Os nomes e a lista completa estão no describe de `update-user`. Na dúvida, mude pela tela Equipe, onde cada chave tem rótulo em português.

## Perfis sugeridos

| Perfil | Papel | Ajustes |
| --- | --- | --- |
| Vendedor | user | contatos, conversas, oportunidades, agenda; `assignedDataOnly: true`; sem configurações, pagamentos, automações e disparos |
| Atendente | user | conversas e contatos; sem oportunidades se não vende; sem configurações |
| Gestor comercial | user ou admin | tudo de vendas, painel e relatórios; sem pagamentos se não cuida do financeiro |
| Financeiro | user | pagamentos e faturas; sem automações |
| Dono | admin | tudo |

## Erros comuns (central da Atlas)

- Convite não chegou: conferir e-mail digitado e spam.
- Usuário vê demais: reduzir perfil ou tirar administrador.
- Usuário não vê o funil: conferir permissão de oportunidades e de funil.
