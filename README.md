# Portfolio
This portfolio contains my end-to-end .NET application build and deploy to an Azure Webapp, which is managed by Terraform (infrastructure as code.) The documentation below walks the reader through each step of the project, but feel free to click the link to watch my YouTube demo.

[![Watch the video](https://img.youtube.com/vi/VIDEO_ID/0.jpg)](https://www.youtube.com/watch?v=VIDEO_ID)



1. Install the necessary tooling locally.
  * Git client
  * .NET SDK
  * Terraform
  * Azure CLI
  * VS Code

2. Build your app locally.
  * dotnet new webapp -n webapp
  * dotnet run ## See the app locally.
  * dotnet publish -c Release -o Release 
    - Creates a release package of your app in a folder named "Release." 
    - We will use this to manually push code.

3. In Azure create a webapp with the GUI. Use Azure CLI to push the code to it.
  * Create a "pay as you go" account in Azure.
  * Log into Azure.
  * Search for "webapps" and create one.
  * You will be prompted to create a new "Resource Group", a bucket that holds all of your cloud resources for a given project.
  * Write down the following pieces of information:
    - Subscription ID
    - The name of the resource group you created.
    - The region you selected to create your resource in. ##I live in the US midwest, so I selected "Central US." 
    - The name of the webapp you created.
  * From your terminal run the following Azure CLI command to deploy your webapp 
    - az webapp deploy --resource-group <RG_NAME> --name <APP_NAME> --src-path <PATH_TO_ZIP>
  * Click the URL in the Azure webapp pane to see your app hosted in Azure.

4. Create an account in github or Azure DevOps and connect it to your console.
  * ssh-keygen -t ed25519 -C "<emailAddress here>" #ed25519 is supposed to be more secure than standard RSA.
  * Upload your public key to your github or Azure DevOps account.

5. Create a git repository, and push to your code to it.
  * git init ## “This folder is now a repo.”
  * git add . ## “Track these files.”
  * git commit -am "Message" ## “Save a snapshot.”
  * git remote add origin git@github.com:YourName/YourRepoName.git ## “Here’s where this repo lives on GitHub.”
  * git push -u origin main ## “Send my code there and remember this connection.”

6. Open Azure DevOps and configure the build & release pipeline.
  * If you don't already have an Azure DevOps account and workspace, create with "pay as you go" selected.
  * You will have to create an organization (usually your name) and a project.
  * Once in your project, navigate to Pipelines> Pipelines.
  * Specify where your source code is kept and follow the wizard to configure it.
  * In the pipeline YAML you can use the UI tooling (or reference my azureBuildPipeline.yaml file) to specify the following steps
    - dotNET build
    - dotNET publish
    - Azure WebApp deployment
    - Start Azure Webapp

7. Build the Terraform for the Azure Webapp on your local workstation.
  * In the Azure portal delete the resource group containing your webapp.
  * In the Terraform folder create the four following files:
    - main.tf
    - variables.tf
    - providers.tf
    - outputs.tf
    - terraform.tfvars
  * In main.tf build out three Azure resources
    - The resource group
    - The Webapp Service Plan (this was created for us in the GUI)
    - The webapp
  * In providers.tf specify your Azure subscription.
  * In variables.tf and terraform.tfvars specify your variables
    - Subscription ID
    - Azure Region
    - Resource Group Name
    - Webapp Name

8. Execute Terraform locally to ensure that it builds your resources properly.
  * terraform init
  * terraform plan -out=tfplan
  * terraform apply -auto-approve tfplan

9. Create a Terraform pipeline in Azure DevOps to build your environment programmatically.
  * I used the "Azure CLI" module to enable Terraform to properly authenticate.
  * I deleted the terraform.tfvars file and used Powershell to dynamically create it using pipeline variables.
  * Add the same Terraform commands from above into the CLI script.
  * Add a "publish" module to store the terraform.tfstate file as a pipeline artifact.

10. Updating the existing environment.
  * Add a "Download Build Artifact" module and point it to the last successful build of this pipeline.
  * Add another "Powershell" module to the build pipeline to test for the presence of terraform.tfstate in the working directory.
    - If found, move it to the terraform folder.
  * When the pipeline resumes it will reference the existing terraform.tfstate file, allowing you to make changes to the