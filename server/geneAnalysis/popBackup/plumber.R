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
library(poppr)
library(dplyr)
library(hierfstat)
library(reshape2)
library(ggplot2)
library(RColorBrewer)
library(scales)
library(Rook)
library (plyr)
library (jsonlite)
library(stringi)


library(kableExtra)
library( data.table )
library(htmlTable)
library(magick)
library(flextable)
library(pegas)




#* @apiTitle Plumber Example API
#* @apiDescription Plumber example description.

#* @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  plumber::forward()
}


#* @serializer csv
#* @post /csv
#* @param file:file
function(file) {
  file
  #req$rook.input$rewind()
  #df <- read.csv(file)
  #response <- list(response = df)
  #response
}


function(file) {
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
  file.path(getwd(), fileName)
}
#* Accept a CSV file through a POST request and write it to the disk
#* @param file:file
#* @post /upload
function(file) {
  
  
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
  lobster_wide = reshape(lobster, idvar = c("ID","Site"), timevar = "Locus", direction = "wide", sep = "")
  ind = as.character(lobster_wide$ID) # individual ID
  site = as.character(lobster_wide$Site) # site ID
  snpgeno = lobster_wide[ , 3:ncol(lobster_wide)]
  
  lobster_gen = df2genind(snpgeno, ploidy = 2, ind.names = ind, pop = site, sep = "")
  
  # number of alles 
  
  nummberOfAlle<- lobster_gen$loc.n.all
  nummberOfAlle
  
  numOfAlleDF <- melt(as.matrix(nummberOfAlle) ) 
  
  
  
  #  Allele freq 
  tab(lobster_gen)[1:5, 1:10]
  typeof(tab(lobster_gen)[1:5, 1:10])
  
  #write alle freq in the file 
  geneIdDF<- melt(as.matrix(lobster_gen)[1:5, 1:10])
  
  
  
  #genetic distance 
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
  string1 <- randomString
  string2 <- "_popGene.docx"
  fileName <- paste(string1, string2, sep ="")
  
  save_as_docx(`genetic distances table ` = gen_distance , 
               `alle freq table`  = t2 , 
               `alle number table`  = flex_numOfAlle  ,
               `HW Test Table ` = felx_HW_DF,
               `F Statistic ` = flex_F_statistic,
               `Expected heterozygosity (Hs)` = flex_heterozy,
               path=fileName)
  
  string3 <- getwd()
  string4 <- "/"
  vec <- cbind(string3, string4 , fileName) # combined vector.
  pathToFile <- paste(string3, string4 , fileName, sep ="")
  pathToFile
}

# Programmatically alter your API
#* @plumber
function(pr) {
  pr %>%
    # Overwrite the default serializer to return unboxed JSON
    pr_set_serializer(serializer_unboxed_json())
  
}



