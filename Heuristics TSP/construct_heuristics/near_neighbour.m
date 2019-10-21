function [tour optimaldistance] = nearestneighbour(data)

distanceMatrix = pdist(data); % calculate the distance between
% each of the x&y co-ordinates and store in a matrix called
% 'distanceMatrix'

distanceMatrix = squareform(distanceMatrix); % store the values in the 
% distanceMatrix in a square matrix with all of the distances calculated 
% between the cities

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