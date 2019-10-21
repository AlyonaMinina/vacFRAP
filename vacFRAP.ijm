// ask the user for the directory with images to process
dir = getDirectory("Choose directory");

// also ask for the upper threshold limit
scan_speed = getNumber("Scanning speed, sec/frame", 0.743);


// get file listing
list = getFileList(dir);
newlist = list;

for(i = 0; i < list.length; i++) {
	if (endsWith(list[i], '/')) {
		files = getFileList(dir + list[i]);
		for (n = 0; n < files.length; n++) {
			files[n] = list[i] + '/' + files[n];
		}
		newlist = Array.concat(newlist, files);
	}
}
list = newlist;

// process only tif files
imglist = newArray(0);
for(w = 0; w < list.length; w++) {
	if(endsWith(list[w], 'tif')) {
		imglist = Array.concat(imglist, list[w]);
	}
}


// loop for all images in the folder
for(w = 0; w < imglist.length; w++) {
	name = dir + '/' + imglist[w];
	basename = File.getName(name);

	run("Bio-Formats Windowless Importer", "open=[" + name + "]");
	
//get FRAP series name	
	title = getTitle;
    dotIndex = indexOf(title, ".");
    name = substring(title, 0, dotIndex);
    dir = getInfo("image.directory");

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
		run("ROI Manager...");
		setTool("freehand");
		waitForUser("Select ROI", "Please select photobleached area and the whole vacuole");
		run("Split Channels");
		close("C2-*");	
		roiManager("Select", 0)
		run("FRAP Profiler", "curve=[Single exponential recovery] time=scan_speed");
        selectWindow("Log");
        saveAs( dir + name +" FRAP results.txt");         
        run("Close");
        close("/*");	
        close("C1*");	
        close("offsetFRAP:*");	
        run("Images to Stack", "name=[FRAP plots] title=[] use");
        run("Make Montage...", "columns=2 rows=2 scale=1 label");
        saveAs("png", dir + name +" FRAPplots.png"); 
        run("Close All");
        selectWindow("ROI Manager");
        run("Close");
        selectWindow("Plot Values");
        run("Close");   
}