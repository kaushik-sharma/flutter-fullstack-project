import { Prisma } from "../generated/client/index.js";
import { PrismaService } from "../services/prisma_service.js";

export class UserDatasource {
  static readonly createUser = async (
    user: Prisma.UserCreateInput,
    transaction: Prisma.TransactionClient
  ): Promise<string> => {
    const createdUser = await transaction.user.create({ data: user });
    return createdUser.id;
  };

  static readonly userByEmailExists = async (
    email: string
  ): Promise<boolean> => {
    const count = await PrismaService.client.user.count({ where: { email } });
    return count > 0;
  };

  static readonly getUserPassword = async (email: string): Promise<string> => {
    const result = await PrismaService.client.user.findFirst({
      where: { email },
      select: { password: true },
    });
    return result!.password;
  };

  static readonly getUserId = async (email: string): Promise<string> => {
    const result = await PrismaService.client.user.findFirst({
      where: { email },
      select: { id: true },
    });
    return result!.id;
  };
}
