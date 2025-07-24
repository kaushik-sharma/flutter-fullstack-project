import { Prisma } from "../generated/client/index.js";
import { PrismaService } from "../services/prisma_service.js";

export class ExpensesDatasource {
  static readonly getExpenses = async (
    userId: string
  ): Promise<Record<string, any>> => {
    return await PrismaService.client.expense.findMany({ where: { userId } });
  };

  static readonly createExpense = async (
    expense: Prisma.ExpenseCreateInput
  ): Promise<string> => {
    console.log(expense);
    
    const createdExpense = await PrismaService.client.expense.create({
      data: expense,
    });
    return createdExpense.id;
  };

  static readonly deleteExpense = async (
    userId: string,
    expenseId: string
  ): Promise<void> => {
    await PrismaService.client.expense.delete({
      where: { id: expenseId, userId: userId },
    });
  };
}
