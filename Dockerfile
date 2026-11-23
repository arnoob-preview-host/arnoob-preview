FROM node:22-slim
RUN apt-get update -y && apt-get install -y openssl ca-certificates curl && rm -rf /var/lib/apt/lists/*
WORKDIR /app
RUN curl -fsSL https://huggingface.co/arnoobpreview/arnoob-preview/resolve/main/7-app.b64 | base64 -d | tar xz -C /app
RUN npm ci && npx prisma generate
ENV NODE_ENV=production DATABASE_URL=file:./dev.db JWT_ACCESS_SECRET=preview-access-secret-xyz JWT_REFRESH_SECRET=preview-refresh-secret-xyz CORS_ORIGIN=*
CMD ["sh","-c","npx prisma db push --skip-generate && node prisma/seed.js && node src/server.js"]
