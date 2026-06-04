# ZaraProfileApi

ZaraProfileApi is an ASP.NET Core Web API created for an Azure deployment assignment. The API manages profile information and is connected to an Azure SQL Database using Entity Framework Core.

## Technologies

* ASP.NET Core Web API
* Entity Framework Core
* Azure SQL Database
* Azure App Service
* GitHub Actions
* Application Insights
* Azure Storage Account
* Swagger

## Azure Deployment

The application is deployed to Azure App Service:

https://zara-profile-api-free-2026.azurewebsites.net/swagger

## Main Features

* CRUD API for profile data
* Azure SQL Database connection
* Swagger for API testing
* Automated deployment with GitHub Actions
* Application monitoring with Application Insights
* HTTPS enabled
* IP access restriction configured
* Azure Storage Account used for static files/log files

## Documentation

Full deployment documentation is available in the Word document:

`ZaraProfileApi_Azure_Deployment_Documentation.docx`

## Project Structure

```text
ZaraProfileApi
├── Controllers
├── Data
├── Models
├── Migrations
├── Program.cs
├── appsettings.json
├── README.md
└── ZaraProfileApi_Azure_Deployment_Documentation.docx
```

## Status

The Web API is deployed and working on Azure App Service.
