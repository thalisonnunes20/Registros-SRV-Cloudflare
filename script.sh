#!/bin/bash

###############################################
#   Cloudflare Minecraft SRV Creator (Final)  #
#   Zero ^H | Backspace funcional | Bonito    #
###############################################

# Cores
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[36m"
RED="\e[31m"
RESET="\e[0m"

# --- SOLUÇÃO FINAL PARA ^H E BACKSPACE ---
stty sane
stty -echoctl

ERASE_KEY=$(stty -a | grep -o "erase = [^;]*" | awk '{print $3}')

if [[ "$ERASE_KEY" != "^?" && "$ERASE_KEY" != "^H" ]]; then
    stty erase '^?'
    ERASE_KEY=$(stty -a | grep -o "erase = [^;]*" | awk '{print $3}')
fi

if [[ "$ERASE_KEY" != "^?" && "$ERASE_KEY" != "^H" ]]; then
    stty erase '^H'
fi
# -------------------------------------------

clear
echo -e "${BLUE}=========================================${RESET}"
echo -e "${GREEN}     Cloudflare Minecraft SRV Creator     ${RESET}"
echo -e "${BLUE}=========================================${RESET}"
echo

# Entrada de dados
read -e -p "🔑 API Token: " API_TOKEN
read -e -p "🆔 Zone ID: " ZONE_ID
read -e -p "🌐 Domínio raiz (ex: exemplo.com.br): " ROOT
read -e -p "📛 Subdomínios (ex: node01 node02 lobby): " SUBS
read -e -p "🔢 Porta inicial: " PORT_START
read -e -p "🔢 Porta final: " PORT_END

# Mostrando resumo
clear
echo -e "${BLUE}========== CONFIRMAR INFORMAÇÕES ==========${RESET}"
echo -e "🌐 ${YELLOW}Domínio raiz:${RESET} $ROOT"
echo -e "📛 ${YELLOW}Subdomínios:${RESET} $SUBS"
echo -e "🔢 ${YELLOW}Range de portas:${RESET} $PORT_START → $PORT_END"
echo -e "🆔 ${YELLOW}Zone ID:${RESET} $ZONE_ID"
echo -e "🔑 ${YELLOW}API Token:${RESET} ******(oculto)"
echo -e "${BLUE}============================================${RESET}"

read -p "❓ Deseja continuar? (s/n): " CONFIRM
if [[ "$CONFIRM" != "s" ]]; then
    echo "❌ Cancelado pelo usuário."
    exit
fi

clear
echo -e "${GREEN}🚀 Iniciando criação dos registros SRV...${RESET}"
echo

PORT=$PORT_START

# Loop de criação
for SUB in $SUBS; do
    FULLNAME="_minecraft._tcp.$SUB"

    echo -e "🔧 Criando SRV para ${YELLOW}$SUB${RESET} → ${GREEN}$ROOT:$PORT${RESET} ..."
    
    JSON=$(cat <<EOF
{
  "type": "SRV",
  "name": "$FULLNAME",
  "ttl": 1,
  "comment": "Registro SRV automático para Minecraft - $SUB",
  "data": {
    "service": "_minecraft",
    "proto": "_tcp",
    "name": "$SUB",
    "priority": 0,
    "weight": 0,
    "port": $PORT,
    "target": "$ROOT"
  }
}
EOF
)

    RESPONSE=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
        -H "Authorization: Bearer $API_TOKEN" \
        -H "Content-Type: application/json" \
        --data "$JSON")

    if echo "$RESPONSE" | grep -q '"success":true'; then
        echo -e "${GREEN}✔ Criado com sucesso!${RESET}"
    else
        echo -e "${RED}❌ Erro ao criar registro!${RESET}"
    fi

    PORT=$((PORT + 1))
    [[ $PORT -gt $PORT_END ]] && break
done

echo -e "${GREEN}🎉 FINALIZADO com sucesso!${RESET}"
