library(shiny)
library(stringr)

getZDCdata <- function(filename) {
  dataframe <- read.csv(filename, fileEncoding="UCS-2LE")
  names(dataframe) <- list("Timestamp","MachineID","Medic","Patient","Date","Time","Elapsed","Timestamp","blank","HR","SpO2","RR","ETCO2","blank1","blank2","blank3")
  
  output = suppressWarnings(data.frame(x=fix(dataframe), HR=as.numeric(levels(dataframe["HR"][,])[dataframe["HR"][,]]), SpO2=as.numeric(levels(dataframe["SpO2"][,])[dataframe["SpO2"][,]]), RR=as.numeric(levels(dataframe["RR"][,])[dataframe["RR"][,]]), ETCO2=as.numeric(gsub("([0-9]+).*$", "\\1",dataframe["ETCO2"][,]))))
  library(reshape2)
  tg <- melt(output, id.vars="x", na.rm=1)
  maxdata <<- max(tg$value)
  return(tg)
}

fix <- function(data) {
  data["Time"] <- gsub("([0-9][0-9]:[0-9][0-9]:[0-9][0-9]).*$", "\\1", levels(data["Time"][,])[data["Time"][,]])
  X <- do.call(paste, c(data[c("Date", "Time")], sep = " ")) 
  #return(X)
  return(strptime(X, format="%m-%d-%Y %H:%M:%S"))
}

graph <- function(output, title) {
  library(ggplot2)
  library(scales)
  #ggplot(data=output, aes(x=x, group=1))+geom_line(aes(y=hr, colour="HR"))+geom_line(aes(y=SpO2, colour="SpO2"))+geom_line(aes(y=RR, colour="RR"))+geom_line(aes(y=ETCO2, colour="ETCO2"))
  case_length <- (as.numeric(max(output$x)-min(output$x))*60)/100
  timebreaks <- min(c(case_length, 300))
  timeseq <- seq(min(output$x), max(output$x), by=300)
  #timeseqminor <- seq(min(output$x), max(output$x), by="min")
  xseq <- seq(min(output$value), max(output$value), by=10)
  maxdata <<- max(output$value)
  g <- ggplot(data=output, aes(x=x, y=value, colour=variable, shape=variable, fill=variable))
  g <- g + geom_line(size=.75)+theme_bw()
  g <- g +theme(axis.text.x = element_text(angle=45, hjust=1,vjust=1))
  g <- g + labs(x="Time", y="Value", colour="Vital Sign", title=title)
  g <- g + scale_x_datetime(breaks=timeseq, labels=date_format("%H:%M:%S", tz=Sys.timezone()))
  g <- g+ scale_y_continuous(breaks=xseq)
  gpl <<- g
  return(g)
}

z <- function(tg, runnumber) {
  
 
    graph(tg, runnumber)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  values <- reactiveValues()
  
  df <- reactive({
    inFile <- input$file1
    if (is.null(inFile)) {
      return(NULL)
    } else {
    dataframe <- read.csv(inFile$datapath, fileEncoding="UCS-2LE")
    names(dataframe) <- list("Timestamp","MachineID","Medic","Patient","Date","Time","Elapsed","Timestamp","blank","HR","SpO2","RR","ETCO2","blank1","blank2","blank3")
    dataout = suppressWarnings(data.frame(x=fix(dataframe),HR=as.numeric(levels(dataframe["HR"][,])[dataframe["HR"][,]]), SpO2=as.numeric(levels(dataframe["SpO2"][,])[dataframe["SpO2"][,]]), RR=as.numeric(levels(dataframe["RR"][,])[dataframe["RR"][,]]), ETCO2=as.numeric(gsub("([0-9]+).*$", "\\1",dataframe["ETCO2"][,]))))
    mx <- max(dataout$x)
    mn <- min(dataout$x)
    updateSliderInput(session, "range", min=mn, max=mx, value=c(mn,mx))
    dataout
    }
  })

  rangeInput <- reactive({
    inFile <- input$file1
    if (is.null(inFile)) {
      values$range <- 1
      value$first <- 0
      values$last <- 1
    } else {
      tg <- df()
      if(input$range[1]==0 || input$range[2]==0) {
          dataout <- df()
          values$last <- max(dataout$x)
          values$first <- min(dataout$x)
      } else {
        values$first <- input$range[1]
        values$last <- input$range[2]
      }
    }
  })
  
  output$plot <- renderPlot({
inFile <- input$file1
      if (is.null(inFile)) {
        return(NULL)
      }
    runnumber <- input$runnumber
    if (runnumber=="") {
      runnumber <- str_replace(inFile$name, ".txt", "")
    }
    updateTextInput(session,"runnumber",value=runnumber)
    rangeInput()
    library(reshape2)
    #start <- min(dataout$x)+values$first
    #end <- min(dataout$x)+values$last
    subtg <- subset(df(), values$first <= x & x <= values$last)
    tg <- melt(subtg, id.vars="x", na.rm=1)
    z(tg, runnumber)
  })
  
  output$cond <- reactive({
    inFile <- input$file1
    is.null(inFile)
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$runnumber,".pdf",sep="")
    },
    content = function(con) {

      inFile <- input$file1
      if (is.null(inFile)) {
        return(NULL)
      }

      runnumber <- input$runnumber
      if (runnumber=="") {
        runnumber <- str_replace(inFile$name, ".txt", "")
      }
      rangeInput()
      library(reshape2)
      #start <- min(dataout$x)+values$first
      #end <- min(dataout$x)+values$last
      subtg <- subset(df(), values$first <= x & x <= values$last)
      tg <- melt(subtg, id.vars="x", na.rm=1)
      z(tg, runnumber)

      ggsave(con,width=10,height=7)

    #   device <- function(..., width, height) {
    #     grDevices::pdf(..., width = width, height = height,
    #                           res = 300, units = "in")
    #           }
    #           ggsave(con, device = device)

    }
  )
  
  outputOptions(output, "cond", suspendWhenHidden = FALSE)


    # # close the R session when Chrome closes
    session$onSessionEnded(function() { 
     stopApp()
     q("no") 
    })
})