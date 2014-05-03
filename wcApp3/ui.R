library(shiny)


cities <- list(`Belo Horizonte` = "Belo Horizonte", Brasilia = "Brasilia", 
  Cuiaba = "Cuiaba", Curitiba = "Curitiba", Fortaleza = "Fortaleza", 
  Manaus = "Manaus", Natal = "Natal", `Porto Alegre` = "Porto Alegre", 
  Recife = "Recife", `Rio de Janeiro` = "Rio de Janeiro", Salvador = "Salvador", 
  `Sao Paulo` = "Sao Paulo")



shinyUI(pageWithSidebar(
  
  headerPanel("World Cup 2014 weather"),
  
  sidebarPanel(
    selectInput("hostCity", "Choose Host City:", cities),
    checkboxInput("fahrenheit", "Fahrenheit", FALSE)
  ),

  mainPanel(
    tabsetPanel(
      tabPanel("MinMax", plotOutput("Plot0")),
      tabPanel("DailyAvg", plotOutput("Plot1"), plotOutput("Plot2"))
    )
  )
))