# LOAD LIBRARIES -------------------------
  library(maptools)
  library(rgdal)

# READ TRACKING DATA DATA -------------------

  # Set working directory
    setwd("E:/Dropbox/Seal_database/seal/workspaces/deployments/")
  
  # Select GPS tables to read
    seal.tables<-dir()[grep("gps",dir())] # up to pv62
    seal.tables
      
  # Read in tables and combine    
    for (i in seal.tables)
    {
      print(i)
      load(i)
      gps<-table1
      if(is.element("REF",names(gps))) gps$ref<-gps$REF
      gps<-gps[is.na(gps$LON)==FALSE & is.na(gps$LAT)==FALSE,]
      gps<-gps[is.na(gps$V_MASK)==FALSE & gps$V_MASK==0,]
      gps<-gps[,c("ref","D_DATE","LAT","LON")]
      if (i==seal.tables[1]) gps.all<-gps
      else gps.all<-rbind(gps.all,gps)
    }  
    gps<-gps.all
    unique(gps$ref)
    
  # Define species
    gps$species<-tolower(substr(gps$ref,1,2))
  
  # calculate correct date
    gps$ddate<-as.POSIXct(gps$D_DATE,format="%Y-%m-%d %H:%M:%S", tz="UTC")
  
  # Sort the data by ref and date
    gps<-gps[order(gps$ref,gps$ddate),]
  
  # Select haulout tables to read
    haul.tables<-dir()[grep("haulout",dir())] # up to pv62
    is.element(gsub("gps","haulout",seal.tables),haul.tables)
    
  # Read in tables and combine    
    for (i in haul.tables)
    {
      print(i)
      load(i)
      haulout<-table1
      if (is.element("REF",names(haulout))) names(haulout)[match("REF",names(haulout))]<-"ref"
      if (is.element("species",names(haulout))) haulout<-haulout[,-match("species",names(haulout))]
      if (is.element("PHOSI_SECS",names(haulout))) haulout<-haulout[,-match("PHOSI_SECS",names(haulout))]
      if (i==haul.tables[1]) haulout.all<-haulout
      else haulout.all<-rbind(haulout.all,haulout)
    }  
    haulout<-haulout.all
  
  # Define species
    haulout$species<-tolower(substr(haulout$ref,1,2))
  
  # calculate correct start and end date
    haulout$s_ddate<-as.POSIXct(haulout$S_DATE,format="%Y-%m-%d %H:%M:%S", tz="UTC")
    haulout$e_ddate<-as.POSIXct(haulout$E_DATE,format="%Y-%m-%d %H:%M:%S", tz="UTC")
    
  # Sort the data by ref and date
    haulout<-haulout[order(haulout$ref,haulout$s_ddate),]

  # Select summary tables to read
    sum.tables<-dir()[grep("summary",dir())] # up to pv62
    
  # Read in tables and combine    
    for (i in sum.tables)
    {
      print(i)
      load(i)
      summary<-table1
      if (is.element("REF",names(summary))) names(summary)[match("REF",names(summary))]<-"ref"
      if (i==sum.tables[1]) summary.all<-summary
      else summary.all<-rbind(summary.all[,1:19],summary[,1:19])
    }  
    summary<-summary.all
  
  # Define species
    summary$species<-tolower(substr(summary$ref,1,2))
  
  # calculate correct start and end date
    summary$s_ddate<-as.POSIXct(summary$S_DATE,format="%Y-%m-%d %H:%M:%S", tz="UTC")
    summary$e_ddate<-as.POSIXct(summary$E_DATE,format="%Y-%m-%d %H:%M:%S", tz="UTC")
  
  # Sort the data by ref and date
    summary<-summary[order(summary$ref,summary$s_ddate),]
  
  # Only select seals occuring in gps
    the.ref<-unique(gps$ref)
    summary<-summary[is.element(summary$ref,the.ref),]
    haulout<-haulout[is.element(haulout$ref,the.ref),]
    
  # Save the workspace
    setwd("E:/Dropbox/collaborative projects/GA_harbour_seal_habitat/")
    save(gps, file="workspaces/gps.rdata")
    save(haulout, file="workspaces/haulout.rdata")
    save(summary,file="workspaces/summary.rdata")
 
