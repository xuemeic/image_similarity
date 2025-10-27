
% Written by Amy on 08/21/2025
% Rewritten by Amy on 08/26/2025 to test the best_match(..) and best_match
% template(..)
% Modified by Amy on 08/28/2025 for clarity
% add 'template' as a variable by Amy on 08/31/2025
% Line up the variables names with the paper by Amy on 08/31/2025
% Add pre-computed phi structure on 10/09/2025

clear; % clear the memory

cat_folder = '/Users/lanheng/Desktop/image_similarity_2025/image_similarity/synthetic_data/cat_image';
N = 301;                       % number of images
m = 50; n = 50;                % size of images
topJ = 16;                     % top J images 
query_idx = 1;                 % use cat_001 as query image W

template = randn(50,50,25);    % define the size of the template bank m*n*K          

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
index = build_phi_index(image_collection, template);

% run both methods
out_cor = best_match_correl(image_collection, query_image, topJ);
out_tpl = best_match_template(image_collection, query_image, topJ, template,index);
out_dis = best_match_distance(image_collection, query_image, topJ);

% print all the outputs
% print correlation method outputs
fprintf('\n=== correlation method ===\n');
fprintf('TopJ idx: '); disp(out_cor.idx_topJ);
fprintf('Shifts (row,col):\n'); disp(out_cor.shifts_topJ);
fprintf('Elapsed: %.3f s\n', out_cor.t_total);

% print distance method outputs
fprintf('\n=== Distance method ===\n');
fprintf('TopJ idx: '); disp(out_dis.idx_topJ);
fprintf('Shifts (row,col):\n'); disp(out_dis.shifts_topJ);
fprintf('Elapsed: %.3f s\n', out_dis.t_total);

%print output method outputs
fprintf('\n=== Template method ===\n');
fprintf('TopJ idx: '); disp(out_tpl.idx_topJ);
fprintf('Shifts (row,col):\n'); disp(out_tpl.shifts_topJ);
fprintf('Elapsed: %.3f s\n', out_tpl.t_total);

% overlap and simple comparison
overlap = intersect(out_cor.idx_topJ, out_tpl.idx_topJ);
fprintf('\nOverlap count (indices appearing in both Top-%d): %d\n', topJ, numel(overlap));
fprintf('Overlap indices: '); disp(sort(overlap));

% simple figure to visualize both rankings
% figure('Name','TopJ by FFT (top) vs Template (bottom)'); colormap gray
% rows = 2; cols = topJ;
% for j = 1:topJ
    %i = out_fft.idx_topJ(j);
    %subplot(rows, cols, j); imagesc(image_collection(:,:,i)); axis image off
    %title(sprintf('FFT %03d', i));

    %j2 = out_tpl.idx_topJ(j);
    %subplot(rows, cols, j+topJ); imagesc(image_collection(:,:,j2)); axis image off
    %title(sprintf('TPL %03d', j2));
%end
