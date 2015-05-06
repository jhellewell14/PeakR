process.runs <- function(dat){
  
  
  ## get run names ##
  unique.runs <- unique(as.vector(dat$Sample.Name))
  
  app <- FALSE
  
  ## indeterminate run vector ##
  ind.runs <- c()
  ## clean run vector ##
  clean.runs <- c()
  
  ## cut out plausible peaks by size ##
  ## need to set min size and max size ##
  minsize <- 100
  maxsize <- 300
  dat <- dat[dat$Size > minsize,]
  ## for each run ##
  for(current.run in unique.runs){
    ## prune to current run ##
    temp <- dat[as.vector(dat$Sample.Name) == current.run,c("Sample.Name","Size","Height","Dye.Sample.Peak")]
    temp$Dye.Sample.Peak <- substring(temp$Dye.Sample.Peak,1,1)
    ## any peaks near threshold? ##
    if(any((temp$Height + 300) > sizing.curve(temp$Size) & temp$Height < sizing.curve(temp$Size)) & substring(temp$Dye.Sample.Peak,1,1) != "R" ){
      
      ind.runs <- c(ind.runs,current.run)
      
    }else{ ## if no trouble, any peaks above threshold? ##
      
      if(any(temp$Height > sizing.curve(temp$Size))){
      
        temp <- temp[temp$Height > sizing.curve(temp$Size),]
        if(app==FALSE){
          write.table(temp,file=paste(getwd(),"/peakR-results.csv",sep=""),sep=",",append=FALSE,col.names=TRUE,row.names=FALSE)
          app=TRUE
        }else{
          write.table(temp,file=paste(getwd(),"/peakR-results.csv",sep=""),sep=",",append=TRUE,col.names=FALSE,row.names=FALSE)
        }
      
      }else{
        clean.runs <- c(clean.runs,current.run)
      }
        
    }

    
    
    
    
    
  }
  
  
  write.table(data.frame("run name"=clean.runs),file=paste(getwd(),"/peakR-results-clean.csv",sep=""),sep=",",append=FALSE,col.names=TRUE,row.names=FALSE)
  
  return(ind.runs)
}

sizing.curve <- function(size){
  return((28*size) + 7000)
}