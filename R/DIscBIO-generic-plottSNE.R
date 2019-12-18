#' @export
#' @title title
#' @rdname plottSNE
#' @param object object
setGeneric("plottSNE", function(object) standardGeneric("plottSNE"))
#' @title title
#' @description description
#' @importFrom graphics text
#' @rdname plotSilhouette
#' @export
setMethod("plottSNE",
          signature = "PSCANseq",
          definition = function(object){
            if ( length(object@tsne) == 0 ) stop("run comptsne before plottsne")
		col=c("black","blue","green","red","yellow","gray")
            part <- object@kmeans$kpart
            plot(object@tsne,las=1,xlab="Dim 1",ylab="Dim 2",pch=20,cex=1.5,col="lightgrey")
            for ( i in 1:max(part) ){
              if ( sum(part == i) > 0 ) text(object@tsne[part == i,1],object@tsne[part == i,2],i,col=col[i],cex=.75,font=4)
            }
          }
          )