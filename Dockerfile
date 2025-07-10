# Etapa 1: build da aplicação
FROM node:20-slim AS builder

WORKDIR /app

# Copia arquivos de dependência
COPY package.json package-lock.json ./
COPY prisma ./prisma

# Instala dependências com postinstall (prisma generate)
RUN apt-get update && apt-get install -y openssl && apt-get clean \
  && npm install

# Copia restante do código
COPY . .

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
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/prisma ./prisma

EXPOSE 3000
CMD ["npm", "start"]
