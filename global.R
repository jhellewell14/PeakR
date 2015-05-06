process.runs <- function(dat){
  
  ## create .csv ##
  write.table(data.frame("Size"=0,"Height"=0,"Dye.Colour"=0),file=paste(getwd(),"/peakR-results.csv",sep=""),sep=",")
  
  ## get run names ##
  unique.runs <- unique(as.vector(dat$Sample.Name))
  
  ## indeterminate run vector ##
  ind.runs <- c()
  
  ## cut out plausible peaks by size ##
  ## need to set min size and max size ##
  minsize <- 100
  maxsize <- 300
  dat <- dat[dat$Size > minsize,]
  ## for each run ##
  for(current.run in unique.runs){
    ## prune to current run ##
    print("Current run:")
    print(current.run)
    temp <- dat[as.vector(dat$Sample.Name) == current.run,c("Size","Height","Dye.Sample.Peak","Sample.Name")]
    ## any peaks near threshold? ##
    if(any(temp$Height - 500 > sizing.curve(temp$Size) & temp$Height < sizing.curve(temp$Size))){
      
      ind.runs <- c(ind.runs,current.run)
      print(ind.runs)
    }else{ ## if no trouble, any peaks above threshold? ##
      
      if(any(temp$Height > sizing.curve(temp$Size))){
      
        temp <- temp[temp$Height > sizing.curve(temp$Size),]
        print(temp)
        write.table(temp,file=paste(getwd(),"/peakR-results.csv",sep=""),sep=",",append=TRUE,col.names=FALSE)
        
      }
        
    }

    
    
    
    
    
  }
  
  
  
  
  
}

sizing.curve <- function(size){
  return((28*size) + 7000)
}