# new filtering code for auto-save PT
#mCherry => same; 
#modifications traj part because : same traj in multiple files

# charge plot 3D
library(plot3D)

#function minimum/maximum
#via for loop somehow 
limx= function(a) {   # enter a as x[[i]]
  min= min(a[[1]] [,2])
  max= max(a[[1]][,2])
  
  for (j in seq_along(a)) {
    if(min(a[[j]][,2])<min) { 
      min=min(a[[j]][,2])
    } 
    if(max(a[[j]][,2])>max) { 
      max=max(a[[j]][,2])
    } 
  }
  return(c(min,max))
}

limy= function(a) {
  min= min(a[[1]] [,3])
  max= max(a[[1]][,3])
  
  for (j in seq_along(a)) {
    if(min(a[[j]][,3])<min) { 
      min=min(a[[j]][,3])
    } 
    if(max(a[[j]][,3])>max) { 
      max=max(a[[j]][,3])
    } 
  }
  
  return(c(min,max))
}


limz= function(a) {
  min= min(a[[1]] [,1])
  max= max(a[[1]][,1])
  
  for (j in seq_along(a)) {
    if(min(a[[j]][,1])<min) { 
      min=min(a[[j]][,1])
    } 
    if(max(a[[j]][,1])>max) { 
      max=max(a[[j]][,1])
    } 
  }
  
  return(c(min,max))
}

#data preparation

all=list.files(pattern="Traj_") # charge all traj files
f = lapply(strsplit(all, "_"), "[", 2) 
f = unique(unlist(f)) # get a list of all possible ids

Data= list()
traj= list()

for (i in seq_along(f)) {
Data[[i]]= lapply(f,function(all) list.files(pattern= f[i]))  #group data by trajectory

traj[[i]]=lapply(Data[[i]][[1]], read.table, comment.char='%')

names(traj[[i]])=Data[[i]][[1]]
}
dataC= list.files(pattern='mCherry') #cytoplasmic mcherry signal
mcherry= lapply(dataC, read.csv)
names(mcherry)=dataC

#Fusion marker quality

pdf('FusionFrameId.pdf',onefile=TRUE)
fusionframe= matrix(ncol=2, nrow= length(mcherry))
for (i in seq_along(mcherry) ){
  y= mcherry[[i]][,2]
  n=length(mcherry[[i]][,2])
  U =data.frame(tau=1:(n-1), RSS=0)
  for (tau in (1:(n-1))) {
    m1= mean(y[1:tau])
    m2=mean(y[(tau+1):n])
    m= c(rep(m1,tau), rep(m2,(n-tau)))
    e= y-m
    U[tau,2] = sum(e^2)+1
  }
  fusionframe[i,1]=names(mcherry)[i]
  fusionframe[i,2]=as.numeric(which.min(U$RSS))
  plot(mcherry[[i]], type='l', col='red', main= names(mcherry)[i], xlab= "Frames", ylab="mCherry Intensity")
  abline(v=fusionframe[(i),2])
}
dev.off()
 
#3D plots

col= c('blue', 'green','red','orange','pink','cyan','black','purple', 'darkgreen', 'grey', 'darkblue') #create a multicolored vector

pdf('Traj3D.pdf', onefile=TRUE)
for (i in seq_along(traj)) {
  xlim=limx(traj[[i]])
  ylim=limy(traj[[i]])
  zlim=limz(traj[[i]])
  lines3D( traj[[i]][[1]][,2],traj[[i]][[1]][,3],traj[[i]][[1]][,1], col='black', xlab = 'X(Pixels)' , 
           ylab = 'Y(Pixels)' ,zlab='Frames',xlim= xlim, ylim= ylim, zlim= zlim, phi=20, theta= 120)
  #prime  plot
  for (j in seq_along(traj[[i]])) {
    lines3D( traj[[i]][[j]][,2],traj[[i]][[j]][,3],traj[[i]][[j]][,1], 
             col=col[j], add= TRUE) #add each potential trajectory to 3D plot in diff colors
    
  }
  legend( "topleft" , names(traj[[i]]) , col = c(col[seq_along(traj[[i]])]) , lty = c( ) , pch = 1 )
#add a legend to recognize which traj to remove if multiples
  }
dev.off()