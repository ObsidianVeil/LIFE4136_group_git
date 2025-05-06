#PROJECT 2

# Load required libraries
library(DESeq2)      # For differential gene expression analysis
library(ggplot2)     # For visualization
library(pheatmap)    # For heatmap generation

# ================================
# STEP 1: LOAD DATA IN DESEQ2
# ================================

# Load the sample metadata file
sample_metadata <- read.csv("sample_metadata.csv", header=TRUE)

# Create a DESeq2 dataset from HTSeq count files
dds <- DESeqDataSetFromHTSeqCount(sampleTable = sample_metadata, 
                                  directory = ".", 
                                  design = ~ condition)  

# Run DESeq2 differential expression analysis
dds <- DESeq(dds)

# Extract results (log2 fold changes & adjusted p-values)
res <- results(dds)

# Save results as CSV file
write.csv(as.data.frame(res), file="DESeq2_results.csv")

# ================================
# STEP 2: VOLCANO PLOT
# ================================

# Add log10 adjusted p-value for better visualization
res$logP <- -log10(res$padj)

# Create a Volcano Plot
ggplot(res, aes(x=log2FoldChange, y=logP, color=(padj < 0.05))) +
  geom_point(alpha=0.6) +  # Plot points with slight transparency
  scale_color_manual(values=c("black", "red"), 
                     labels = c("Not Significant", "Significant (p < 0.05)")) + 
  theme_minimal() +
  labs(title="Volcano Plot",
       x="Log2 Fold Change",
       y="-Log10 Adjusted P-value",
       color="Significance")

# Save Volcano Plot
ggsave("Volcano_plot.png", width=10, height=8, dpi=300)

# ================================
# STEP 3: PCA PLOT 
# ================================


### Performing Variance analysis first 

# Compute sample variance from normalized counts
vsd <- varianceStabilizingTransformation(dds)

# Calculate row variances (gene-wise variance)
gene_variances <- rowVars(assay(vsd))

# Identify samples with high variance
sample_variance <- apply(assay(vsd), 2, var)
print(sample_variance)  


# Perform variance stabilizing transformation (log-like transformation)
rld <- rlog(dds, blind=FALSE) 

# Extract PCA data
pca_data <- plotPCA(rld, intgroup="condition", returnData=TRUE)

# Calculate variance percentage for each principal component
percentVar <- round(100 * attr(pca_data, "percentVar"))

# Add sample names for labeling
pca_data$sample <- colnames(dds)

# Create a simple PCA plot
ggplot(pca_data, aes(x=PC1, y=PC2, color=condition, label=sample)) +
  geom_point(size=4) +   
  geom_text(vjust=-1.2, size=4) +  
  theme_minimal() +  
  labs(title="PCA Plot",
       x=paste0("PC1: ", percentVar[1], "% variance"),
       y=paste0("PC2: ", percentVar[2], "% variance"),
       color="Condition") +  
  scale_color_manual(values=c("blue", "red"), 
                     labels=c("Control", "Treatment"))

# Save PCA Plot
ggsave("PCA_plot.png", width=10, height=8, dpi=300)

# ================================
# STEP 4: MA PLOT
# ================================

# Plot MA Plot (mean vs fold-change)
plotMA(res, ylim=c(-6,6), main="MA Plot")

# Save MA Plot
ggsave("MA_plot.png", width=10, height=8, dpi=300)

# ================================
# STEP 5: HEATMAP
# ================================

# Compute sample-to-sample distances (Euclidean distance)
sampleDist <- dist(t(assay(rld)))  
sampleDistMatrix <- as.matrix(sampleDist)  

# Create Heatmap with explicit color mapping
pheatmap(sampleDistMatrix, 
         clustering_distance_rows="euclidean", 
         clustering_distance_cols="euclidean", 
         main="Sample Distance Heatmap")

# Save Heatmap
ggsave("Heatmap.png", width=10, height=8, dpi=300)









### Filtered data (remove Human5)

library(DESeq2)    
library(ggplot2)    
library(pheatmap)   

# ================================
# STEP 1: LOAD DATA IN DESEQ2
# ================================

# Load the sample metadata file
sample_metadata <- read.csv("filteredsample_metadata.csv", header=TRUE)

# Create a DESeq2 dataset from HTSeq count files
dds <- DESeqDataSetFromHTSeqCount(sampleTable = sample_metadata, 
                                  directory = ".", 
                                  design = ~ condition)  

# Run DESeq2 differential expression analysis
dds <- DESeq(dds)

# Extract results (log2 fold changes & adjusted p-values)
res <- results(dds)

# Save results as CSV file
write.csv(as.data.frame(res), file="filteredDESeq2_results3.csv")

# ================================
# STEP 2: VOLCANO PLOT
# ================================

# Add log10 adjusted p-value for better visualization
res$logP <- -log10(res$padj)

# Create a Volcano Plot
ggplot(res, aes(x=log2FoldChange, y=logP, color=(padj < 0.05))) +
  geom_point(alpha=1) +  
  scale_color_manual(values=c("black", "red"), 
                     labels = c("Not Significant", "Significant (p < 0.05)")) + 
  theme_minimal() +
  labs(title="Volcano Plot",
       x="Log2 Fold Change",
       y="-Log10 Adjusted P-value",
       color="Significance")

# Save Volcano Plot
ggsave("FilteredVolcano_plot3.png", width=10, height=8, dpi=300)

# ================================
# STEP 3: PCA PLOT 
# ================================


### Performing Variance analysis first 

# Compute sample variance from normalized counts
vsd <- varianceStabilizingTransformation(dds)

# Calculate row variances (gene-wise variance)
gene_variances <- rowVars(assay(vsd))

# Identify samples with high variance
sample_variance <- apply(assay(vsd), 2, var)
print(sample_variance)  


# Perform variance stabilizing transformation (log-like transformation)
rld <- rlog(dds, blind=FALSE) 

# Extract PCA data
pca_data <- plotPCA(rld, intgroup="condition", returnData=TRUE)

# Calculate variance percentage for each principal component
percentVar <- round(100 * attr(pca_data, "percentVar"))

# Add sample names for labeling
pca_data$sample <- colnames(dds)

# Create a simple PCA plot
ggplot(pca_data, aes(x=PC1, y=PC2, color=condition, label=sample)) +
  geom_point(size=4) +   
  geom_text(vjust=-1.2, size=4) +  
  theme_minimal() +  
  labs(title="PCA Plot",
       x=paste0("PC1: ", percentVar[1], "% variance"),
       y=paste0("PC2: ", percentVar[2], "% variance"),
       color="Condition") +  
  scale_color_manual(values=c("blue", "red"), 
                     labels=c("Control", "Treatment"))

# Save PCA Plot
ggsave("filteredPCA_plot3.png", width=10, height=8, dpi=300)

# ================================
# STEP 4: MA PLOT
# ================================

# Plot MA Plot (mean vs fold-change)
plotMA(res, ylim=c(-6,6), main="MA Plot")

# Save MA Plot
ggsave("filteredMA_plot3.png", width=10, height=8, dpi=300)

# ================================
# STEP 5: HEATMAP
# ================================

# Compute sample-to-sample distances (Euclidean distance)
sampleDist <- dist(t(assay(rld)))  
sampleDistMatrix <- as.matrix(sampleDist)  

# Create Heatmap with explicit color mapping
pheatmap(sampleDistMatrix, 
         clustering_distance_rows="euclidean", 
         clustering_distance_cols="euclidean", 
         main="Sample Distance Heatmap")

# Save Heatmap
ggsave("filteredHeatmap3.png", width=10, height=8, dpi=300)
