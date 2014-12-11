### Mapping NOBA Atlantis Geometry
# By: Erik Olsen
# Created: 9.12.2014
# Updated: 

library(lattice) #load lattice library
library(RColorBrewer)
library(plyr)
library(ggplot2)
library("sp", lib.loc="/Users/eriko/Library/R/3.0/library")
library("geosphere", lib.loc="/Users/eriko/Library/R/3.0/library")
library(rgdal)
library(rgeos)
library("maps", lib.loc="/Users/eriko/Library/R/3.0/library")


###import NOBA shape-file instead of the BGM file

setwd("~/Documents/G-copy/USA studieopphold/atlantis/NOBA atlantis/nordic_grid_220812")
NOBAsp <- readOGR(dsn = ".", "MENUIIareasPolNewId_grass_tol0p01")
setwd("~/Documents/G-copy/USA studieopphold/atlantis/NOBA atlantis/spatial")

slotNames(NOBAsp) # look at the slotnames
names(NOBAsp)
str(NOBAsp, max.level=3)

#changes projection to LAT LON using projection information gathered from the 'slotNames' command above
NOBAsp2 <- spTransform(NOBAsp, CRS("+proj=longlat +ellps=GRS80"))


### Create NOBA area map with numbers for each region
NOBA.f<-fortify(NOBAsp2, region="nyId") #creates X - Y points of the polygons

cnames <- aggregate(cbind(long, lat) ~ id, data=NOBA.f, FUN=function(x)mean(range(x)))

# use world map as background
world<- map_data("world") 
NOBAmap1 <- ggplot(world, aes(x=long, y=lat, group=group)) + geom_path(colour="gray50") + scale_y_continuous(breaks=(-2:2) * 30) + scale_x_continuous(breaks=(-4:4) * 45) + xlim(-23,70) +ylim(58,85)
NOBAmap1

NOBAmap1 <- NOBAmap1 + geom_polygon(data=NOBA.f, aes(x=long, y=lat, group=group),colour="tomato3", fill="lightskyblue1", label=id) +theme_bw() + ggtitle("NOBA map") + geom_text(data=cnames, aes(x=long, y=lat, group=id, label = id), size=4) + theme(plot.title = element_text(size=16, face="bold")) 

NOBAmap1

#NOBAmap2 <- ggplot(NOBA.f, aes(x=long, y=lat, group=id)) + geom_polygon(data=NOBA.f, aes(x=long, y=lat, group=group),colour="tomato3", fill="lightskyblue1", label=id) + geom_text(data=cnames, aes(x=long, y=lat, group=id, label = id), size=4)

#NOBAmap2

ggsave("NOBA Atlantis map.pdf", scale = 1, dpi = 400)

