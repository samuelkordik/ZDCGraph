library(shiny)

shinyUI(fluidPage(
  titlePanel("Zoll Vitals Graph"),
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose ZDC File',
                accept=c('text/csv', 
                 'text/comma-separated-values,text/plain', 
                 '.txt')),
      tags$hr(),
      textInput('runnumber', 'Run Number'),
      width=2
    ),
    mainPanel(
      conditionalPanel(
        condition = "output.cond == false",
        plotOutput("plot"),
        sliderInput("range",label="Time Span of Graph:", min=as.POSIXct(Sys.time()),max=as.POSIXct(Sys.time()), value=c(as.POSIXct(Sys.time()),as.POSIXct(Sys.time())), width="100%",timeFormat="%H:%M:%S"),
        downloadButton('downloadData', 'Download PDF')
          
      )
      
    )
  )
))