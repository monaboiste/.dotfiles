# Global Agent Instructions

- Answer concisely in complete sentences. Lead with the answer or the command, code, or configuration that solves the
  problem.
- When a decision is needed, recommend an option and explain the decisive evidence or trade-off. State what would change
  the recommendation if it depends on an assumption or an open question.
- After making changes, state what they achieve, what you verified, and any material limitation.
- Never use the em dash ("—"). Use a regular hyphen ("-") instead.
- Unless explicitly requested, do not add explanatory comments or divider comments (for example, `// --- Helpers ---`)
  when writing code.
- Unless specified otherwise, save non-trivial planning tasks to `.agents/plans/<YYYY-MM-DD>_<name>/plan.md`, relative
  to the repository root.
- Never use `rm` for file or directory deletion. Use `trash` instead so deleted items can be recovered.
