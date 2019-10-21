function [tour, optimaldistance] = cheapestinsertion(data)

%calculate the distance matrix and define starting variables
DistanceMatrix = squareform(pdist(data, 'euclidean'));
DistanceMatrix(DistanceMatrix==0) = realmax;
NoCities = size(DistanceMatrix,2);
optimaldistance = realmax;   

for r = 1:NoCities
    OriginNode = r;
    Path = OriginNode;
    OutsideNodes = (1:size(DistanceMatrix,1));
    OutsideNodes(OutsideNodes==OriginNode) = [];
    CurrentNode = OriginNode;
    DistanceTravelled = 0;
    Shortest_Ins_Cost = realmax; 
         
    [real_Min,NextNode] = min(DistanceMatrix(CurrentNode,:)); 
    % navigate to the row in the distanceMatrix that corresponds to the current 
    % city. Once found, find the minimum value by checking each element in each
    % column, this is the nearest city to the current city. This will save the 
    % distance as a'realMin' and the index position as 'cityLocation', which is 
    % the next city to visit

    if (length(NextNode) > 1)
        NextNode = NextNode(1); % if the minimum function has returned two 
        % cities that are of equal distance away from the current city, select the 
        % first element in the vector to visit next 
    end    
    Path(end+1,1) = NextNode;
    CurrentNode = NextNode;
    DistanceTravelled = DistanceTravelled + real_Min;
    OutsideNodes(OutsideNodes == CurrentNode) = [];
    Path(end+1,1) = OriginNode;
    DistanceTravelled = DistanceTravelled + DistanceMatrix(CurrentNode, OriginNode);
    
        for d = 1:NoCities-2
            Shortest_Ins_Cost = realmax;
        % Select which city to insert
            for a = 1:size(Path,1)-1
                b = a+1;
                i = Path(a,1);
                j = Path(b,1);
                    for c = 1:size(OutsideNodes,2)  %number of nodes to insert
                        k = OutsideNodes(1,c);
                        CalculateCost = DistanceMatrix(i,k)+DistanceMatrix(k,j)-DistanceMatrix(i,j);
                        if CalculateCost < Shortest_Ins_Cost
                            Shortest_Ins_Cost = CalculateCost;
                            enter_city = OutsideNodes(1,c); %value from row 1 column
                            %[enter_position,irrelevant] = find(Path==i)
                            %enter_position = enter_position + 1
                            enter_position = b;
                        end
                    end
            end     
            DistanceTravelled = DistanceTravelled + Shortest_Ins_Cost;     
            Path(end+1,1) = 0;
            z = size(Path,1);

            for y = z:-1:2
                Path(y) = Path(y-1);
                if  y == enter_position
                    break
                end
            end
            Path(enter_position) = enter_city;
            %[irr,NodeInOutVec] = find(OutsideNodes==k)
            OutsideNodes(OutsideNodes==enter_city) = [];
        end
        ShortestDistFromOrigNode(r,1) = DistanceTravelled;

    if  (DistanceTravelled < optimaldistance)
            optimaldistance = DistanceTravelled;
            tour = transpose(Path);
    end    
end