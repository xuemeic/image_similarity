
% Oringinally Written by Justin & Landon on April 2026
% Modified and Commented by Amy Lan on 07/08/2025
% Blend noise.m into gen_cat_image.m (main function) by Amy on 07/09/2025
% Add PNG folder to the output by my on 07/09/2025
% Rewrote the loop and remove the hur_case.rain struct by Amy on 07/09/2025

% Main function: Generate 301 cat images and save it in a folder
B = zeros(50,50);
B(4,5) = 1; B(4,11) = 1; B(5,4:2:6) = 1; B(5,10:2:12) = 1;
B(6,4) = 1; B(6,7:9) = 1; B(6,13:17) = 1; B(7,18) = 1;
B(7:9,3) = 1; B(8,19) = 1; B(8,1:2) = 1; B(9:10,20) = 1;
B(11:15,21) = 1; B(16,3) = 1; B(16,20) = 1; B(17,4) = 1; B(17,19) = 1;
B(18,5:18) = 1; B(10:15,2) = 1; B(10,1) = 1;
B(9,5:3:11) = 1; B(10,7:2:9) = 1; B(8:2:10,13:14) = 1;
B(7,14) = 0.5; B(7:8,15:2:17) = 0.5; B(8,18) = 0.5;
B(17,14) = 1; B(16,15:17) = 1; B(15,18) = 1;
B(17,15:2:17) = 0.5; B(16,18) = 0.5; B(7,7:2:9) = 0.5;
% Generates a pattern

B = circshift(B,[13 13]);
% reposition each pixel by +13 in row and +13 in column

folderMAT = fullfile('..','synthetic_data','cat_image');
folderPNG = fullfile(folderMAT,'png');
% use fullfile to build the path
% fullfile prevents hardcoding separators like "/" and "\" differences


if ~exist(folderMAT,'dir'), mkdir(folderMAT); end
if ~exist(folderPNG,'dir'), mkdir(folderPNG); end
% check folder status


%% The Scrambling
N = 300;

for i = 0:N
    % i=0 → first image (unmodified), i=1..N → variants
    % A = imrotate(B,(-1)^i * mod(i,11), 'bilinear', 'crop');
    A = B;
    if i>0
            % random horizontal + vertical shift (up to 5/8 width)
            w = size(A,2);
            maxShift = floor(5*w/8);
            dx = randi(maxShift);
            dy = randi(maxShift);
            A = circshift(A, [dy, dx]);

            % add zero-mean Gaussian noise, std dev uniform [0.005,0.1]
            e = 0.005 + (0.1-0.005)*rand;
            A = A + e*randn(size(A));

            % sprinkle 2*i random dots of fresh rand( ) intensity
            A = add_dot(A, 2*i);

            % every 10th variant, fully scramble pixels
            if mod(i,10)==0
                A = scram(A);
            end
    end
   
    % build a three‐digit index by doing (i+1)
    idx = i+1;  % so i=0→001, i=300→301
    name = sprintf('cat_%03d', idx);
     
    % creates a path like '../synthetic_data/cat_image/cat_001.mat'
    fnameMAT = fullfile(folderMAT, [name '.mat']);
    save(fnameMAT, 'A');

    % creates PNG in path like '../synthetic_data/cat_image/png/cat_001.png'
    img = mat2gray(A); % rescales A into range [0,1] for image writing
    fnamePNG = fullfile(folderPNG, [name '.png']); 
    imwrite(img, fnamePNG);

end
fprintf('Done: generated %d images in %s\n', N+1, folderMAT);

