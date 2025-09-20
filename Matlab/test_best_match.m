
% Written by Amy on 08/21/2025
% Rewritten by Amy on 08/26/2025 to test the best_match(..) and best_match
% template(..)
% Modified by Amy on 08/28/2025 for clarity
% add 'template' as a variable by Amy on 08/31/2025
% Line up the variables names with the paper by Amy on 08/31/2025

clear; % clear the memory

cat_folder = '/Users/lanheng/Desktop/image_similarity_2025/image_similarity/synthetic_data/cat_image';
N = 301;                       % number of images
m = 50; n = 50;                % size of images
topJ = 16;                     % top J images 
query_idx = 1;                 % use cat_001 as query image W

template = randn(50,50,50);    % define the size of the template bank m*n*K          

% FUTURE: uncomment to use other templates
% T = your_loaded_templates;      % m*n*K 
% K = size(image_collection,3);  % template count: K total

% load stack M*N*J and the query img
image_collection = zeros(m,n,N);
for i = 1:N
    S = load(fullfile(cat_folder, sprintf('cat_%03d.mat', i)));
    image_collection(:,:,i) = S.A;         % each mat file has 50 * 50 variable A 
end
query_image = image_collection(:,:,query_idx);

% run both methods
out_fft = best_match_norm(image_collection, query_image, topJ);
out_tpl = best_match_template(image_collection, query_image, topJ, template);

% print all the outputs
fprintf('\n=== FFT baseline ===\n');
fprintf('TopJ idx: '); disp(out_fft.idx_topJ);
fprintf('Shifts (row,col):\n'); disp(out_fft.shifts_topJ);
fprintf('Elapsed: %.3f s\n', out_fft.t_total);

fprintf('\n=== Template method ===\n');
fprintf('TopJ idx: '); disp(out_tpl.idx_topJ);
fprintf('Shifts (row,col):\n'); disp(out_tpl.shifts_topJ);

% overlap and simple comparison
overlap = intersect(out_fft.idx_topJ, out_tpl.idx_topJ);
fprintf('\nOverlap count (indices appearing in both Top-%d): %d\n', topJ, numel(overlap));
fprintf('Overlap indices: '); disp(sort(overlap));

% simple figure to visualize both rankings
figure('Name','TopJ by FFT (top) vs Template (bottom)'); colormap gray
rows = 2; cols = topJ;
for j = 1:topJ
    i = out_fft.idx_topJ(j);
    subplot(rows, cols, j); imagesc(image_collection(:,:,i)); axis image off
    title(sprintf('FFT %03d', i));

    j2 = out_tpl.idx_topJ(j);
    subplot(rows, cols, j+topJ); imagesc(image_collection(:,:,j2)); axis image off
    title(sprintf('TPL %03d', j2));
end
