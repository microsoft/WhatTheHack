function authenticate_to_azure {
    # Authenticate with Azure
    if [[ "$USE_SERVICE_PRINCIPAL" == true ]]; then
        if [[ -z "$TENANT_ID" || -z "$SERVICE_PRINCIPAL_ID" || -z "$SERVICE_PRINCIPAL_PASSWORD" ]]; then
            error_exit "Service Principal ID, Password, and Tenant ID are required for Service Principal authentication."
        fi
        if ! az account show > /dev/null 2>&1; then
            az login --service-principal -u "$SERVICE_PRINCIPAL_ID" -p "$SERVICE_PRINCIPAL_PASSWORD" --tenant "$TENANT_ID" || error_exit "Failed to authenticate using Service Principal."
        fi
    else
        if ! az account show > /dev/null 2>&1; then
            az login || error_exit "Failed to authenticate with Azure."
        fi
    fi
}
# Processes named command-line arguments into variables.
parse_args() {
    # $1 - The associative array name containing the argument definitions and default values
    # $2 - The arguments passed to the script
    local -n arg_defs=$1
    shift
    local args=("$@")

    # Assign default values first for defined arguments
    for arg_name in "${!arg_defs[@]}"; do
        declare -g "$arg_name"="${arg_defs[$arg_name]}"
    done

    # Process command-line arguments
    for ((i = 0; i < ${#args[@]}; i++)); do
        arg=${args[i]}
        if [[ $arg == --* ]]; then
            arg_name=${arg#--}
            next_index=$((i + 1))
            next_arg=${args[$next_index]}

            # Check if the argument is defined in arg_defs
            if [[ -z ${arg_defs[$arg_name]+_} ]]; then
                # Argument not defined, skip setting
                continue
            fi

            if [[ $next_arg == --* ]] || [[ -z $next_arg ]]; then
                # Treat as a flag
                declare -g "$arg_name"=1
            else
                # Treat as a value argument
                declare -g "$arg_name"="$next_arg"
                ((i++))
            fi
        else
            break
        fi
    done
}