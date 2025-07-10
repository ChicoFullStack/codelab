# Etapa 1: build da aplicação
FROM node:20-slim AS builder

WORKDIR /app

# Instala libssl e dependências necessárias para Prisma
RUN apt-get update && apt-get install -y openssl && apt-get clean

# Copia tudo de uma vez
COPY . .

# Instala dependências com postinstall (prisma generate + lightningcss detectado)
RUN npm install --platform=linux

# Gera o build do Next.js
RUN npm run build

# Etapa 2: imagem final para produção
FROM node:20-slim AS runner

WORKDIR /app

# Instala libssl no runtime para o Prisma funcionar
RUN apt-get update && apt-get install -y openssl && apt-get clean

# Copia arquivos necessários do builder
COPY --from=builder /app/.next .next
COPY --from=builder /app/public public
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modul
