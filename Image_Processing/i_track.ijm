
macro "i_track" {
	
// Atomated centroid extraction using a custom version of Particle Tracker ( modified by Dr. Andrea Picco)
	//enter PT parameters + POI imaged
Dialog.create("Particle Tracker, parameters:");
Dialog.addString("POI imaged:", "POI-");  //enter prot name as POI-é
Dialog.addString("Channel:","_B");
Dialog.addNumber("Particle radius",13);
Dialog.addNumber("Percentile",0.5);
Dialog.show();
POI=Dialog.getString();
ch=Dialog.getString();
rpt=Dialog.getNumber();
pc=Dialog.getNumber();  

//functions to open ff-ROI for each files
function processFolder(input , ct) {
	list = getFileList(input); 
	for (i = 0; i < list.length; i++){
		if(startsWith(list[i],"ff-Roi") ==1 )  // check if file is ROI for fusion focus
		   { path= list[i];                     
			processFile(path, ct);
		   }
	}
}

function processFile(path, ct) {
roiManager("Open",Traj+ POI + ct +File.separator+path);	  // open ROI; can be modified to do wtv on the file
}

//get BGN and trajectories folders' directories

BGN= getDirectory("Choose BGN-MD folder");
Traj= getDirectory(" Choose trajectories folder");
data=getFileList(BGN);
f=getFileList(Traj);
for (i=0; i<data.length; i++) {
	print ( "Tracking particules for:"+POI+(i+1));
	pathBGN=BGN+data[i];
	open(pathBGN);  //open BGN-MD image
	ff= Traj+f[i];
	processFolder(ff, i+1); //open ROI for ff
	
roiManager("List");
list_name= "ROI_coord_"+(i+1)+".csv";
coord= Traj+ POI +(i+1)+File.separator+list_name;
print("saving:"+coord);
saveAs("Results", coord); //save coordinates of each ROI 
run("Clear Results");
	for (j=0; j<
	roiManager("count"); j++) {
		n=j+1;    
        Title= "image_"+n+ch+ ".tiff";
        roiManager("Select", j); //select ROI in j position
        run("Duplicate...", "duplicate");  //duplicate ROI 
        output=Traj+ POI +(i+1)+File.separator+Title;
        print("saving:"+output);
        saveAs("Tiff", output);  //Save movie of cropped area aka FF(j) 
        //run particle tracker on cropped image      
        run("Particle Tracker", "radius="+rpt+" cutoff=0 percentile="+pc+" link=3 displacement=15");

        close();
	}
	roiManager("Delete");
    roiManager("Delete");
	close("*");
	}
    
//	run("Quit");
}