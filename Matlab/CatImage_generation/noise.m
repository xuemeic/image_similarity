% Oringinally Written by Justin & Landon on April 2026
% Modified and Commented by Amy Lan on 07/08/2025
% Rewritten by Amy Lan 07/08/2025
% Used to add zero mean Gaussian noise to a 50 * 50 matrix
function output = noise(A,e)

E = e * randn(50, 50); 
% Gaussian noise with standard deviation of 0.1
% e as a scalar controlling noise magnitute

output = A + E;

end