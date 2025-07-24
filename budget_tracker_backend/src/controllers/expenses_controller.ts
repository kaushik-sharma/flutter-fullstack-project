import { RequestHandler } from "express";
import { validateData } from "../helpers/validation_helper";
import { expenseSchema, ExpenseType } from "../validation/expense_schems";
import { asyncHandler } from "../helpers/async_handler";
import { Prisma } from "../generated/client/index.js";
import { ExpensesDatasource } from "../datasources/expenses_datasource";
import { successResponseHandler } from "../helpers/success_handler";

export class ExpensesController {
  static readonly getExpenses: RequestHandler = asyncHandler(
    async (req, res, next) => {
      const userId = req.user!.userId;

      const expenses = await ExpensesDatasource.getExpenses(userId);

      successResponseHandler({
        res: res,
        status: 200,
        data: { expenses },
      });
    }
  );

  static readonly validateCreateRequest: RequestHandler = (req, res, next) => {
    req.parsedData = validateData(expenseSchema, req.body);
    next();
  };

  static readonly createExpense: RequestHandler = asyncHandler(
    async (req, res, next) => {
      const userId = req.user!.userId;
      const parsedData = req.parsedData! as ExpenseType;

      const expenseData: Prisma.ExpenseCreateInput = {
        ...parsedData,
        user: {
          connect: { id: userId },
        },
      };
      await ExpensesDatasource.createExpense(expenseData);

      successResponseHandler({
        res: res,
        status: 200,
        metadata: { message: "Expense created successfully." },
      });
    }
  );

  static readonly deleteExpense: RequestHandler = asyncHandler(
    async (req, res, next) => {
      const userId = req.user!.userId;
      const expenseId = req.params.expenseId;

      await ExpensesDatasource.deleteExpense(userId, expenseId);

      successResponseHandler({
        res: res,
        status: 200,
        metadata: { message: "Expense deleted successfully." },
      });
    }
  );
}
