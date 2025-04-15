macro "mCherry intensity" {
	
// measure intensity for each selection added to the roi

function processFolder(input , ct) {  
	list = getFileList(input);
	for (i = 0; i < list.length; i++){
		if(startsWith(list[i],"mC-Roi") ==1 )
		   { path= list[i];
			processFile(path, ct);
		   }
	}
}

function processFile(path, ct) {
	print(Traj+ POI + ct +File.separator+path);
roiManager("Open",Traj+ POI + ct +File.separator+path);	
}

Dialog.create("Parameters:");
Dialog.addString("POI imaged:", "POI-");
Dialog.show();
POI=Dialog.getString();

BGN=getDirectory("BGN");
files= getFileList(BGN);
Traj=getDirectory("trajectories file");
ff=getFileList(Traj);

for (i=0; i<ff.length; i++) {
output = Traj+ff[i];

processFolder(output, i+1); //open mC roi
pathB= BGN+ files[i];   
print (pathB) ;
open(pathB); //open red BGN

    for (j=0; j<roiManager("count"); j++) { 
    n=j+1;
    Title= "mCherry_"+n+".csv";	
    roiManager("Select", j);
    roiManager("Multi Measure");
    saveAs("Results", output+Title);
    run("Clear Results");
}

roiManager("Delete");
roiManager("Delete");
close("*");
print ("done"+ i );
}
print("done");
}