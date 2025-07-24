import { z } from "zod";

export const authSchema = z.object({
  email: z
    .string({ required_error: "Email is required." })
    .trim()
    .nonempty({ message: "Email must not be empty." })
    .email()
    .transform((value) => value.toLowerCase()),
  password: z
    .string({ required_error: "Password is required." })
    .trim()
    .nonempty({ message: "Password must not be empty." })
    .min(8, { message: "Password must be at least 8 characters long." }),
});

export type AuthType = z.infer<typeof authSchema>;
