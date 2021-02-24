# test integrity of the input data
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

import sys
import os
import numpy as np
import pandas as pd

# number of features
n_columns = 10

# distribution of features in the training set
historical_mean = np.array(
    [
        -3.63962254e-16,
        1.26972339e-16,
        -8.01646331e-16,
        1.28856202e-16,
        -8.99230414e-17,
        1.29609747e-16,
        -4.56397112e-16,
        3.87573332e-16,
        -3.84559152e-16,
        -3.39848813e-16,
        1.52133484e02,
    ]
)
historical_std = np.array(
    [
        4.75651494e-02,
        4.75651494e-02,
        4.75651494e-02,
        4.75651494e-02,
        4.75651494e-02,
        4.75651494e-02,
        4.75651494e-02,
        4.75651494e-02,
        4.75651494e-02,
        4.75651494e-02,
        7.70057459e01,
    ]
)

# maximal relative change in feature mean or standrd deviation that we can tolerate
shift_tolerance = 3


def check_schema(X):
    n_actual_columns = X.shape[1]
    if n_actual_columns != n_columns:
        print(
            "Error: found {} feature columns. The data should have {} feature columns.".format(
                n_actual_columns, n_columns
            )
        )
        return False

    return True


def check_missing_values(dataset):
    n_nan = np.sum(np.isnan(dataset.values))
    if n_nan > 0:
        print("Warning: the data has {} missing values".format(n_nan))
        return False
    return True


def check_distribution(dataset):
    mean = np.mean(dataset.values, axis=0)
    std = np.mean(dataset.values, axis=0)
    if (
        np.sum(abs(mean - historical_mean) > shift_tolerance * abs(historical_mean)) > 0
        or np.sum(abs(std - historical_std) > shift_tolerance * abs(historical_std)) > 0
    ):
        print("Warning: new data has different distribution than the training data")
        return False
    return True


def main():
    filename = sys.argv[1]
    if not os.path.exists(filename):
        print("Error: The file {} does not exist".format(filename))
        return

    dataset = pd.read_csv(filename)
    if check_schema(dataset[dataset.columns[:-1]]):
        print("Data schema test succeeded")
        if check_missing_values(dataset) and check_distribution(dataset):
            print("Missing values test passed")
            print("Data distribution test passed")
        else:
            print(
                "There might be some issues with the data. Please check warning messages."
            )


if __name__ == "__main__":
    main()
