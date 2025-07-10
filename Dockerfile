# Etapa 1: build da aplicação
FROM node:20-slim AS builder

# Diretório de trabalho
WORKDIR /app

# Copia os arquivos de dependência primeiro
COPY package.json package-lock.json ./

# ✅ Copia o schema do Prisma ANTES da instalação
COPY prisma ./prisma

# Instala as dependências (executa "postinstall" => prisma generate)
RUN npm install

# Copia o restante da aplicação
COPY . .

# Gera o build do Next.js
RUN npm run build

# Etapa 2: imagem final
FROM node:20-alpine AS runner

WORKDIR /app

# Copia build e arquivos necessários para produção
COPY --from=builder /app/.next .next
COPY --from=builder /app/public public
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules

# ⚠️ Se você for usar Prisma em runtime (ex: via API routes ou Edge Functions)
COPY --from=builder /app/prisma ./prisma

EXPOSE 3000
CMD ["npm", "start"]
