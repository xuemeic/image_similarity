
%Written by Amy on 08/21/2025
%Rewritten by Amy on 08/26/2025 to test the best_match(..) and best_match
%Template(..)
%Modified by AMy on 08/28/2025 for clarity


clear; % clear the memory

cat_folder = '/Users/lanheng/Desktop/image_similarity_2025/image_similarity/synthetic_data/cat_image';
K = 301;                       % number of images
M = 50; N = 50;
topK = 16;
query_idx = 1;                 % use cat_001 as query; change if you like

% load stack M*N*J and the query img
image_collection = zeros(M,N,K);
for j = 1:K
    S = load(fullfile(cat_folder, sprintf('cat_%03d.mat', j)));
    image_collection(:,:,j) = S.A;         % each mat file has 50 * 50 variable A 
end
query_image = image_collection(:,:,query_idx);
image_collection2 = circshift(query_image,[30,25]);
% explaining the shift directions

% run both methods
out_fft = best_match(image_collection2, query_image, 1);

% print all the outputs
fprintf('\n=== FFT baseline ===\n');
fprintf('TopK idx: '); disp(out_fft.idx_topK);
fprintf('Shifts (row,col):\n'); disp(out_fft.shifts_topK);
fprintf('Elapsed: %.3f s\n', out_fft.t_total);
