library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Teste - Mapas tematicos"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    selectInput("indicator", 
                "Indicador:", 
                choices = c("Populacao rural", "Concentracao CO2")),
    selectInput("year", 
                "Ano:", 
                choices = paste(2005:2011))
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("plot", width = "100%")
  )
))