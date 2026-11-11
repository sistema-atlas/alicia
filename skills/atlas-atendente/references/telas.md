# Telas do atendente

O atendente não opera telas. Ele só precisa saber montar o endereço da conta para entregar links.

## Endereço base

- `https://<domínio da conta>/v2/location/<locationId>/`
- O domínio aparece em `get-location` (`data.location.domain`) e nos `uiUrl` que algumas operações devolvem. Na conta de teste da Atlas o painel usa `crm.atlasoficial.com` (conferido em 03/11/2026). O domínio `links.atlasoficial.com` aparece só nos links públicos (ex.: link de agendamento), não no painel.
- Se o cliente acessa por outro domínio, use o que aparece na aba dele.

## Links que o atendente entrega com frequência

| Tela | Caminho depois do endereço base | Fonte |
| --- | --- | --- |
| Funis e etapas (configuração) | `crm-settings` (Configurações > Oportunidades & Pipelines) (conferido em 03/11/2026) | tela |
| Campos personalizados | `settings/fields` (Configurações > Campos personalizados) (conferido em 03/11/2026) | tela |
| Motivos de perda | sem tela própria encontrada na conferência de 03/11/2026; ler pelo conector (`get-lost-reason`), cadastrar pelo suporte da Atlas | telas-conferidas-2.md |
| Uma automação | `automation/workflow/<id>` | `uiUrl` de `get-workflow` |
| Formulários | `form-builder/main` (Sites > Formulários) (conferido em 03/11/2026) | tela |
| Pesquisas | `survey-builder/main` (Sites > Pesquisas) (conferido em 03/11/2026) | tela |
| Painel de controle | `dashboard` (conferido em 03/11/2026) | tela |
| Marca da empresa (logo, cores, fontes) | `marketing/brand-boards` (Configurações > Brand Boards) (conferido em 03/11/2026) | tela |

Para as demais telas, use o `telas.md` da skill da área.

## Central de ajuda

- `https://help.atlasoficial.com/crm/suporte/` (índice em `atlas-suporte`).
