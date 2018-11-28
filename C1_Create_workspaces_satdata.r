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
