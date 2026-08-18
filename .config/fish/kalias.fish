function __kubectl_safe_command \
    -d "echo a command that runs kubectl with explicit config file and context"

    # We don't simply alias to "kubectl --context some-context" because it won't work
    # for custom k8s plugins and some built in k8s commands. The plugins require --context and
    # --kubeconfig to be passed after the plugin name.
    echo "kubectl $argv[3] --kubeconfig $argv[1] --context $argv[2] $argv[4..]"
end

function __kubectl_safe
    eval (__kubectl_safe_command $argv)
end

function __kubectl_safe_completions
    set -l args (commandline -opc)
    set -l lastArg (commandline -ct)
    set -l kubecmd (__kubectl_safe_command $args[2..] $lastArg)
    # Invoke completion for kubectl
    complete --do-complete "$kubecmd"
end

complete -c __kubectl_safe -e
complete -c __kubectl_safe -n '__kubectl_safe_completions' -f -a '$__kubectl_comp_results'

function kalias \
    -d "add a alias to run kubectl with explicit config file and context"

    alias $argv[1] "__kubectl_safe $argv[2] $argv[3]"
end

function kubeconfig \
    -d "select a cluster for this shell session (one kubeconfig file per cluster)"

    # ~/.kube/config is the scratch file for local clusters (kind, orbstack).
    # Long-lived clusters live in one file per cluster under ~/.kube/clusters/.
    set -l files $HOME/.kube/config
    for f in $HOME/.kube/clusters/*.yaml
        set -a files $f
    end
    set -l kubeconfig (printf '%s\n' $files | fzf --delimiter=/ --with-nth=-1)
    test -n "$kubeconfig" && set -gx KUBECONFIG $kubeconfig
end
