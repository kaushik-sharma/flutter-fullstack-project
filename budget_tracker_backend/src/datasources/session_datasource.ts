import { PrismaService } from "../services/prisma_service.js";

export class SessionDatasource {
  static readonly signOutSession = async (
    sessionId: string,
    userId: string
  ): Promise<void> => {
    await PrismaService.client.session.delete({
      where: {
        id: sessionId,
        userId: userId,
      },
    });
  };
}
