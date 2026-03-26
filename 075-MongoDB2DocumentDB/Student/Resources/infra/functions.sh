#!/usr/bin/env bash

error_exit() {
  echo "Error: $1" >&2
  exit 1
}

authenticate_to_azure() {
  if [[ "${USE_SERVICE_PRINCIPAL:-false}" == true ]]; then
    if [[ -z "${TENANT_ID:-}" || -z "${SERVICE_PRINCIPAL_ID:-}" || -z "${SERVICE_PRINCIPAL_PASSWORD:-}" ]]; then
      error_exit "Service Principal ID, Password, and Tenant ID are required for Service Principal authentication."
    fi

    if ! az account show > /dev/null 2>&1; then
      az login --service-principal -u "$SERVICE_PRINCIPAL_ID" -p "$SERVICE_PRINCIPAL_PASSWORD" --tenant "$TENANT_ID" >/dev/null || error_exit "Failed to authenticate using Service Principal."
    fi
  else
    if ! az account show > /dev/null 2>&1; then
      az login >/dev/null || error_exit "Failed to authenticate with Azure."
    fi
  fi
}

# Processes named command-line arguments into variables.
parse_args() {
  # $1 - The associative array name containing the argument definitions and default values
  local -n arg_defs=$1
  shift
  local args=("$@")

  for arg_name in "${!arg_defs[@]}"; do
    declare -g "$arg_name"="${arg_defs[$arg_name]}"
  done

  for ((i = 0; i < ${#args[@]}; i++)); do
    arg=${args[i]}

    if [[ $arg == --* ]]; then
      arg_name=${arg#--}
      next_index=$((i + 1))
      next_arg=${args[$next_index]:-}

      if [[ -z ${arg_defs[$arg_name]+_} ]]; then
        continue
      fi

      if [[ $next_arg == --* ]] || [[ -z $next_arg ]]; then
        declare -g "$arg_name"=1
      else
        declare -g "$arg_name"="$next_arg"
        i=$((i + 1))
      fi
    else
      break
    fi
  done
}
