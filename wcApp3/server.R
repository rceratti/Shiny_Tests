library(shiny)
library(ggplot2)
library(reshape2)
library(grid)
library(geoR)
library(maptools)
library(RColorBrewer)



load('data/Krige_Maps.RData')

br0 <- readShapePoly("data/Shapefiles/BRASIL.shp")
br1 <- readShapePoly("data/Shapefiles/BR_Contorno.shp")


x <- seq(bbox(br1)['x', 1], bbox(br1)['x', 2], l = 80)
y <- seq(bbox(br1)['y', 1], bbox(br1)['y', 2], l = 80)
locs <- as.matrix(expand.grid(x = x, y = y))

pols <- br1@polygons[[1]]@Polygons


files <- paste0('data/', c('hosts', 'weather', 'stations_v2'), '.csv')
dat <- lapply(files, read.csv, stringsAsFactors = F)


hdat <- dat[[1]]
wdat <- dat[[2]]
sdat <- dat[[3]]


hosts <- merge(hdat, sdat, by = 'Code')


plotKrig <- function(brShape0) {
  for(j in 1:27) {
    pols0 <- brShape0@polygons[[j]]@Polygons
    for(i in 1:length(pols0)) 
      lines(pols0[[i]])
  }
}


plotFun <- function(data, Temperature = TRUE, Fahrenheit = FALSE) {
  if(Temperature)
    vars <- c('MinTempC', 'MaxTempC')
  else
    vars <- c('MinHumidity', 'MaxHumidity')

  dat <- data[, c('DateMD', vars)]
  names(dat) <- c('Date', 'Min', 'Max')
  dat <- melt(dat, id = 'Date', variable.name = 'Scale')

  dat <- dat[(dat$value < Inf) & (dat$value > -Inf), ]

  if(Temperature & Fahrenheit)
    dat$value <- (9*dat$value/5) + 32

  l <- length(unique(dat$Date))
  p <- ggplot(dat, aes(Date, value, col = Scale)) + geom_point(alpha = .5) + 
    theme_bw() + scale_x_discrete(breaks = unique(dat$Date)[seq(1, 32, 3)]) + 
    stat_smooth(aes(group = Scale))

  if(Temperature) {
    if(Fahrenheit)
      p <- p + ylab('Temperature (°F)')
    else
      p <- p + ylab('Temperature (°C)')
  }
  else
    p <- p + ylab('Humidity (%)')

  p
}



shinyServer(function(input, output) {
  mycol <- colorRampPalette(brewer.pal(11, "Spectral"))(50)  
  city <- reactive(input$hostCity)
  
  output$Plot0 <- renderPlot({
    city <- hdat$Code[match(city(), hdat$Hosts)]
    wdat1 <- wdat[wdat$Station == city, ]
    wdat1 <- wdat1[wdat1$MaxTempC < 50 & wdat1$MinTempC > -30, ]
    wdat1$DateMD <- format(as.Date(wdat1$Date), "%m-%d")

    Fahrenheit <- input$fahrenheit

    p1 <- plotFun(wdat1,, Fahrenheit)
    p2 <- plotFun(wdat1, F)

    pushViewport(viewport(layout = grid.layout(1, 2)))
    print(p1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
    print(p2, vp = viewport(layout.pos.row = 1, layout.pos.col = 2))
  })

  output$Plot1 <- renderPlot({
    temp <- krige.list$Temperature

    Fahrenheit <- input$fahrenheit
    if(Fahrenheit)
      temp$predict <- (9*temp$predict/5) + 32

    mypch <- ifelse(hosts$Hosts == city(), 15, 17)
    xl <- c(-69, -68)
    yl <- c(-30, -20)

    image(temp, col = rev(colorRampPalette(brewer.pal(11, "Spectral"))(50)), 
          xlab = "", ylab = "", main = 'Temperature', axes = F)
    legend.krige(x.leg = xl, y.leg = yl, temp$predict, 
                 col = rev(mycol), vert = T)
    plotKrig(br0)
    points(hosts$Lon, hosts$Lat, pch = mypch, col = 3, cex = 1.5)
  })

  output$Plot2 <- renderPlot({
    humi <- krige.list$Humidity

    mypch <- ifelse(hosts$Hosts == city(), 15, 17)
    xl <- c(-69, -68)
    yl <- c(-30, -20)

    image(humi, col = colorRampPalette(brewer.pal(11, "Spectral"))(50), 
          xlab = "", ylab = "", main = 'Humidity', axes = F)
    legend.krige(x.leg = xl, y.leg = yl, humi$predict, 
                 col = mycol, vert = T)
    plotKrig(br0)
    points(hosts$Lon, hosts$Lat, pch = mypch, col = 3, cex = 1.5)
  })
})