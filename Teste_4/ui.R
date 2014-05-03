library(shiny)


shinyUI(pageWithSidebar(
  
  headerPanel("Hello Shiny!"),
  
  sidebarPanel(
    sliderInput("alpha", 
                "Parametro alpha:", 
                min = -.5, 
                max = .5, 
                value = .3,
                step = .01),
    sliderInput("beta", 
                "Parametro beta:", 
                min = 0, 
                max = .5, 
                value = .15,
                step = .01)
  ),
  
  mainPanel(
    plotOutput("distPlot")
  )
))