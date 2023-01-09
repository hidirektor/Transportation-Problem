% Define the cost matrix
C = [20 10 20 12 2;     8 12 2 13 2;     4 8 2 8 3];

% Define the supply and demand vectors
supply = [11; 7; 12];
demand = [1; 3; 4; 13; 9];

% Check if the problem is balanced or unbalanced
if sum(supply) > sum(demand)
    % Unbalanced problem
    % Calculate the difference in supply and demand
    diff = sum(supply) - sum(demand);
    
    % Add a dummy row and column to the cost matrix
    C = [C zeros(3,1);         zeros(1,4)];
    
    % Add the difference in supply and demand to the dummy row
    supply = [supply; diff];
    
    % Add a zero to the dummy column
    demand = [demand; 0];
elseif sum(supply) < sum(demand)
    % Unbalanced problem
    % Calculate the difference in supply and demand
    diff = sum(demand) - sum(supply);
    
    % Add a dummy row and column to the cost matrix
    C = [C zeros(3,1);         zeros(1,4)];
    
    % Add the difference in supply and demand to the dummy column
    demand = [demand; diff];
    
    % Add a zero to the dummy row
    supply = [supply; 0];
end

% Initialize the solution matrix and the allocation matrix
X = zeros(size(C));
alloc = zeros(size(C));

% Create a copy of the cost matrix
C_copy = C;

% Iterate until the problem is solved
while true
    % Find the minimum element in the cost matrix
    [row, col] = find(C_copy == min(min(C_copy)), 1);
    
    % Check if the minimum element is in a supply row or demand column
    if supply(row) < demand(col)
        % Allocate the entire supply to the demand
        X(row, col) = supply(row);
        demand(col) = demand(col) - supply(row);
        supply(row) = 0;
        alloc(row, col) = 1;
    elseif supply(row) > demand(col)
        % Allocate the entire demand to the supply
        X(row, col) = demand(col);
        supply(row) = supply(row) - demand(col);
        demand(col) = 0;
        alloc(row, col) = 1;
    else
        % Allocate the entire supply and demand to each other
        X(row, col) = supply(row);
        supply(row) = 0;
        demand(col) = 0;
        alloc(row, col) = 1;
    end
    
    % Check if the problem is solved
    if all(supply == 0) && all(demand == 0)
        break;
    end
    
    % Set the allocated element to Inf to prevent it from being chosen again
    C_copy(row, col) = Inf;
end

% Calculate the total cost of the solution
cost = sum(sum(C(1:3,1:3) .* X(1:3,1:3)));

% Print the solution and the total cost
fprintf('Solution matrix:\n');
disp(X);
fprintf('Total cost: %d\n', cost);
