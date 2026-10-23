## Git

- IMPORTANT: Use the commit skill to commit code and follow its conventions.
- Use `git get <repo_url>` to clone repositories into `~/src` with a GOPATH-style layout.
- To find a local repository, pipe `list_git_projects` through `grep` or `fzf` rather than listing every repository. DO NOT recursively search `~/src` with `find` or similar commands.
- I normally perfer one commit one MR. It's okay to squash and force push on feature branches.
- Write human facing MR descriptions. Descrition should focus on the MR changes, not the process of building this MR and iteration from review. Do not include info available from ci jobs like test passed.
