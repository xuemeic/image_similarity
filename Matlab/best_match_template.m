% Written by Amy on 08/27/2025
% Separated template method from the best_cat.m by Amy on 08/27/2025
% Add 'template' as a variable by Amy on 08/31/2025
% Line up the variables names with the paper by Amy on 08/31/2025

function out = best_match_template(image_collection, query_image, topJ,template)
% BEST_MATCH_TEMPLATE  a template-based retrieval method in which we 
% treat a template bank ('template') and score the query img by the max filter method 
% 
% out = best_match_template(image_collection, query_image, topJ)
% Note: the function will mirror BEST_MATCH for easy comparison.
%   0) choose an image_collection m*n*N (images in the size of m*n with N
%   images)
%   1) choose a template bank m*n*K (images in the size of m*n with K templates)
%   2) build phi(:,i) = max_filter(template, Img_i) for all images,
%   3) build phi0     = max_filter(template, query_image),
%   4) rank images by distance to phi0 (nearest neighbors in phi-space),
%   5) report circular shifts for the retrieved images via FFT argmax.


t_phi_start = tic;

% normalize templates 
norms = sqrt(sum(template.^2,[1 2])) + eps;   
Tn    = template ./ norms;

% Tn = T % Denormalize

% Define the image_collection and build phi (KxN)
[m,n,N] = size(image_collection);
topJ = min(topJ, N);
phi  = zeros(size(Tn,3), N);

% score every cat_i (N total in img collection) against all K templates

for i = 1:N
    Img_i = image_collection(:,:,i);  % load 50x50 matrix 
    phi(:, i) = max_filter(Tn, Img_i);    % Kx1
end

% scores via max-filterfor template to compute phi0
phi0 = max_filter(Tn, query_image); 
% create a k*1 feature vector for query image versus template stack
% phi0 will be used for nearest neighbor search

% nearest neighbors in phi-space 
D2 = sum((phi - phi0).^2, 1);  
% phi K*N (K templates * N cat images in img collection
% 1xN squared distances
% matlab expand phi0 across N columns
% sum down each column across K templates

[~, order]   = sort(D2, 'ascend');
%smaller distance, similar image
idx_topJ   = order(1:topJ);
% find the top k smallest distances
distances    = sqrt(D2); 
% convert back to Euclidean Distance


% also compute circular shifts for those topK (same argmax trick)
Fq = fft2(query_image);
shifts = zeros(topJ,2);
for t = 1:topJ
    k  = idx_topJ(t);
    Img_i = image_collection(:,:,k);     % report shift relative to the actual image k
    cm = ifft2( Fq .* fft2(rot90(Img_i,2)));
    [~, idx] = max(cm(:));
    % convert linear index back into a M*N array
    [r,c] = ind2sub([m n], idx);
    % convert argmax position to circular shift 
    % to align each image in collection to query img
    row_shift = mod(m - r, m);
    col_shift = mod(n - c, n);
    shifts(t,:) = [row_shift, col_shift];
end

t_phi = toc(t_phi_start);

% pack
out = struct();
%out.scores      = scores;       % 1×K templates
out.idx_topJ    = idx_topJ;     % 1×topJ
out.shifts_topJ = shifts;       % topJ×2
out.t_total     = t_phi;        % timing
out.distances   = distances;     % 1*J=

end

