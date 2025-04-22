run("Close All");

function filterFileNames(filelist,extension,ignorecase)
{
  tmpfiles=newArray(filelist.length);
  count=0;
  pattern=extension;
  for(i=0;i<filelist.length;i++)
  {
    strin=filelist[i];
    if (ignorecase)
    {
      strin=toLowerCase(strin);
      pattern=toLowerCase(pattern);
    }
    if (endsWith(strin,pattern))
    {
      tmpfiles[count]=filelist[i];
      count++;
    }
  }
  filteredList=newArray(count);
  for (i=0;i<count;i++)
  {
    filteredList[i]=tmpfiles[i];
    print(filteredList[i]);
  }
  return filteredList;
}

imgDir=getDirectory("Image folder");
eventFolders=getFileList(imgDir);
for (i=0; i<eventFolders.length; i++){
	eventPath=imgDir+eventFolders[i];
	tmpfiles=getFileList(eventPath);
	B=filterFileNames(tmpfiles,"_B.tiff",true);
	R=filterFileNames(tmpfiles,"_R.tiff",true);
	G=filterFileNames(tmpfiles,"_G.tiff",true);
	ROI=filterFileNames(tmpfiles,".zip",true);
	roiManager("Open",eventPath+ROI[0]);
	
	open(eventPath+B[0]);
	for (j=0; j<roiManager("count"); j++) {
			if ((j+1)<10) {
		       x="0"+(j+1);}
	        else { x=j+1;}
	        roiManager("Select", j); //select ROI in j position
			profile = getProfile();
		  	for (k=0; k<profile.length; k++){
    			 setResult("Value", k, profile[k]);
  	       		 updateResults;}
  	       		 Plot.create("Profile", "X", "Value", profile);
  	       		 profilePath =eventPath+"profile_"+x+"_B.csv";
  	       		 print(profilePath);
  	       		 saveAs("Results",profilePath);
  	       		 run("Clear Results");}
  	      close();
  	      
  	  open(eventPath+G[0]);
		for (j=0; j<roiManager("count"); j++) {
			if ((j+1)<10) {
		       x="0"+(j+1);}
	        else { x=j+1;}
	        roiManager("Select", j); //select ROI in j position
			profile = getProfile();
		  	for (k=0; k<profile.length; k++){
    			 setResult("Value", k, profile[k]);
  	       		 updateResults;}
  	       		 Plot.create("Profile", "X", "Value", profile);
  	       		 profilePath =eventPath+"profile_"+x+"_G.csv";
  	       		 print(profilePath);
  	       		 saveAs("Results",profilePath);
  	       		 run("Clear Results");}
  	      close();
  	   open(eventPath+R[0]);
		for (j=0; j<roiManager("count"); j++) {
			if ((j+1)<10) {
		       x="0"+(j+1);}
	        else { x=j+1;}
	        roiManager("Select", j); //select ROI in j position
			profile = getProfile();
		  	for (k=0; k<profile.length; k++){
    			 setResult("Value", k, profile[k]);
  	       		 updateResults;}
  	       		 Plot.create("Profile", "X", "Value", profile);
  	       		 profilePath =eventPath+"profile_"+x+"_R.csv";
  	       		 print(profilePath);
  	       		 saveAs("Results",profilePath);
  	       		 run("Clear Results");}
  	      close();   
  	      
   roiManager("Delete");
	if (roiManager("count")>0) {
    roiManager("Delete");}
	
}
