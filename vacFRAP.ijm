//the macro relies on the use of FRAP profiler plugin
// ask the user for the directory with images to process
dir = getDirectory("Choose directory");

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
	name = getTitle();
    dir = getInfo("image.directory");
    run("ROI Manager...");
	setTool("freehand");
//FRAP profiler requires manual selection of the photobleached area and the whole are of organelle/cell in question. sic! smaller area will be automaticaly considered as photobleacher
	waitForUser("Select ROI", "Please select photobleached area and the whole vacuole");	
	run("FRAP Profiler", "curve=[Single exponential recovery] time=0.743");
    roiManager("Select", 0);
//selected areas can be later used for defining what root zone was analyzed. sic! For this, during scanning all roots must be oriented in the same direction! 
    run("Set Measurements...", "area bounding display redirect=None decimal=5");
    roiManager("Show All");
    roiManager("multi-measure append");
    selectWindow("Results");
    saveAs( dir + name +" area.txt");
    selectWindow("Log");
    saveAs( dir + name +" FRAP results.txt");
	run("Close All");
	selectWindow("Results");
	run("Close");
	selectWindow("ROI Manager");
	run("Close");
    selectWindow("Plot Values");
    run("Close");
    selectWindow("Log");
    run("Close");
}
