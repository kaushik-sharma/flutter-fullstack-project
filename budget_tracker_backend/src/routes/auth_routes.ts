import { Router } from "express";

import { AuthController } from "../controllers/auth_controller.js";

export const getAuthRouter = (): Router => {
  const router = Router();

  router.post(
    "/signup",
    AuthController.validateAuthRequest,
    AuthController.signUp
  );
  router.post(
    "/signin",
    AuthController.validateAuthRequest,
    AuthController.signIn
  );

  return router;
};
