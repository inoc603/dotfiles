function k --description 'kubectl; -c <cluster> runs via aid-kubeconfig cluster configs'
    # Route to aid-k (which pins KUBECONFIG to ~/.kube/clusters/<cluster>.yaml)
    # when the first argument selects a managed cluster; otherwise run plain
    # kubectl, preserving the old `k = kubectl` alias for local clusters.
    if set -q argv[1]; and string match -q -- '-c*' -- $argv[1]
        aid-k $argv
        return
    end
    command kubectl $argv
end
