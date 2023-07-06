

# Detach the adegenet package from the R session
detach("package:adegenet", unload=TRUE)

# Install the adegenet package
install.packages("adegenet")



# Load the haplo.stats package
library(haplo.stats)
library(trio)
library(readxl)
library(adegenet)
ls(name="package:haplo.stats")
help(haplo.em)


# Read in the genetic data as a haplo.stats "geno" object
geno2 <- read_xls("D:/grad/Haploview/Haploview-input_N_Ansari-Pour.xls")



num.el <- sapply(geno2, length)
# Generate the matrix
res <- cbind(unlist(geno2), rep(1:length(geno2), num.el))
haplo_data <- haplo.em(res )

# Perform haplotype analysis using the EM algorithm
hap_em <- haplo.em(geno)



# Print the haplotype frequencies
print(hap_em$frequencies)
# Perform haplotype association testing using the score test
hap_assoc <- haplo.score(hap_em, trait)
# Print the haplotype association results
print(hap_assoc$results)
# Visualize the LD patterns using the plot.ld function
plot.ld(hap_em)
# Define haplotype blocks using the block.generation function
blocks <- block.generation(hap_em)
# Print the haplotype block definitions
print(blocks$blocks)
geno