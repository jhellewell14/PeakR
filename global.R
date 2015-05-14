process.runs <- function(dat){
  
  
  ## get run names ##
  unique.runs <- unique(as.vector(dat$Sample.Name))
  
  app <- FALSE
  
  ## indeterminate run vector ##
  ind.runs <- c()
  ## clean run vector ##
  clean.runs <- c()
  ## determinate run vector ##
  det.runs <- c()
  
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
    temp <- temp[substring(temp$Dye.Sample.Peak,1,1) != "R" & substring(temp$Dye.Sample.Peak,1,1) != "Y" ,]
    ## any peaks near threshold? ##
    if(any((temp$Height + 2000) > sizing.curve(temp$Size) & temp$Height < sizing.curve(temp$Size) & substring(temp$Dye.Sample.Peak,1,1) != "R" & substring(temp$Dye.Sample.Peak,1,1) != "Y" )){
      
      ind.runs <- c(ind.runs,current.run)
      
    }else{ ## if no trouble, any peaks above threshold? ##
      
      if(any(temp$Height > sizing.curve(temp$Size))){
      
        temp <- temp[temp$Height > sizing.curve(temp$Size),]
        if(app==FALSE){
          write.table(temp,file=paste(getwd(),"/peakR-results.csv",sep=""),sep=",",append=FALSE,col.names=TRUE,row.names=FALSE)
          app=TRUE
          det.runs <- c(det.runs,current.run)
        }else{
          write.table(temp,file=paste(getwd(),"/peakR-results.csv",sep=""),sep=",",append=TRUE,col.names=FALSE,row.names=FALSE)
          det.runs <- c(det.runs,current.run)
        }
      
      }else{
        clean.runs <- c(clean.runs,current.run)
      }
        
    }
    
    
  }
  
  
  write.table(data.frame("run name"=clean.runs),file=paste(getwd(),"/peakR-results-clean.csv",sep=""),sep=",",append=FALSE,col.names=TRUE,row.names=FALSE)
  
  if(file.exists(paste(getwd(),"/peakR-results.csv",sep=""))){
  write.clones("/peakR-results.csv")
  }
  return(list("ind"=ind.runs,"clean"=clean.runs,"det"=det.runs))
}

sizing.curve <- function(size){
  #return((28*size) + 7000)
  return(4000+(0*size))
}


bin.vec <- function(vec){
  
  num.bins <- 1
  bin.list <- list()

  while(length(vec>0)){
    
    cs <- vec[1]
    relev <- which(abs(cs-vec)<3)
    bin.list[[num.bins]] <- vec[relev]
    vec <- vec[-relev]
    num.bins <- num.bins + 1
    
  }
  
  names(bin.list) <- lapply(bin.list,function(x){round(mean(x),0)})
  
  return(bin.list)
}

write.clones <- function(filename){
  temp <- read.table(file=paste(getwd(),filename,sep=""),sep=",",header=TRUE)
  bins.G <- bin.vec(temp$Size[which(substring(temp$Dye.Sample.Peak,1,1)=="G")])
  bins.B <- bin.vec(temp$Size[which(substring(temp$Dye.Sample.Peak,1,1)=="B")])
  temp$Clone.Name <- rep("",length(temp$Size))
  if(length(bins.G)>0){
  for(ind in 1:length(bins.G)){
    temp$Clone.Name[temp$Size %in% bins.G[[ind]]]  <- names(bins.G)[[ind]]
  }
  }
  
  if(length(bins.B)>0){
  for(ind in 1:length(bins.B)){
    temp$Clone.Name[temp$Size %in% bins.B[[ind]]]  <- names(bins.B)[[ind]]
  }
  }
  
  temp$Clone.Name <- paste(ifelse(substring(temp$Dye.Sample.Peak,1,1)=="B","3D7","FC27"),temp$Clone.Name,sep="_")
  temp$Clone.Name.Nums <- paste(ifelse(substring(temp$Dye.Sample.Peak,1,1)=="B","1","2"),temp$Clone.Name,sep="_")
  write.table(temp,file=paste(getwd(),filename,sep=""),sep=",",append=FALSE,col.names=TRUE,row.names=FALSE)
}


commit.run <- function(dat){
  if(file.exists(paste(getwd(),"/peakR-results.csv",sep=""))){
  
    temp <- read.table(file=paste(getwd(),"/peakR-results.csv",sep=""),header=TRUE,sep=",")
    temp <- temp[!is.na(temp$Size),]
    temp <- as.vector(temp$Sample.Name)

    dat$Clone.Name <- rep(NA,length(dat$Size))
    dat$Clone.Name.Num <- rep(NA,length(dat$Size))
    
    if((as.vector(dat$Sample.Name[1]) %in% temp) == FALSE){
      dat <- dat[dat$Dye.Sample.Peak != "R" & dat$Dye.Sample.Peak != "Y",]
      write.table(dat,file=paste(getwd(),"/peakR-results.csv",sep=""),sep=",",append=TRUE,col.names=FALSE,row.names=FALSE)
    }
    
  }else{
    dat <- dat[dat$Dye.Sample.Peak != "R" & dat$Dye.Sample.Peak != "Y",]
    write.table(dat,file=paste(getwd(),"/peakR-results.csv",sep=""),sep=",",append=FALSE,col.names=TRUE,row.names=FALSE)
  }
}


