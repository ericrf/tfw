# tfw

```
Usage tfw <subcommand> args

  The tfw is a wrapper for a terraform command.
  It must help you to deal with multiple workspaces.

  Main commands:
    install         It will create a sym link in the disired preffix (default preffix: /usr/local/bin) 
                      * This command requires sudo permissions.

    init            It will wrap the terraform init command.
                      It will create the logs and plan folders if they don't exist. 
                      It will create a shared_variables file if it don't exist. This file will be used with all tfw commands.
                      It will add a .tfw entry inside the .gitignore file if it exists

    plan            It will wrap the terraform plan command with the command below.
                      terraform plan -var-file \"./variables/\$(terraform workspace show).tfvars\" -out \"./.tfw/plans/\$(terraform workspace show).tfplan\"

    apply           It will wrap the terraform apply command with the command below.
                      terraform apply \"./.tfw/plans/\$(terraform workspace show).tfplan\"

    workspace new   It will wrap the terraform workspace new command and will create the variables file for the created workspace
```