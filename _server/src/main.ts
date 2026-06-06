import { NestFactory } from '@nestjs/core';
import { ExpressAdapter } from '@nestjs/platform-express';
import { ValidationPipe } from '@nestjs/common';
import helmet from 'helmet';
// eslint-disable-next-line @typescript-eslint/no-require-imports
const compression = require('compression');
// eslint-disable-next-line @typescript-eslint/no-require-imports
const express = require('express');
import { AppModule } from './app.module';

const expressApp = express();
let bootstrapPromise: Promise<typeof expressApp> | null = null;

async function bootstrap() {
  if (!bootstrapPromise) bootstrapPromise = initApp();
  return bootstrapPromise;
}

async function initApp() {
  const app = await NestFactory.create(
    AppModule,
    new ExpressAdapter(expressApp),
    { logger: ['log', 'error', 'warn'] },
  );

  app.use(compression());
  app.use(helmet());

  const allowedOrigins = (process.env.CORS_ORIGIN ?? '')
    .split(',')
    .map((o) => o.trim())
    .filter(Boolean);

  app.enableCors({
    origin: allowedOrigins.length > 0 ? allowedOrigins : false,
    methods: ['GET', 'POST', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Request-ID'],
    credentials: true,
  });

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      transformOptions: { enableImplicitConversion: true },
    }),
  );

  // Reject requests not coming through the Vercel proxy (only enforced when PROXY_SECRET is set)
  app.use((req, res, next) => {
    const secret = process.env.PROXY_SECRET;
    if (secret && req.headers['x-proxy-secret'] !== secret) {
      return res.status(403).end();
    }
    next();
  });

  // Bind to localhost only — not reachable from outside even without firewall
  await app.init();
  return expressApp;
}

// Vercel serverless handler
export default async (req: any, res: any) => {
  await bootstrap();
  expressApp(req, res);
};

// Local dev — only runs when executed directly (npm run start:dev / start:prod)
if (require.main === module) {
  bootstrap().then((server) => {
    server.listen(process.env.PORT ?? 3000, () => {
      console.log(`Server running on port ${process.env.PORT ?? 3000}`);
    });
  });
}
