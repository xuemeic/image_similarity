% Sweep K and plot overlap vs. number of templates.
% Written by Amy 09/25/2025

clear; clc;

% setting parameters 
topJ = 16;          % number of overlap images to compare in Top-J lists
seed = 42;          % fix seed so the template bank is reproducible
num_tpls   = 1:50;       % sweep number of templates

overlaps = zeros(size(num_tpls));
t_fft    = zeros(size(num_tpls));
t_tpl    = zeros(size(num_tpls));

for ii = 1:numel(num_tpls)
    K = num_tpls(ii);
    R = compare_fft_vs_template(K, topJ, seed);
    overlaps(ii) = R.overlap_count;
    t_fft(ii)    = R.t_fft;
    t_tpl(ii)    = R.t_tpl;
end

% plot overlap vs K
figure('Name','Overlap vs Number of Templates (K)');
plot(num_tpls, overlaps, 'o-','LineWidth',1.5); grid on;
xlabel('Number of templates (K)');
ylabel(sprintf('Overlap count in Top-%d', topJ));
title('FFT vs Template — Overlap vs Template Bank Size');

% Timing plots
figure('Name','Timing vs Number of Templates (K)');
plot(num_tpls, t_fft, 'o-', num_tpls, t_tpl, 's-','LineWidth',1.5); grid on;
xlabel('Number of templates (K)');
ylabel('Elapsed time (s)');
legend({'FFT baseline','Template method'}, 'Location','best');
title('Runtime vs Template Bank Size');
