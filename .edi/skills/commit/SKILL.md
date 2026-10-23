---
name: commit
description: Stage and commit current change with proper commit message
---

## Step 1: Gather context

Run the context script bundled with this skill to understand the current state:

- macOS/Linux: `bash scripts/context.sh`
- Windows (PowerShell): `pwsh -NoProfile -File scripts/context.ps1`

If neither shell is available, gather the same information with the `git` commands directly.

## Step 2: Stage and commit

Based on the context output, stage and commit with a proper message.

Rules:
- If you're on a feature branch, make sure branch name follows: (fix|feat|refactor)/{JIRA-TICKET}-{simple-name}, e.g. feat/proj-0000-error-handling. Rename if necessary. PROJ-0000 is the default placeholder. Max 60 chars.
- Use conventional commits.
- For non-trivial changes, include a body after the subject and a blank line. Explain why the change is needed, the approach taken, and its impact or important trade-offs. Use a header-only commit only for a small mechanical change whose full purpose is clear from the subject.
- Focus on important changes: new features, refactoring, bug fixes. Do not mention trivial things like formatting, comments, docs, or tests.
- Focus on why the change is made and its impact.
- Max line length of commit message is 100.
- LEAVE OUT YOUR SIGNATURE.
