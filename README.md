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