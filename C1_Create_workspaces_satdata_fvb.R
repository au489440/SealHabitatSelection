# Date: 3-Jan-2018
# Purpose: load seal data and do habitat selection analyses
# R.3.5.1 64-bits (mac) 
#			Seems the odbcConnectAccess from the RODBC package only works on 32-bits R (with normal Windows installed). 
# 			Below some code that works for Mac based on Hmisc and get.mdb()


# loading in .mdb files 
library(Hmisc)
# Floris: for this to work one should install mdbtools by homebrew: 'brew install mdbtools' (paste into terminal).

# Specify databases
  databases<-c('pv28', 'pv36', 'pv46', 'hg23', 'hg23f')
  
# Specify tables within databases
  tablenames <- c('gps','tag_info','summary','haulout','dive')
    
# Do loop
  for (database in databases){
  for (tablename in tablenames){
  print(database)
  print(tablename)

# Specify location of databases (NOTE: should be no space in path directory otherwise get.mdb() crashes)
    channel<- paste("~/Dropbox/Seal_habitat_selection_and_density/rawdat/",database,".mdb",sep="")
		mdb.get(channel, tables=TRUE)

# Get tables
#  thetables <- mdb.get(channel, tables=c('gps','tag_info','summary','haulout','dive'))

# Read data and tables into R
  if (tablename=="gps")  table1<-mdb.get(channel,tables="gps")
  if (tablename=="tag_info")  table1<-mdb.get(channel,tables="tag_info")
  if (tablename=="haulout")  table1<-mdb.get(channel,tables="haulout")
  if (tablename=="summary")  table1<-mdb.get(channel,tables="summary")
  if (tablename=="dive")  table1<-mdb.get(channel,tables="dive")

# Save as RData
  if (exists("table1")) save.image(paste("~/Dropbox/Seal_habitat_selection_and_density/workspaces/deployments/",database,tablename,".Rdata",sep=""))
  
# remove table1
  rm("table1")

  }
  }








## original code from Geert
 







# Load R3.3.2 32bits

# Make database connection
  library(RODBC)

# Databases
  #databases<-c("hg10","hg12","hg14a","hg14g","hg16g","hg21g",
  #             "pv10","pv16","pv21","pv21b","pv22g","pv25",
  #             "pv31","pv32","pv37","pv38","pv39")
  #databases<-c("pv54L","pv54G","pv48","hg41","hg38","hg10","hg43LZ","hg43G","hg43LT")
  databases<-c("pv62")
  databases<-c("pv66")
  
# Specify table
  tablenames<-c("gps","diag","summary","haulout","dive")
    
# Do loop
  for (database in databases){
  for (tablename in tablenames){
  print(database)
  print(tablename)

# Load satelite tag table
  #channel<-odbcConnectAccess(paste("E:/Dropbox/Seal_database/seal/SatDatabases/Finished/",database,".mdb",sep=""))
  channel<-odbcConnectAccess(paste("E:/Dropbox/Seal_database/seal/SatDatabases/InProgress/",database,".mdb",sep=""))
  
# Get tables
  thetables<-sqlTables(channel)

# Read data_time objects as text
  if (tablename=="gps" & is.element("gps",thetables$TABLE_NAME))  table1<-sqlFetch(channel,tablename,as.is=3)
  if (tablename=="diag" & is.element("diag",thetables$TABLE_NAME))  table1<-sqlFetch(channel,tablename,as.is=3)
  if (tablename=="haulout")  table1<-sqlFetch(channel,tablename,as.is=c(3,4))
  if (tablename=="summary")  table1<-sqlFetch(channel,tablename,as.is=c(4,5))
  if (tablename=="dive")  table1<-sqlFetch(channel,tablename,as.is=c(4))

# Save workspace
  #if (exists("table1")) save.image(paste("w:/imares/texel/zeehonden/seal/workspaces/deployments/",database,tablename,"2015_02_04.rdata",sep=""))
  if (exists("table1")) save.image(paste("E:/Dropbox/Seal_database/seal/workspaces/deployments/",database,tablename,"2017_11_15.rdata",sep=""))
  
# remove table1
  rm("table1")

  }
  }
