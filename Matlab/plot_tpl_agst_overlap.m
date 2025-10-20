% Sweep K and plot overlap vs. number of templates.
% Written by Amy 09/25/2025
% UPDATED 10/19/2025: include distance method + pairwise/triple overlaps.


clear; clc;


% Settings
topJ = 16;              % Top-J list size
seed = 42;              % RNG seed for template bank reproducibility
num_tpls = 1:50;        % sweep over K (number of templates)


% Preallocate
nK = numel(num_tpls);

% Overlaps
overlap_cor_tpl = zeros(1, nK);
overlap_cor_dis = zeros(1, nK);
overlap_dis_tpl = zeros(1, nK);
overlap_all3    = zeros(1, nK);

% Timings
t_cor = zeros(1, nK);
t_tpl = zeros(1, nK);
t_dis = zeros(1, nK);


% Sweep K

for ii = 1:nK
    K = num_tpls(ii);
    R = compare_dis_corr_vs_template(K, topJ, seed);

    % Pairwise + triple overlaps
    overlap_cor_tpl(ii) = R.overlap_cor_tpl_count;
    overlap_cor_dis(ii) = R.overlap_cor_dis_count;
    overlap_dis_tpl(ii) = R.overlap_dis_tpl_count;
    overlap_all3(ii)    = R.overlap_all3_count;

    % Timings
    t_cor(ii) = R.t_cor;
    t_tpl(ii) = R.t_tpl;
    t_dis(ii) = R.t_dis;
end


% Plot overlaps vs K

figure('Name','Overlap vs Number of Templates (K)');
plot(num_tpls, overlap_cor_tpl, 'o-','LineWidth',1.5); hold on;
plot(num_tpls, overlap_cor_dis, 's-','LineWidth',1.5);
plot(num_tpls, overlap_dis_tpl, 'd-','LineWidth',1.5);
plot(num_tpls, overlap_all3,    '^-','LineWidth',1.5); grid on; hold off;
xlabel('Number of templates (K)');
ylabel(sprintf('Overlap count in Top-%d', topJ));
title('Overlap vs Template Bank Size (COR, TPL, DIS)');
legend({'COR \cap TPL','COR \cap DIS','DIS \cap TPL','COR \cap TPL \cap DIS'}, ...
       'Location','best');

% Plot timings vs K

figure('Name','Timing vs Number of Templates (K)');
plot(num_tpls, t_cor, 'o-','LineWidth',1.5); hold on;
plot(num_tpls, t_tpl, 's-','LineWidth',1.5);
plot(num_tpls, t_dis, 'd-','LineWidth',1.5); grid on; hold off;
xlabel('Number of templates (K)');
ylabel('Elapsed time (s)');
legend({'Correlation (COR)','Template (TPL)','Distance (DIS)'}, 'Location','best');
title('Runtime vs Template Bank Size');

%  summary 

fprintf('\n=== Summary (TopJ=%d) ===\n', topJ);
fprintf('Max triple overlap across K: %d (at K=%d)\n', max(overlap_all3), num_tpls(overlap_all3==max(overlap_all3)));


