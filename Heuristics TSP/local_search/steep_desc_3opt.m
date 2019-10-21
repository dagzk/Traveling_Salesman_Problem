function [tour optimaldistance] = steepestdescent3opt(data)

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

NNdist = optimaldistance %assign the distance traveled during the NN methods as
% 'NNdist'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   START Steepest Descent 3-opt Method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


zmin = -1 %create a variable called zmin and assign a value of -1. This is used
% inside the 3-opt steepest descent below to identify improvements that can
% be made (breaking 3 edges and reconnecting results in an overall shorter
% distance)

x=0; % this is used inside the the 3-opt steepest as a counter. Merely used
% for observational purposes and see how many iterations the code has
% looped through

while   zmin < 0 % continue seeking improvements if an improvement was made
%during the last iteration
        zmin = 0; % reset the improvement variable to zero. if no improvement 
% is identifed in this iteration, z will remain at zero and the while
% condition will break 

        for a=1:noCities-3 % for loop to set point A in the latest tour
            for b=a+1:noCities-2 % for loop to set point B in the latest tour
                for c=b+1:noCities-1 % for loop to set point C in the latest
                    % tour
                    A = tour(1,1:a); % create a vector from node 1 to position
                    % a in the latest tour
                    B = tour(1,a+1:b); % create a vector position a+1 to 
                    % position b in the latest tour
                    C = tour(1,b+1:c); % create a vector from position b+1 to 
                    % position c in the latest tour
                    D = tour(1,c+1:end); % create a vector from position c+1 
                    % to the final node in the latest tour
                    
                    % run through each of the 7 possible ways to reconnect
                    % a tour after breaking 3 edges & calculate the
                    % cost/distance of each option

                    delcost = distanceMatrix(tour(a),tour(a+1))+distanceMatrix(tour(b),tour(b+1))+distanceMatrix(tour(c),tour(c+1));
                    

                    opt1 = [A C B D];
                    cost_opt1=distanceMatrix(tour(a),tour(b+1))+distanceMatrix(tour(c),tour(a+1))+distanceMatrix(tour(b),tour(c+1));
                    
                    opt2 = [A C fliplr(B) D];
                    cost_opt2=distanceMatrix(tour(a),tour(b+1))+distanceMatrix(tour(c),tour(b))+distanceMatrix(tour(a+1),tour(c+1));


                    opt_matrix=[opt1;opt2];
                    
                    if cost_opt1 < cost_opt2                       
                       mincost = cost_opt1;
                       index = 1;                      
                    else
                       mincost = cost_opt2;                      
                       index = 2;
                    end

                    z = mincost - delcost;
                    
                    % if an improvement is made, make the z equal zmin.
                    % save the shortest tour option calculated, along with
                    % the new tour
                    if z < zmin
                       zmin = z;
                       bestoptdist = optimaldistance+z;
                       newtour = opt_matrix(index,:);
                    end
                end
            end
        end
        
        % apply the newly calculated shortest tour 
        if zmin < 0
           optimaldistance = bestoptdist;
           tour = newtour;
         
        end  
        % a counter to see how many times the code has iterated
        x = x+1
end

end

%function to compute routing costs
function cost = compute_route_cost(cost_matrix,route)
total_cost=0;
    for i=1:length(route)-1
        total_cost=total_cost+cost_matrix(route(1,i),route(1,i+1));
    end
    cost=total_cost;
end