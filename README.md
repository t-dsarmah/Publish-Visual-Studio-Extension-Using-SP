# Publish Visual Studio Extension Using Service Principal

A  task that publishes a visual studio extension using a service principal.

## Inputs of the task

* `TenantID` - The tenant ID of the service principal.
* `ManifestFile` - Extension manifest file relative to source directory. Example: `vss-extension.json`
* `ManifestFolder` - Path to the folder containing the extension manifest file relative to source directory. Leave empty if the manifest file is in the root of the source directory.

## How to use

1. Add the [Tfx installer](https://github.com/microsoft/azure-devops-extension-tasks/tree/main/BuildTasks/TfxInstaller) task to your pipeline to install [tfx-cli](https://www.npmjs.com/package/tfx-cli):
     
      ``` yaml
      - task: TfxInstaller@4
        inputs:
          version: 'v0.x'
      ```
2. Add the [Azure Key Vault v2 task](https://learn.microsoft.com/en-us/azure/devops/pipelines/tasks/reference/azure-key-vault-v2?view=azure-pipelines) to your pipeline to access the key vault for client ID and client secret. For instance if your key vault is named `KeyVaultName` with Azure subscription `Azure SPN` and you've stored the client ID and client secret of the service principal as `ClientId` and `ClientSecret` respectively, you can add the following task to your pipeline:

    ``` yaml
    - task: AzureKeyVault@2
      inputs:
        azureSubscription: 'Azure SPN'
        KeyVaultName: 'KeyVaultName'
        SecretsFilter: 'ClientID, ClientSecret'
    ```

3. Add the [PublishVSExtensionUsingSP](https://marketplace.visualstudio.com/items?itemName=dsarmah.PublishVSExtensionUsingSP) task to your pipeline. Make sure to pass the `ClientID` and `ClientSecret` secrets to the respective environment variables `CLIENT_ID` and `CLIENT_SECRET`: 
    ``` yaml
    - task: PublishVSExtensionUsingSP@1
      inputs:
        TenantID: <Tenant ID of your SP>
        ManifestFile: <Manifest file of your extension>
        ManifestFolder: <Path to folder containing manifest file> # Can be omitted if the manifest file is in the root of the source directory 
      env:
        CLIENT_SECRET: $(ClientSecret)
        CLIENT_ID: $(ClientId)
    ```

## FAQs

1. Should the [PublishVSExtensionUsingSP](https://marketplace.visualstudio.com/items?itemName=dsarmah.PublishVSExtensionUsingSP) task immediately follow the [Azure Key Vault v2 task](https://learn.microsoft.com/en-us/azure/devops/pipelines/tasks/reference/azure-key-vault-v2?view=azure-pipelines) in the pipeline?

    No, the [PublishVSExtensionUsingSP](https://marketplace.visualstudio.com/items?itemName=dsarmah.PublishVSExtensionUsingSP) task need not immediately follow the [Azure Key Vault v2 task](https://learn.microsoft.com/en-us/azure/devops/pipelines/tasks/reference/azure-key-vault-v2?view=azure-pipelines) in the pipeline. You can have other tasks in between the two tasks. The important thing to note is that the [PublishVSExtensionUsingSP](https://marketplace.visualstudio.com/items?itemName=dsarmah.PublishVSExtensionUsingSP) task should be able to access the client ID and client secret as environment variables. 

## Get the source
The [source](https://github.com/t-dsarmah/Publish-Visual-Studio-Extension-Using-SP) for this extension is on GitHub. You can get the source code and build the extension locally if you'd like to.

## Feedback and issues
If you have feedback or issues, please file an issue on [GitHub](https://github.com/t-dsarmah/Publish-Visual-Studio-Extension-Using-SP/issues).

<br/>

<p align="center">
Made with 💖 in Microsoft KP Towers, Noida, India
</p>