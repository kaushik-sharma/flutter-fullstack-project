import { Router } from "express";

import { ExpensesController } from "../controllers/expenses_controller.js";
import { requireAuth } from "../middlewares/auth_middlewares.js";

export const getExpensesRouter = (): Router => {
  const router = Router();

  router.get("/", requireAuth(), ExpensesController.getExpenses);
  router.post(
    "/",
    requireAuth(),
    ExpensesController.validateCreateRequest,
    ExpensesController.createExpense
  );
  router.delete("/:expenseId", requireAuth(), ExpensesController.deleteExpense);

  return router;
};
