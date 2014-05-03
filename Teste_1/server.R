library(WDI)
library(reshape2)
library(maptools)
library(RColorBrewer)
library(shiny)


d <- WDI_data[[2]]
countries <- d[d[, 'region'] != "Aggregates", 'iso2c']

# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {

  # Return the requested dataset
  indInput <- reactive({
    switch(input$indicator,
           "Populacao rural" = "SP.RUR.TOTL.ZS",
           "Concentracao CO2" = "EN.ATM.CO2E.PC")
  })

  yInput <- reactive({
    as.integer(input$year)
  })

  # Generate a summary of the dataset
  output$view <- renderTable({
    dataset <- WDI(countries, indInput(), yInput(), yInput())
    #dataset <- dcast(dataset, iso2c ~ year, value.var = names(dataset)[3])
    head(dataset, 10)
  })
})