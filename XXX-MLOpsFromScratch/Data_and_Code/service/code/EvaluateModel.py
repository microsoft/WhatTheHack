"""
Copyright (C) Microsoft Corporation. All rights reserved.​
 ​
Microsoft Corporation (“Microsoft”) grants you a nonexclusive, perpetual,
royalty-free right to use, copy, and modify the software code provided by us
("Software Code"). You may not sublicense the Software Code or any use of it
(except to your affiliates and to vendors to perform work on your behalf)
through distribution, network access, service agreement, lease, rental, or
otherwise. This license does not purport to express any claim of ownership over
data you may have shared with Microsoft in the creation of the Software Code.
Unless applicable law gives you more rights, Microsoft reserves all other
rights not expressly granted herein, whether by implication, estoppel or
otherwise. ​
 ​
THE SOFTWARE CODE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
MICROSOFT OR ITS LICENSORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THE SOFTWARE CODE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
"""
import os, json
from azureml.core import Workspace
from azureml.core import Experiment
from azureml.core.model import Model
import azureml.core
from azureml.core import Run
from azureml.core.authentication import AzureCliAuthentication

with open("./configuration/config.json") as f:
    config = json.load(f)

workspace_name = config["workspace_name"]
resource_group = config["resource_group"]
subscription_id = config["subscription_id"]
location = config["location"]

cli_auth = AzureCliAuthentication()


# Get workspace
#ws = Workspace.from_config(auth=cli_auth)
ws = Workspace.get(
        name=workspace_name,
        subscription_id=subscription_id,
        resource_group=resource_group,
        auth=cli_auth
    )

# Paramaterize the matrics on which the models should be compared

# Add golden data set on which all the model performance can be evaluated

# Get the latest run_id
with open("./configuration/run_id.json") as f:
    config = json.load(f)

new_model_run_id = config["run_id"]
experiment_name = config["experiment_name"]
exp = Experiment(workspace=ws, name=experiment_name)


try:
    # Get most recently registered model, we assume that is the model in production. Download this model and compare it with the recently trained model by running test with same data set.
    model_list = Model.list(ws)
    production_model = next(
        filter(
            lambda x: x.created_time == max(model.created_time for model in model_list),
            model_list,
        )
    )
    production_model_run_id = production_model.tags.get("run_id")
    run_list = exp.get_runs()
    # production_model_run = next(filter(lambda x: x.id == production_model_run_id, run_list))

    # Get the run history for both production model and newly trained model and compare R2
    production_model_run = Run(exp, run_id=production_model_run_id)
    new_model_run = Run(exp, run_id=new_model_run_id)

    production_model_r2 = production_model_run.get_metrics().get("r2")
    new_model_r2 = new_model_run.get_metrics().get("r2")
    print(
        "Current Production model r2: {}, New trained model r2: {}".format(
            production_model_r2, new_model_r2
        )
    )

    promote_new_model = False
    if new_model_r2 > production_model_r2:
        promote_new_model = True
        print("New trained model performs better, thus it will be registered")
except:
    promote_new_model = True
    print("This is the first model to be trained, thus nothing to evaluate for now")

run_id = {}
run_id["run_id"] = ""
# Writing the run id to /aml_config/run_id.json
if promote_new_model:
    run_id["run_id"] = new_model_run_id

run_id["experiment_name"] = experiment_name
with open("./configuration/run_id.json", "w") as outfile:
    json.dump(run_id, outfile)
