// ask the user to pick the directory with individual FRAP.tif series
dir = getDirectory("Choose directory");

// ask the user for the framerate used for scanning
scan_speed = getNumber("Scanning speed, sec/frame", 0.743);
//Gaussian blur might help to average out noise that might have a big impact whenROI is very small
Gaussian_Blur = getNumber("Gaussian Blur", 1);

// get file listing
list = getFileList(dir);

// process only tif files
imglist = newArray(0);
for(w = 0; w < list.length; w++) {
	if(endsWith(list[w], 'tif')) {
		imglist = Array.concat(imglist, list[w]);
	}
}

// loop for all tif files in the folder
for(w = 0; w < imglist.length; w++) {
	imgname = dir + imglist[w];
	run("Bio-Formats Windowless Importer", "open=[" + imgname + "]");
	
// get FRAP series name	
	title = getTitle;
    dotIndex = indexOf(title, ".");
    name = substring(title, 0, dotIndex);
    dir = getInfo("image.directory");
    
// user has to decide if drift correction is required. sic! it will fuck up images with low intensities    
    waitForUser("Please scroll through your FRAP time series and decide if it requires drift correction");
    regq = getBoolean("Would you like to carry out drift correction?\n");

if (regq) {
	    driftCorrection3D();
        FRAPquantification();
} else {
	   FRAPquantification();
}
    
//Correct for drift 
    function driftCorrection3D() {
    	run("Correct 3D drift", "channel=1 only=0 lowest=1 highest=1");
    	print("\\Clear");
    	selectWindow("registered time points");
    	}
//FRAP profiler requires manual selection of the photobleached area and the whole are of organelle/cell in question. sic! smaller area will be automaticaly considered as photobleacher
	function FRAPquantification() {
		run("Gaussian Blur...", "sigma=Gaussian_Blur stack");
		run("ROI Manager...");
		setTool("freehand");
		makeOval(250, 250, 20, 20);
		roiManager("add");
		roiManager("Select", 0);
		roiManager("Rename", "photobleached area");
		waitForUser("Select ROI", "Please select or re-select photobleached area and the whole vacuole");
		run("Split Channels");
		close("C2-*");	
		roiManager("Select", 0)
		run("FRAP Profiler", "curve=[Single exponential recovery] time=scan_speed");
        selectWindow("Log");
        saveAs( dir + name +" FRAP results.txt");         
        run("Close");
        close("C1*");	
        close("offsetFRAP:*");	
        run("Images to Stack", "name=[FRAP plots] title=[] use");
        run("Make Montage...", "columns=2 rows=2 scale=1 label");
        saveAs("png", dir + name +" FRAPplots.png"); 
        run("Close All");
        selectWindow("Plot Values");
        run("Close");   
        }
        selectWindow("ROI Manager");
        run("Close");
}