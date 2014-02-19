library(shiny)


shinyUI(pageWithSidebar(
  
  headerPanel("Zombie outbreak"),
  
  sidebarPanel(
    sliderInput("ab1", 
                "alpha:", 
                min = 1, 
                max = 15, 
                value = 2),
    sliderInput("ab2", 
                "beta:", 
                min = 1, 
                max = 15, 
                value = 2),
    sliderInput("infected.prop", 
                "Infected proportion:", 
                min = .01, 
                max = .03, 
                value = .015,
                step = .005),
    submitButton("Run")
  ),
  
  mainPanel(
    plotOutput("distPlot1"),
    plotOutput("distPlot2")
  )
))
