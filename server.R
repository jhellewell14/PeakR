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
    
    
    
    ## REACTIVE WHICH RETURNS CURRENT FILE NAME ##
    filename <- reactive({
      dat <- filedata()
      if(is.null(dat)) return(NULL)
      run.names <- unique(as.vector(dat$Sample.Name))
      run.names[as.numeric(input$run.names)]
    })
    
    
    
    ## RENDER TABLE BASED ON RUN SELECTION ##
    output$contents <- renderTable({
      relevant.data()
    })
    
    ## SET UP CUT OFF SLIDERS BASED ON RUN SELECTION ##
    output$hcut <- renderUI({
      dat <- filedata()
      maxval=0
      if(!is.null(dat)) maxval = max(dat$Height)
      sliderInput("heightcut","Global min height",min=0,max=maxval,value=0)
    })
    
    ## SELECT DYES TO SHOW ##
    output$dchoice <- renderUI({
      dat <- filedata()
      if(!is.null(dat)){ d.names <- unique(substring(dat$Dye.Sample.Peak,1,1))
        d.choices <- c(1:length(d.names))
        names(d.choices) <- d.names
        checkboxGroupInput("dyechoice", label = h3("Dye colours"), 
                           choices = d.choices,
                           selected = c(1:length(d.names)))
      }
      
    })
    
   
    
    
   ## RENDER GRAPH ##
   output$ephgram <- renderPlot({
     
     dat <- filedata()
     
     if(!is.null(dat)){
       dat$Dye.Sample.Peak <- substring(dat$Dye.Sample.Peak,1,1)
       dye.names <- unique(substring(dat$Dye.Sample.Peak,1,1))
     }
     dat <- relevant.data()
    # dat <- dat[as.vector(dat$Sample.Name)==filename(),c("Size","Height","Dye.Sample.Peak")]
     #dat <- dat[dat$Size>input$scut,]
    # dat <- dat[dat$Size<551,]
    # dat <- dat[dat$Height>input$heightcut,]
     
     if(!is.null(dat)){
       
       #names(dat) <- c("Size","Height","Dye.Colour")
       #dye.choices <- dye.names[as.numeric(input$dyechoice)]
       #dat <- dat[which(substring(dat$Dye.Colour,1,1) %in% dye.choices),]
       plot(1,type='n',xlim=c(0,550),ylim=c(0,max(dat$Height)))
     
       for(num in input$dyechoice){
         points <- dat[which(substring(dat$Dye.Colour,1,1) == dye.names[as.numeric(num)]),]
         vec <- rep(0,551)
         vec[round(points$Size)] <- points$Height
         line.col <- switch(dye.names[as.numeric(num)],
              "R" = "Red",
              "B" = "Blue",
              "G" = "Green",
              "Y" = "Yellow")
        lines(c(0:550),vec,col=line.col)

       } #end for
     } #end if
     
   })
  
   
   relevant.data <- reactive({
     dat <- filedata()
     
     if(!is.null(dat)){
       dat$Dye.Sample.Peak <- substring(dat$Dye.Sample.Peak,1,1)
       dye.names <- unique(substring(dat$Dye.Sample.Peak,1,1))
     }
     
     dat <- dat[as.vector(dat$Sample.Name)==filename(),c("Size","Height","Dye.Sample.Peak")]
     dat <- dat[dat$Size>input$scut,]
     dat <- dat[dat$Size<551,]
     dat <- dat[dat$Height>input$heightcut,]
     
     if(!is.null(dat)){
       names(dat) <- c("Size","Height","Dye.Colour")
       dye.choices <- dye.names[as.numeric(input$dyechoice)]
       dat <- dat[which(substring(dat$Dye.Colour,1,1) %in% dye.choices),]
     }
     
     dat
   })
   
   ## WRITE TO .CSV ON BUTTON PRESS ## 
  output$filewrite <- renderPrint({
    dat <- relevant.data()
    if(input$fwrite > 0){
      write.table(dat,file=paste(getwd(),"/peakR-results.csv",sep=""),sep=",",append=TRUE,col.names=FALSE)
    }else{
      write.table(dat,file=paste(getwd(),"/peakR-results.csv",sep=""),sep=",")
    }
    
    return("Printed to peakR-results.csv")
  })
     
     
  
})
  