
%written by Amy on 08/21/2025
template_mat = randn(50, 50, 10);
proj_path = '/Users/lanheng/Desktop/image_similarity_2025/image_similarity/synthetic_data';
image_folder = fullfile(proj_path,'cat_image');
query_idx    = 1;     % which cat_XXX.mat to use as query
topK         = 16;    % how many neighbors to report

out = best_cat(template_mat, image_folder, query_idx, topK)
