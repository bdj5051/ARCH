# Copyright 2020 Observational Health Data Sciences and Informatics
#
# This file is part of ARCHv7
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Format and check code ---------------------------------------------------
OhdsiRTools::formatRFolder()
OhdsiRTools::checkUsagePackage("ARCHv7")
OhdsiRTools::updateCopyrightYearFolder()
devtools::spell_check()

# Create manual -----------------------------------------------------------
unlink("extras/ARCHv7.pdf")
shell("R CMD Rd2pdf ./ --output=extras/ARCHv7.pdf")

# Create vignettes ---------------------------------------------------------
rmarkdown::render("vignettes/UsingSkeletonPackage.Rmd",
                  output_file = "../inst/doc/UsingSkeletonPackage.pdf",
                  rmarkdown::pdf_document(latex_engine = "pdflatex",
                                          toc = TRUE,
                                          number_sections = TRUE))

rmarkdown::render("vignettes/DataModel.Rmd",
                  output_file = "../inst/doc/DataModel.pdf",
                  rmarkdown::pdf_document(latex_engine = "pdflatex",
                                          toc = TRUE,
                                          number_sections = TRUE))

# Insert cohort definitions from ATLAS into package -----------------------
ROhdsiWebApi::insertCohortDefinitionSetInPackage(fileName = "CohortsToCreate.csv",
                                                 baseUrl = Sys.getenv("baseUrl"),
                                                 insertTableSql = TRUE,
                                                 insertCohortCreationR = TRUE,
                                                 generateStats = FALSE,
                                                 packageName = "ARCHv7")

# Create analysis details -------------------------------------------------
source("extras/CreateStudyAnalysisDetails.R")
createAnalysesDetails("inst/settings/")
createPositiveControlSynthesisArgs("inst/settings/")

# Store environment in which the study was executed -----------------------
OhdsiRTools::createRenvLockFile("ARCHv7")
