require(raster)
require(terra)
require(dplyr)

puc = raster('puc_reclass.tif')
uso85 = raster('uso85_agrupado.tif')
uso20 = raster('uso20_agrupado.tif')


e1 = c(extent(puc)[1], extent(uso85)[1], extent(uso20)[1])
e2 = c(extent(puc)[2], extent(uso85)[2], extent(uso20)[2])
e3 = c(extent(puc)[3], extent(uso85)[3], extent(uso20)[3])
e4 = c(extent(puc)[4], extent(uso85)[4], extent(uso20)[4])

puc = crop(puc, extent(max(e1), min(e2), max(e3), min(e4)))
proj4string(puc) = CRS("+init=epsg:31983")

uso85 = crop(uso85, extent(max(e1), min(e2), max(e3), min(e4)))
proj4string(uso85) = CRS("+init=epsg:31983")
uso85 = raster(vals=values(uso85),
                  ext=extent(puc),
                  crs=crs(puc),
                  nrows=dim(puc)[1],
                  ncols=dim(puc)[2])

uso20 = crop(uso20, extent(max(e1), min(e2), max(e3), min(e4)))
proj4string(uso20) = CRS("+init=epsg:31983")
uso20 = raster(vals=values(uso20),
                  ext=extent(puc),
                  crs=crs(puc),
                  nrows=dim(puc)[1],
                  ncols=dim(puc)[2])

expSilvi = overlay(uso20, uso85, fun=function(x,y){return(ifelse(x == 2 & y != 2, 1, 0))})
proj4string(expSilvi) = CRS("+init=epsg:31983")
plot(expSilvi)

expPastagem = overlay(uso20, uso85, fun=function(x,y){return(ifelse(x == 3 & y != 3, 1, 0))})
proj4string(expPastagem) = CRS("+init=epsg:31983")
plot(expPastagem)

expAgri = overlay(uso20, uso85, fun=function(x,y){return(ifelse(x == 4 & y != 4, 1, 0))})
proj4string(expAgri) = CRS("+init=epsg:31983")
plot(expAgri)

mystack = stack(uso85, uso20, puc, expSilvi, expPastagem, expAgri)
names(mystack) = c("uso85", "uso20", "puc", "expSilvi", "expPastagem", "expAgri")

pucUso85 = crosstab(mystack$uso85, mystack$puc)
pucUso85

pucUso20 = crosstab(mystack$uso20, mystack$puc)
pucUso20

pucExpSilvi = crosstab(mystack$expSilvi, mystack$puc)
pucExpSilvi

pucExpPastagem = crosstab(mystack$expPastagem, mystack$puc)
pucExpPastagem

pucExpAgri = crosstab(mystack$expAgri, mystack$puc)
pucExpAgri


uso85ExpSilvi = crosstab(mystack$expSilvi, mystack$uso85)
uso85ExpSilvi

uso85ExpPastagem = crosstab(mystack$expPastagem, mystack$uso85)
uso85ExpPastagem

uso85ExpAgri = crosstab(mystack$expAgri, mystack$uso85)
uso85ExpAgri
