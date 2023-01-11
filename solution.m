% Northwest corner rule algorithm
clear all
tic

% Cost matrix
c = [6 10 14 0;      12 19 21 0;      15 14 17 0];

% Supply and demand
s = [50;      50;      50];
d = [30 40 55 25];

% Sum of supply and demand
sums = sum(s);
sumd = sum(d);
if sums ~= sumd
    disp('Review amount of supply and demand');
    return
end

% Initialize variables
x = zeros(size(c));
d1 = d;
s1 = s;

% Assign supply and demand
for j = 1:size(c, 2)
    for i = 1:size(c, 1)
        if s1(i) > 0 && d1(j) > 0
            if d1(j) > s1(i)
                d1(j) = d1(j) - s1(i);
                x(i, j) = s1(i);
                s1(i) = 0;
            else
                s1(i) = s1(i) - d1(j);
                x(i, j) = d1(j);
                d1(j) = 0;
            end
        end
    end
end

% Calculate the objective function
ZNWC = sum(x(x > 0) .* c(x > 0));

% Count number of non-basic variables
countnwc = sum(x(:) > 0);

% Check for degeneracy
if countnwc >= size(c, 1) + size(c, 2) - 1
    disp('Non-degeneracy problem');
    disp('After calculation matrix: \n');
    disp(x);
    disp(['Total cost: ', num2str(ZNWC)]);
else
    disp('The degeneracy problem');
    disp('After calculation matrix: \n');
    disp(x);
    disp(['Total cost: ', num2str(ZNWC)]);
end

toc
