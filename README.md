# 🚀 Cloudflare Minecraft SRV Creator

Um script para criar automaticamente registros **SRV de Minecraft** usando a API da Cloudflare.  
Ideal para quem precisa gerar vários SRVs rapidamente, com portas sequenciais, comentários automáticos e correção do bug do backspace (`^H`).

---

## 🏆 Funcionalidades

- 🔧 Criação automática de múltiplos registros SRV  
- 🌐 Suporte a qualquer quantidade de subdomínios  
- 🔢 Geração automática de portas sequenciais  
- 📝 Comentários automáticos no Cloudflare  
- 🔐 Entrada interativa com confirmação  
- 🎨 Interface limpa com cores  
- ⌨️ Correção definitiva do bug `^H` no terminal  

---

## 📦 Pré-requisitos

- Linux / WSL / Termux  
- `curl` instalado  
- API Token da Cloudflare com permissão **DNS Edit**  
- Zone ID da zona DNS no Cloudflare  

---

## 📥 Instalação

Clone o repositório:

```bash
git clone https://github.com/thalisonnunes20/Criar-Varios-SRV-Cloudflare
cd Criar-Varios-SRV-Cloudflare
```
```bash
chmod +x script.sh
./script.sh
```
