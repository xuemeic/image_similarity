% written by Amy on 08/10/2025
% Updated by Amy on 08/15/2025

function out = best_cat(template_mat, image_folder, query_idx, topK)
% BEST_CAT  Score 50×50 cat images against a template collection and
% retrieve nearest matches in phi space and by direct fft correlation
% method
%
% Usage:
%   out = best_cat(template_mat, image_folder, query_idx, topK)
%
%
% Inputs
%   template_mat : .mat file containing variable:
%                  - templates  (50x50xK double)
%   image_folder : folder path with cat_001.mat ... cat_301.mat (each has variable A)
%   query_idx    : which image to use as the query
%   topK         : number of neighbors to return
%
% Output wrapped in struct
%   out.phi              : K×J feature matrix (scores per template per image)
%   out.phi0             : K×1 feature vector for the query image
%   out.distances        : 1×J Euclidean distances in φ-space
%   out.idx_phi_topK     : indices of topK nearest neighbors in φ-space
%   out.corr_scores      : 1×J direct FFT correlation peaks vs query
%   out.idx_corr_topK    : indices of topK highest direct correlations
%   out.t_phi, out.t_corr: timings (seconds)
%
% Note!!!:-)))
%   - Requires max_filter.m /max_filter_no_loop.m on path
%   - Templates are normalized per slice for fair scoring (do we need
%   normalization?)

% assumptions: fixed 301 images named cat_001..cat_301.mat, each with A (50x50)
J = 301;
query_idx = max(1, min(J, query_idx));
topK      = min(topK, J);

% 1) load templates (50x50xK) and L2-normalize each slice
K     = size(template_mat, 3);
norms = sqrt(sum(template_mat.^2, [1 2])) + eps;
Tn    = template_mat./ norms;

% 2) build phi (KxJ): score every cat_j (J total in img collection) against all K templates
phi = zeros(K, J);
t_phi_start = tic;
for j = 1:J
    load(fullfile(image_folder, sprintf('cat_%03d.mat', j)), 'A');  % load 50x50 matrix A
    phi(:, j) = max_filter(Tn, A);                                  % Kx1
end
t_phi = toc(t_phi_start);

% 3) Query image & phi0

load(fullfile(image_folder, sprintf('cat_%03d.mat', query_idx)), 'A');
% create a filename like 'cat_001.mat' when query_idx is 1
query_img = A; 
% image save as variable A
phi0 = max_filter(Tn, query_img); 
% create a k*1 feature vector for query image versus template stack
% phi0 will be used for nearest neighbor search

% 4) nearest neighbors in phi-space 
D2 = sum((phi - phi0).^2, 1);  
% phi K*J (K templates * J cat images in img collection
% 1xJ squared distances
% matlab expand phi0 across J columns
% sum down each column across K templates
[~, order]   = sort(D2, 'ascend');
idx_phi_topK = order(1:topK);
% find the top k smallest distances
distances    = sqrt(D2); 
% convert back to Euclidean Distance

% 5) Direct FFT-correlation baseline
% FFT is used for a different goal
% compute the full cross-correlation map between the query and each candidate image 
% to get a single best score per image
Fq = fft2(query_img);
% precompute fft score for query image

scores = zeros(1, J);
t_corr_start = tic;
for j = 1:J
    load(fullfile(image_folder, sprintf('cat_%03d.mat', j)), 'A');
    cm = ifft2(Fq .* fft2(rot90(A,2)), 'symmetric');
    scores(j) = max(cm, [], 'all');
    % find the best value in cm
end
t_corr = toc(t_corr_start);
[~, idx_corr_topK] = maxk(scores, topK);

% 6) quick displays
figure('Name','Nearest in \phi-space'); colormap gray
rows = ceil(topK/4); cols = 4;
for k = 1:topK
    j = idx_phi_topK(k);
    load(fullfile(image_folder, sprintf('cat_%03d.mat', j)), 'A');
    subplot(rows, cols, k), imagesc(A), axis image off
    title(sprintf('cat_%03d', j)), subtitle(sprintf('dist=%.3f', distances(j)));
end

figure('Name','Top by direct correlation'); colormap gray
for k = 1:topK
    j = idx_corr_topK(k);
    load(fullfile(image_folder, sprintf('cat_%03d.mat', j)), 'A');
    subplot(rows, cols, k), imagesc(A), axis image off
    title(sprintf('cat_%03d', j)), subtitle(sprintf('score=%.3f', scores(j)));
end

% 7) Pack outputs
out = struct();
out.phi           = phi;
out.phi0          = phi0;
out.distances     = distances;
out.idx_phi_topK  = idx_phi_topK;
out.corr_scores   = scores;
out.idx_corr_topK = idx_corr_topK;
out.t_phi         = t_phi;
out.t_corr        = t_corr;

fprintf('phi build: %.3fs | direct corr: %.3fs | query = cat_%03d\n', t_phi, t_corr, query_idx);
end




