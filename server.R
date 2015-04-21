library(seqinr)
dat <- NULL


shinyServer(function(input,output, session){
    
    ## DEAL WITH .CSV FILE ##
    filedata <- reactive({
    inFile <- input$file1
    if(is.null(inFile)) return(NULL)
    read.csv(inFile$datapath, header = TRUE)
    })
    
    output$run <- renderUI({
          dat <- filedata()
          if(is.null(dat)) return(NULL)
          
          run.names <- unique(as.vector(dat$Sample.Name))
          run.select <- c(1:length(run.names))
          names(run.select) <- run.names
         selectInput("run.names","select run name",choices=run.select)
    })
    
  
})
  