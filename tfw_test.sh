#!/usr/bin/env bash
#set -aeu -o pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

testInstallWithPrefix(){
  local WORK_DIR=$(mktemp -d -p "$SCRIPT_DIR")
  local BIN_FOLDER="${WORK_DIR}/bin"

  mkdir "${BIN_FOLDER}"
  ./tfw install "${WORK_DIR}"
  
  assertTrue 'Symbolic Link should be created' "[ -f ${BIN_FOLDER}/tfw ]"
}

testInit(){
  local WORK_DIR=$(mktemp -d -p "$SCRIPT_DIR")
  cd "${WORK_DIR}"
  ../tfw init

  assertTrue '.tfw folder should be created' "[ -d .tfw ]"
  assertTrue '.tfw/logs folder should be created' "[ -d .tfw/logs ]"
  assertTrue '.tfw/plans folder should be created' "[ -d .tfw/plans ]"
  assertTrue '.tfw/shared_variables.sh file should be created' "[ -f .tfw/shared_variables.sh ]"
  assertTrue '.gitignore file should be  and should not be empty' "[ -s .gitignore ]"
  assertTrue '.gitignore should have .tfw entry' "grep -q .tfw .gitignore"
  
}

testWorkspaceNew(){
  local WORKSPACE_NAME="development"
  local WORK_DIR=$(mktemp -d -p "$SCRIPT_DIR")
  cd "${WORK_DIR}"
  ../tfw workspace new "${WORKSPACE_NAME}"

  assertTrue "./variables/${WORKSPACE_NAME}.tfvars file should be created" "[ -f ./variables/${WORKSPACE_NAME}.tfvars ]"
  assertEquals "${WORKSPACE_NAME}" "$(../tfw workspace show)"
  
}

testPlan(){
  local WORKSPACE_NAME="development"
  local WORK_DIR=$(mktemp -d -p "$SCRIPT_DIR")
  cd "${WORK_DIR}"
  ../tfw init 
  ../tfw workspace new "${WORKSPACE_NAME}"

cat <<EOF > main.tf
output "my_output" {
  value = "output"
}
EOF

  ../tfw plan

  assertTrue "./.tfw/plans/${WORKSPACE_NAME}.tfplan file should be created" "[ -f ./.tfw/plans/${WORKSPACE_NAME}.tfplan ]"
}

testApply(){
  local WORKSPACE_NAME="development"
  local WORK_DIR=$(mktemp -d -p "$SCRIPT_DIR")
  cd "${WORK_DIR}"
  ../tfw init 
  ../tfw workspace new "${WORKSPACE_NAME}"

cat <<EOF > main.tf
output "my_output" {
  value = "output"
}
EOF

  ../tfw plan
  ../tfw apply
  
  assertTrue "./.tfw/plans/${WORKSPACE_NAME}.tfplan file should be created" "[ -f ./.tfw/plans/${WORKSPACE_NAME}.tfplan ]"
  assertEquals "output" "$(../tfw show -json | jq -r '.values.outputs.my_output.value')"
}