# Snippets e modelos de SMS

Fonte: Help Center da Atlas ("Como usar snippets de texto", "Como usar templates de SMS").

## O que são

- **Resposta pronta** (na tela pode aparecer como snippet): resposta usada na caixa de conversas para dúvidas repetidas. Acelera sem tirar o contexto.
- **Modelo de SMS**: texto reaproveitado em follow-ups, lembretes e confirmações.

## Pelo MCP

- Listar o que existe: `GET-all-or-email-sms-templates` com `originId` = `locationId` e `type` (`sms`, `email` ou `whatsapp`).
- Criar, editar ou apagar: não há operação liberada nesta conexão. Navegador (`telas.md`).

## Como criar (navegador)

1. Conversas > aba "Trechos" (`conversations/templates`, conferido em 03/11/2026).
2. Novo snippet: nome interno pelo uso prático (ex.: "Preço consulta"), texto base.
3. Texto adaptável: claro, com espaço para personalizar antes de enviar.
4. Variáveis (ex.: `{{contact.first_name}}`) só se o campo estiver preenchido na maioria dos contatos.
5. Salve e organize por assunto, etapa ou canal. Evite duplicados.
6. Confira: o snippet aparece para seleção e a variável vem preenchida no teste.

Criar resposta pronta é escrita simples: mostre nome e texto e peça um SIM antes de salvar.

## Boas práticas

- Uma resposta pronta por dúvida recorrente, nome curto.
- Revise com base nas conversas reais e mensalmente.
- Evite promessas e informações que mudam muito (preço, prazo): use valor personalizado da conta quando der (skill `atlas-campos-e-dados`).
- Resposta pronta não é template oficial do WhatsApp: fora da janela de 24 horas, só template aprovado pela Meta.

## Erros comuns

- Variável aparece quebrada: confira o campo usado.
- Texto longo demais: corte.
- Tom genérico: personalize nome, contexto e próximo passo antes de enviar.
