In order to obtain all results please open the ‘ConstructionHeuristics.m’ file in MATLAB and run the file. 
Make sure that all files from the folder are in the same folder. The project is designed to be fully automated and therefore is plug-and-play. While the file is running, it will display both the heuristic it is applying and which dataset is handled. 

This MATLAB file will:

- Convert all 43 .tsp files from the directory to .csv files
- Calculate a distance matrix for each of the instances and save that distance matrix to a (instancename)_distancematrix.txt file
- Apply all 7 construction heuristic functions to each of the instances. Each function will return an optimal path order and tour length. The CPU time for each function is saved.
- Compare results from each construction heuristic to the optimal solution for that instance and return the increase in distance compared to the known optimum solution. Optimum solutions were taken from the TSPLIB Documentation file . 
- Return a 43 x 22 matrix with instance names as rows and 7 x3 columns with for each of the 7 heuristics respectively its tour length, the CPU time and tour length increase in percentages (%) over the optimum solution (PerformanceResult).
- Perform basic (min, max, mean, std and iqr) statistics over the above results and return this to the screen (PerformanceStatisticsResult).
- Perform basic (min, max, mean, std and iqr) statistics over the percentage over optimum solution increase per dataset and return this to screen (DatasetPerformanceStatisticsResult).
- Save both performance and statistics results as .csv and .xlsx
