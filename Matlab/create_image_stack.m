% Written by Amy on July 18th 2025

% Description:
%   Loads every .mat file in a specified folder, extracts the primary
%   2D image variable, resizes each image to M×N, and stacks them into
%   an M×N×K array (where K is the number of files).

% Usage:
%   image_stack = create_image_stack(folder, M, N)
%
% Inputs:
%   folder      – path to directory containing .mat image files
%   M           – number of rows for each resized image
%   N           – number of columns for each resized image
%
% Output:
%   image_stack – M×N×K numeric array of stacked images

function image_stack = create_image_stack(folder, M, N)
    arguments
        folder (1,:) char
        M      (1,1) double {mustBePositive, mustBeInteger}
        N      (1,1) double {mustBePositive, mustBeInteger}
    end

    % Gather all .mat files (ignore hidden files)
    files = dir(fullfile(folder, '*.mat'));
    files = files(~startsWith({files.name}, '.'));

    % Sort by filename to ensure consistent stacking
    [~, idx] = sort({files.name});
    files = files(idx);

    K = numel(files);                    % number of images
    image_stack = zeros(M, N, K);        % pre‑allocate output

    % Loop over each file
    for i = 1:K
        full_path = fullfile(folder, files(i).name);

        % Detect variable name inside .mat
        info     = whos('-file', full_path);
        var_name = info(1).name;             % assume first var is the image

        % Load the image matrix
        data     = load(full_path, var_name);
        img      = data.(var_name);

        % a) Validate it’s 2D
        if ndims(img) ~= 2
            error('File "%s" does not contain a 2D matrix.', files(i).name);
        end

        % b) Resize to M×N (requires Image Processing Toolbox)
        img_resized = imresize(img, [M, N]);

        % c) Store in the output stack
        image_stack(:, :, i) = img_resized;
    end

    % Inform user
    fprintf('Loaded %d images from "%s" into a %dx%dx%d array.\n', ...
            K, folder, M, N, K);
end

