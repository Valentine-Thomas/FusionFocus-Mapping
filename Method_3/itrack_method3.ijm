// crop events from images and save them in indvd folders


run("Close All");

// function to open images based on name
function filterFileNames(filelist,pattern,ignorecase)
{
  tmpfiles=newArray(filelist.length);
  count=0;
  for(i=0;i<filelist.length;i++)
  {
    strin=filelist[i];
    if (ignorecase)
    {
      strin=toLowerCase(strin);
      pattern=toLowerCase(pattern);
    }
    if (startsWith(strin,pattern))
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
Dialog.create("Channel to  crop");
Dialog.addString("channel:", "B");
Dialog.show();
channel=Dialog.getString();

ImgDir=getDirectory("Choose images directory"); 
ROIDir=getDirectory("Choose ROI directory"); 
TrajDir=getDirectory("Choose Traj directory"); 


Img=getFileList(ImgDir);
tmpfiles=getFileList(ROIDir);
ffROI= filterFileNames(tmpfiles,"ff-",true);
if( channel== 'BGN') {
	cytoROI= filterFileNames(tmpfiles,"mC-",true);
}

for (i=0; i<Img.length ; i++) { 
	if ((i+1)<10){
		n='0'+(i+1);}
	else{n=i+1;}
	
	pathImg=ImgDir+Img[i];
	pathff=ROIDir+ffROI[i];
	open(pathImg);
	roiManager("Open",pathff);
	outImg=TrajDir+File.separator+"Image_"+n+File.separator;
	File.makeDirectory(outImg);
	
	for (j=0; j<roiManager("count"); j++) {
			if ((j+1)<10) {
		       x="0"+(j+1);}
	        else { x=j+1;}
	        outEvent=outImg+"Event_"+x+File.separator;
	        File.makeDirectory(outEvent);
	        imgTitle= "event_"+x+"_"+channel+ ".tiff";
        	roiManager("Select", j); //select ROI in j position
        	run("Duplicate...", "duplicate");
        	output=outEvent+imgTitle;
        	saveAs("Tiff", output);
        	close(); 
        	}
	roiManager("Delete");
	if (roiManager("count")>0) {
    roiManager("Delete");}
    
	
if( channel== 'BGN') {
	pathcyto=ROIDir+cytoROI[i];
	roiManager("Open",pathcyto);
	for (j=0; j<roiManager("count"); j++) {
			if ((j+1)<10) {
		       n="0"+(j+1);}
	        else { n=j+1;}
	        outEvent=outImg+"Event_"+n+File.separator;
	        print(outEvent);
	        Title= "cyto_"+n+".csv";	
        	roiManager("Select", j); //select ROI in j position
        	 roiManager("Multi Measure");
        	 out_cyto=outEvent+Title;
		     saveAs("Results", out_cyto);
    		run("Clear Results");
        	}
	roiManager("Delete");
	if (roiManager("count")>0) {
    roiManager("Delete");}
	
}
close("*");
}







