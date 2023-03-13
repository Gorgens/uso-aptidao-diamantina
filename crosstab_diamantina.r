require(raster)
require(terra)
require(dplyr)

puc = raster('./pucEmbrapaClass31983.tif')
uso85 = raster('./uso85_reclass.tif')
uso20 = raster('./uso20_reclass.tif')


e1 = c(extent(puc)[1], extent(uso85)[1], extent(uso20)[1])
e2 = c(extent(puc)[2], extent(uso85)[2], extent(uso20)[2])
e3 = c(extent(puc)[3], extent(uso85)[3], extent(uso20)[3])
e4 = c(extent(puc)[4], extent(uso85)[4], extent(uso20)[4])

puc = crop(puc, extent(round(max(e1), 0), round(min(e2), 0), round(max(e3), 0), round(min(e4), 0)))
proj4string(puc) = CRS("+init=epsg:31983")
writeRaster(puc, 'pucStack.tiff')

uso85 = crop(uso85, extent(round(max(e1), 0), round(min(e2), 0), round(max(e3), 0), round(min(e4), 0)))
proj4string(uso85) = CRS("+init=epsg:31983")
uso85 = raster(vals=values(uso85),
                  ext=extent(puc),
                  crs=crs(puc),
                  nrows=dim(puc)[1],
                  ncols=dim(puc)[2])
writeRaster(uso85, 'uso85Stack.tiff')

uso20 = crop(uso20, extent(round(max(e1), 0), round(min(e2), 0), round(max(e3), 0), round(min(e4), 0)))
proj4string(uso20) = CRS("+init=epsg:31983")
uso20 = raster(vals=values(uso20),
                  ext=extent(puc),
                  crs=crs(puc),
                  nrows=dim(puc)[1],
                  ncols=dim(puc)[2])
writeRaster(uso20, 'uso20Stack.tiff')

expSilvi = overlay(uso20, uso85, fun=function(x,y){return(ifelse(x == 2 & y != 2, 1, 0))})
proj4string(expSilvi) = CRS("+init=epsg:31983")
plot(expSilvi)
writeRaster(expSilvi, 'expSilviStack.tiff')

expPastagem = overlay(uso20, uso85, fun=function(x,y){return(ifelse(x == 3 & y != 3, 1, 0))})
proj4string(expPastagem) = CRS("+init=epsg:31983")
plot(expPastagem)
writeRaster(expPastagem, 'expPastagemStack.tiff')

expAgri = overlay(uso20, uso85, fun=function(x,y){return(ifelse(x == 4 & y != 4, 1, 0))})
proj4string(expAgri) = CRS("+init=epsg:31983")
plot(expAgri)
writeRaster(expAgri, 'expAgriStack.tiff')

mystack = stack(uso85, uso20, puc, expSilvi, expPastagem, expAgri)
names(mystack) = c("uso85", "uso20", "puc", "expSilvi", "expPastagem", "expAgri")

pucUso85 = crosstab(mystack$uso85, mystack$puc)
write.csv(pucUso85, 'pucUso85.csv')

pucUso20 = crosstab(mystack$uso20, mystack$puc)
write.csv(pucUso20, 'pucUso20.csv')

pucExpSilvi = crosstab(mystack$expSilvi, mystack$puc)
write.csv(pucExpSilvi, 'pucExpSilvi.csv')

pucExpPastagem = crosstab(mystack$expPastagem, mystack$puc)
write.csv(pucExpPastagem, 'pucExpPastagem.csv')

pucExpAgri = crosstab(mystack$expAgri, mystack$puc)
write.csv(pucExpAgri, 'pucExpAgri.csv')


uso85ExpSilvi = crosstab(mystack$expSilvi, mystack$uso85)
write.csv(uso85ExpSilvi, 'uso85ExpSilvi.csv')

uso85ExpPastagem = crosstab(mystack$expPastagem, mystack$uso85)
write.csv(uso85ExpPastagem, 'uso85ExpPastagem.csv')

uso85ExpAgri = crosstab(mystack$expAgri, mystack$uso85)
write.csv(uso85ExpAgri, 'uso85ExpAgri.csv')
