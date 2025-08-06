
% Written by Amy on 07/25/2025
% Written based on max_filter.m but with Loop removed
% Renamed variables for clarity: image_collection, query_image by Amy on
% 07/30/2025

%% MAX_FILTER   Peak cross‐correlation via FFT (a loop‐free edition)
% Usage:
%   scores = max_filter_no_loop(image_collection, query_image)
%
% Inputs:
%   image_collection – an M×N×K collection of images
%   query_image      – an M×N query image to compare against the collection
%
% Output:
%   scores           – a K×1 vector where scores(k) is the highest correlation
%                      value of image_collection(:,:,k) anywhere in the query image
% 
% what are we comparing between K images in the image collection and the query image?
% we slide image k via FFT based correlation over every possible
% position in our image
% we compute a correlation map of size M*N, where each entry tells you "how
% well does image k match the image when its top-left corner is at(x,y)?
% Then we find the maximum in our M*N matrix and recored that to the K*1
% vector ( we totally have k maximums over k images)

function scores = max_filter_no_loop(image_collection, query_image)

    % rotate all K images in the collection by 180° (for cross‑correlation)
    collection_rotated = rot90(image_collection, 2);

    %image_collection = single(image_collection);
    %query_image = single(query_image);

    % FFT of the query image and of each rotated collection image
    F_query      = fft2(query_image);          % M×N
    F_collection = fft2(collection_rotated);    % M×N×K

    % multiply in the frequency domain → K correlation maps
    corr_maps = real(ifft2( F_query .* F_collection));  % M×N×K
    % corr_maps = ifft2(F_query .* F_collection, 'symmetric'); 

    % max‑pool over rows & columns to get one score per image
    scores = reshape(max(max(corr_maps,[],1),[],2), [], 1);
    % Now scores is K×1

end