#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#
library(plumber)
library(adegenet)
library(stringi)
library(hierfstat)
library(flextable)



library(poppr)
library(dplyr)
library(reshape2)
library(ggplot2)
library(RColorBrewer)
library(scales)
library(Rook)
library (plyr)
library (jsonlite)
library(mime)
library(kableExtra)
library( data.table )
library(htmlTable)
library(magick)
library(pegas)

library(gdata)      # for reading .xls files
library(haplo.stats)
library(adegenet)
library(stringi)
library(genetics)
library(openxlsx)
library(gdata)
library(genoPlotR)


#* @apiTitle Plumber Example API
#* @apiDescription Plumber example description.

#* @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  plumber::forward()
}

#* Accept a CSV file through a POST request and write it to the disk
#* @param file:file
#* @post /upload
function(file) {
  
  # convert the file coming from client to store it in the disk 
  file <- unlist(file)
  formattedfile <- do.call(rbind, type.convert(strsplit(file, "\n"), as.is = TRUE))
  mdat <- matrix(formattedfile, byrow = TRUE)
  formatted_matrix <- do.call(rbind, type.convert(strsplit(mdat, ","), as.is = TRUE))
  
  #generate random unique name for the file 
  randomString <- stri_rand_strings(1 , 10 , pattern = "[A-Za-z0-9]")
  string1 <- randomString
  string2 <- "_popGene.csv"
  fileName <- paste(string1, string2, sep ="")
  
  # Write the CSV file to the disk
  write.csv(formatted_matrix, file.path(getwd(), fileName), row.names = FALSE , col.names = FALSE)
  
  
  
  lobster = read.csv(file.path(getwd(), fileName) , skip = 1 )
  
  #start analysis 
  lobster_wide = reshape(lobster, idvar = c("ID","Site"), timevar = "Locus", direction = "wide", sep = "")
  ind = as.character(lobster_wide$ID) # individual ID
  site = as.character(lobster_wide$Site) # site ID
  snpgeno = lobster_wide[ , 3:ncol(lobster_wide)]
  
  lobster_gen = df2genind(snpgeno, ploidy = 2, ind.names = ind, pop = site, sep = "")
  
  # number of alles 
  
  nummberOfAlle<- lobster_gen$loc.n.all
  nummberOfAlle
  
  #format the num of alles to store in the docx file 
  numOfAlleDF <- melt(as.matrix(nummberOfAlle) ) 
  
  
  
  #  Allele freq 
  tab(lobster_gen)[1:5, 1:10]
  
  
  #write alle freq in the file 
  geneIdDF<- melt(as.matrix(lobster_gen)[1:5, 1:10])
  
  
  
  #genetic distance , works on genepop object 
  genPop_lob <- genind2genpop(lobster_gen)
  
  genetic_Distance <- dist.genpop(genPop_lob) 
  
  gen_Distance_DF <- melt(as.matrix(genetic_Distance) ) 
  
  
  
  # HW Test works on geneid  ,
  hwTest<- hw.test(lobster_gen , B = 0 ) 
  
  HW_DF<- melt(as.matrix(hwTest) ) 
  
  
  
  
  # F Statistic 
  ftab <- Fst(as.loci(lobster_gen))
  
  
  ftab_DF<- melt(as.matrix(ftab) ) 
  
  
  
  # heterozygosity 
  heterozy <- Hs(lobster_gen )
  
  
  heterozy_DF <- melt(as.matrix(heterozy) ) 
  
  
  
  
  # lelts start writing the result in the file 
  set_flextable_defaults(
    font.size = 10, theme_fun = theme_vanilla,
    font.family = "fantasy",
    padding = 6,
    background.color = "#EFEFEF",
    Layout = "autofit"
    
  )
  
  gen_distance <- flextable(gen_Distance_DF)
  t2 <-flextable(geneIdDF) 
  flex_numOfAlle <- flextable(numOfAlleDF) 
  felx_HW_DF <- flextable(HW_DF)
  flex_F_statistic <- flextable(ftab_DF)
  flex_heterozy <- flextable(heterozy_DF)
  
  
  
  #generate random unique name for the file 
  string0 <- "result/"
  string1 <- randomString
  string2 <- "_popGene.docx"
  fileName <- paste(string0 , string1, string2, sep ="")
  
  
  if(!file.exists("result"))
    dir.create("result")
  
  
  save_as_docx(`genetic distances table ` = gen_distance , 
               `alle freq table`  = t2 , 
               `alle number table`  = flex_numOfAlle  ,
               `HW Test Table ` = felx_HW_DF,
               `F Statistic ` = flex_F_statistic,
               `Expected heterozygosity (Hs)` = flex_heterozy,
               path=fileName)
   (fileName)
}


#start uploading haploview 

#* @param file:file
#* @post /upload_haplo
function(file) {
  
  
  g1 <- genotype( c('T/A',    NA, 'T/T',    NA, 'T/A',    NA, 'T/T', 'T/A',
                    'T/T', 'T/T', 'T/A', 'A/A', 'T/T', 'T/A', 'T/A', 'T/T',
                    NA, 'T/A', 'T/A',   NA) )
  
  g2 <- genotype( c('C/A', 'C/A', 'C/C', 'C/A', 'C/C', 'C/A', 'C/A', 'C/A',
                    'C/A', 'C/C', 'C/A', 'A/A', 'C/A', 'A/A', 'C/A', 'C/C',
                    'C/A', 'C/A', 'C/A', 'A/A') )
  
  
  g3 <- genotype( c('T/A', 'T/A', 'T/T', 'T/A', 'T/T', 'T/A', 'T/A', 'T/A',
                    'T/A', 'T/T', 'T/A', 'T/T', 'T/A', 'T/A', 'T/A', 'T/T',
                    'T/A', 'T/A', 'T/A', 'T/T') )
  
  
  dfGs <- data.frame(g1,g2,g3)
  data <- makeGenotypes(data.frame(g1,g2,g3))
  
  # Compute & display  LD for one marker pair
  ld <- LD(g1,g2)
  
  # Compute LD table for all 3 genotypes
  ldt <- LD(data)
  
  # display the results
  
  randomString <- stri_rand_strings(1 , 10 , pattern = "[A-Za-z0-9]")
  string0 <- "result/"
  string1 <- randomString
  string2 <- "_LD_plot.pdf"
  fileName <- paste(string0 , string1, string2, sep ="")
  
  if(!file.exists("result"))
    dir.create("result")
  
  
  # start visualizing  and store this result in pdf 
  pdf(fileName)
  
  LDtable(ldt)                            # graphical color-coded table
  LDplot(ldt, distance=c(124, 834, 927))  # LD plot vs distance
  
  
  
  # more markers makes prettier plots!
  data <- list()
  nobs <- 1000
  ngene <- 20
  s <- seq(0,1,length=ngene)
  a1 <- a2 <- matrix("", nrow=nobs, ncol=ngene)
  for(i in 1:length(s) )
  {
    
    rallele <- function(p) sample( c("A","T"), 1, p=c(p, 1-p))
    
    if(i==1)
    {
      a1[,i] <- sample( c("A","T"), 1000, p=c(0.5,0.5), replace=TRUE)
      a2[,i] <- sample( c("A","T"), 1000, p=c(0.5,0.5), replace=TRUE)
    }
    else
    {
      p1 <- pmax( pmin( 0.25 + s[i] * as.numeric(a1[,i-1]=="A"),1 ), 0 )
      p2 <- pmax( pmin( 0.25 + s[i] * as.numeric(a2[,i-1]=="A"),1 ), 0 )
      a1[,i] <- sapply(p1, rallele )
      a2[,i] <- sapply(p2, rallele )
    }
    
    data[[paste("G",i,sep="")]] <- genotype(a1[,i],a2[,i])
  }
  data <- data.frame(data)
  data <- makeGenotypes(data)
  
  ldt <- LD(data)
  plot(ldt, digits=2, marker=19) # d
  
  
  
  parent_Title = "Pairwise LD -----------"
  
  
  title1 = "LD Test : "
  N =  paste0("N is : " , unlist(ld$n))
  P_value = paste0("P-value is : " , unlist(ld$`P-value`))
  X_2 = paste0("X^2 is : " , unlist(ld$`X^2`))
  
  
  title2 = "Estimates : "
  D1 = paste0("D` is : " , unlist(ld$`D'`))
  D2 =paste0("D is : " , unlist(ld$D))
  
  plot(NA, xlim=c(0,9), ylim=c(0,9), bty='n',
       xaxt='n', yaxt='n', xlab='', ylab='')
  
  
  text(1,8 , parent_Title , pos = 4 )
  
  
  text(1,7,title1 , pos = 4 )
  text(1,6,N, pos=4)
  text(1,5,P_value, pos=4)
  text(1,4,X_2, pos=4)
  
  text(1,3,title2 , pos = 4 ) 
  text(1,2,D1, pos=4)
  text(1,1,D2, pos=4)
  
  points(rep(1,8),1:8, pch=8)
  
  
  dev.off()
  
  fileName
  
  
}

# Programmatically alter your API
#* @plumber
function(pr) {
  pr %>%
    # Overwrite the default serializer to return unboxed JSON
    pr_set_serializer(serializer_unboxed_json())
  
}


#* @param file:file
#* @post /upload_haplo
function(file) {
  
  
  g1 <- genotype( c('T/A',    NA, 'T/T',    NA, 'T/A',    NA, 'T/T', 'T/A',
                    'T/T', 'T/T', 'T/A', 'A/A', 'T/T', 'T/A', 'T/A', 'T/T',
                    NA, 'T/A', 'T/A',   NA) )
  
  g2 <- genotype( c('C/A', 'C/A', 'C/C', 'C/A', 'C/C', 'C/A', 'C/A', 'C/A',
                    'C/A', 'C/C', 'C/A', 'A/A', 'C/A', 'A/A', 'C/A', 'C/C',
                    'C/A', 'C/A', 'C/A', 'A/A') )
  
  
  g3 <- genotype( c('T/A', 'T/A', 'T/T', 'T/A', 'T/T', 'T/A', 'T/A', 'T/A',
                    'T/A', 'T/T', 'T/A', 'T/T', 'T/A', 'T/A', 'T/A', 'T/T',
                    'T/A', 'T/A', 'T/A', 'T/T') )
  
  
  dfGs <- data.frame(g1,g2,g3)
  data <- makeGenotypes(data.frame(g1,g2,g3))
  
  # Compute & display  LD for one marker pair
  ld <- LD(g1,g2)
  
  # Compute LD table for all 3 genotypes
  ldt <- LD(data)
  
  # display the results
  
  randomString <- stri_rand_strings(1 , 10 , pattern = "[A-Za-z0-9]")
  string0 <- "result/"
  string1 <- randomString
  string2 <- "_LD_plot.pdf"
  fileName <- paste(string0 , string1, string2, sep ="")
  
  if(!file.exists("result"))
    dir.create("result")
  
  
  # start visualizing  and store this result in pdf 
  pdf(fileName)
  
  LDtable(ldt)                            # graphical color-coded table
  LDplot(ldt, distance=c(124, 834, 927))  # LD plot vs distance
  
  
  
  # more markers makes prettier plots!
  data <- list()
  nobs <- 1000
  ngene <- 20
  s <- seq(0,1,length=ngene)
  a1 <- a2 <- matrix("", nrow=nobs, ncol=ngene)
  for(i in 1:length(s) )
  {
    
    rallele <- function(p) sample( c("A","T"), 1, p=c(p, 1-p))
    
    if(i==1)
    {
      a1[,i] <- sample( c("A","T"), 1000, p=c(0.5,0.5), replace=TRUE)
      a2[,i] <- sample( c("A","T"), 1000, p=c(0.5,0.5), replace=TRUE)
    }
    else
    {
      p1 <- pmax( pmin( 0.25 + s[i] * as.numeric(a1[,i-1]=="A"),1 ), 0 )
      p2 <- pmax( pmin( 0.25 + s[i] * as.numeric(a2[,i-1]=="A"),1 ), 0 )
      a1[,i] <- sapply(p1, rallele )
      a2[,i] <- sapply(p2, rallele )
    }
    
    data[[paste("G",i,sep="")]] <- genotype(a1[,i],a2[,i])
  }
  data <- data.frame(data)
  data <- makeGenotypes(data)
  
  ldt <- LD(data)
  plot(ldt, digits=2, marker=19) # d
  
  
  
  parent_Title = "Pairwise LD -----------"
  
  
  title1 = "LD Test : "
  N =  paste0("N is : " , unlist(ld$n))
  P_value = paste0("P-value is : " , unlist(ld$`P-value`))
  X_2 = paste0("X^2 is : " , unlist(ld$`X^2`))
  
  
  title2 = "Estimates : "
  D1 = paste0("D` is : " , unlist(ld$`D'`))
  D2 =paste0("D is : " , unlist(ld$D))
  
  plot(NA, xlim=c(0,9), ylim=c(0,9), bty='n',
       xaxt='n', yaxt='n', xlab='', ylab='')
  
  
  text(1,8 , parent_Title , pos = 4 )
  
  
  text(1,7,title1 , pos = 4 )
  text(1,6,N, pos=4)
  text(1,5,P_value, pos=4)
  text(1,4,X_2, pos=4)
  
  text(1,3,title2 , pos = 4 ) 
  text(1,2,D1, pos=4)
  text(1,1,D2, pos=4)
  
  points(rep(1,8),1:8, pch=8)
  
  
  dev.off()
  
  fileName
  
  
}
