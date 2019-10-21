function [tour optimaldistance] = nearestmerger(data)
distancematrix = squareform(pdist(data, 'euclidean'));%distance matrix
n = size(distancematrix,1);
d = triu(distancematrix);%distance matrix
d(d==0)=inf; %avoid repeat               
tour=zeros(n,n);
alldistance = [];
for i=1:n  %create n subtours which have only one node
    for j=1:2
        tour(i,j)=i;
        j=j+1;
    end
    i=i+1;
end

while sum(d(:)==inf)< numel(distancematrix)
        mindistance=min(min(d)); %find the shortest distance between nodes
        [X Y]=find(d==mindistance);%put all pair of nodes which have the shortest distance in one matrix
        g=[X Y];
        shortest=g(1,:);%find the first shortest pair
        x=shortest(1,1);
        y=shortest(1,2);
        [row1 col1]=find(tour==x);%find where node x is in subtour matrix
        [row2 col2]=find(tour==y);%find where node y is in subtour matrix
        rowlocationx=row1(1,:);%find the row number of node x in subtour matrix
        rowlocationy=row2(1,:);%find the row number of node y in subtour matrix
    
        %if node x and node y are already in the same subtour
        if rowlocationx==rowlocationy 
            d(x,y)=inf;
            d(y,x)=inf;

        %if node x is in a subtour which only has one node
        else
            if length(nonzeros(tour(rowlocationx,:)))<=2
                if length(nonzeros(tour(rowlocationy,:)))<=2 %if node y is in a subtour which only has one node
                    tour(rowlocationx,2)=y;%insert node into a subtour
                    tour(rowlocationx,3)=x;%close the subtour
                    tour(rowlocationy,:)=[];%delete the subtour which has been inserted in another subtour
                    d(x,y)=inf;
                    d(y,x)=inf;
                
    %if node y is in a subtour which has more than one node,and node x is alone
                else
                    for r = 1:length(nonzeros(tour(rowlocationy,:)))-1      %find where is the shortest in the subtour to insert in 
                        Cheapest_Break = realmax;
                        l = r+1;
                        upper = tour(rowlocationy,r);
                        lower = tour(rowlocationy,l);
                        Cost = distancematrix(upper,x)+distancematrix(x,lower)-distancematrix(upper,lower);
                        if Cost < Cheapest_Break
                            Cheapest_Break = Cost;
                            enter_position = l;
                        end
                    end
                
                    z = length(nonzeros(tour(rowlocationy,:)))+1;
                    for h= z:-1:2
                        tour(rowlocationy,h) = tour(rowlocationy,h-1);% put node x into subtour which contains node y
                        if h==enter_position
                            break
                        end
                    end
                    tour(rowlocationy,enter_position) = x;
                    tour(rowlocationx,:)=[];
                    d(x,y)=inf;
                    d(y,x)=inf;            
                end
            
        %if node x is in a subtour which has more than one node, and node y is alone
        else if length(nonzeros(tour(rowlocationy,:)))<=2  
    
                for r = 1:length(nonzeros(tour(rowlocationx,:)))-1      %find where is the shortest in the subtour to insert in  
                    Cheapest_Break = realmax;
                    l = r+1;
                    upper = tour(rowlocationx,r);
                    lower = tour(rowlocationx,l);
                    Cost = distancematrix(upper,y)+distancematrix(y,lower)-distancematrix(upper,lower);
                    if Cost < Cheapest_Break
                        Cheapest_Break = Cost;
                        enter_position = l;
                    end
                end
                
                z = length(nonzeros(tour(rowlocationx,:)))+1;
                for h= z:-1:2
                    tour(rowlocationx,h) = tour(rowlocationx,h-1);% put node x into subtour which contains node y
                    if h==enter_position
                        break
                    end
                end
                tour(rowlocationx,enter_position) = y;
                tour(rowlocationy,:)=[];
                d(x,y)=inf;
                d(y,x)=inf;            
            
            %if node x and node y are both in the subtours which have more than one node
            else
                
                for r = 1:length(nonzeros(tour(rowlocationx,:)))-1  
                    Cheapest_Break = realmax;
                    l = r+1;
                    upper1 = tour(rowlocationx,r);
                    lower1 = tour(rowlocationx,l);
         

                    for e = 1:length(nonzeros(tour(rowlocationy,:)))-1  
                        f = e+1;

                        upper2 = tour(rowlocationy,e);
                        lower2 = tour(rowlocationy,f);
                        Cost = distancematrix(upper1,upper2)+distancematrix(lower1,lower2)-(distancematrix(upper1,lower1)+distancematrix(upper2,lower2));

                        if Cost < Cheapest_Break
                            Cheapest_Break = Cost;
                            Cheapestupper2 = tour(rowlocationy,e);
                            Cheapestlower2 = tour(rowlocationy,f);
                            
                        end

                    end
                end
                
                
                         
                for r = 1:length(nonzeros(tour(rowlocationx,:)))-1
                    Cheapest_Break = realmax; 
                    l = r+1;
                    upper1 = tour(rowlocationx,r);
                    lower1 = tour(rowlocationx,l);
         

                    for e = 1:length(nonzeros(tour(rowlocationy,:)))-1  %number of nodes to insert
                        f = e+1;

                        upper2 = tour(rowlocationy,e);
                        lower2 = tour(rowlocationy,f);
                        Cost = distancematrix(upper1,upper2)+distancematrix(lower1,lower2)-(distancematrix(upper1,lower1)+distancematrix(upper2,lower2));

                        if Cost < Cheapest_Break
                            Cheapest_Break = Cost;
                            CheapestUpper1 = tour(rowlocationx,r);%value from row 1 column
                            CheapestLower1 = tour(rowlocationx,l);
                           
                        end

                    end
                end
                
                Lenx = length(nonzeros(tour(rowlocationx,:)));
                Leny = length(nonzeros(tour(rowlocationy,:)));
                tem=zeros(1,Lenx+Leny-1);
                if f==length(nonzeros(tour(rowlocationy,:)))
                    tem(1,1:r)=tour(rowlocationx,1:r);
                    tem(1,r+1:r+e) = tour(rowlocationy,e:-1:1);
                    tem(1,r+e+1:r+e+Lenx-l+1) = tour(rowlocationx,l:Lenx);                  
                else
                    tem(1,1:r)=tour(rowlocationx,1:r);
                    tem(1,r+1:r+e) = tour(rowlocationy,e:-1:1);
                    tem(1,r+e+1:r+e+Leny-f) = tour(rowlocationy,Leny-1:-1:f);
                    tem(1,r+e+Leny-f+1:r+e+Leny-f+Lenx-l+1) = tour(rowlocationx,l:Lenx);
                    
                end
                tour(rowlocationx,1:length(tem)) = tem;
                tour(rowlocationy,:)=[];
                d(x,y)=inf;
                d(y,x)=inf;
  
            end
        end
    end
end

optimaldistance = distancematrix(tour(end),tour(1));
for i=1:n-1 
    optimaldistance = optimaldistance + distancematrix(tour(i),tour(i+1));
    tour(:,i+1);
end