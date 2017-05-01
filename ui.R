#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(markdown)
library(DT)

navbarPage("European economic integration: PCA and clustering",
           tabPanel("Graphs",
                    sidebarLayout(
                      sidebarPanel(
                        sliderInput("year_select",
                                    "Year:",
                                    min = 1995,
                                    max = 2014,
                                    value = 2014),
                        sliderInput("k",
                                    "Number of clusters:",
                                    min = 1,
                                    max = 8,
                                    value = 5),
                        checkboxGroupInput("variables", "Variables:", c("GDP" = "GDP", "GDP growth" = "gdp_growth", 
                                                                        "Average annual wage" = "average_annual_wage", "CPI inflation" = "cpi",
                                                                        "Current Account Balance" = "current_account_balance",
                                                                        "Productivity" = "productivity", "Unemployment rate" = "unemployment_rate",
                                                                        "Gross Expenditure on R&D (GERD)" = "GERD", 
                                                                        "Government fiscal balance" = "govt_fiscal_balance", 
                                                                        "Government debt" = "govt_debt", 
                                                                        "Current account flows" = "current_account_flows", 
                                                                        "Investment flows" = "investment_flows"),
                                           selected = c("GDP", "gdp_growth", "average_annual_wage", "cpi",
                                                        "current_account_balance", "unemployment_rate",
                                                        "govt_fiscal_balance", "govt_debt", "current_account_flows"))
                      ),
                      mainPanel(
                        plotOutput("pca_plot"),
                        plotOutput("dendrogram")
                      ))
           ),
           tabPanel("Map",
                      mainPanel(
                        plotOutput("map")
                      )
           ),
           tags$head(tags$style(HTML('
                                     .irs-bar {
                                     background: #fb370b;
                                     border-top:#fb370b;
                                     border-bottom:#fb370b;
                                     }
                                     .irs-bar-edge {
                                     border: #fb370b;
                                     background: #fb370b;
                                     
                                     }
                                     .irs-single {
                                     background: #fb370b;
                                     }
                                     
                                     '))),
           tabPanel("Report",
                    includeHTML("Report.html")
           ))
