#' @title Volcano Plot
#' @description Plotting differentially expressed genes (DEGs) in a particular
#'   cluster. Volcano plots are used to readily show the DEGs by plotting
#'   significance versus fold-change on the y and x axes, respectively.
#' @param object A data frame showing the differentially expressed genes (DEGs)
#'   in a particular cluster
#' @param value A numeric value of the false discovery rate. Default is 0.05..
#'   Default is 0.05
#' @param fc A numeric value of the fold change. Default is 0.5.
#' @param FS A numeric value of the font size. Default is 0.4.
#' @param name A string vector showing the name to be used to save the resulted
#'   tables.
#' @importFrom samr samr samr.compute.delta.table samr.plot
#'   samr.compute.siggenes.table
#' @importFrom graphics title
#' @importFrom utils write.csv
#' @importFrom calibrate textxy
#' @return A volcano plot
#' @export
#' @examples
#' \dontrun{
#' sc <- DISCBIO(valuesG1msReduced)
#' sc <- NoiseFiltering(sc, percentile=0.9, CV=0.2)
#' sc <- Normalizedata(
#'     sc, mintotal=1000, minexpr=0, minnumber=0, maxexpr=Inf, downsample=FALSE,
#'     dsn=1, rseed=17000
#' )
#' sc <- FinalPreprocessing(sc, GeneFlitering="NoiseF")
#' sc <- Clustexp(sc, cln=3) # K-means clustering
#' sc <- comptSNE(sc, rseed=15555)
#' dff <- DEGanalysis2clust(sc, Clustering="K-means", K=3, fdr=0.1, name="Name")
#' name <- dff[[2]][1, 6]
#' U <- read.csv(file = paste0(name), head=TRUE, sep=",")
#' VolcanoPlot(U, value=0.05, name=name, adj=FALSE, FS=.4)
#' }
VolcanoPlot <- function(object,
                        value = 0.05,
                        name,
                        fc = 0.5,
                        FS = .4) {
    if (length(object[1, ]) > 8) {
        object <- object[, -1]
    }
    NO0 <- object[, 8]
    NO0 <- NO0[-which(NO0 == 0)]
    w <- which.min(NO0)
    adjV <- NO0[w] / 100
    object[, 8] <- ifelse(object[, 8] == 0, adjV, object[, 8])
    with(
        object,
        plot(
            abs(object[, 7]),
            -log10(object[, 8]),
            pch = 20,
            cex = 2,
            las = 1,
            xlab = "log2 Fold Change",
            ylab = "-log10 FDR",
            sub = paste0("Volcano plot ", name),
            font.sub = 4,
            col.sub = "black"
        )
    )
    FC <- subset(object, abs(object[, 7]) > fc)    # Fold Change
    sigFC <-
        subset(object, object[, 8] < value &
                   abs(object[, 7]) > fc) # Significant genes
    with(FC, points(
        abs(FC[, 7]),
        -log10(FC[, 8]),
        pch = 20,
        cex = 2,
        col = "red"
    ))
    with(sigFC, points(
        abs(sigFC[, 7]),
        -log10(sigFC[, 8]),
        pch = 20,
        cex = 2,
        col = "blue"
    ))
    with(sigFC,
         textxy(
             abs(sigFC[, 7]),
             -log10(sigFC[, 8]),
             labs = sigFC[, 2],
             cex = FS,
             col = "blue"
         ))
    add_legend <- function(...) {
        opar <- par(
            fig = c(0, 1, 0, 1),
            oma = c(0, 0, 0, 0),
            mar = c(0, 0, 0, 0),
            new = TRUE
        )
        on.exit(par(opar))
        plot(
            0,
            0,
            type = 'n',
            bty = 'n',
            xaxt = 'n',
            yaxt = 'n'
        )
        legend(...)
    }
    add_legend(
        "topleft",
        legend = c(
            paste0("DEGs (FC < ", fc, " - FDR> ", value, ")   "),
            paste0("DEGs (FC > ", fc, " - FDR> ", value, ")"),
            paste0("DEGs (FC > ", fc, " - FDR< ", value, ")   ")
        ),
        pch = 20,
        col = c("black", "red", "blue"),
        horiz = TRUE,
        bty = 'n',
        cex = 0.7
    )
}