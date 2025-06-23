library(curatedBladderData)
##########################################################################
data(package="curatedBladderData")

data(GSE1827_eset)

write.csv(exprs(GSE1827_eset), file="GSE1827_eset_exprs.csv")

write.csv(pData(GSE1827_eset), file="GSE1827_eset_clindata.csv")
############################################################################################################
data("GSE19915.GPL3883_eset")

write.csv(exprs(GSE19915.GPL3883_eset), file = "GSE19915.GPL3883_eset.csv")

write.csv(pData(GSE19915.GPL3883_eset),file="GSE19915.GPL3883_eset_clindata.csv")
          
    