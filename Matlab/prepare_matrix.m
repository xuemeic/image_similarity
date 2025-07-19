% Originally Written by Justin on March 2025
% Rewritten and Commented by Amy Lan on 07/16/2025
% Modified & Documented by Amy Lan on 07/17/2025
% Renamed and Modified again by Amy on 07/18/2025

% Description:
% The functiom is oringinally designed for real hurricane data. Later on we
% switched to simulated car data, then this process may not be necessary.
% It ensures :
% 1. The input matrix is square (rows×rows)
% 2. Shifts all non-NaN values by a constant
% 3. Replaces any NaNs with zeros. 
% Generally it is used to standardize image matrices before filtering.

%Usage:
%   M = PrepareMatrix(test_im)
%   M = PrepareMatrix(test_im, VALUE)
%
% Inputs:
%   test_im – an a×n matrix (may be non‑square)
%   VALUE   – scalar to add to all non‑NaN entries (default = 0)
%
% Output:
%   matrix  – a×a matrix with no NaNs, values shifted by VALUE

function matrix = prepare_matrix(test_im, VALUE)


    arguments
    test_im
    VALUE = 0
    end

    % 1. Get dimensions
    [rows, cols] = size(test_im);

    % 2. If not square, pad with NaNs on the left to make it rows×rows
    if rows ~= cols
        padCols = rows - cols;           % number of columns to add
        nanPad  = NaN(rows, padCols);    % create NaN padding
        test_im = [nanPad, test_im];     % pad to the left
    end

    % 3. Add VALUE to every non‑NaN entry
    idxNonNaN = ~isnan(test_im);
    test_im(idxNonNaN) = test_im(idxNonNaN) + VALUE;

    % 4. Replace all remaining NaNs with zeros
    test_im(isnan(test_im)) = 0;

    % 5. Return the processed matrix
    matrix = test_im;
end