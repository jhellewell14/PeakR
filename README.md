# PeakR
An R Shiny app which lets users process capillary DNA electrophoresis data in R

Currently PeakR has only been programmed to work in very specific circumstances, what follows are instructions on how to
use PeakR.

For now PeakR only works with very specific input files: exported .csv data files from the program PeakScanner by Applied
Biosystems. Import the .fsa files from capillary electrophoresis machine into PeakScanner and analyse them as usual, next
choose "Export Combined Table" from the menu bar at the top and save the combined table as a .csv file.

Run PeakR in RStudio using the "Run App" button or the command runApp("<app location>"). PeakR will automatically scan 
for runs which are obviously clean (no peaks corresponding to the presence of merozoite surface proteins) or obviously 
infected (very large singular peaks) and writes these results into the files "peakR-results-clean.csv" and "peakR-results.csv".
PeakR will then present you with any indeterminate runs, you must then use the minimum height and size sliders and dye
colour checkboxes to eliminate all peaks except those which you consider to be indications of MSP clones. You can verify
which peaks are under consideration in the table under the electropherogram. Pressing the "commit" button will then write these
peaks into "peakR-results.csv" for you.

The sizing curve is currently set to a constant threshold of 4000 and any peaks falling between 2000 and 4000 will cause
the run to be tagged as indeterminate. If no peaks are above 2000 then the run will be considered clean. The size of your
peaks will change depending on the concentration of your DNA solution, if this sizing curve fails to detect your peaks then
you can alter the sizing curve equation in the sizing.curve() function in the file global.R

