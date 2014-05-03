library(shiny)
library(VGAM)


fElo <- function(dr) 1/(10^(-dr/400) + 1)


fMod <- Vectorize(function(dr, alpha, beta) {
  dr <- dr/100
  mu1 <- exp(alpha + beta *  dr)
  mu2 <- exp(alpha - beta *  dr)
  x <- -30:30
  psk <- dskellam(x, mu1, mu2)
  sum(psk[x > 0])/sum(psk[x != 0])
}, 'dr')


rd <- c(0L, 10L, 20L, 30L, 40L, 50L, 60L, 70L, 80L, 90L, 100L, 110L, 
120L, 130L, 140L, 150L, 160L, 170L, 180L, 190L, 200L, 210L, 220L, 
230L, 240L, 250L, 260L, 270L, 280L, 290L, 300L, 325L, 350L, 375L, 
400L, 425L, 450L, 475L, 500L, 525L, 550L, 575L, 600L, 625L, 650L, 
675L, 700L, 725L, 750L, 775L, 800L)



shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
        
    # generate an rnorm distribution and plot it
    plot(rd, fElo(rd), pch = 20, ylab = "Probability")
    points(rd, fMod(rd, input$alpha, input$beta), pch = 20, col = 2)
  })
  
})

