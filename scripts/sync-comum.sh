#!/usr/bin/env bash
# Copia _comum/*.md para skills/*/references/_comum/. Rode sempre que mudar _comum.
set -e
cd "$(dirname "$0")/.."
for s in skills/*/; do
  mkdir -p "$s/references/_comum"
  cp _comum/*.md "$s/references/_comum/"
done
echo "sincronizado em $(ls -d skills/*/ | wc -l) skills"
