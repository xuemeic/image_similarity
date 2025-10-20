% written by Amy on 10/15/2025 to include distance method

function out = best_match_distance(image_collection, query_image, topJ)
% BEST_MATCH  Retrieval by group-invariant distance via FFT correlation (no normalization).
%   out = best_match_distance(image_collection, query_image, topJ)
% Inputs:
%   image_collection : m*n*N stack (each slice is a candidate image in img collection)
%   query_image      : m*n*1 query
%   topJ             : number of top matches to return
% Output (structure fields unchanged):
%   out.scores       : 1×J score per slice (here: negative squared distance; larger is better)
%   out.idx_topJ     : 1×topJ indices of best matches (descending by score)
%   out.shifts_topJ  : topJ×2 [row_shift, col_shift] (circular) to align slice to query
%   out.t_total      : elapsed time in second

t0 = tic;
[m,n,N] = size(image_collection);
topJ = min(topJ, N);

q0 = query_image;
Fq = fft2(q0);                                  % no normalization
norm_q2 = norm(q0,'fro')^2;                     % ||Y||_F^2

scores = zeros(1,N);

% 1) score each slice by NEGATIVE squared distance:
%    d^2([X],[Y]) = ||X||^2 + ||Y||^2 - 2 * max( X * RY )
%    We store score = d^2 so smaller = better.
for i = 1:N
    Ii = image_collection(:,:,i);
    norm_i2 = norm(Ii,'fro')^2;                 % ||X||_F^2

    % circular correlation via FFT: max( X * RY )
    % using rot90(.,2) instead of conjugation in frequency
    cm = ifft2( Fq .* fft2(rot90(Ii,2)) , 'symmetric' );
    maxCorr = max(cm, [], 'all');

    dist2 = norm_i2 + norm_q2 - 2*maxCorr;
    scores(i) = dist2;                         % larger score = closer match
end

% 2) pick topJ (descending by score, as in the original)
[~, order] = sort(scores, 'ascend');
idx_topJ   = order(1:topJ);

t_total = toc(t0);

% 3) for topJ, also compute circular shifts from the argmax of the same cm
shifts = zeros(topJ,2);
for t = 1:topJ
    i   = idx_topJ(t);
    Ii  = image_collection(:,:,i);
    cm  = ifft2( Fq .* fft2(rot90(Ii,2)) , 'symmetric' );
    [~, idx] = max(cm(:));
    [r,c] = ind2sub([m n], idx);
    row_shift = mod(m - r, m);
    col_shift = mod(n - c, n);
    shifts(t,:) = [row_shift, col_shift];
end

% pack
out = struct();
out.scores      = scores;
out.idx_topJ    = idx_topJ;
out.shifts_topJ = shifts;
out.t_total     = t_total;
end
