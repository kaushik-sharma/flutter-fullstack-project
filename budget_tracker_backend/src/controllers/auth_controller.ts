import { RequestHandler } from "express";

import { Prisma } from "../generated/client/index.js";
import { asyncHandler } from "../helpers/async_handler.js";
import { validateData } from "../helpers/validation_helper.js";
import { successResponseHandler } from "../helpers/success_handler.js";
import { CustomError } from "../middlewares/error_middlewares.js";
import { JwtService } from "../services/jwt_service.js";
import { UserDatasource } from "../datasources/user_datasource.js";
import { PrismaService } from "../services/prisma_service.js";
import { authSchema, AuthType } from "../validation/auth_schema.js";
import { BcryptService } from "../services/bcrypt_service.js";

export class AuthController {
  static readonly validateAuthRequest: RequestHandler = (req, res, next) => {
    req.parsedData = validateData(authSchema, req.body);
    next();
  };

  static readonly signUp: RequestHandler = asyncHandler(
    async (req, res, next) => {
      const parsedData = req.parsedData! as AuthType;

      const emailExists = await UserDatasource.userByEmailExists(
        parsedData.email
      );
      if (emailExists) {
        throw new CustomError(409, "Account with this email already exists.");
      }

      const userData: Prisma.UserCreateInput = {
        email: parsedData.email,
        password: await BcryptService.hash(parsedData.password),
      };

      const authToken = await PrismaService.client.$transaction<string>(
        async (tx) => {
          const userId = await UserDatasource.createUser(userData, tx);
          return await JwtService.createAuthToken(userId, tx);
        }
      );

      successResponseHandler({
        res: res,
        status: 200,
        data: { authToken: authToken },
      });
    }
  );

  static readonly signIn: RequestHandler = asyncHandler(
    async (req, res, next) => {
      const parsedData = req.parsedData! as AuthType;

      const emailExists = await UserDatasource.userByEmailExists(
        parsedData.email
      );
      if (!emailExists) {
        throw new CustomError(409, "Account with this email does not exist.");
      }

      const hashedPasswordFromDb = await UserDatasource.getUserPassword(
        parsedData.email
      );
      const passwordMatches = await BcryptService.compare(
        parsedData.password,
        hashedPasswordFromDb
      );
      
      if (!passwordMatches) {
        throw new CustomError(401, "Incorrect password.");
      }

      const userId = await UserDatasource.getUserId(parsedData.email);
      const authToken = await PrismaService.client.$transaction<string>(
        async (tx) => {
          return await JwtService.createAuthToken(userId, tx);
        }
      );

      successResponseHandler({
        res: res,
        status: 200,
        data: { authToken: authToken },
      });
    }
  );
}
