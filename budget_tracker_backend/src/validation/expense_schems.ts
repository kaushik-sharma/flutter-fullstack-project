import { z } from "zod";
import { DateTime } from "luxon";

import { ExpenseCategory } from "../generated/client/index.js";

const DATE_REGEX = /^\d{4}-\d{2}-\d{2}$/;

export const expenseSchema = z.object({
  category: z.nativeEnum(ExpenseCategory, {
    required_error: "Category is required.",
  }),
  amount: z
    .number({ required_error: "Amount is required." })
    .positive({ message: "Amount must be a positive number." }),
  description: z
    .string({ required_error: "Description is required." })
    .trim()
    .nonempty({ message: "Description must not be empty." }),
  date: z
    .string({ required_error: "Date is required." })
    .trim()
    .nonempty({ message: "Date must not be empty." })
    .regex(DATE_REGEX, {
      message: "Date format is invalid. Expected format - 'yyyy-MM-dd'",
    })
    .superRefine((value, ctx) => {
      const inputDate = DateTime.fromFormat(value, "yyyy-MM-dd", {
        zone: "utc",
      });

      if (!inputDate.isValid) {
        ctx.addIssue({
          code: "custom",
          message: "Date is not parsable.",
        });
        return;
      }
    }),
});

export type ExpenseType = z.infer<typeof expenseSchema>;
