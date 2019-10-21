**Please make sure both the Steepest Methods have been executed before running the Random Descent methods.**

### How to run the Steepest Descent code

In order to obtain all results for Steepest Descent please open the ‘steep_desc_runfile.m’ file in MATLAB. From the proposed list select which function you want to run and run the file afterwards. Make sure that all files from the folder are in the same folder. 
While the file is running, it will display both the classical local search technique it is applying and which dataset is handled.  

This MATLAB file will:
- Convert all 27 .tsp files from the directory to .csv files
- Apply the selected Classical Local Search technique to the above 27 .tsp instances 
- Compute the CPU time and minimum distance/costs for that technique for each TSPLIB instance 
- Compare results from the CLS to the optimum solution for that instance and return the increase (%) in costs/distance compared to the known optimum solution. Optimum solutions were taken from the TSPLIB Documentation file . 
- Compare results from the CLS to the original Nearest Neighbour solution and show the decrease in costs/distance in percentages.
- Return all of the above in 1 matrix which is saved as both a .csv and a .xlsx file for that function. The file name looks like (functionname)_result.csv or (functionname)_result.xlsx e.g. steepestdescent2opt_result.csv

### How to run the Random Descent code

In order to obtain all results for Random Descent please open the ‘rand_desc_runfile.’ file in MATLAB. From the proposed list select which function you want to run and run the file afterwards. Make sure that all files from the folder are in the same folder. While the file is running, it will display both the classical local search technique it is applying and which dataset is handled. The ‘nearestneighbour.m’ function has been used to create a benchmark file ‘originalnearestneighbour_results.txt’, even though each of the CLS functions runs the Nearest Neighbour Algorithm in its own code. 

This MATLAB file will:
 - Apply the same steps as the Steepest Descent method but then for the Random Descent method
