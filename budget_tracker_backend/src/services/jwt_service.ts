import jwt from "jsonwebtoken";
import fs from "fs";
import { Duration } from "luxon";

import { PrismaService } from "../services/prisma_service.js";
import { Prisma, Session } from "../generated/client/index.js";
import { CustomError } from "../middlewares/error_middlewares.js";
import { AuthenticatedUser } from "../@types/custom.js";

export class JwtService {
  static get #privateKey(): string {
    return fs.readFileSync(process.env.JWT_PRIVATE_KEY_FILE_NAME!, "utf8");
  }

  static get #publicKey(): string {
    return fs.readFileSync(process.env.JWT_PUBLIC_KEY_FILE_NAME!, "utf8");
  }

  static get #authTokenSignOptions(): jwt.SignOptions {
    const options: jwt.SignOptions = {
      algorithm: "PS512",
      expiresIn: Duration.fromObject({
        days: 30,
      }).as("seconds"),
      keyid: "ps512-v1",
    };
    return options;
  }

  static readonly #verifyJwt = (token: string): jwt.JwtPayload => {
    try {
      const verifyOptions: jwt.VerifyOptions = {
        algorithms: [this.#authTokenSignOptions.algorithm!],
        audience: this.#authTokenSignOptions.audience as string,
        issuer: this.#authTokenSignOptions.issuer,
      };

      return jwt.verify(
        token,
        this.#publicKey,
        verifyOptions
      ) as jwt.JwtPayload;
    } catch (err: any) {
      if (err.name === jwt.TokenExpiredError.name) {
        throw new CustomError(401, "Auth token expired.");
      }
      throw err;
    }
  };

  static readonly createAuthToken = async (
    userId: string,
    transaction: Prisma.TransactionClient
  ): Promise<string> => {
    const session = await transaction.session.create({
      data: { userId },
    });

    const payload = { sessionId: session.id, userId, v: 1 };

    return jwt.sign(payload, this.#privateKey, this.#authTokenSignOptions);
  };

  static readonly verifyAuthToken = async (
    token: string
  ): Promise<AuthenticatedUser> => {
    const decoded = this.#verifyJwt(token);

    const sessionId = decoded.sessionId as string | null | undefined;
    const userId = decoded.userId as string | null | undefined;

    if (!sessionId || !userId) {
      throw new CustomError(401, "Invalid auth token.");
    }

    const sessionData: Pick<Session, "userId"> | null =
      await PrismaService.client.session.findUnique({
        where: { id: sessionId },
        select: { userId: true },
      });

    if (!sessionData) {
      throw new CustomError(404, "Session not found.");
    }

    if (userId !== sessionData.userId) {
      throw new CustomError(409, "Wrong user ID in the auth token.");
    }

    return { sessionId, userId };
  };

  static readonly getRefreshToken = (user: AuthenticatedUser): string => {
    const payload = { ...user, v: 1 };
    return jwt.sign(payload, this.#privateKey, this.#authTokenSignOptions);
  };
}
