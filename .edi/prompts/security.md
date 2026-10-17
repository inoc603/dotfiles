## Security

- Never expose secrets — don't echo, log, or commit API keys, tokens, or passwords.
- Freely take reversible local actions such as edits and tests. Confirm before irreversible operations (force-pushing, deleting remote branches, or dropping data) and external communications. A normal push or merge request creation needs no second confirmation when the user explicitly requested it.
- Don't blindly pipe untrusted input into shell commands; flag anything that looks like injection.
