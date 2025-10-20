% a function to take K templates from a randomly generated randn(m,n,k)
% function and try to find the overlapped count between fft and template
% method given the specific numeber of temolates.

% written by Amy on 09/25/2025
% update by Amy on 10/19/2025: include distance method

function result = compare_dis_corr_vs_template(K, topJ, seed)
%COMPARE_FFT_VS_TEMPLATE  Compare correlation vs. template vs. distance.
%
% result = compare_fft_vs_template(K, topJ, seed)
%    K     : number of templates in the bank (template size m*n*K)
%    topJ  : size of the Top-J lists to compare overlap counts
%    seed  : RNG seed for reproducibility of randn() (default: 42)
%
% Requires:
%   best_match_norm.m, best_match_template.m, best_match_distance.m,
%   build_phi_index.m
%
% Returns a struct with fields:
%   .idx_topJ_cor, .shifts_topJ_cor, .t_cor
%   .idx_topJ_tpl, .shifts_topJ_tpl, .t_tpl
%   .idx_topJ_dis, .shifts_topJ_dis, .t_dis
%   .overlap_cor_tpl_indices, .overlap_cor_tpl_count
%   .overlap_cor_dis_indices, .overlap_cor_dis_count
%   .overlap_dis_tpl_indices, .overlap_dis_tpl_count
%   .overlap_all3_indices,   .overlap_all3_count

    if nargin < 3 || isempty(seed), seed = 42; end


    % setting the argument
    cat_folder = '/Users/lanheng/Desktop/image_similarity_2025/image_similarity/synthetic_data/cat_image';
    N = 301;             % number of images
    m = 50; n = 50;      % image size
    query_idx  = 1;      % use cat_001 as query image

    % Load image stack
    image_collection = zeros(m, n, N);
    for i = 1:N
        S = load(fullfile(cat_folder, sprintf('cat_%03d.mat', i)));
        image_collection(:, :, i) = S.A;   % each MAT has 50x50 variable A
    end
    query_image = image_collection(:, :, query_idx);

    % Template bank with fixed seed
    rng(seed, 'twister');
    template = randn(m, n, K);

    
    % precomput phi for templates
    index = build_phi_index(image_collection, template);
    
    % Run three methods
    % correlation method
    t0 = tic;
    out_cor = best_match_correl(image_collection, query_image, topJ);
    t_cor = toc(t0);

    % template method
    t1 = tic;
    out_tpl = best_match_template(image_collection, query_image, topJ, template,index);
    t_tpl = toc(t1);  % keep even if best_match_template doesn't fill timing

    % distance method
    t2 = tic;
    out_dis = best_match_distance(image_collection, query_image, topJ);
    t_dis = toc(t2);

   
    % Overlap calculations
    cor_ids = out_cor.idx_topJ(:).';
    tpl_ids = out_tpl.idx_topJ(:).';
    dis_ids = out_dis.idx_topJ(:).';

    overlap_cor_tpl = intersect(cor_ids, tpl_ids);
    overlap_cor_dis = intersect(cor_ids, dis_ids);
    overlap_dis_tpl = intersect(dis_ids, tpl_ids);

    % Triple overlap
    overlap_all3 = intersect(overlap_cor_tpl, dis_ids);


    % Package result
    result = struct();

    % correlation (normalized correlation) method
    result.idx_topJ_cor    = cor_ids;
    result.shifts_topJ_cor = out_cor.shifts_topJ;
    result.t_cor           = t_cor;

    % template (max-filtering with φ-index) method
    result.idx_topJ_tpl    = tpl_ids;
    result.shifts_topJ_tpl = out_tpl.shifts_topJ;
    result.t_tpl           = t_tpl;

    % distance method
    result.idx_topJ_dis    = dis_ids;
    result.shifts_topJ_dis = out_dis.shifts_topJ;
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
    fprintf('\n=== K=%d, TopJ=%d ===\n', K, topJ);

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
end