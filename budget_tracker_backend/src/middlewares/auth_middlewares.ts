import { RequestHandler } from "express";

import { JwtService } from "../services/jwt_service.js";

export const requireAuth = (): RequestHandler => {
  return async (req, res, next) => {
    const token = req.headers["authorization"] as string;
    req.user = await JwtService.verifyAuthToken(token);
    next();
  };
};
