#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$pca_plot <- renderPlot({

    macro_pca <- source("macro_convergence.R")
    macro_pca(year_select = input$year_select, k = input$k, 
              variables = input$variables)$pca_plot      
  })
  
  output$dendrogram <- renderPlot({
    
    macro_pca <- source("macro_convergence.R")
    macro_pca(year_select = input$year_select, k = input$k, 
              variables = input$variables)$dendrogram     
  })
  
  output$map <- renderPlot({
    
    macro_pca <- source("macro_convergence.R")
    macro_pca(year_select = input$year_select, k = input$k, 
              variables = input$variables)$map     
  })
  
})
