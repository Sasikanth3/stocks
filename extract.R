if(!require(yaml)){install.packages("yaml")}
if(!require(RCurl)){install.packages("RCurl")}

library(yaml)
library(RCurl)

#Load variables from config
config = yaml.load_file("config.yml")
cred = paste(config$ftp$user,config$ftp$password,sep = ":")
path.files= paste(config$ftp$host,config$ftp$serverDir,sep = "/")
file.zip=getURL(path.files,userpwd=cred,ftp.use.epsv=F,dirlistonly=T)

#Extract files from FTP
bin<-getBinaryURL(paste(path.files,substr(file.zip,0,nchar(file.zip)-1),sep=''),userpwd=cred,ftp.use.epsv=F)
if(length(bin)<10){stop('no zip file found at FTP Site or File cannot be download from ftp')}
writeBin(bin, "stocks.zip") 
if(!file.exists('stocks.zip')){stop('cannot create a valid FTP file')}

#Unzip csv files and clean the zip file
if (file.exists(config$ftp$downloadDir)){
  dir.create(config$ftp$downloadDir)
}
unzip("stocks.zip",exdir = config$ftp$downloadDir)
file.remove("stocks.zip")
