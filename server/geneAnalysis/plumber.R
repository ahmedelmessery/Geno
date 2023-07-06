#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#
setwd("D:/grad/popgene/src/PopGeneApi")
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
library(officer)

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


#* @get /csv
function(res) {
  filename <- "D:/grad/popgene/src/PopGeneApi/6SHpFHq55J_popGene.docx" # replace with the filename of the file you want to serve
  file <- read_docx(filename)
  typeof(file)
  as_attachment(file , filename = "pop.csv")
}



# Define a lookup table of MIME types for common file extensions
mime_types <- list(
  txt = "text/plain",
  pdf = "application/pdf",
  docx = "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  xlsx = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
)


#* Return a file as an attachment
#* @get /download
function(res) {

 #file <- "D:/grad/popgene/src/PopGeneApi/4Jp5B9ST8B_popGene.csv"
 #file <- "D:/grad/Gene_Analysis/tutorial-basics.pdf"
  file <- "D:/grad/popgene/src/PopGeneApi/code_V3.txt"
  # Set the Content-Type header based on the file extension
  ext <- tools::file_ext(file)
  content_type <- ifelse(ext %in% names(mime_types), mime_types[[ext]], "application/octet-stream")
  
  
  fileContent <- as.data.frame(include_file(file, res, content_type = content_type))
  # Return the file as an attachment
  as_attachment( fileContent, filename = "filenemae.txt") 
}

#* Return a file as an attachment
#* @get /download2
function(res) {
  
  #file_path <- "D:/grad/popgene/src/PopGeneApi/25tYmg5jue_popGene.docx"
  #file <- "D:/grad/Gene_Analysis/tutorial-basics.pdf"
  file_path <- "D:/grad/popgene/src/PopGeneApi/code_V3.txt"
  file_content <- readBin(file_path, "raw", file.info(file_path)$size)
  
  # Create a response object with the file content
  res <- list(
    body = file_content,
    headers = c(
      'Content-Type' = 'text/plain',
      'Content-Disposition' = sprintf('attachment; filename="%s"', "myfileIsHere")
    )
  )
  
  
  # Return the file content as the response
  return(res)
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
  t1 <- flextable(df)
  t2 <-flextable(geneIdDF) 
  flex_numOfAlle <- flextable(numOfAlleDF) 
  felx_HW_DF <- flextable(HW_DF)
  flex_F_statistic <- flextable(ftab_DF)
  flex_heterozy <- flextable(heterozy_DF)
  
  
  
  #generate random unique name for the file 
  string1 <- randomString
  string2 <- "_popGene.docx"
  fileName <- paste(string1, string2, sep ="")
  
  save_as_docx(`genetic distances table ` = t1 , 
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



