// TODO: temporary - workaround for https://github.com/ctotheameron/agent-ste/issues/15

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent"
import { getMarkdownTheme } from "@earendil-works/pi-coding-agent"
import { Container, Markdown, Text } from "@earendil-works/pi-tui"

export default function (pi: ExtensionAPI) {
  pi.registerToolRenderer((toolName, next) => {
    if (toolName !== "say" && toolName !== "ste_lint") return next()

    const reply = toolName === "say"

    return {
      renderShell: reply ? "self" : "default",
      renderCall(_args, theme) {
        return reply
          ? new Container()
          : new Text(theme.fg("muted", "STE lint"), 0, 0)
      },
      renderResult(result, { isPartial }, theme, context) {
        if (isPartial) return new Container()

        const text = result.content
          .filter((part) => part.type === "text")
          .map((part) => part.text)
          .join("\n")

        if (context.isError) {
          return new Text(theme.fg("error", text), reply ? 1 : 0, 0)
        }

        return reply
          ? new Markdown(text, 1, 0, getMarkdownTheme())
          : new Text(text, 0, 0)
      },
    }
  })
}
