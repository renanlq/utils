#!/bin/bash
# Uso
# ./git-commit-copy.sh <hash1> <hash2> <path>

# Diretório de destino
PATH=$3

echo "Copiando pastas e arquivos de: $PATH"

for i in $(git diff --name-only $1 $2)
    do
        # Criando diretório de destino
        mkdir -p "$PATH/$(dirname $i)"
         # Copiando arquivos
        cp "$i" "$PATH/$i"
    done

echo "Arquivos copiados para o diretório";
