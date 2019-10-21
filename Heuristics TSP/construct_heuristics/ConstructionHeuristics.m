%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   
%   University of Edinburgh Business School
%   MSc Business Analytics 2017-2018
%   Business Analytics with Heuristics
%   Group 3
%
%   Chris Loynes
%   Olivier Kraaijeveld
%   Ruitong Le
%   Rongrong Le
%   Georgios Makridakis
%   Daghan Kendirli
%
%   Please read attached 'Documentation' and 'Report' file for more information
%   
%   Copyright© of this project is with the authors
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
%                                - TITLE - 
%       Developing decision rules for selecting construction heuristics 
%

%   
%                              - HOW TO USE -
%
%       Estimated run time: 30-90 minutes (depending on computing power)
%       
%       1. Run file, which will return the results and statistics in 3
%       separate tables. That's it:)
%
%       Construction heuristics that are applied to 43 (n <= 500 nodes) TSPLIB instances: 
%       
%       1. Optimized Clarke & Wright Savings Algorithm    
%       2. Nearest Neighbour (NN) Algorithm     
%       3. Nearest Insertion procedure          
%       4. Farthest Insertion procedure         
%       5. Arbitrary Insertion procedure        
%       6. Cheapest Insertion procedure         
%       7. Nearest Merger Algorithm             
%       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%array with all functionnames
selectedfunction = {'clarkeandwright', 'nearestneighbour', 'nearestinsertion', 'farthestinsertion', 'arbitraryinsertion', 'cheapestinsertion','nearestmerger'}

%for loop to apply each function to all 43. tsp instances
for kol=1:size(selectedfunction,2)
    selectedfunctionname = selectedfunction{kol}
    
    %convert string to function handle
    actualselectedfunction = str2func(selectedfunctionname);

    %select all .tsp files from directory
    files = dir('*.tsp');
    bestdistance = [];
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

    %Task 1. Create distance matrix and write to .txt file

    %Create distance matrix
        x = table2array(dataset(:,2));
        kol = table2array(dataset(:,3));
        distance = squareform(pdist(data, 'euclidean'));

    %create filename for instance distance matrix file
        var = strcat(name, '_distancematrix.txt');

    %Write distance matrix to .txt file line by line
        fid = fopen(var, 'wt'); 
        for i=1:size(distance,1)
           fprintf(fid, '%d ', distance(i,:));
           fprintf(fid, '\n');
        end
        fclose(fid);

    %Function returns a matrix with instancename, costs/distance, CPU time,
    %optimal distance and % increase in costs/distance

    %Apply function to dataset and time function using tic & toc
        tStart=tic;   
        [tour optimaldistance] = actualselectedfunction(data);
        timeElapsed=toc(tStart);    

    %save CPU time, distance and path respectively to arrays
        time(end+1,1) = timeElapsed;
        bestdistance(end+1,1) = int64(optimaldistance);
        path = transpose(tour);
        path(end+1,1) = 1;
        path = array2table(path);

    %     Remove comments in order to plot all datasets and path results
    %     
    %     Concatenate path order with node coordinates
    %     path.Properties.VariableNames = {'Path'};
    %     dataset.Properties.VariableNames = {'Path','x','y'};
    %     mergedfile = innerjoin(path, dataset, 'Keys', 'Path')
    %     x1 = table2array(mergedfile(:,2));
    %     y1 = table2array(mergedfile(:,3));
    % 
    %     Plot the dataset and the optimized path
    %     figure
    %     subplot(2,1,1);       % add first dataset scatterplot in 2 x 1 grid
    %     scatter(x,y);
    %     title(strcat('Visualisation of TSPLIB instance: ', 32, name));
    %     subplot(2,1,2);       % add second optimal path plot in 2 x 1 grid
    %     plot(x1,y1);           
    %     title('Optimized path to solve TSP')

    end

    %convert arrays to tables
    instance = array2table(instance);
    time = array2table(time);
    bestdistance = array2table(bestdistance);

    %read optimal distance from TSPLIB library file
    optimalbounds = readtable('optimalsolutions.txt');

    %add all results into 1 matrix
    result = horzcat(instance, bestdistance, time);
    result = join(result, optimalbounds, 'Keys', 'instance');

    %calculate percentage increase in distance row by row
    bestdistance = table2array(bestdistance);
    optimalbounds1 = table2array(optimalbounds(:,2));
    percentageincrease= [];
    for value = 1:size(result)
        percentage = (((bestdistance(value) - optimalbounds1(value)) / optimalbounds1(value))) * 100;
        percentageincrease(end+1,1) = percentage;
    end
    percentageincrease = array2table(percentageincrease);

    %show overview of results in table
    result = horzcat(result, percentageincrease);

    %write result matrix to .csv file
    resultfilename = strcat(selectedfunctionname, '_result.csv');
    writetable(result,resultfilename,'WriteRowNames',true);
end

CW = readtable('clarkeandwright_result.csv');
NN = readtable('nearestneighbour_result.csv');
CI = readtable('cheapestinsertion_result.csv');
FI = readtable('farthestinsertion_result.csv');
AI = readtable('arbitraryinsertion_result.csv');
NI = readtable('nearestinsertion_result.csv');
NM = readtable('nearestmerger_result.csv');

%select relevant columns from tables
CW = CW(:,[1,2,3,5]);
CW.Properties.VariableNames = {'Instance', 'CWbestdistance' 'CWtime','CWperc'};
NN = NN(:,[2,3,5]);
NN.Properties.VariableNames = {'NNbestdistance' 'NNtime','NNperc'};
CI = CI(:,[2,3,5]);
CI.Properties.VariableNames = {'CIbestdistance' 'CItime','CIperc'};
FI = FI(:,[2,3,5]);
FI.Properties.VariableNames = {'FIbestdistance' 'FItime','FIperc'};
AI = AI(:,[2,3,5]);
AI.Properties.VariableNames = {'AIbestdistance' 'AItime','AIperc'};
NI = NI(:,[2,3,5]);
NI.Properties.VariableNames = {'NIbestdistance' 'NItime','NIperc'};
NM = NM(:,[2,3,5]);
NM.Properties.VariableNames = {'NMbestdistance' 'NMtime','NMperc'};

%concatenate all results together in 1 matrix and save it to a .csv file
endresult = horzcat(CW,NN,CI,FI,AI,NI,NM);

%calculate 5 statistics for every method's results and put in matrix
index = transpose({'Min', 'Max', 'Mean', 'Std', 'IQR'});
index2 = transpose({'Min', 'Max', 'Mean', 'Std', 'IQR'});
index = array2table(index);
index2 = array2table(index2);
index2.Properties.VariableNames = {'index'};
for num = 2:size(endresult,2)
    column = endresult(:,num);
    columnname = column.Properties.VariableNames;
    column = table2array(column);
    colmin = min(column);
    colmax = max(column);
    colmean = mean(column);
    colstd = std(column);
    coliqr = iqr(column);
    values = transpose([colmin colmax colmean colstd coliqr]);
    values = array2table(values);
    values.Properties.VariableNames = columnname;
    index = [index values];
    heuristicstatistics = join(index2, index, 'Keys', 'index');
end
%save final result to 2 separate .csv files and 2 separate .xlsx files
endresult
writetable(endresult,'ConstructionHeuristics_PerformanceResult.xlsx','WriteRowNames',true);
writetable(endresult,'ConstructionHeuristics_PerformanceResult.csv','WriteRowNames',true);
heuristicstatistics
writetable(heuristicstatistics,'ConstructionHeuristics_PerformanceStatisticsResult.xlsx','WriteRowNames',true);
writetable(heuristicstatistics,'ConstructionHeuristics_PerformanceStatisticsResult.csv','WriteRowNames',true);

%calculate performance statistics for each dataset independently 
datasetstats = table2array(endresult(:,[4,7,10,13,16,19,22]));
percincreasemin = [];
percincreasemax = [];
percincreasemean = [];
percincreasestd =[];
percincreaseiqr = [];
for j=1:size(datasetstats,1)
    datasetpercincr = datasetstats(j,:);
    datasetpercincrmin = min(datasetpercincr);
    percincreasemin(end+1,1) = datasetpercincrmin;
    datasetpercincrmax = max(datasetpercincr);
    percincreasemax(end+1,1) = datasetpercincrmax;
    datasetpercincrmean = mean(datasetpercincr);
    percincreasemean(end+1,1) = datasetpercincrmean;
    datasetpercincrstd = std(datasetpercincr);
    percincreasestd(end+1,1) = datasetpercincrstd;
    datasetpercincriqr = iqr(datasetpercincr);
    percincreaseiqr(end+1,1) = datasetpercincriqr;
end

%add all statistics together to 1 table
percincreasemin = array2table(percincreasemin);
percincreasemax = array2table(percincreasemax);
percincreasemean = array2table(percincreasemean);
percincreasestd = array2table(percincreasestd);
percincreaseiqr = array2table(percincreaseiqr);
datasetstatistics = [endresult(:,1) percincreasemin percincreasemax percincreasemean percincreasestd percincreaseiqr]

%save result to .csv file and to .xlsx file
writetable(datasetstatistics, 'ConstructionHeuristics_DatasetPerformanceStatisticsResult.xlsx' ,'WriteRowNames',true);
writetable(datasetstatistics,'ConstructionHeuristics_DatasetPerformanceStatisticsResult.csv','WriteRowNames',true);