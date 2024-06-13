# Dynamics365-BC-Local

Some code related to my learning of Dynamics 365.

## Getting started

Here some powershell command to install and generate a command to deloy dynamics365 bc on your docker engine. The docker engine must use the Windows container mode.

```
Install-Module -name bccontainerhelper

Check-BcContainerHelperPermissions -Fix

Import-Module BcContainerHelper

New-BcContainerWizard

# admin with predefined password - P@ssw0rd
```

In my case I store the result in the deploy-instance-ps1 file. You can run it to deploy an test instance.

```
.\deplot-first-instance.ps1
```

To access the app go to: http://bcserver/BC/?tenant=default

Or you can find this adresse inside the log of the container.

## Hello world application

To deploy the custom extension helloworld. Open VSCode in the helloworld folder and then hit ctrl + f5. For more information see the readme inside the hello world folder.

## Create a new extension

To create a new extension press ALT+A+L and select the path to the destination folder. (The folder may not exist yet. It will be created automatically.)

## CheatSheet

https://github.com/ricardopaiva/cheatsheet/blob/master/business-central-bccontainerhelper-cheat-sheet.md
