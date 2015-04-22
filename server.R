library(seqinr)
dat <- NULL


shinyServer(function(input,output, session){
    
    ## DEAL WITH .CSV FILE ##
    filedata <- reactive({
    inFile <- input$file1
    if(is.null(inFile)) return(NULL)
    out <- read.csv(inFile$datapath, header = TRUE)
    out <- out[!is.na(out$Size),]
    out
    })
    
    ## CHANGE OPTIONS IN SELECT BOX ##
    output$run <- renderUI({
      dat <- filedata()
      if(is.null(dat)) return(NULL)
      
      run.names <- unique(as.vector(dat$Sample.Name))
      run.select <- c(1:length(run.names))
      names(run.select) <- run.names
      selectInput("run.names","select run name",choices=run.select)
    })
    
    filename <- reactive({
      dat <- filedata()
      if(is.null(dat)) return(NULL)
      run.names <- unique(as.vector(dat$Sample.Name))
      run.names[as.numeric(input$run.names)]
    })
    
    ## RENDER TABLE BASED ON RUN SELECTION ##
    output$contents <- renderTable({
      dat <- filedata()
      if(!is.null(dat)) dat$Dye.Sample.Peak <- substring(dat$Dye.Sample.Peak,1,1)
      dat <- dat[as.vector(dat$Sample.Name)==filename(),c("Size","Height","Dye.Sample.Peak")]
      dat <- dat[dat$Size>input$scut,]
      if(!is.null(dat)) names(dat) <- c("Size","Height","Dye Colour")
      dat[dat$Height>input$heightcut,]
    })
    
    ## SET UP CUT OFF SLIDERS BASED ON RUN SELECTION ##
    output$hcut <- renderUI({
      dat <- filedata()
      maxval=0
      if(!is.null(dat)) maxval = max(dat$Height)
      sliderInput("heightcut","Global min height",min=0,max=maxval,value=0)
    })
    
    ## SELECT DYES TO SHOW ##
    
    
    
    
  
})
  