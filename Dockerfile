# Etapa 1: build da aplicação
FROM node:20-bullseye AS builder

WORKDIR /app

# Copia o projeto completo
COPY . .

# Instala dependências (já inclui o postinstall com lightningcss)
RUN npm install

# Gera o build de produção
RUN npm run build

# Etapa 2: imagem final
FROM node:20-bullseye AS runner

WORKDIR /app

COPY --from=builder /app/.next .next
COPY --from=builder /app/public public
COPY --from=builder /app/package.json package.json
COPY --from=builder /app/node_modules node_modules
COPY --from=builder /app/prisma prisma

EXPOSE 3000
CMD ["npm", "start"]
