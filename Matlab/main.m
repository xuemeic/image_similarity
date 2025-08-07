% written by Amy Lan on 07/18/2025
% Modified by Amy Lan On 07/23/2025
% Remove step 2 create image stack by Amy Lan on 07/25/2025
% Add tic toc to calcuate the computing time by Amy on 07/26/2025

% Description:
% creates an M×N×K image stack from your folder of .mat cat images,
% then feeds it (along with the template bank) into process_matrix.
% serve as a main function to get cat_image_results.csv


% 1. Define paths & parameters
cat_folder = fullfile('/Users/lanheng/Desktop/image_similarity_2025', ...
    'image_similarity', 'synthetic_data', 'cat_image' );
% folder of cat *.mat
template_file = fullfile('/Users/lanheng/Desktop/image_similarity_2025', ...
    'image_similarity', 'synthetic_data', 'cat_image','cat_001.mat');
% contains ONE 50 * 50 template
output_csv    = 'cat_image_results_no_loop.csv';

% add timer
tStart = tic;

M = 50;    % define number of rows
N = 50;    % define number of cols

% 2. build the image stack
% image_stack = create_image_stack(cat_folder, M, N);
% prints: Loaded 301 images from "…/cat_image" into a 50×50×301 array.

% 3. load your real template bank and reshape from 50*50 to 50*50*1
info      = whos('-file', template_file);
info = whos('-file', template_file);
if isempty(info)
    error('No variables found in %s', template_file);
end
varName   = info(1).name;                % assume first variable is the template
S         = load(template_file, varName);
T         = S.(varName);                 % T is 50x50
templates = reshape(T, M, N, 1);         % make it MxNx1
fprintf('Loaded template "%s" (size = %dx%dx%d).\n', varName, size(templates));

% 4. process the stack
process_image(cat_folder, templates, output_csv);
% you’ll see: Output written to: cat_image_results_no_loop.csv

elapsed = toc(tStart);
fprintf('Total runtime: %.3f s (%.2f min)\n', elapsed, elapsed/60);