#!/usr/bin/env bash
# Busca de marca: procura termos proibidos (lista em _comum/termos-de-marca.md)
# em tudo que vai ser publicado. Exceções aprovadas ficam no mesmo arquivo.
#
# Uso: scripts/checar-marca.sh [pasta]
# MODO=aviso    mostra o que achou e sai com 0 (padrão até 17/11/2026)
# MODO=bloqueio mostra o que achou e sai com 1 (padrão a partir de 18/11/2026)
set -u
cd "$(dirname "$0")/.."
LISTA="${LISTA:-_comum/termos-de-marca.md}"
ALVO="${1:-.}"
if [ "$(date +%Y%m%d)" -ge 20261118 ]; then MODO="${MODO:-bloqueio}"; else MODO="${MODO:-aviso}"; fi

if [ ! -e "$ALVO" ]; then
  echo "Busca de marca: $ALVO não existe. Nada foi conferido." >&2
  exit 2
fi

termos=$(sed -n '/<!-- termos:inicio -->/,/<!-- termos:fim -->/p' "$LISTA" | grep -v '<!--' | sed '/^\s*$/d')
excecoes=$(sed -n '/<!-- excecoes:inicio -->/,/<!-- excecoes:fim -->/p' "$LISTA" | grep -v '<!--' | sed '/^\s*$/d')

# Monta o padrão: espaço ou hífen opcionais entre as palavras de cada termo.
padrao=$(printf '%s\n' "$termos" | sed 's/[ -]/[ _-]?/g' | paste -sd'|' -)
padrao="(^|[^a-z0-9])($padrao)"

achados=0
while IFS= read -r linha; do
  arq="${linha%%:*}"; arq="${arq#./}"
  resto="${linha#*:}"; num="${resto%%:*}"; texto="${resto#*:}"
  ok=0
  while IFS='|' read -r ex_arq ex_termo _; do
    ex_arq=$(echo "$ex_arq" | xargs); ex_termo=$(echo "$ex_termo" | xargs)
    [ -z "$ex_arq" ] && continue
    case "$arq" in
      $ex_arq)
        if [ "$ex_termo" = "*" ] || echo "$texto" | grep -qi -- "$ex_termo"; then ok=1; break; fi ;;
    esac
  done <<< "$excecoes"
  if [ $ok -eq 0 ]; then
    achados=$((achados+1))
    printf '%s:%s: %s\n' "$arq" "$num" "$(echo "$texto" | cut -c1-160)"
  fi
done < <(grep -rniHE --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=results \
           --include='*.md' --include='*.json' --include='*.txt' --include='*.html' --include='*.css' --include='*.js' --include='*.sh' \
           "$padrao" "$ALVO" 2>/dev/null)

if [ $achados -eq 0 ]; then
  echo "Busca de marca: limpo."
  exit 0
fi
echo
echo "Busca de marca: $achados linha(s) com termo proibido fora das exceções (modo $MODO)."
echo "Troque o termo ou pergunte ao Lucca. Nunca adicione exceção sozinho."
[ "$MODO" = "bloqueio" ] && exit 1
exit 0
