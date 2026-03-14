# Completions for git-branchless `git move`

# Register `move` as a git subcommand
complete -f -c git -n __fish_git_needs_command -a move -d 'Move a subtree of commits (git-branchless)'

# Flags that take a commit/branch argument
complete -f -c git -n '__fish_git_using_command move' -s s -l source -d 'Source commit to move' -ra '(__fish_git_refs)'
complete -f -c git -n '__fish_git_using_command move' -s b -l base -d 'Base of subtree to move' -ra '(__fish_git_refs)'
complete -f -c git -n '__fish_git_using_command move' -s x -l exact -d 'Specific commits to move' -ra '(__fish_git_refs)'
complete -f -c git -n '__fish_git_using_command move' -s d -l dest -d 'Destination commit' -ra '(__fish_git_refs)'

# Boolean flags
complete -f -c git -n '__fish_git_using_command move' -s f -l force-rewrite -d 'Force moving public commits'
complete -f -c git -n '__fish_git_using_command move' -s m -l merge -d 'Attempt to resolve merge conflicts'
complete -f -c git -n '__fish_git_using_command move' -s F -l fixup -d 'Squash moved commits into destination'
complete -f -c git -n '__fish_git_using_command move' -l in-memory -d 'Only attempt in-memory rebase'
complete -f -c git -n '__fish_git_using_command move' -l on-disk -d 'Skip in-memory rebase, use on-disk'
complete -f -c git -n '__fish_git_using_command move' -l no-deduplicate-commits -d 'Don'\''t deduplicate commits'
complete -f -c git -n '__fish_git_using_command move' -l hidden -d 'Include hidden commits in revset evaluation'
