# Load required packages
library(gdata)      # for reading .xls files
library(haplo.stats)
library(adegenet)

library(genetics)
library(hierfstat)
data(hla.demo)
typeof(hla.demo)
attach(hla.demo)

# Load the LDheatmap package
library(LDheatmap)

# Create genotype objects for each sample
g1 <- genotype(c('T/A', NA, 'T/T', NA, 'T/A', NA, 'T/T', 'T/A', 'T/T', 'T/T', 'T/A', 'A/A', 'T/T', 'T/A', 'T/A', 'T/T', NA, 'T/A', 'T/A', NA))
g2 <- genotype(c('C/A', 'C/A', 'C/C', 'C/A', 'C/C', 'C/A', 'C/A', 'C/A', 'C/A', 'C/C', 'C/A', 'A/A', 'C/A', 'A/A', 'C/A', 'C/C', 'C/A', 'C/A', 'C/A', 'A/A'))
g3 <- genotype(c('T/A', 'T/A', 'T/T', 'T/A', 'T/T', 'T/A', 'T/A', 'T/A', 'T/A', 'T/T', 'T/A', 'T/T', 'T/A', 'T/A', 'T/A', 'T/T', 'T/A', 'T/A', 'T/A', 'T/T'))

# Combine the genotype data into a single matrix
genotypes <- cbind(g1, g2, g3)

# Calculate the pairwise LD statistics
ld <- ld(genotypes)

# Generate the LD block diagram
ldheatmap(ld)