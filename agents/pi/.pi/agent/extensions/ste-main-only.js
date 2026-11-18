/*
 * Enable STE only for main agent (exlude subagents from STE).
 */

import { homedir } from "node:os";
import { join } from "node:path";
import { pathToFileURL } from "node:url";

const agentDir =
  process.env.PI_CODING_AGENT_DIR ??
  join(homedir(), ".pi", "agent");

const extensionPath = join(
  agentDir,
  "npm/node_modules/agent-ste/extension.mjs",
);

const steExtension = process.env.PI_SUBAGENT_ID
  ? null
  : (await import(pathToFileURL(extensionPath).href)).default;

export default function (pi) {
  steExtension?.(pi);
}
