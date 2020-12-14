
"""
Helper functions
"""
import subprocess

def az_login(sp_user : str, sp_password : str, sp_tenant_id : str):
    """
    Uses the provided service principal credentials to log into the azure cli.
    This should always be the first step in executing az cli commands.
    """
    cmd = "az login --service-principal --username {} --password {} --tenant {}"
    out, err = run_cmd(cmd.format(sp_user, sp_password, sp_tenant_id))
    return out, err

def run_cmd(cmd : str):
    """
    Runs an arbitrary command line command.  Works for Linux or Windows.
    Returns a tuple of output and error.
    """
    proc = subprocess.Popen(cmd, shell = True, stdout=subprocess.PIPE, universal_newlines = True)
    output, error = proc.communicate()
    if proc.returncode !=0:
        print('Following command execution failed: {}'.format(cmd))
        raise Exception('Operation Failed. Look at console logs for error info')
    return output, error

def az_account_set(subscription_id : str):
    """
    Sets the correct azure subscription.
    This should always be run after the az_login.
    """
    cmd = "az account set  -s {}"
    out, err = run_cmd(cmd.format(subscription_id))
    return out, err

def az_acr_create(resource_group : str, acr_name : str):
    cmd = "az acr create --resource-group {} --name {} --sku Basic"
    out, err = run_cmd(cmd.format(resource_group, acr_name))
    return out, err

def az_acr_login(acr_name : str):
    cmd = "az acr login --name {}"
    out, err = run_cmd(cmd.format(acr_name))
    return out, err