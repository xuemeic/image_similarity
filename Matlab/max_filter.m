% Originally Written by Justin & Landon on April 2025
% Rewritten and Commented by Amy Lan on 07/12/2025
% Blended & Documented by Amy Lan on 07/15/2025
% Variable names updated for clarity by Amy on 08/03/2025

% Structure of the function
% Usage:
%   scores = max_filter(image_collection, query_image)
%
% Inputs:
%   image_collection – M×N×K 3-D array (each slice is one template image)
%                      (:,:,1) is the first template, (:,:,n) is the n-th.
%   query_image      – M×N image in which to search for each template
%
% Output:
%   scores           – K×1 vector of peak correlation values;
%                      scores(k) is the maximum response of template k
%                      anywhere in the M×N query image
%
% Process:
%   - For each template in image_collection:
%       1. Rotate template 180° for correlation
%       2. Compute FFT of rotated template
%       3. Multiply with FFT of query_image in frequency domain
%       4. Inverse FFT to get correlation map
%       5. Take the max correlation value over all positions

function scores = max_filter(image_collection, query_image)
    
    [M, N, K] = size(image_collection);

    % Compute FFT of the query image once
    F_query = fft2(query_image);

    % Preallocate scores
    scores = zeros(K, 1);

    for k = 1:K
        % a) Extract and rotate template 180 degrees for correlation
        tpl = image_collection(:,:,k);
        tplR = rot90(tpl, 2);

        % b) FFT of rotated template
        F_tpl = fft2(tplR);

        % c) Multiply in freq‑domain 
        corr_map = real(ifft2(F_query .* F_tpl));

        % d) Record its peak response
        scores(k) = max(corr_map(:));
    end
end