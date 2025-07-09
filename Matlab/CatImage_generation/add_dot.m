% Oringinally Written by Justin & Landon on April 2026
% Modified and Commented by Amy Lan on 07/08/2025
% This function "add_dot(A,n)" is used to sprinkle n random dots on a matrix
% called A and return as a matrix called "output"

function output = add_dot(A,n)

% A any matrix
% n is number of dots
% return a matrix called "output"
    
    bound = size(A,2);
    % computes the number of columns in A and stores it in "bound"

    for k = 1:n
        i = randi([1,bound]);
        j = randi([1,bound]);
        A(i,j) = rand;
        % picks a random row index i and a random column index j
        % each uniformly from 1 to bound
        % overwrites the entry (i,j) of A with a random number in [0,1]
    end

    output = A;
end