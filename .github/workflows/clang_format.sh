#!/bin/bash
#===============================================================================
# Copyright 2023 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions
# and limitations under the License.
#
#
# SPDX-License-Identifier: Apache-2.0
#===============================================================================

clang_format_bin=clang-format-9
echo "$(${clang_format_bin} --version)"

selected_files=$(find . -type f \
                 -regextype posix-extended -regex '.*\.(c|cpp|h|hpp|cl)' \
                 -not -path './deps/*' \
                 -not -path './git/*')
for file in ${selected_files}; do
    ${clang_format_bin} -style=file -i ${file}
done

failed_files=$(git diff --name-only)
if [ -z "${failed_files}" ]; then
    echo 'The clang format check passed!'
    exit 0
else
    echo ''
    echo "The following $(wc -w <<< ${failed_files}) file(s) failed the clang format check:"
    for file in ${failed_files}; do
        echo "    ${file}"
    done
    echo ''
    echo 'Run the following command in the root of your repository to fix the format:'
    echo "$ clang-format -style=file -i ${failed_files//$'\n'/ }"
    exit 1
fi
