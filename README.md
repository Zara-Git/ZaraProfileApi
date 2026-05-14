# ZaraProfileApi

## Project Overview

ZaraProfileApi is a simple ASP.NET Core Web API created for the Azure App Service deployment assignment.

The API manages profile information such as full name, title, about text, email, LinkedIn and GitHub links. The project uses Entity Framework Core for database connection and Swagger for testing the API endpoints.

The main goal of this project is to demonstrate how to create, test and deploy a working Web API to Azure App Service using Azure CLI, Azure SQL Database, Application Insights, Storage Account, Key Vault, Managed Identity and GitHub Actions.

---

## Project URLs

### Local development URL

The API was tested locally with Swagger using:

```text
https://localhost:7083/swagger
```

The local API also listened on:

```text
https://localhost:7083
http://localhost:5217
```

### Azure App Service URL

The Azure App Service was created with the following URL:

```text
https://zara-profile-api-free-2026.azurewebsites.net
```

After deployment, Swagger should be available at:

```text
https://zara-profile-api-free-2026.azurewebsites.net/swagger
```

### API Endpoints on Azure

After deployment, the API endpoints will be available here:

```text
GET     https://zara-profile-api-free-2026.azurewebsites.net/api/Profiles
POST    https://zara-profile-api-free-2026.azurewebsites.net/api/Profiles
GET     https://zara-profile-api-free-2026.azurewebsites.net/api/Profiles/{id}
PUT     https://zara-profile-api-free-2026.azurewebsites.net/api/Profiles/{id}
DELETE  https://zara-profile-api-free-2026.azurewebsites.net/api/Profiles/{id}
```

---

## Technologies Used

- ASP.NET Core Web API
- .NET 8
- Entity Framework Core
- SQL Server / Azure SQL Database
- Swagger / OpenAPI
- Azure App Service
- Azure App Service Plan
- Azure SQL Server
- Azure SQL Database
- Azure Storage Account
- Azure Key Vault
- Managed Identity
- Application Insights
- Azure CLI
- GitHub Actions

---

## Project Structure

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
│   └── InitialCreate
│
├── Models
│   └── Profile.cs
│
├── appsettings.json
├── Program.cs
├── ZaraProfileApi.csproj
├── ZaraProfileApi.http
└── azure-setup.ps1
```

---

## Model

The API uses a `Profile` model.

```csharp
namespace ZaraProfileApi.Models;

public class Profile
{
    public int Id { get; set; }

    public string FullName { get; set; } = string.Empty;

    public string Title { get; set; } = string.Empty;

    public string About { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;

    public string LinkedIn { get; set; } = string.Empty;

    public string GitHub { get; set; } = string.Empty;
}
```

---

## Database Context

Entity Framework Core is used to connect the API to a SQL database.

```csharp
using Microsoft.EntityFrameworkCore;
using ZaraProfileApi.Models;

namespace ZaraProfileApi.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public DbSet<Profile> Profiles { get; set; }
}
```

---

## API Endpoints

The API contains the following endpoints:

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/Profiles` | Get all profiles |
| GET | `/api/Profiles/{id}` | Get one profile by ID |
| POST | `/api/Profiles` | Create a new profile |
| PUT | `/api/Profiles/{id}` | Update an existing profile |
| DELETE | `/api/Profiles/{id}` | Delete a profile |

---

## Local Development

### 1. Create the Web API project

The project was created as an ASP.NET Core Web API project in Visual Studio.

The project was later changed to use:

```xml
<TargetFramework>net8.0</TargetFramework>
```

This was done to make the project more compatible with Azure App Service.

---

### 2. Install required NuGet packages

The following packages were used:

```xml
<PackageReference Include="Microsoft.EntityFrameworkCore.Design" Version="8.0.7" />
<PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="8.0.7" />
<PackageReference Include="Microsoft.EntityFrameworkCore.Tools" Version="8.0.7" />
<PackageReference Include="Swashbuckle.AspNetCore" Version="6.6.2" />
```

---

### 3. Configure local database connection

In `appsettings.json`, a local SQL Server LocalDB connection string was added:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\MSSQLLocalDB;Database=ZaraProfileDb;Trusted_Connection=True;MultipleActiveResultSets=True;TrustServerCertificate=True;"
  },

  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },

  "AllowedHosts": "*"
}
```

---

### 4. Configure Program.cs

The database context and Swagger were configured in `Program.cs`.

```csharp
using Microsoft.EntityFrameworkCore;
using ZaraProfileApi.Data;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
```

---

### 5. Create and apply database migration

The database migration was created using Entity Framework Core.

In Package Manager Console:

```powershell
Add-Migration InitialCreate
Update-Database
```

The database was successfully created and updated.

The output confirmed:

```text
The database is already up to date.
Done.
```

---

## Local Testing with Swagger

The API was tested locally using Swagger.

The application was running on:

```text
https://localhost:7083/swagger
```

### POST test

A new profile was created using:

```json
{
  "fullName": "Zara Rangkhoni",
  "title": "Frontend & .NET Cloud Developer",
  "about": "I am a developer with a background in frontend, UI/UX and cloud development.",
  "email": "zara@example.com",
  "linkedIn": "https://www.linkedin.com/in/your-profile",
  "gitHub": "https://github.com/your-username"
}
```

The API returned:

```text
201 Created
```

This confirmed that the API could save data to the database.

### GET test

The endpoint:

```text
GET /api/Profiles
```

returned:

```json
[
  {
    "id": 1,
    "fullName": "Zara Rangkhoni",
    "title": "Frontend & .NET Cloud Developer",
    "about": "I am a developer with a background in frontend, UI/UX and cloud development.",
    "email": "zara@example.com",
    "linkedIn": "https://www.linkedin.com/in/your-profile",
    "gitHub": "https://github.com/your-username"
  }
]
```

The API returned:

```text
200 OK
```

This confirmed that the API could read data from the database.

---

## Azure Setup

Azure resources were created using Azure CLI, as required by the assignment.

The school provided an Azure subscription and resource group.

### Azure subscription

```text
SUB-Utbildning-DotNetCloudDeveloper-2026-VT-Mars-Goteborg
```

### Resource group

```text
RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg
```

The resource group already existed and was provided by the school. Therefore, the script does not create a new resource group.

---

## Azure CLI Installation and Login

Azure CLI was installed using PowerShell:

```powershell
winget install --exact --id Microsoft.AzureCLI
```

After installation, Azure CLI was verified with:

```powershell
az --version
```

Login was done using:

```powershell
az login --use-device-code
```

The active Azure account was checked with:

```powershell
az account show
```

---

## Azure Resources Created

The following Azure resources were created for this project:

| Resource | Name | Purpose |
|---|---|---|
| App Service Plan | `plan-zara-profile-free` | Hosts the App Service using Free tier |
| App Service | `zara-profile-api-free-2026` | Hosts the Web API |
| Azure SQL Server | `zara-profile-sql-free26` | SQL server for the database |
| Azure SQL Database | `ZaraProfileDb` | Stores profile data |
| Storage Account | `zaraprofilestfree26` | Used for static files or logs |
| Key Vault | `kv-zara-prof-free26` | Intended for storing secrets |
| Application Insights | `appi-zara-profile-free` | Monitoring and logging |
| Managed Identity | Enabled on App Service | Used for secure Azure resource access |

---

## Azure Setup Script

The Azure resources were created using the script:

```text
azure-setup.ps1
```

The script creates the Azure resources, enables HTTPS, configures App Service settings and connects Application Insights.

Important variables in the script:

```powershell
$resourceGroup = "RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg"
$location = "swedencentral"

$appServicePlan = "plan-zara-profile-free"
$appName = "zara-profile-api-free-2026"

$sqlServer = "zara-profile-sql-free26"
$sqlDatabase = "ZaraProfileDb"

$storageAccount = "zaraprofilestfree26"
$keyVault = "kv-zara-prof-free26"
$appInsights = "appi-zara-profile-free"
```

The App Service Plan was created using the Free tier:

```powershell
az appservice plan create `
  --name $appServicePlan `
  --resource-group $resourceGroup `
  --location $location `
  --sku F1 `
  --is-linux
```

The Web App was created using:

```powershell
az webapp create `
  --resource-group $resourceGroup `
  --plan $appServicePlan `
  --name $appName `
  --runtime "DOTNETCORE:8.0"
```

HTTPS only was enabled:

```powershell
az webapp update `
  --resource-group $resourceGroup `
  --name $appName `
  --https-only true
```

Azure SQL Server and database were created:

```powershell
az sql server create `
  --name $sqlServer `
  --resource-group $resourceGroup `
  --location $location `
  --admin-user $sqlAdmin `
  --admin-password $sqlPassword

az sql db create `
  --resource-group $resourceGroup `
  --server $sqlServer `
  --name $sqlDatabase `
  --service-objective Basic
```

A Storage Account was created:

```powershell
az storage account create `
  --name $storageAccount `
  --resource-group $resourceGroup `
  --location $location `
  --sku Standard_LRS
```

A Key Vault was created:

```powershell
az keyvault create `
  --name $keyVault `
  --resource-group $resourceGroup `
  --location $location
```

Managed Identity was enabled:

```powershell
az webapp identity assign `
  --name $appName `
  --resource-group $resourceGroup
```

Application Insights was created:

```powershell
az monitor app-insights component create `
  --app $appInsights `
  --location $location `
  --resource-group $resourceGroup `
  --application-type web
```

The SQL connection string was added to App Service application settings:

```powershell
az webapp config appsettings set `
  --resource-group $resourceGroup `
  --name $appName `
  --settings "ConnectionStrings__DefaultConnection=$connectionString"
```

Application Insights connection string was added to App Service application settings:

```powershell
az webapp config appsettings set `
  --resource-group $resourceGroup `
  --name $appName `
  --settings "APPLICATIONINSIGHTS_CONNECTION_STRING=$appInsightsConnectionString"
```

---

## Azure Setup Result

The script completed and returned:

```text
Azure setup completed!
App URL: https://zara-profile-api-free-2026.azurewebsites.net
```

The resources were confirmed using:

```powershell
az resource list --resource-group RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg -o table
```

The following project resources were created:

```text
plan-zara-profile-free
zara-profile-api-free-2026
zara-profile-sql-free26
ZaraProfileDb
zaraprofilestfree26
kv-zara-prof-free26
appi-zara-profile-free
```

---

## Cost-Aware Setup

To avoid unnecessary cost in the school subscription, the App Service Plan was created using Free tier:

```text
LinuxFree
```

The script also prints this note:

```text
Backup note: App Service backup is not supported in Free tier. Document this limitation or ask teacher if temporary Basic tier is required.
```

This was done because the assignment requires daily backups, but App Service Backup is not supported in the Free tier.

---

## Key Vault Limitation

The Key Vault was created successfully. However, saving the SQL connection string as a secret failed with the following error:

```text
ForbiddenByRbac
```

This means that the Azure account did not have permission to create secrets inside the Key Vault.

The Key Vault resource was created, but the secret could not be stored because of RBAC permission limitations.

This limitation should be documented in the assignment report.

Explanation:

```text
I created Azure Key Vault using Azure CLI. However, when I tried to store the SQL connection string as a secret, the command failed with ForbiddenByRbac. This means my account did not have permission to set secrets in Key Vault. I documented this limitation because the resource was created successfully, but the secret could not be added due to RBAC permissions.
```

---

## Backup Limitation

The assignment requires daily backups of the App Service. However, this project was created using Free tier to avoid unnecessary cost in the school subscription.

App Service Backup is not supported in the Free tier.

Therefore, this limitation was documented instead of upgrading the App Service Plan to a paid tier.

Explanation:

```text
I attempted to configure daily backup for the App Service. However, the Free tier does not support App Service backup. To avoid unnecessary cost in the school subscription, I documented this limitation instead of upgrading the plan.
```

---

## Deployment Plan

The next step is to deploy the API code to Azure App Service using GitHub Actions.

The deployment target is:

```text
https://zara-profile-api-free-2026.azurewebsites.net
```

After the API is deployed, Swagger should be available at:

```text
https://zara-profile-api-free-2026.azurewebsites.net/swagger
```

GitHub Actions will be configured with a workflow file:

```text
.github/workflows/deploy.yml
```

The deployment will use the Azure App Service publish profile stored as a GitHub secret:

```text
AZURE_WEBAPP_PUBLISH_PROFILE
```

---

## Planned GitHub Actions Workflow

The planned GitHub Actions workflow will build and deploy the API to Azure App Service.

```yaml
name: Deploy ZaraProfileApi to Azure App Service

on:
  push:
    branches:
      - main

jobs:
  build-and-deploy:
    runs-on: windows-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up .NET 8
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: '8.0.x'

      - name: Restore
        run: dotnet restore

      - name: Build
        run: dotnet build --configuration Release --no-restore

      - name: Publish
        run: dotnet publish --configuration Release --output ./publish

      - name: Deploy to Azure Web App
        uses: azure/webapps-deploy@v3
        with:
          app-name: zara-profile-api-free-2026
          publish-profile: ${{ secrets.AZURE_WEBAPP_PUBLISH_PROFILE }}
          package: ./publish
```

---

## Cleanup

Azure resources can generate cost or use school subscription credits. Therefore, old resources should be removed after testing.

To list resources:

```powershell
az resource list --resource-group RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg -o table
```

To delete the project resources after testing:

```powershell
az webapp delete --name zara-profile-api-free-2026 --resource-group RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg
```

```powershell
az appservice plan delete --name plan-zara-profile-free --resource-group RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg --yes
```

```powershell
az sql server delete --name zara-profile-sql-free26 --resource-group RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg --yes
```

```powershell
az storage account delete --name zaraprofilestfree26 --resource-group RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg --yes
```

```powershell
az keyvault delete --name kv-zara-prof-free26 --resource-group RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg
```

```powershell
az resource delete --name appi-zara-profile-free --resource-group RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg --resource-type "Microsoft.Insights/components"
```

---

## Current Status

### Completed

- ASP.NET Core Web API created
- Entity Framework Core configured
- Local SQL database created
- Migration created and applied
- Swagger tested locally
- POST endpoint tested successfully
- GET endpoint tested successfully
- Azure CLI installed
- Azure login completed
- School Azure subscription selected
- Azure resources created with Azure CLI
- App Service Plan created using Free tier
- App Service created
- Azure SQL Server and Database created
- Storage Account created
- Key Vault created
- Managed Identity enabled
- Application Insights created
- HTTPS Only enabled
- Cleanup commands tested

### Remaining

- Configure GitHub Actions deployment
- Add Azure publish profile as GitHub secret
- Deploy API to Azure App Service
- Run database migration against Azure SQL
- Test deployed API in Swagger
- Add IP restriction
- Document Application Insights logs
- Document backup limitation
- Finalize assignment report

---

## Reflection

This project helped me understand the full process of creating and deploying a Web API to Azure App Service.

I learned how to:

- Build an ASP.NET Core Web API
- Use Entity Framework Core with SQL Server
- Test API endpoints with Swagger
- Create Azure resources using Azure CLI
- Work with Azure App Service
- Configure Azure SQL Database
- Use Azure Storage Account
- Create Azure Key Vault
- Enable Managed Identity
- Connect Application Insights
- Understand Azure RBAC permission issues
- Clean up Azure resources after testing

The project also showed the importance of cost awareness when working with cloud resources, especially in an educational subscription.


IP restriction was configured to allow only my current public IP address. This demonstrates how access to the App Service can be limited for security reasons.
IP restriction was configured to allow only my current public IP address: 80.217.192.54/32. All other IP addresses are denied by default. If the teacher needs to test the API from another network, that IP address must also be added to the allow list.