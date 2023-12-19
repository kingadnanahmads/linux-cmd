function show_help() {
    echo "Usage: internsctl [options]"
    echo "Options:"
    echo "  --help          Show this help message"
    echo "  --version       Show command version"
    echo "  cpu getinfo     Get CPU information"
    echo "  memory getinfo  Get memory information"
    echo "  user create     Create a new user"
    echo "  user list       List all regular users"
    echo "  user list --sudo-only  List users with sudo permissions"
    echo "  file getinfo    Get information about a file"
    echo "  file getinfo [options] <file-name>"
    echo "    --size, -s          Print file size"
    echo "    --permissions, -p   Print file permissions"
    echo "    --owner, -o         Print file owner"
    echo "    --last-modified, -m Print last modified time"
}
function show_version() {
    echo "internsctl v0.1.0"
}
function get_cpu_info() {
    lscpu
}

function get_memory_info() {
    free
}

function create_user() {
    if [ -z "$1" ]; then
        echo "Error: Please provide a username."
    else
        sudo useradd -m "$1"
        echo "User $1 created successfully."
    fi
}

function list_users() {
    if [ "$1" == "--sudo-only" ]; then
        getent passwd | grep -E 'sudo|admin' | cut -d: -f1
    else
        getent passwd | grep -vE 'nologin|false' | cut -d: -f1
    fi
}

function file_getinfo() {
    if [ -z "$2" ]; then
        echo "Error: Please provide a file name."
    else
        file="$2"
        if [[ "$1" == "--size" -o "$1" == "-s" ]]; then
            stat -c %s "$file"
        elif [[ "$1" == "--permissions" -o "$1" == "-p" ]]; then
            stat -c %A "$file"
        elif [[ "$1" == "--owner" -o "$1" == "-o" ]]; then
            stat -c %U "$file"
        elif [[ "$1" == "--last-modified" -o "$1" == "-m" ]]; then
            stat -c %y "$file"
        else
            # Default output
            stat "$file"
        fi
    fi
}

case "$1" in
    "--help")
        show_help
        ;;
    "--version")
        show_version
        ;;
    "cpu"|"memory"|"user"|"file")
        # Subcommands
        shift
        "${1}_$2" "$@"
        ;;
    *)
        echo "Error: Unknown command. Use 'internsctl --help' for usage."
        exit 1
        ;;
esac
