import http from "http";
import dotenv from "dotenv";
import express from "express";
import helmet from "helmet";
import morgan from "morgan";

import { PrismaService } from "./services/prisma_service.js";
import { getAuthRouter } from "./routes/auth_routes.js";
import { errorHandler } from "./middlewares/error_middlewares.js";
import logger from "./utils/logger.js";
import { getExpensesRouter } from "./routes/expenses_routes.js";

dotenv.config({ path: ".env.development" });

await PrismaService.connect();

const app = express();

app.use(helmet());

app.use(
  morgan("combined", {
    stream: {
      write: (message) => logger.info(message.trim()),
    },
  })
);

app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader(
    "Access-Control-Allow-Methods",
    "GET, POST, PUT, PATCH, DELETE"
  );
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
  next();
});

app.use(express.json({ limit: "100kb" }));

app.use("/api/v1/auth", getAuthRouter());
app.use("/api/v1/expenses", getExpensesRouter());

app.use(errorHandler);

process.on("unhandledRejection", (reason, promise) => {
  console.error(reason);
});
process.on("uncaughtException", (error, origin) => {
  console.error(error);
  console.error(origin);
});

const server = http.createServer(
  {
    maxHeaderSize: 8192,
  },
  app
);

server.listen(3000, "0.0.0.0", () => {
  logger.info("Server running at http://localhost:3000/");
});
