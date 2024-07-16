ARCHv6
==============================


Requirements
============

- A database in [Common Data Model version 5](https://github.com/OHDSI/CommonDataModel) in one of these platforms: SQL Server, Oracle, PostgreSQL, IBM Netezza, Apache Impala, Amazon RedShift, Google BigQuery, or Microsoft APS.
- R version 3.5.0 or newer
- On Windows: [RTools](http://cran.r-project.org/bin/windows/Rtools/)
- [Java](http://java.com)
- 25 GB of free disk space

How to run
==========
1. Follow [these instructions](https://ohdsi.github.io/Hades/rSetup.html) for seting up your R environment, including RTools and Java. 

2. Open your study package in RStudio. Use the following code to install all the dependencies:

	```r
	renv::restore()
	```

3. In RStudio, select 'Build' then 'Install and Restart' to build the package.

3. Once installed, you can execute the study by modifying and using the code below. For your convenience, this code is also provided under `extras/CodeToRun.R`:

	```r
	library(ARCHv6)
	
  # Maximum number of cores to be used:
	maxCores <- parallel::detectCores()
	
	# The folder where the study intermediate and result files will be written:
	outputFolder <- "./outputFolder"

	# Optional: specify where the temporary files (used by the Andromeda package) will be created:
	options(andromedaTempFolder = file.path(outputFolder, "andromedaTemp"))

	
	# Details for connecting to the server:
	# See ?DatabaseConnector::createConnectionDetails for help
	connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = "postgresql",
									server = "some.server.com/ohdsi",
									user = "joe",
									password = "secret")
	
	# The name of the database schema where the CDM data can be found:
	cdmDatabaseSchema <- "CDM_IBM_MDCD_V1153.dbo"
	
	# The name of the database schema and table where the study-specific cohorts will be instantiated:
	cohortDatabaseSchema <- "scratch.dbo"
	cohortTable <- "ARCH_v1"
	
	# Some meta-information that will be used by the export function:
	databaseId <- "Synpuf" # AMC or KUMC
	
	# For Oracle: define a schema that can be used to emulate temp tables:
	oracleTempSchema <- NULL
	
	# For Oracle: define a schema that can be used to emulate temp tables:
	oracleTempSchema <- NULL
	
	execute(connectionDetails = connectionDetails,
	        cdmDatabaseSchema = cdmDatabaseSchema,
	        cohortDatabaseSchema = cohortDatabaseSchema,
	        cohortTable = cohortTable,
	        oracleTempSchema = oracleTempSchema,
	        outputFolder = outputFolder,
	        databaseId = databaseId,
	        databaseName = databaseId,
	        databaseDescription = databaseId,
	        createCohorts = TRUE,
	        synthesizePositiveControls = FALSE,
	        runAnalyses = TRUE,
	        packageResults = TRUE,
	        maxCores = maxCores)
	```

4. Upload the file ```export/Results_<DatabaseId>.zip``` in the output folder to the study coordinator:

		
5. To view the results, use the Shiny app:

	```r
	prepareForEvidenceExplorer("Result_<databaseId>.zip", "/shinyData")
	launchEvidenceExplorer("/shinyData", blind = TRUE)
	```
  
  Note that you can save plots from within the Shiny app. It is possible to view results from more than one database by applying `prepareForEvidenceExplorer` to the Results file from each database, and using the same data folder. Set `blind = FALSE` if you wish to be unblinded to the final results.

License
=======
The ARCHv6 package is licensed under Apache License 2.0

Development
===========
ARCHv6 was developed in ATLAS and R Studio.

### Development status

Unknown
