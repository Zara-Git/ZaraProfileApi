# ===============================
# Azure setup for ZaraProfileApi
# Low-cost / class version
# ===============================

# Variables
$resourceGroup = "RG-Zara-Rangkhoni-e8ef10-DotNetCloudDeveloper-VT-Mars-Goteborg"
$location = "swedencentral"

$appServicePlan = "plan-zara-profile-free"
$appName = "zara-profile-api-free-2026"

$sqlServer = "zara-profile-sql-free26"
$sqlDatabase = "ZaraProfileDb"
$sqlAdmin = "sqladminuser"

$sqlPassword = Read-Host "Enter SQL admin password"
$storageAccount = "zaraprofilestfree26"
$keyVault = "kv-zara-prof-free26"
$appInsights = "appi-zara-profile-free"

# 1. Use existing school Resource Group
Write-Host "Using existing resource group: $resourceGroup"

# 2. Create App Service Plan - Free tier
az appservice plan create `
  --name $appServicePlan `
  --resource-group $resourceGroup `
  --location $location `
  --sku F1 `
  --is-linux

# 3. Create Azure App Service / Web App
az webapp create `
  --resource-group $resourceGroup `
  --plan $appServicePlan `
  --name $appName `
  --runtime "DOTNETCORE:8.0"

# 4. Enable HTTPS Only
az webapp update `
  --resource-group $resourceGroup `
  --name $appName `
  --https-only true

# 5. Create Azure SQL Server
az sql server create `
  --name $sqlServer `
  --resource-group $resourceGroup `
  --location $location `
  --admin-user $sqlAdmin `
  --admin-password $sqlPassword

# 6. Create Azure SQL Database
# Note: Basic is used for CLI scripting. If a strictly free SQL offer is required,
# it can be created manually in Azure Portal and documented.
az sql db create `
  --resource-group $resourceGroup `
  --server $sqlServer `
  --name $sqlDatabase `
  --service-objective Basic

# 7. Allow Azure services to access SQL Server
az sql server firewall-rule create `
  --resource-group $resourceGroup `
  --server $sqlServer `
  --name AllowAzureServices `
  --start-ip-address 0.0.0.0 `
  --end-ip-address 0.0.0.0

# 8. Create Storage Account
az storage account create `
  --name $storageAccount `
  --resource-group $resourceGroup `
  --location $location `
  --sku Standard_LRS

# 9. Create Key Vault
az keyvault create `
  --name $keyVault `
  --resource-group $resourceGroup `
  --location $location

# 10. Enable Managed Identity for App Service
az webapp identity assign `
  --name $appName `
  --resource-group $resourceGroup

# 11. Create Application Insights
# If Azure CLI asks to install the application-insights extension, answer Y.
az monitor app-insights component create `
  --app $appInsights `
  --location $location `
  --resource-group $resourceGroup `
  --application-type web

# 12. SQL connection string
$connectionString = "Server=tcp:$sqlServer.database.windows.net,1433;Initial Catalog=$sqlDatabase;Persist Security Info=False;User ID=$sqlAdmin;Password=$sqlPassword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"

# 13. Try to save SQL connection string in Key Vault
# If this fails with ForbiddenByRbac, document the permission issue.
az keyvault secret set `
  --vault-name $keyVault `
  --name "SqlConnectionString" `
  --value $connectionString

if ($LASTEXITCODE -ne 0) {
  Write-Host "Key Vault secret could not be created. Possible reason: ForbiddenByRbac / missing permission to create secrets."
  Write-Host "This limitation must be documented in README."
}

# 14. Add connection string to App Service settings
az webapp config appsettings set `
  --resource-group $resourceGroup `
  --name $appName `
  --settings "ConnectionStrings__DefaultConnection=$connectionString"

# 15. Connect Application Insights to App Service
$appInsightsConnectionString = az monitor app-insights component show `
  --app $appInsights `
  --resource-group $resourceGroup `
  --query connectionString `
  --output tsv

az webapp config appsettings set `
  --resource-group $resourceGroup `
  --name $appName `
  --settings "APPLICATIONINSIGHTS_CONNECTION_STRING=$appInsightsConnectionString"

# 16. Add IP restriction
$myIp = "80.217.192.54/32"

az webapp config access-restriction add `
  --resource-group $resourceGroup `
  --name $appName `
  --rule-name "AllowMyIP" `
  --action Allow `
  --ip-address $myIp `
  --priority 100

# 17. Note about backup
Write-Host "Backup note: App Service backup is not supported in Free tier. Document this limitation."

# 18. Final URL
Write-Host "Azure setup completed!"
Write-Host "App URL: https://$appName.azurewebsites.net"