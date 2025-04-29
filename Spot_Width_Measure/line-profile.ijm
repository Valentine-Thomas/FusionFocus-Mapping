if (roiManager("count")>0) {
    roiManager("Delete");}

if (roiManager("count")>0) {
    roiManager("Delete");}

close("*");

filepath=getDirectory("ROI");
roi=getFileList(filepath);
eventPath=getDirectory("destination");
imagefolder=getDirectory("Image folder");
imgpath=getFileList(imagefolder);

for (i=0; i<roi.length; i++){
roiManager("Open",filepath+roi[i]);
img=imagefolder+imgpath[i];
open(img);
for (j=0; j<roiManager("count"); j++) {
			if ((j)<10) {
		       x="0"+(j);}
	        else { x=j;}
	        roiManager("Select", j); //select ROI in j position
			profile = getProfile();
		  	for (k=0; k<profile.length; k++){
    			 setResult("Value", k, profile[k]);
  	       		 updateResults;}
  	       		 Plot.create("Profile", "X", "Value", profile);
  	       		 profilePath =eventPath+i+"_profile_"+x+"_myo52.csv";
  	       		 print(profilePath);
  	       		 saveAs("Results",profilePath);
  	       		 run("Clear Results");}
roiManager("Delete");
	if (roiManager("count")>0) {
    roiManager("Delete");}
     close();
}
  	 