# Domínio de envio e entregabilidade

Fontes: base completa de artigos da central de ajuda da Atlas, com os temas: domínio dedicado de envio, autenticação SPF, DKIM e DMARC, erros de autenticação, aquecimento de envio, saúde de envio, List-Unsubscribe, por que e-mails vão para spam, por que e-mail gratuito não serve como remetente, reputação de domínio e de IP, bloqueio por bounce. A tela fica em Configurações > Email Services (`settings/smtp_service`, conferido em 03/11/2026); a versão traduzida dos artigos é genérica, então os passos dentro dela continuam (a conferir no navegador). Nenhum número de limite aqui: se o cliente perguntar volume ou taxa, diga que confere na tela Email Services ou com o suporte.

## O básico em uma frase para o cliente

Para o e-mail chegar na caixa de entrada, ele precisa sair de um domínio seu, autenticado, para pessoas que querem receber, com um jeito fácil de sair da lista.

## Domínio dedicado de envio

- O que é: um subdomínio do site do cliente usado só para enviar e-mail (por exemplo `email.suaempresa.com.br`), configurado nos serviços de e-mail da conta.
- Por que: separa a reputação de envio e permite autenticar o remetente.
- Remetente de campanha sempre com o domínio próprio. **E-mail gratuito (Gmail, Hotmail) não serve como remetente** de campanha: os provedores rejeitam ou mandam para spam.

### Passo a passo (a conferir no navegador)
1. Configurações > Email Services (`settings/smtp_service`, conferido em 03/11/2026).
2. Adicionar domínio dedicado e digitar o subdomínio.
3. A tela mostra os registros de DNS (SPF, DKIM, às vezes DMARC e rastreamento).
4. O cliente (ou quem cuida do domínio dele) cria esses registros no provedor do domínio. O assistente não mexe no DNS do cliente.
5. Voltar à tela e verificar. A propagação do DNS pode demorar.
6. Definir como domínio padrão de envio, se houver a opção.

## Autenticação

- **SPF**: diz quais servidores podem enviar pelo domínio.
- **DKIM**: assinatura que prova que o e-mail não foi alterado.
- **DMARC**: política do domínio para e-mails que falham no SPF ou no DKIM.
- Erro de autenticação: confira se o registro foi copiado inteiro, no subdomínio certo, sem duplicar SPF. Se continuar, suporte da Atlas.

## Boas práticas de envio

1. **Lista com permissão.** Só quem pediu ou é cliente. Lista comprada derruba a reputação.
2. **Aquecimento.** Domínio novo começa enviando para os contatos mais engajados e aumenta aos poucos. O agendamento aceita segmentos de engajados (`engaged_last_30_days` e outros) e envio em lotes (`batch`).
3. **Descadastro visível** em todo e-mail. O cabeçalho List-Unsubscribe ajuda os provedores a oferecer a saída e reduz denúncias de spam.
4. **Limpe a lista.** E-mails que voltam (bounce) e quem nunca abre pesam contra. Bounce em excesso pode suspender o envio.
5. **Assunto honesto**, sem caixa alta e sem excesso de pontuação.
6. **Equilíbrio de imagem e texto.** E-mail feito só de imagem cai mais no spam.
7. **Links do próprio domínio**, sem encurtador.
8. **Teste antes** com o e-mail do próprio cliente.

## "Meus e-mails estão indo para spam"

Pergunte uma coisa por vez, nesta ordem:
1. De qual endereço sai? (gratuito: troque por domínio próprio)
2. O domínio está autenticado na tela Email Services (Configurações)? (não: configure SPF, DKIM, DMARC)
3. Para quem foi? (lista sem permissão ou antiga: segmente engajados)
4. O e-mail tem descadastro e texto além da imagem?
Depois, olhe `get-campaign-stats` da última campanha para ver entregues, aberturas, bounces e denúncias, se a resposta trouxer esses dados.
