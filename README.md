# ZaraProfileApi

## Project Overview

ZaraProfileApi is an ASP.NET Core Web API created for the Azure App Service deployment assignment.

The API manages profile information such as:

- Full name
- Title
- About text
- Email
- LinkedIn link
- GitHub link

The project uses:

- ASP.NET Core Web API
- Entity Framework Core
- Azure SQL Database
- Swagger
- Azure App Service
- Application Insights
- Azure Key Vault
- Managed Identity
- Azure Storage Account
- Azure CLI
- GitHub Actions

The goal of the project was to deploy a working Web API to Azure App Service, connect it to a database, automate deployment, configure basic security, enable monitoring, and document the process.

---
## Table of Contents

1. [Azure Resources](#azure-resources)
2. [Project Structure](#project-structure)
3. [Create Azure App Service and Deploy a Working Application](#1-create-azure-app-service-and-deploy-a-working-application)
4. [Azure CLI Verification Commands](#2-azure-cli-verification-commands)
5. [Application Insights for Logging and Monitoring](#3-application-insights-for-logging-and-monitoring)
6. [Basic Security](#4-basic-security)
7. [Azure Storage Account](#5-azure-storage-account)
8. [Azure Key Vault and Managed Identity](#6-azure-key-vault-and-managed-identity)
9. [App Service Application Settings](#7-app-service-application-settings)
10. [Azure Setup Script](#8-azure-setup-script)
11. [Requirement Checklist](#9-requirement-checklist)
12. [Final Status](#10-final-status)

## Azure Resources

The following Azure resources were created using Azure CLI:

| Resource | Name |
|---|---|
| Resource Group | `RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg` |
| App Service Plan | `plan-zara-profile-free` |
| App Service | `zara-profile-api-free-2026` |
| Azure SQL Server | `zara-profile-sql-free26` |
| Azure SQL Database | `ZaraProfileDb` |
| Storage Account | `zaraprofilestfree26` |
| Key Vault | `kv-zara-prof-free26` |
| Application Insights | `appi-zara-profile-free` |

The resource group was provided by the school:

```text
RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg
```

---

## Project Structure

The project contains the following important files and folders:

```text
ZaraProfileApi
│
├── Controllers
│   └── ProfilesController.cs
│
├── Data
│   └── AppDbContext.cs
│
├── Migrations
│   ├── 20260502210046_InitialCreate.cs
│   └── AppDbContextModelSnapshot.cs
│
├── Models
│   └── Profile.cs
│
├── .github
│   └── workflows
│       └── deploy.yml
│
├── appsettings.json
├── azure-setup.ps1
├── Program.cs
├── README.md
└── ZaraProfileApi.http
```

Explanation:

- `Models/Profile.cs` defines the Profile model.
- `Data/AppDbContext.cs` configures the Entity Framework Core database context.
- `Controllers/ProfilesController.cs` contains the API endpoints.
- `Migrations` contains the EF Core database migration.
- `.github/workflows/deploy.yml` contains the GitHub Actions deployment workflow.
- `azure-setup.ps1` contains the Azure CLI script used to create Azure resources.
- `README.md` documents the process and verification steps.

---

# 1. Create Azure App Service and Deploy a Working Application

## Requirement

The assignment requires:

- Create an Azure App Service using Azure CLI.
- Create a Web API with database connection using Entity Framework Core.
- Publish the application to Azure App Service using GitHub Actions or Azure DevOps.
- Confirm that the application works correctly after deployment.

---

## 1.1 Azure App Service Created with Azure CLI

The Azure App Service was created using Azure CLI in the script:

```text
azure-setup.ps1
```

The App Service Plan was created with the Free tier:

```powershell
az appservice plan create `
  --name $appServicePlan `
  --resource-group $resourceGroup `
  --location $location `
  --sku F1 `
  --is-linux
```

The Azure Web App / App Service was created with:

```powershell
az webapp create `
  --resource-group $resourceGroup `
  --plan $appServicePlan `
  --name $appName `
  --runtime "DOTNETCORE:8.0"
```

The deployed App Service name is:

```text
zara-profile-api-free-2026
```

The App Service URL is:

```text
https://zara-profile-api-free-2026.azurewebsites.net
```

Swagger is available at:

```text
https://zara-profile-api-free-2026.azurewebsites.net/swagger
```

---

## 1.2 Web API with Entity Framework Core and Database Connection

The project is an ASP.NET Core Web API that uses Entity Framework Core.

The database model is defined in:

```text
Models/Profile.cs
```

The database context is defined in:

```text
Data/AppDbContext.cs
```

The controller is defined in:

```text
Controllers/ProfilesController.cs
```

The project includes an EF Core migration:

```text
Migrations/20260502210046_InitialCreate.cs
```

The migration created the `Profiles` table in Azure SQL Database.

The Azure SQL Database used by the application is:

```text
ZaraProfileDb
```

The Azure SQL Server is:

```text
zara-profile-sql-free26
```

After deployment, the EF Core migration was applied to Azure SQL Database using:

```powershell
dotnet ef database update --connection "Azure SQL connection string"
```

This created the required `Profiles` table in Azure SQL Database.

---

## 1.3 Deployment with GitHub Actions

The API was deployed to Azure App Service using GitHub Actions.

The workflow file is located in:

```text
.github/workflows/deploy.yml
```

The Azure publish profile was stored securely as a GitHub repository secret:

```text
AZURE_WEBAPP_PUBLISH_PROFILE
```

The GitHub Actions workflow was used to automate deployment to Azure App Service.

The workflow completed successfully, and the deployed API was available through Swagger:

```text
https://zara-profile-api-free-2026.azurewebsites.net/swagger
```

---

## 1.4 Testing the Deployed API

The deployed API was tested through Swagger.

The following endpoints were tested:

| Method | Endpoint | Result |
|---|---|---|
| GET | `/api/Profiles` | 200 OK |
| POST | `/api/Profiles` | Profile created successfully |
| GET | `/api/Profiles` | Returned the saved profile |

Example POST body used for testing:

```json
{
  "fullName": "Zara Rangkhoni",
  "title": "Frontend and .NET Cloud Developer",
  "about": "This is a test profile deployed on Azure.",
  "email": "test@example.com",
  "linkedIn": "https://linkedin.com",
  "gitHub": "https://github.com"
}
```

The test confirmed that:

- The API was successfully deployed to Azure App Service.
- Swagger was available online.
- The API endpoints worked.
- The API could save data to Azure SQL Database.
- The API could retrieve saved data from Azure SQL Database.

---

# 2. Azure CLI Verification Commands

This section contains Azure CLI commands that can be copied and executed during the presentation to verify the deployment.

---

## 2.1 Check Current Azure Account

Before running Azure CLI commands, I can check which Azure account and subscription I am using:

```powershell
az account show --output table
```

This confirms that I am logged in to Azure CLI and using the correct Azure subscription.

---

## 2.2 Verify that the Azure App Service Exists

I can verify the Azure App Service using Azure CLI:

```powershell
az webapp show `
  --resource-group "RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg" `
  --name "zara-profile-api-free-2026"
```

This command shows the full configuration of the Azure App Service.

---

## 2.3 Show App Service Status in a Readable Table

To make the output easier to read during the presentation, I can use this command:

```powershell
az webapp show `
  --resource-group "RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg" `
  --name "zara-profile-api-free-2026" `
  --query "{name:name, state:state, enabled:enabled, url:defaultHostName, httpsOnly:httpsOnly}" `
  --output table
```

Expected result:

```text
Name                        State    Enabled    Url                                          HttpsOnly
--------------------------  -------  ---------  -------------------------------------------  ---------
zara-profile-api-free-2026  Running  True       zara-profile-api-free-2026.azurewebsites.net True
```

This confirms that:

- The App Service exists.
- The App Service is running.
- The App Service is enabled.
- The App Service has a public Azure URL.
- HTTPS Only is enabled.

Presentation explanation:

```text
I use Azure CLI to verify that the App Service exists and is running. 
The resource group and app name are the same values that I used in my azure-setup.ps1 script.
```

---

## 2.4 Verify the App Service Plan

The App Service is connected to the App Service Plan `plan-zara-profile-free`.

```powershell
az appservice plan show `
  --resource-group "RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg" `
  --name "plan-zara-profile-free" `
  --query "{name:name, location:location, sku:sku.tier}" `
  --output table
```

Expected result:

```text
Name                    Location        Sku
----------------------  --------------  ----
plan-zara-profile-free  Sweden Central  Free
```

This confirms that:

- The App Service Plan exists.
- It is located in Sweden Central.
- It uses the Free pricing tier.

Presentation explanation:

```text
Here I verify the App Service Plan with Azure CLI. 
The output shows that the plan exists, it is located in Sweden Central, and it uses the Free tier.
```

---

## 2.5 Verify the Azure SQL Database

I can verify that the Azure SQL Database exists using this command:

```powershell
az sql db show `
  --resource-group "RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg" `
  --server "zara-profile-sql-free26" `
  --name "ZaraProfileDb" `
  --query "{name:name, status:status, location:location}" `
  --output table
```

This confirms that the Azure SQL Database exists.

---

## 2.6 Verify the Azure SQL Server

I can verify the Azure SQL Server using:

```powershell
az sql server show `
  --resource-group "RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg" `
  --name "zara-profile-sql-free26" `
  --query "{name:name, location:location, administratorLogin:administratorLogin}" `
  --output table
```

This confirms that the SQL Server exists in the correct resource group.

---

## 2.7 Verify EF Core Migrations Locally

To check the EF Core migrations in the project, I can run:

```powershell
dotnet ef migrations list
```

Expected migration:

```text
20260502210046_InitialCreate
```

This confirms that Entity Framework Core migrations were created.

---

## 2.8 Verify the Deployed Application in Browser

The deployed API can be opened in the browser through Swagger:

```text
https://zara-profile-api-free-2026.azurewebsites.net/swagger
```

In Swagger, I tested:

```text
GET /api/Profiles
POST /api/Profiles
GET /api/Profiles
```

This confirms that the application works correctly after deployment.

---

# 3. Application Insights for Logging and Monitoring

## Requirement

The assignment requires Application Insights to be enabled for logging and monitoring.

Application Insights was created using Azure CLI:

```powershell
az monitor app-insights component create `
  --app $appInsights `
  --location $location `
  --resource-group $resourceGroup `
  --application-type web
```

Application Insights resource:

```text
appi-zara-profile-free
```

The Application Insights connection string was added to the App Service application settings:

```powershell
$appInsightsConnectionString = az monitor app-insights component show `
  --app $appInsights `
  --resource-group $resourceGroup `
  --query connectionString `
  --output tsv

az webapp config appsettings set `
  --resource-group $resourceGroup `
  --name $appName `
  --settings "APPLICATIONINSIGHTS_CONNECTION_STRING=$appInsightsConnectionString"
```

After testing the API through Swagger, I verified that requests were collected in Application Insights Logs.

Examples of logged requests:

```text
GET Profiles/GetProfiles
POST Profiles/CreateProfile
```

The logs showed:

- Request name
- Status code
- Success value
- Response duration

---

## 3.1 Verify Application Insights with Azure CLI

I can verify Application Insights using:

```powershell
az monitor app-insights component show `
  --app "appi-zara-profile-free" `
  --resource-group "RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg" `
  --query "{name:name, location:location, appId:appId}" `
  --output table
```

This confirms that the Application Insights resource exists.

---

## 3.2 Presentation Explanation

```text
Application Insights is connected to my App Service. 
After I tested the API in Swagger, I checked the logs in Azure Portal. 
The logs showed successful GET and POST requests, including status and duration.
```

---

# 4. Basic Security

## Requirement

The assignment requires basic security:

- Restrict access using IP restrictions.
- Enable HTTPS.
- Schedule daily backups.

---

## 4.1 HTTPS Only

HTTPS Only was enabled for the App Service using Azure CLI:

```powershell
az webapp update `
  --resource-group $resourceGroup `
  --name $appName `
  --https-only true
```

This ensures that communication between clients and the application is encrypted.

I can verify HTTPS Only with:

```powershell
az webapp show `
  --resource-group "RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg" `
  --name "zara-profile-api-free-2026" `
  --query "{name:name, httpsOnly:httpsOnly}" `
  --output table
```

Expected result:

```text
Name                        HttpsOnly
--------------------------  ---------
zara-profile-api-free-2026  True
```

---

## 4.2 IP Restriction

IP restriction was configured to allow only my current public IP address:

```text
80.217.192.54/32
```

The rule name is:

```text
AllowMyIP
```

The default action was set to Deny, which means all other IP addresses are blocked by default.

Example Azure CLI command for IP restriction:

```powershell
az webapp config access-restriction add `
  --resource-group "RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg" `
  --name "zara-profile-api-free-2026" `
  --rule-name "AllowMyIP" `
  --action Allow `
  --ip-address "80.217.192.54/32" `
  --priority 100
```

Command to verify IP restrictions:

```powershell
az webapp config access-restriction show `
  --resource-group "RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg" `
  --name "zara-profile-api-free-2026" `
  --output table
```

Important note:

```text
If the teacher needs to test the API from another network, that IP address must also be added to the allow list.
```

---

## 4.3 Backup Limitation

The assignment requires daily backups.

However, App Service Backup is not supported in the Free tier.

This project was created as a cost-aware student solution using the Free tier. Therefore, daily backup could not be configured without upgrading to a paid App Service tier.

This limitation was documented.

My teacher confirmed that documenting this limitation was acceptable.

Explanation:

```text
App Service Backup is not available in the Free tier. 
Because this is a student project and the goal was to avoid unnecessary cost, I documented this limitation instead of upgrading to a paid tier.
```

---

# 5. Azure Storage Account

## Requirement

The assignment requires using an Azure Storage Account for static resources or log files.

A Storage Account was created using Azure CLI:

```powershell
az storage account create `
  --name $storageAccount `
  --resource-group $resourceGroup `
  --location $location `
  --sku Standard_LRS
```

Storage Account name:

```text
zaraprofilestfree26
```

The Storage Account was created to prepare storage for static files or exported logs.

Because the API is a simple profile API and does not require user-uploaded files, the Storage Account was mainly created as part of the Azure infrastructure and can be used for storing exported logs or static resources.

---

## 5.1 Verify Storage Account

I can verify the Storage Account using:

```powershell
az storage account show `
  --resource-group "RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg" `
  --name "zaraprofilestfree26" `
  --query "{name:name, location:location, sku:sku.name, kind:kind}" `
  --output table
```

This confirms that the Storage Account exists.

---

# 6. Azure Key Vault and Managed Identity

## Requirement

The assignment requires using Azure Key Vault to handle sensitive information, such as API keys or connection strings, using Managed Identity.

A Key Vault was created using Azure CLI:

```powershell
az keyvault create `
  --name $keyVault `
  --resource-group $resourceGroup `
  --location $location
```

Key Vault name:

```text
kv-zara-prof-free26
```

Managed Identity was enabled for the App Service using:

```powershell
az webapp identity assign `
  --name $appName `
  --resource-group $resourceGroup
```

The goal was to store the SQL connection string in Key Vault:

```powershell
az keyvault secret set `
  --vault-name $keyVault `
  --name "SqlConnectionString" `
  --value $connectionString
```

However, saving the SQL connection string as a Key Vault secret failed with:

```text
ForbiddenByRbac
```

This happened because my Azure account did not have permission to create secrets inside the Key Vault.

Therefore, the infrastructure for Key Vault and Managed Identity was created, but the full Key Vault secret integration could not be completed because of RBAC permission limitations.

This limitation was documented.

---

## 6.1 Verify Key Vault

I can verify the Key Vault using:

```powershell
az keyvault show `
  --resource-group "RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg" `
  --name "kv-zara-prof-free26" `
  --query "{name:name, location:location, vaultUri:properties.vaultUri}" `
  --output table
```

This confirms that the Key Vault exists.

---

## 6.2 Verify Managed Identity

I can verify the Managed Identity for the App Service using:

```powershell
az webapp identity show `
  --resource-group "RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg" `
  --name "zara-profile-api-free-2026" `
  --output table
```

This confirms that Managed Identity is enabled for the App Service.

---

## 6.3 Presentation Explanation

```text
I created a Key Vault and enabled Managed Identity for the App Service. 
The goal was to store the SQL connection string in Key Vault. 
However, creating the secret failed because my student Azure account did not have RBAC permission to create secrets. 
I documented this limitation and used App Service application settings for the connection string instead.
```

---

# 7. App Service Application Settings

The SQL connection string was added to the App Service application settings using Azure CLI:

```powershell
az webapp config appsettings set `
  --resource-group $resourceGroup `
  --name $appName `
  --settings "ConnectionStrings__DefaultConnection=$connectionString"
```

The Application Insights connection string was also added to App Service application settings:

```powershell
az webapp config appsettings set `
  --resource-group $resourceGroup `
  --name $appName `
  --settings "APPLICATIONINSIGHTS_CONNECTION_STRING=$appInsightsConnectionString"
```

---

## 7.1 Verify App Settings

I can verify the App Service settings using:

```powershell
az webapp config appsettings list `
  --resource-group "RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg" `
  --name "zara-profile-api-free-2026" `
  --output table
```

Note:

```text
Connection strings and secrets should not be shared publicly.
```

---

# 8. Azure Setup Script

The Azure resources were scripted in:

```text
azure-setup.ps1
```

The script includes:

- Variables for resource names
- App Service Plan creation
- App Service creation
- HTTPS Only configuration
- Azure SQL Server creation
- Azure SQL Database creation
- SQL firewall rule
- Storage Account creation
- Key Vault creation
- Managed Identity assignment
- Application Insights creation
- App Service application settings
- Application Insights connection to App Service
- IP restriction command
- Notes about backup limitation

---

# 9. Requirement Checklist

| Requirement | Status | Explanation |
|---|---|---|
| Create Azure App Service via Azure CLI | Completed | App Service `zara-profile-api-free-2026` was created using Azure CLI. |
| Create App Service Plan via Azure CLI | Completed | App Service Plan `plan-zara-profile-free` was created using Azure CLI. |
| Create Web API with EF Core database | Completed | ASP.NET Core Web API uses Entity Framework Core and Azure SQL Database. |
| Automated deployment | Completed | GitHub Actions deploys the API to Azure App Service. |
| Confirm deployed app works | Completed | Swagger was tested and GET/POST endpoints worked successfully. |
| Application Insights | Completed | Requests were visible in Application Insights Logs. |
| HTTPS Only | Completed | HTTPS Only was enabled for the App Service. |
| IP restriction | Completed | Only my public IP address was allowed. |
| Daily backups | Documented limitation | App Service Backup is not supported in the Free tier. Teacher confirmed this limitation is acceptable. |
| Storage Account | Completed | Storage Account was created for static resources or exported logs. |
| Key Vault + Managed Identity | Partially completed / documented limitation | Key Vault and Managed Identity were created, but saving secrets failed because of RBAC permission limitation. |
| Azure CLI script | Completed | Azure resources were scripted in `azure-setup.ps1`. |

---

# 10. Final Status

The API is deployed and working on Azure App Service.

The application can:

- Save profile data
- Retrieve profile data
- Connect to Azure SQL Database
- Run online through Azure App Service
- Be tested through Swagger
- Be deployed automatically with GitHub Actions
- Be monitored with Application Insights

Security was configured using:

- HTTPS Only
- IP restriction
- Managed Identity

Some limitations were documented:

- App Service Backup is not supported in the Free tier.
- Key Vault secret creation failed because of RBAC permission limitations.

The project demonstrates:

- Azure App Service deployment
- EF Core database connection
- Azure SQL Database
- Automated deployment with GitHub Actions
- Basic security configuration
- Monitoring with Application Insights
- Azure Storage Account creation
- Cost-aware Azure configuration
- Step-by-step documentation