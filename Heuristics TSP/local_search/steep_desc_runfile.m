%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   University of Edinburgh Business School
%   MSc Business Analytics 2017-2018
%   Business Analytics with Heuristics
%   Group 3
%   Project 4
%
%   Chris Loynes
%   Olivier Kraaijeveld
%   Ruitong Le
%   Rongrong Le
%   Georgios Makridakis
%   Daghan Kendirli
%
%   Copyright© of this project is with the authors
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
%                                - TITLE - 
%       Optimizing with Steepest and Random Descent Methods for the Nearest Neighbour
%       Algorithm
%

%                          STEEPEST DESCENT METHODS
%
%                              - HOW TO USE -
%       
%       1. Define which function you want to use by writing the following:
%          on line 45. Select functionname from options below and run file
%
%           selectedfunctionname = 'functionname';
%           e.g.
%           selectedfunctionname = 'steepestdescent2opt';
%
%       Functions to choose from:  
%       
%       1. Steepest Descent Method 2-opt        steepestdescent2opt
%       2. Steepest Descent Method 3-opt        steepestdescent3opt
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       

%Please the function you want to use from the list above
selectedfunctionname = 'steepestdescent2opt';

%select all .tsp files from directory and convert input to function
selectedfunction = str2func(selectedfunctionname)
files = dir('*.tsp');
tourlength = [];
time = [];
instance = {};

%create for loop for all files in directory and convert them to .csv
for i=1:length(files)
    filename=files(i).name
    [pathstr, name, ext] = fileparts(filename);
    copyfile(filename, fullfile(pathstr, [name '.csv']));
    datasetfullname = strcat(name, '.csv');
    instance{end+1,1} = name;
    
%read .csv file and find obsolete headerlines
    fid = fopen(datasetfullname);
    data = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
    firstline = data{1};
    fclose(fid);
    headerline1 = find(strcmp(firstline, 'NODE_COORD_SECTION'), 1);
    headerline2 = find(strcmp(firstline, 'DISPLAY_DATA_SECTION'), 1);
    headerline3 = find(strcmp(firstline, 'NODE_COORD_SECTION '), 1);

%Delete obsolete headerlines
    if ~isempty(headerline1)
      firstline(1:headerline1) = []; 
      firstline(end) = [];
    end
    if ~isempty(headerline2)
      firstline(1:headerline2) = []; 
      firstline(end) = [];
    end
    if ~isempty(headerline3)
      firstline(1:headerline3) = []; 
      firstline(end) = [];
    end
    
%Save the adapted .csv file again
    fid = fopen(datasetfullname, 'w');
    fprintf(fid, '%s\n', firstline{:});
    fclose(fid);
    
%Read the x&y coordinates from the .csv file
    dataset = readtable(datasetfullname, 'CommentStyle', 'EOF');
    data = table2array(dataset(:,2:3));

%declare filename as global variable so it can be used by CLS function
    instancename = name;
    global instancename;
    
%Apply selected function and find CPU time
    tStart=tic;                                             
    [tour, optimaldistance] = selectedfunction(data);
    timeElapsed=toc(tStart);

%save CPU time, distance, path and respectively to arrays
    time(end+1,1) = timeElapsed;
    tourlength(end+1,1) = int64(optimaldistance);
    path = transpose(tour);
    path(end+1,1) = 1;
    path = array2table(path);
end

%convert arrays to tables
instance = array2table(instance);
time = array2table(time);
tourlength = array2table(tourlength);

%read optimal distance from TSPLIB library file
optimalsolution = readtable('optimalsolutions.txt');
nearestneighbour = readtable('originalnearestneighbour_results.csv');

%add all results into 1 matrix
result = horzcat(instance, time, tourlength);

%calculate percentage increase in distance row by row
tourlength = table2array(tourlength);
optimalbounds1 = table2array(optimalsolution(:,2));
percincreaseoveroptimum= [];
for value = 1:size(result)
    percentage = (((tourlength(value) - optimalbounds1(value)) / optimalbounds1(value))) * 100;
    percincreaseoveroptimum(end+1,1) = percentage;
end
percincreaseoveroptimum = array2table(percincreaseoveroptimum);

%percentage decrease compared to original nearest neighbour 
percdecreaseoverNN= [];
for value = 1:size(result)
    percentage = (((tourlength(value) - table2array(nearestneighbour(value,2))) / table2array(nearestneighbour(value,2)))) * 100;
    percdecreaseoverNN(end+1,1) = percentage;
end
percdecreaseoverNN = array2table(percdecreaseoverNN);

%show overview of results in table
result = horzcat(result, percincreaseoveroptimum);
result = join(result, nearestneighbour, 'Keys', 'instance');
result = horzcat(result,percdecreaseoverNN)

%write result matrix to .csv and .xlsx file
resultfilename = strcat(selectedfunctionname, '_result.csv');
writetable(result,resultfilename,'WriteRowNames',true);
resultfilenameexcel = strcat(selectedfunctionname, '_result.xlsx');
writetable(result,resultfilenameexcel,'WriteRowNames',true);