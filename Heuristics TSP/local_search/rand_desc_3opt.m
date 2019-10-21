function [stringall tour optimaldistance] = randomdescent3opt(data)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Nearest Neighbour Algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

distanceMatrix = pdist(data); 

distanceMatrix = squareform(distanceMatrix); 

distanceMatrix(distanceMatrix==0) = realmax; % make all zero values in the
% matrix equal to the largest possible floating number
noCities = size(distanceMatrix,1); % calculate the number of rows in the 
% distance matrix, which equates to the number of cities
ShortestDistanceFromStartingCityI = zeros(noCities, 1); % a column vector is 
% created that will store the shortest distance of e full path, starting from 
% city i
optimaldistance = realmax; % initially set as the largest possible floating
% number, it will update each time a new shortest path is calculated, after
% starting from city i

for i=1:noCities % iterate through each city as a starting point for a path
    startCity = i; % assign i as the start city 
    path = startCity; % assign the start of the path as the start city
    currentCity = startCity; % assign the start city as the current city
    distanceTraveled = 0; % initialise the distance traveled to zero
    distanceMatrixNew = distanceMatrix; % a duplicate distance matrix is created
% each time we start at a new city and begin a new path, as the matrix will be
% populated with the largest possible floating point numbers each time a city is
% visited to prevent it being revisited whilst a path is being created
    
    for j=1:noCities-1 % iterate through the number of cities minus 1, since 
% you are already starting at a city at the beginning of the path

        [realMin,cityLocation] = min(distanceMatrixNew(currentCity,:)); 
% navigate to the row in the distanceMatrix that corresponds to the current 
% city. Once found, find the minimum value by checking each element in each
% column, this is the nearest city to the current city. This will save the 
% distance as a'realMin' and the index position as 'cityLocation', which is 
% the next city to visit

        if (length(cityLocation) > 1)
        cityLocation = cityLocation(1); % if the minimum function has returned two 
% cities that are of equal distance away from the current city, select the 
% first element in the vector to visit next 
        end
        
        distanceMatrixNew(:,currentCity) = realmax; % in the distanceMatrixNew
% matrix, populate each row in the column corresponding to the currentCity with the
% largest floating number. This prevents returning to the city again

        path(end+1,1) = cityLocation; % go to the final point in the 
% path vector and add one element. This element is cityLocation (the next node
% to be visited)

        currentCity = cityLocation; % make the city I have moved to the
% current city

        distanceTraveled = distanceTraveled + realMin; % distance traveled is
% the prior distance traveled plus the distance from the previous city to
% to the current city

    end
    
    path(end+1,1) = startCity; % having visited each city, return to your
% starting city

    distanceTraveled = distanceTraveled + distanceMatrix(currentCity, startCity);
% adds the distance from the final city to start city to the overall 
% distance traveled

    ShortestDistanceFromStartingCityI(i,1) = distanceTraveled;

    if  (distanceTraveled < optimaldistance)
        optimaldistance = distanceTraveled; % if the distance traveled
% in the current path is less than the current shortest path (initially set
% to the largest possible floating number, replace it as the shortest path
        tour = transpose(path); 
 % if the above if formula is satisfied, make the path taken when traveling 
% the shortest distance the new shortest path
    end
    
end

%use Nearest Neighbour values as comparison values
NNdistance = optimaldistance;
NNtour = tour;
tour(:, end) = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   START Random Descent 3-opt Method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%declare starting variables
n = numel(tour);
all = [];
stringall = '';
global instancename

%find time constraint value from steepest 3-opt results and use as a
%benchmark
timeconstraint = readtable('steepestdescent3opt_result.csv');
index = table2array((timeconstraint(:,1)));
ind=find(ismember(index,instancename));
time = table2array(timeconstraint(ind,2))

%iterate 2 times and time each iteration using tic/toc
for iteration = 1:2
    tic
    stop = -1;
    optimaldistance = NNdistance;
    tour = NNtour;
    
    %iterate until time constraint is reached
    while stop < 0 
        %randomly select three edges in the tour
        i = randi(n-5);
        a = tour(i);
        i = i+1;
        b = tour(i);
        j = i+randi(n-i-3);
        c = tour(j);
        j = j+1;
        d = tour(j);
        k = j+randi(n-j-1);
        e = tour(k);
        k = k+1;
        f = tour(k);

        %calculate the improvement = new cost - old cost
        z = distanceMatrix(a,c) + distanceMatrix(d,f) + distanceMatrix(b,e) - distanceMatrix(c,d) - distanceMatrix(a,b) - distanceMatrix(e,f);

        % Apply exchange
        if z < 0 %if there is an improvemrnt
            tour(i:j-1) = tour(j-1:-1:i);
            tour(j:k-1) = tour(k-1:-1:j);
        end
        toc;
        if toc > time %when the time limit is reached, then stop
           stop = 1;
        end
    end
    
    %find path (q) and calculate the distance (optimaldistance)
    q = double(tour);
    len = length(q)-1;
    q = q(:,1:len);
    ind = sub2ind([n,n],q,[q(2:n),q(1)]);
    optimaldistance = sum(distanceMatrix(ind))
    
    %store the distance for each iteration
    all(end+1,1) = optimaldistance;
    
    %store the distance for each iteration in 1 string separated by ','
    stringdist = strcat(num2str(optimaldistance), ',');
    stringall = strcat(stringall, stringdist);
end

%return mean of all iterations as optimal distance, as solution is
%non-deterministic
optimaldistance = mean(all)
end