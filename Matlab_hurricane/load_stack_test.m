% written by Amy to test the load_stack(..) function on 10/19/2025

%specify folder path and query image oath
img_collection_folder = '../../cat1-cat5-cahill/2014';
query_image_folder = '../../cat1-cat5-cahill/2014/ADJALI';
image_size = 301;
num_of_tpls = 100;
addpath('../Matlab')

% load template bank (size: m*n*K)
template = randn(image_size,image_size,num_of_tpls);    

% load stack and file list
% or explicitly:
% [stack, files] = load_rain_stack(root, 'hur_case.rain');
[image_collection, file_list] = load_stack(img_collection_folder);


% load query image
[query_image,img_file] = load_stack(query_image_folder);
query_image = query_image(:,:,1);

% load pre-computed phi matrix 
pre_compu_index = build_phi_index(image_collection, template); % precompute phi_matrix

% speficy Top J
TopJ = 32;

%call three functions
% add timing as well
t0 = tic;
out_cor_hur = best_match_correl(image_collection, query_image, TopJ);
t_cor = toc(t0);

t1 = tic;
out_tpl_hur = best_match_template(image_collection, query_image, TopJ, template, pre_compu_index);
t_tpl = toc(t1);

t2 = tic;
out_dis_hur = best_match_distance(image_collection, query_image, TopJ);
t_dis = toc(t2);


% print correlation method outputs
fprintf('\n=== correlation method ===\n');
fprintf('TopJ idx: '); disp(out_cor_hur.idx_topJ);
fprintf('Shifts (row,col):\n'); disp(out_cor_hur.shifts_topJ);
fprintf('Elapsed: %.3f s\n', out_cor_hur.t_total);

% print distance method outputs
fprintf('\n=== Distance method ===\n');
fprintf('TopJ idx: '); disp(out_dis_hur.idx_topJ);
fprintf('Shifts (row,col):\n'); disp(out_dis_hur.shifts_topJ);
fprintf('Elapsed: %.3f s\n', out_dis_hur.t_total);

% print template method outputs
fprintf('\n=== Template method ===\n');
fprintf('TopJ idx: '); disp(out_tpl_hur.idx_topJ);
fprintf('Shifts (row,col):\n'); disp(out_tpl_hur.shifts_topJ);
fprintf('Elapsed: %.3f s\n', out_tpl_hur.t_total);


   
% Overlap calculations
cor_ids = out_cor_hur.idx_topJ(:).';
tpl_ids = out_tpl_hur.idx_topJ(:).';
dis_ids = out_dis_hur.idx_topJ(:).';

overlap_cor_tpl = intersect(cor_ids, tpl_ids);
overlap_cor_dis = intersect(cor_ids, dis_ids);
overlap_dis_tpl = intersect(dis_ids, tpl_ids);

% Triple overlap
overlap_all3 = intersect(overlap_cor_tpl, dis_ids);

% Package result
result = struct();

% correlation (normalized correlation) method
result.idx_topJ_cor    = cor_ids;
result.shifts_topJ_cor = out_cor_hur.shifts_topJ;
result.t_cor           = t_cor;

% template (max-filtering with φ-index) method
result.idx_topJ_tpl    = tpl_ids;
result.shifts_topJ_tpl = out_tpl_hur.shifts_topJ;
result.t_tpl           = t_tpl;

% distance method
result.idx_topJ_dis    = dis_ids;
result.shifts_topJ_dis = out_dis_hur.shifts_topJ;
result.t_dis           = t_dis;

% overlaps
result.overlap_cor_tpl_indices = sort(overlap_cor_tpl);
result.overlap_cor_tpl_count   = numel(overlap_cor_tpl);

result.overlap_cor_dis_indices = sort(overlap_cor_dis);
result.overlap_cor_dis_count   = numel(overlap_cor_dis);

result.overlap_dis_tpl_indices = sort(overlap_dis_tpl);
result.overlap_dis_tpl_count   = numel(overlap_dis_tpl);

result.overlap_all3_indices    = sort(overlap_all3);
result.overlap_all3_count      = numel(overlap_all3);

% Console summary
fprintf('\n=== K=%d, TopJ=%d ===\n', num_of_tpls, TopJ);

fprintf('\n[COR] TopJ idx:     '); disp(result.idx_topJ_cor);
fprintf('[TPL] TopJ idx:     '); disp(result.idx_topJ_tpl);
fprintf('[DIS] TopJ idx:     '); disp(result.idx_topJ_dis);

fprintf('\nPairwise overlaps:\n');
fprintf('  COR ∩ TPL: count=%d | ', result.overlap_cor_tpl_count); disp(result.overlap_cor_tpl_indices);
fprintf('  COR ∩ DIS: count=%d | ', result.overlap_cor_dis_count); disp(result.overlap_cor_dis_indices);
fprintf('  DIS ∩ TPL: count=%d | ', result.overlap_dis_tpl_count); disp(result.overlap_dis_tpl_indices);

fprintf('\nTriple overlap (COR ∩ TPL ∩ DIS): count=%d | ', result.overlap_all3_count);
disp(result.overlap_all3_indices);

fprintf('\nElapsed times (s): COR=%.3f | TPL=%.3f | DIS=%.3f\n', t_cor, t_tpl, t_dis);