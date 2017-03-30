#!/bin/bash -e
# check_jq() {
#   {
#     type jq &> /dev/null && echo "jq is already installed"
#   } || {
#     echo "Installing 'jq'"
#     echo "----------------------------------------------"
#     apt-get install -y jq
#   }
# }

# get_commit_sha() {
#   echo "----------------------------------------------"

#   local ver_file_path="/build/IN/app-version/version.json"

#   find -L "/build/IN/app-version"
#   SHA=$(cat $ver_file_path \
#     | jq -r '.version.propertyBag.commitSha')
#   echo "COMMIT_SHA: $SHA"
# }

# run_deploy() {
#   echo "----------------------------------------------"
#   cd /build/IN/master-branch/gitRepo
#   git reset --hard "$SHA"
#   yes '' | eb init shippablesample -r us-west-2 -p Node.js
#   eb deploy shippablesample-env
# }

# main() {
#   check_jq
#   get_commit_sha
#   run_deploy
# }

# main

#!/bin/bash -e

export TF_INSALL_LOCATION=/opt
export TF_VERSION=0.6.9
export REPO_RESOURCE_NAME="master-branch"
export RES_AWS_CREDS="beta-aws-creds"

install_terraform() {
  pushd $TF_INSALL_LOCATION
  echo "Fetching terraform"

  rm -rf $TF_INSALL_LOCATION/terraform
  mkdir -p $TF_INSALL_LOCATION/terraform

  wget -q https://releases.hashicorp.com/terraform/$TF_VERSION/terraform_"$TF_VERSION"_linux_386.zip
  apt-get install unzip
  unzip -o terraform_"$TF_VERSION"_linux_386.zip -d $TF_INSALL_LOCATION/terraform
  export PATH=$PATH:$TF_INSALL_LOCATION/terraform
  echo "downloaded terraform successfully"

  local tf_version=$(terraform version)
  echo "Terraform version: $tf_version"
  popd
}

apply_changes() {
  pushd /build/IN/$REPO_RESOURCE_NAME/gitRepo/
  echo "-----------------------------------"
  ps -eaf | grep ssh
  ls -al ~/.ssh/
  which ssh-agent

  echo "applying config changes"
  terraform plan
  echo "apply changes"
  terraform apply
  terraform show
  popd
}

install_terraform
apply_changes