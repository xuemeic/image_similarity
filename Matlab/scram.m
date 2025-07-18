% Oringinally Written by Justin & Landon on April 2026
% Modified and Commented by Amy Lan on 07/08/2025
% Rewritten by Amy Lan 07/08/2025
% Used to reposition elements in B randomly and return in "Output"
function output = scram(B)
% Declare a function named "scram" that takes one input B 
% The matrix has to be in 50*50
% The function return 
        A = B(:); 
        % Stacking each column in order
        A = A(randperm(numel(A)));
        % numel(A) returned the total number of elements in A
        % Here it is 2500
        % randperm(...) permutes the n*1 column
        % A(..) overwrites A
        output = reshape(A, size(B,1), size(B,2));
        % take the n-vector and lays it back out to a sqrt(n)^2 matrix
end