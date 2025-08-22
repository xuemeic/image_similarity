% Written By Dr.Chen on 07/26/2025
% Modified and commented by Amy on 08/03/2025
% This is to check the efficiency between max_filter and max_filter_no_loop


m = 500; n = 500; K = 5000; % K images in the collection each m*n,
rng(3); % set seeds for reproducibility
Imgs = randn(m, n, K); % k random images
W = randn(m, n); % one random query image

tic; s = max_filter(Imgs, W); t1 = toc % time loop version

tic; s_no = max_filter_no_loop(Imgs, W); t2 = toc % time loop-free version

% print timings
fprintf('max_filter time        : %.3f s\n', t1);
fprintf('max_filter_no_loop time: %.3f s\n', t2);
norm(s - s_no)