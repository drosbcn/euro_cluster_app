

macro_pca <- function(year_select, k, variables){
  
  setwd(getwd())
  
  library(plyr)
  library(dplyr)
  library(ggplot2)
  
  macro_dataset <- read.csv("macro_dataset.csv")[,-1]
  
  dataset <- macro_dataset %>%
    filter(Year == year_select) %>%
    select_(.dots = c("LOCATION", "region", variables))
  
  dataset[,3:ncol(dataset)] <- scale(dataset[,3:ncol(dataset)])
  
  for(i in 3:ncol(dataset)){
    dataset[,i][is.na(dataset[,i])] = mean(dataset[,i], na.rm = TRUE)
  }
  
  rownames(dataset) <- dataset[,1]
  
  dataset_dist <- dist(dataset[,3:ncol(dataset)])
  dataset_clust <- hclust(dataset_dist, method = "average")
  dendrogram <- plot(dataset_clust)
  cut_tree <- as.matrix(cutree(dataset_clust, k = k), ncol = 1)
  
  dataset <- cbind(dataset, cut_tree)
  
  # Import world map
  world <- read.csv("world.csv", stringsAsFactors = FALSE)
  
  merged <- join(world, dataset, by = "region", type = "left")
  
  sub <- subset(merged, region == dataset$region)
  
  svd_data <- svd(dataset[, 3:(ncol(dataset) - 1)])
  rpc <- data.frame(svd_data$u %*% diag(svd_data$d))
  csc <- data.frame(svd_data$v)
  
  pve <- 100*svd_data$d^2/sum(svd_data$d^2)
  
  pca_plot <- ggplot(NULL, aes(x = X1, y = X2)) +
    geom_point(data = rpc, size = 8, alpha = 0.7, aes(col = as.factor(dataset$cut_tree),
                                                      stroke = 1)) +
    geom_text(data = rpc, aes(label = dataset[,1])) +
    geom_segment(data = csc, aes(x = 0, xend = 5* csc[,1], y = 0, yend = 5*csc[,2]),
                 arrow = arrow(length = unit(0.2,"cm"))) +
    geom_text(data = csc, aes(x = 5.5* csc[,1], y = 5.5*csc[,2], 
                              label = colnames(dataset[,3:(ncol(dataset) - 1)]))) +
    # Make the background blank, get rid of grid lines, but keep axis lines and make the axis text bold
    theme(panel.background = element_blank(), panel.grid = element_blank(), axis.line = element_line(color = "black"), 
          axis.ticks = element_line(color = "black"), axis.title = element_text(face = "bold"), 
          axis.text = element_text(face = "bold"), legend.position = "none") +
    # Add horizontal and vertical dotted lines at 0
    geom_hline(yintercept = 0, lty = 2, alpha = 0.5) +
    geom_vline(xintercept = 0, lty = 2, alpha = 0.5) +
    ggtitle(paste0("Year: ", year_select, 
                   " (total variance explained: ", round(pve[1] + pve[2]), "%)")) + 
    theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
    scale_colour_brewer(type = "qual") +
    xlab(paste0("First Principal Component (variance explained: ", round(pve[1]), "%)")) +
    ylab(paste0("Second Principal Component (variance explained: ", round(pve[2]), "%)"))
  

  
  map <- ggplot(merged, aes(x = long, y = lat)) +
    geom_polygon(aes(group = group, fill = as.factor(cut_tree)), color = "white", cex = 0.1) +
    theme(legend.position = "None") +
    scale_color_brewer(type = "qual") +
    theme(axis.line = element_blank(), axis.ticks = element_blank(), 
          axis.title.x = element_blank(), axis.title.y = element_blank(), 
          axis.text.x = element_blank(), 
          axis.text.y = element_blank(), 
          panel.background = element_blank()) +
    ylim(c(min(sub$lat), max(sub$lat)))
  
  
  return(list(dendrogram = dendrogram, pca_plot = pca_plot, map = map))
}

