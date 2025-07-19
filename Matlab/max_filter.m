
% Originally Written by Justin & Landon on April 2025
% Rewritten and Commented by Amy Lan on 07/12/2025
% Blended & Documented by Amy Lan on 07/15/2025

% Structure of the function
% Usage:
%   scores = MaxFilter(templates, img)
%
% Inputs:
%   templates  – M×N×K 3-D array ( each slice is a first template)
%   (:,:,1) is my first template and (:,:,n) is the n-th template
%   img        – M×N image in which to search for each template
%
% Output:
%   scores          – 1×1×K array (or K×1 vector) of peak correlation values;
%   scores(k) is the maximum response of template k anywhere in the M*N
%   testing image
% 
% what are we comparing between k templates and the testing image?
% we slide template k via FFT based correlation over every possible
% position in our image
% we compute a correlation map of size M*N, where each entry tells you "how
% well does template k match the image when its top-left corner is at(x,y)?
% Then we find the maximum in our M*N matrix and recored that to the K*1
% vector ( we totally have k maximums over k templates)

function scores = max_filter(templates, img)
    
    [M,N,K] = size(templates);

    % Compute FFT of the image once
    F_img = fft2(img);

    % Create the k*1 array and set them to zero
    scores = zeros(K,1);

    for k = 1:K
        % a) Extract and rotate template 180 degrees for correlation
        tpl = templates(:,:,k);
        tplR = rot90(tpl, 2);

        % b) FFT of rotated template
        F_tpl = fft2(tplR);

        % c) Multiply in freq‑domain & back
        corr_map = real(ifft2( F_img .* F_tpl ));

        % d) Record its peak response
        scores(k) = max(corr_map(:));
    end
end