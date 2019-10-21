function [tour, optimaldistance] = clarkeandwright(data)

%define number of nodes and declare starting variables
totalsize = size(data,1); 
StartingNode = 0;
alldistances = [];

%select any node as starting node and find node with shortest path
for k=1:totalsize
    StartingNode = StartingNode + 1;  
    distances = squareform(pdist(data, 'euclidean'));  %find distancematrix
    savings = zeros(totalsize);                        %empty matrix for savings

%calculate savings for each node and rank them descending
    for i=1:totalsize    
        savings(i,(i+1):totalsize) = distances(i,StartingNode)+distances(StartingNode,(i+1):totalsize)-distances(i,(i+1):totalsize);
    end
    minParent = 1:totalsize;
    [~,si] = sort(savings(:),'descend');
    si = si(1:fix(end));

%track and count visited nodes
    VisitedNodes = zeros(1,totalsize);
    VisitedNodes(StartingNode) = 1;
    CountVisitedNodes = totalsize-1;
    degrees = zeros(1,totalsize);
    selectedNode = 1;  
    tour = zeros(totalsize,2);
    currentEdgeCount = 1;

%form appropriate subtours based upon the savings until path is completed
    while CountVisitedNodes > 2
        i = mod(si(selectedNode)-1,totalsize)+1;
        j = floor((si(selectedNode)-1)/totalsize)+1;
        
        %form larger subtours by linking appropriate nodes i and j
        if VisitedNodes(i)==0 && VisitedNodes(j)==0 && (minParent(i)~=minParent(j)) && i~=j && i~=StartingNode && j~=StartingNode     
            degrees(i)=degrees(i)+1;
            degrees(j)=degrees(j)+1;
            tour(currentEdgeCount,:) = [i,j];
            if minParent(i)<minParent(j)
                minParent(minParent==minParent(j))=minParent(i);
            else
                minParent(minParent==minParent(i))=minParent(j);            
            end
            currentEdgeCount = currentEdgeCount + 1;
            if degrees(i)==2
                VisitedNodes(i) = 1;
                CountVisitedNodes = CountVisitedNodes - 1;
            end
            if degrees(j)==2
                VisitedNodes(j) = 1;
                CountVisitedNodes = CountVisitedNodes - 1;
            end
        end
        selectedNode = selectedNode + 1;
    end

%check which nodes are still remaining
    remain = find(VisitedNodes==0);
    n1=remain(1);
    n2=remain(2);

%add node to tour and apply StitchTour function to pair nodes
    tour(currentEdgeCount,:) = [StartingNode n1];
    currentEdgeCount = currentEdgeCount + 1;
    tour(currentEdgeCount,:) = [StartingNode n2];
    tour = stitchTour(tour);
    tour = tour(:,1)';
    
%calculate distance traveled
    length = distances(tour(end),tour(1));
    for i=1:totalsize-1 
        length = length + distances(tour(i),tour(i+1));
        tour(:,i+1);
    end
    
%add all total distances to array
    alldistances(end+1,1) = length;
    
%select minimum distance from all distances to 
    optimaldistance = min(alldistances);
end

    function tour = stitchTour(t) %merge all nodes together in pairs

    totalsize=size(t,1);

    [~,nIdx] = sort(t(:,1));
    t=t(nIdx,:);

    tour(1,:) = t(1,:);
    t(1,:) = -t(1,:);
    lastNode = tour(1,2);

    %find starting node, followed by next edge + node and add column
    for i=2:totalsize
        nextEdge = find(t(:,1)==lastNode,1);
        if ~isempty(nextEdge)
            tour(i,:) = t(nextEdge,:);
            t(nextEdge,:)=-t(nextEdge,:);
        else
            nextEdge = find(t(:,2)==lastNode,1);
            tour(i,:) = t(nextEdge,[2 1]);
            t(nextEdge,:)=-t(nextEdge,:);
        end
        lastNode = tour(i,2);

    end
    end
end

