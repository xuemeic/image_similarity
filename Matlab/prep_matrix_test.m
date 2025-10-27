S = load('/Users/lanheng/Desktop/image_similarity_2025/cat1-cat5-cahill/cat1-cat5-cahill/2014/ADJALI/20141117-1151-NOAA18.mat'); 
A = S.hur_case.rain;
A = prepare_matrix(A, 0);
imagesc(A); axis image off; colorbar;
