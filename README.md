# vacFRAP
Half-baked (misses the statistical analysis) pipeline originally developed for FRAP analysis of vacuolar lumen markers in <i>Arabidopsis thaliana</i> roots. It shuld be applicable for any FRAPS with currently the only restrictriction: FRAP series must have 4 frames scanned before photobleaching was done.

<b>Installation </b>
1. <a href="https://imagej.net/Fiji/Downloads">Fiji</a>
2. <a href="https://github.com/AlyonaMinina/vacFRAP/tree/master/FRAP%20profiler%20modified%20to%20detect%20recovery%20at%20the%205th%20slice">Hacked FRAP_profiler plugin</a>:
- download the zip of the repository and extract all files
- open Fiji (ImageJ)-> Plugins-> Install Plugin-> locate FRAP_profiler.class you downloaded from the repository-> Install
- restart Fiji


Analysis:

1. Create a folder with all FRAP series saved as individual tif files
- open Fiji
- Plugins-> Macro->Run-> locate “Processing Leica CLSM project file for vacFRAP.ijm” file you downloaded from the repository
- open the folder with the Leica CLSM project file with FRAP series into the first macro that will split it into individual tiffs (this stuff can also be done manually for other confocal systems)
- make sure that you have a folder containing only FRAP series saved as tiffs

2. Process all FRAP series in the created folder
- in Fiji go to Plugins-> Macro->Run-> locate “vacFRAP.ijm” file you downloaded from the repository
- select the folder with FRAP series
- Type in the frame rate of your FRAP series (how many sec it takes to scan a single frame)
- Decide if you want to blur the FRAP images.  Blur might be needed for extra difficult FRAPs of tiny structures with low signal intensity. Otherwise set to 0. Sic! Make sure that ALL series you are comparing are processed in the same way.
- Decide if your series need drift correction and chose yes or no, accordingly
- Move the selection named “photobleached area” to where it belongs 
- Use the freehand tool to select the whole vacuole in question-> add to ROI manger and click ok
- The quantitative data and combined plots will be saved into the folder with the FRAP series
- Macro will process all .tiff files in your folder
