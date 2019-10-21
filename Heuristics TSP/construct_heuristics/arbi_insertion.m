function [tour optimaldistance] = arbitraryinsertion(data)
% Calculate the distance data into a euclidian square matrix
    Distance_data = squareform(pdist(data, 'euclidean'));
   
% Creating a solution vector full of Nan in one single row
    tour = NaN(1,size(Distance_data,1)+1);    
    
 % Making of the Initial Subtour with 3 different subfunctions:
 % Subtour with node i only and inputting the next node criterias
 
    function [VecIns] = Vector(VecIns, Value1)
        % Looks for the next empty position and adds a value into it
        for a = 1:size(VecIns,2)
        if isnan(VecIns(1,a))
            VecIns(1,a) = Value1;
            return
        end
        end   
    end

    function [Next_Node] = Follower(Array1)
       % Follower gives the next node in the subtour
        for c = 1:size(Array1,2)
        if isnan(Array1(1,c))
            Next_Node = Array1(1, c-1) ;
            return
        end
        end
    end

    function Answer = ArrayChecker(Array2, Value2)
        % ArrayChecker checks if a value is already in an array
        % it returns true if value found otherwise returns false
        for d = 1:size(Array2,2)
            if Array2(1,d) == Value2
            Answer = true;
            return
            end
        end
        Answer = false;
    end

% Subfunctions and their name used:

% Vector
% Follower
% ArrayChecker
% Inserter
% NonNanVector
% CalcDist
    
Maximum_Value = max(Distance_data(:))+1;    
tour = Vector(tour,ceil(rand()*size(data,1)));
Starting_Node = Follower(tour);


for i = 1:size(Distance_data,2)
    if ArrayChecker(tour,i) == false && Distance_data(Starting_Node,i) < Maximum_Value && Distance_data(Starting_Node,i) ~= 0
      
            Maximum_Value = Distance_data(Starting_Node,i); 
            Next_Node = i;
    end
end
    
% Making and Inserting the second node closest to the origin node 
    

tour = Vector(tour,Next_Node);
tour = Vector(tour,tour(1,1));
GeneratedValues = zeros(1,(size(data,1)-2));

 % Outer loop goes through the nodes inserted as requested:
 
    function real_values = NonNaNVector(Array)
 % NonNaNVector returnsvalues that are different from NaN into a vector
    for f = 1:size(Array,2)
       if isnan(Array(1,f))
           real_values = f - 1;
           return
       end
    end
    real_values = size(Array,2);
    end

function Insert_Res = Inserter(Array3, Value3, Position)
    % Insert takes a vector, a value and a position. it shifts all the values
    % and insert the new value in the assigned position
        for q =  size(Array3,2):-1:2
            Array3(1,q) = Array3(1,q-1);
            if q == Position 
                Array3(1, q) = Value3;
                Insert_Res = Array3;
                return
            end
        end
end

Arbitrary_Vector = 1:size(data,1);
    for i = 1:size(data,1)
        remove_num = tour(1,i);
        Arbitrary_Vector(Arbitrary_Vector == remove_num) = [];
    end
    
randd = ceil(rand()*(size(data,1)));
    for i = 1:size(data,1) -2
        randd = ceil(rand()*(size(data,1)));
        while (ArrayChecker(GeneratedValues,randd)==true || ArrayChecker(tour,randd)==true)
           randd = ceil(rand()*(size(data,1))); 
        end
        GeneratedValues(1,i) = randd;
    end
 
% Selection Step: Compute the distance between the first TWO nodes. Then move
% to the others and compare them. The smallest distance will be taken and
% the node will be inserted between the two nodes.

% Insert: takes a vector, a value and a position. it shifts all the values
%         and inserts the new value in the assigned position 
% Put before because can't have nested function while for loop is running
% InsertIn: Variable that inserts itself

for b = 1:size(GeneratedValues,2)
    
    Next_Node = GeneratedValues(1,b);
    
C_ik = Distance_data(tour(1,1),Next_Node);
C_kj = Distance_data(Next_Node, tour(1,2));
C_ij = Distance_data(tour(1,1), tour(1,2));
Expected_Distance = C_ik + C_kj - C_ij;
InsertedNode = 2;
    for i = 2:NonNaNVector(tour)-1
        C_ik1 = Distance_data(tour(1,i),Next_Node);
        C_kj1 = Distance_data(Next_Node, tour(1,i+1));
        C_ij1 = Distance_data(tour(1,i), tour(1,i+1));
        Actual_Distance = C_ik1 + C_kj1 - C_ij1;
        if Actual_Distance < Expected_Distance
           Expected_Distance = Actual_Distance;
           InsertedNode = i +1;
        end
    end
    tour = Inserter(tour,Next_Node,InsertedNode);

end  

    function Distance = CalcDist(Vector_Sol,Distance_data)
        % CalculateDistance calculates the total distance of the nodes in a matrix
    Current_Distance = 0;
    for z = 2:size(Vector_Sol,2)
        if isnan(Vector_Sol(z))
            Distance = Current_Distance;
            return
        end
        Current_Distance = Current_Distance + Distance_data(Vector_Sol(z),Vector_Sol(z-1));
    end
    Distance = Current_Distance;
        
    end
optimaldistance = CalcDist(tour,Distance_data);
return
end