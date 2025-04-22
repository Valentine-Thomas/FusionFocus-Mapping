//SplitChannelMacro adapted from A.Guevarra, align frames adapted from A.Vejstica, BGN-MD from A.Picco

inputFolder= getDirectory("Choose a Directory"); //choose root folder
print(inputFolder); 	//print root folder name
Dialog.create("Image correction, parameters:");
 	Dialog.addNumber("Rolling Ball Radius:",60);
	Dialog.addNumber("Median filter Radius (blue spot radius):",13);
	Dialog.addNumber("Median filter Radius (red spot radius):",13);
	Dialog.addNumber("Median filter Radius (for GFP):",13);
	Dialog.show();
	r=Dialog.getNumber();
	rm=Dialog.getNumber(); 
	rmr=Dialog.getNumber(); 
	rmg=Dialog.getNumber();      
        outputRed= inputFolder + "/RedChannel/"; 
        outputGreen= inputFolder + "/GreenChannel/"; 
        outputBlue= inputFolder + "/BlueChannel/";
   data= getFileList(inputFolder); // make list of all files in input folder
   File.makeDirectory(outputRed); 
   File.makeDirectory(outputGreen); 
   File.makeDirectory(outputBlue);  //create output folder
        
    //split channels   
        for (i=0; i<data.length; i++) {   // set algorithm for alfiles of folder
                setBatchMode(true); //batch mode 
                inputPath= inputFolder + data[i]; // path of image at i rank in list
               run("Bio-Formats Importer", "open=["+inputPath+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");  // open image i of the input folder
                Title=getTitle();  // obtain imageId
                print("Splitting Image: " + Title); // print what the macro is doing
                run("Split Channels"); 
                selectWindow( "C2-" + Title); // select channel C2
                saveAs("Tiff", outputRed + "TRITC_" + Title);	//save as Tiff in red channel folderadd TRITC_ before name
                close(); 
                selectWindow("C3-" + Title); 
                saveAs("Tiff", outputGreen + "GFP_" +Title);	
                close(); 
                selectWindow("C1-" + Title); 
                saveAs("Tiff", outputBlue + "DAPI_"+Title); 
                close();	
                 write("Conversion Complete"); 
      
} 
print("Channels split");
// Align frames for each channel
dataR=getFileList(outputRed);
dataB=getFileList(outputBlue);
dataG=getFileList(outputGreen);
	outputAligned=inputFolder+"/Aligned files/";
	File.makeDirectory(outputAligned);
print("Aligned folder created");
	outputR=outputAligned+"/RedChannel/";
	File.makeDirectory(outputR);
	outputB=outputAligned+"/BlueChannel/";
	File.makeDirectory(outputB);
	outputG=outputAligned+"/GreenChannel/";
	File.makeDirectory(outputG);
transfoFiles=outputAligned+"/Transformations_matrices/";
File.makeDirectory(transfoFiles);
setOption("ExpandableArrays", true);
listTRANSFOfiles=newArray;

for (i = 0; i < dataR.length; i++)
{
	print("loop"+i+ "started");
	pathR=outputRed+dataR[i];
	pathB=outputBlue+dataB[i];
	pathG=outputGreen+dataG[i];
	open(pathR);
	Title=getTitle();
	listTRANSFOfiles[i]=transfoFiles+"TransformationMatrice_"+Title+".txt";
	nameREFmatrix=listTRANSFOfiles[i];
	print("Opened:"+Title);
	run("MultiStackReg", "stack_1=" + Title + " action_1=Align file_1=[" + nameREFmatrix + "] stack_2=None action_2=Ignore file_2=[] transformation=[Rigid Body] save");
	print("aligned red");
	saveAs("Tiff",outputR+Title);
	print("saved"+Title);
	close("*");
	open(pathB);
	Title=getTitle();
	print("Opened"+Title);
	run("MultiStackReg", "stack_1=" + Title + " action_1=[Load Transformation File] file_1=[" + nameREFmatrix + "] stack_2=None action_2=Ignore file_2=[] transformation=[Rigid Body]");
	print("aligned blue");
	saveAs("Tiff",outputB+Title);
	print("saved"+Title);
	close("*");
	open(pathG);
	Title=getTitle();
	print("Opened"+Title);
	run("MultiStackReg", "stack_1=" + Title + " action_1=[Load Transformation File] file_1=[" + nameREFmatrix + "] stack_2=None action_2=Ignore file_2=[] transformation=[Rigid Body]");
	print("aligned green");
	saveAs("Tiff",outputG+Title);
	print("saved"+Title);
	close("*");
}
print("alignement complete");
setBatchMode(false); 

// BGN_MD for Red and blue channel
dataR= getFileList(outputR);
dataB = getFileList(outputB);
dataG=getFileList(outputG);
		outputR_BGN= outputR + "/Red_BGN/"; 
		outputR_BGNMD= outputR + "/Red_BGN-MD/"; 
		outputB_BGN= outputB + "/Blue_BGN/"; 
		outputB_BGNMD= outputB + "/Blue_BGN-MD/";
		outputG_BGN= outputG + "/Green_BGN/"; 
		outputG_BGNMD= outputG + "/Green_BGN-MD/";
File.makeDirectory(outputB_BGN);
File.makeDirectory(outputB_BGNMD);
File.makeDirectory(outputR_BGNMD);
File.makeDirectory(outputR_BGN);
File.makeDirectory(outputG_BGN);
File.makeDirectory(outputG_BGNMD);
print("folders created");
 for (i=0; i<dataR.length; i++) {
 	print("loop"+ i + "started");
	path=outputR+dataR[i];
 	open(path);
 	image_name=getTitle();
	run("Subtract Background...", "rolling="+r+" stack");
	print("red BG subtracted");
	run("Duplicate...", "title=filtered_frame1.tif");
	print("duplication done");
	run("Median...", "radius="+rmr+" stack");
	setOption("BlackBackground", true);
	setAutoThreshold();
	run("Convert to Mask");
	run("Create Selection");
	selectWindow(image_name);
	run("Restore Selection");
	run("corr_bleach");
	print("red PB corrected");
	normalized_output_name=replace(image_name,".tif","_BGN.tif");
	saveAs("Tiff", outputR_BGN+normalized_output_name);
	print("red BGN saved");
	selectWindow("filtered_frame1.tif");
	close();
	selectWindow(normalized_output_name);
	run("Duplicate...", "title=median_filtered_image.tif duplicate");
	run("Median...", "radius="+rm+" stack");
	imageCalculator("Subtract create stack", normalized_output_name,"median_filtered_image.tif");
	print("red normalized");
	md_output_name=replace(image_name,".tif","_BGN_MD.tif");
	saveAs("Tiff", outputR_BGNMD+md_output_name);
	print("red MD saved");
	close("*");
}
print("Red BGN-MD done");
for (i=0; i<dataB.length; i++) {
 	print("loop started");
	path=outputB+dataB[i];
	open(path);
	image_name=getTitle();
	run("Subtract Background...", "rolling="+r+" stack");
	print("blue BG subtracted");
	run("Duplicate...", "title=filtered_frame1.tif");
	run("Median...", "radius="+rm+" stack");
	setOption("BlackBackground", true);
	setAutoThreshold();
	run("Convert to Mask");
	run("Create Selection");
	selectWindow(image_name);
	run("Restore Selection");
	run("corr_bleach");
	print("blue PB corrected");
	normalized_output_name=replace(image_name,".tif","_BGN.tif");
	saveAs("Tiff", outputB_BGN+normalized_output_name);
	print("blue BGN saved");
	selectWindow("filtered_frame1.tif");
	close();
	selectWindow(normalized_output_name);
	run("Duplicate...", "title=median_filtered_image.tif duplicate");
	run("Median...", "radius="+rm+" stack");
	imageCalculator("Subtract create stack", normalized_output_name,"median_filtered_image.tif");
	print("blue normalized");
	md_output_name=replace(image_name,".tif","_BGN_MD.tif");
	saveAs("Tiff", outputB_BGNMD+md_output_name);
	print("blue MD saved");
	close("*");
}
print("blue BGN-MD done");

 for (i=0; i<dataG.length; i++) {
 	print("loop"+ i + "started");
 	path=outputG+dataG[i];
 	open(path);
 	image_name=getTitle();
run("Subtract Background...", "rolling="+r+" stack");
print("green BG subtracted");
run("Duplicate...", "title=filtered_frame1.tif");
run("Median...", "radius="+rmg+" stack");
setOption("BlackBackground", true);
setAutoThreshold();
run("Convert to Mask");
run("Create Selection");
selectWindow(image_name);
run("Restore Selection");
run("corr_bleach");
print("green PB corrected");
normalized_output_name=replace(image_name,".tif","_BGN.tif");
saveAs("Tiff", outputG_BGN+normalized_output_name);
print("green BGN saved");
selectWindow("filtered_frame1.tif");
close();
selectWindow(normalized_output_name);
run("Duplicate...", "title=median_filtered_image.tif duplicate");
run("Median...", "radius="+rmg+" stack");
imageCalculator("Subtract create stack", normalized_output_name,"median_filtered_image.tif");
print("green normalized");
md_output_name=replace(image_name,".tif","_BGN_MD.tif");
saveAs("Tiff", outputG_BGNMD+md_output_name);
print("green MD saved");
close("*");
}
print("green BGN-MD done");
