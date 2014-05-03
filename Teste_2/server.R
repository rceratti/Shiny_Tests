library(WDI)
library(reshape2)
library(maptools)
library(RColorBrewer)
library(shiny)


d <- WDI_data[[2]]
countries <- d[d[, 'region'] != "Aggregates", 'iso2c']


wrl <- readShapePoly("C:/Users/b2415110/Downloads/TM_WORLD_BORDERS_SIMPL-0.3/TM_WORLD_BORDERS_SIMPL-0.3.shp")

wrl.data <- wrl@data
wrl.data$indice <- 1:nrow(wrl.data)

wrl.data$ISO2 <- paste(wrl.data$ISO2)


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
  output$plot <- renderPlot({
    x <- WDI(countries, indInput(), yInput(), yInput())
    x <- dcast(x, iso2c ~ year, value.var = names(x)[3])
    names(x)[1] <- "ISO2"

    wrl.data <- merge(wrl.data, x, by = 'ISO2', all.x = TRUE)
    wrl.data <- wrl.data[order(wrl.data$indice), ]
    attr(wrl, "data") <- wrl.data

    brks <- seq(0, ceiling(max(wrl.data[[input$year]], na.rm = T)), l = 10)
    brks <- round(brks, 2)
    my.pal <- brewer.pal(length(brks)-1, "YlGnBu")  # "Blues"
    ind.graph <- findInterval(wrl.data[[input$year]], brks)
 
    par(mar = c(2, 3, 3, 1))
    plot(wrl, col = my.pal[ind.graph])
    box()
    title(input$indicator)
    legend(-190, -90, bty = "n", fill = my.pal, cex = 0.8,
           legend = leglabs(brks), horiz = F)
  }, height = 700, width = 800)
})