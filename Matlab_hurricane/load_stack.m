% written by Amy on 10/20/2025

function [stack, filelist] = load_stack(root)
% LOAD_RAIN_STACK  Build an m x n x N stack from nested .mat files.
%
%   [stack, filelist] = load_rain_stack(root)
%   [stack, filelist] = load_rain_stack(root, fieldPath)
%
% Inputs
%   root      : char/string. Folder to search (recursively) for *.mat files.
%              'hur_case.rain' is coded in the function
% Outputs
%   stack     : m x n x N numeric array (NaN/Inf replaced with 0).
%   filelist  : N-by-1 cell array of absolute file paths used.

    % Find all .mat files
    addpath('../Matlab')
    f = dir(fullfile(root, '**', '*.mat'));
    if isempty(f)
        error('No .mat files found under: %s', root);
    end

    % Stable ordering by filename
    [~, idx] = sort({f.name});
    f = f(idx);

    % read the first file and create an empty stack
    S1 = load(fullfile(f(1).folder, f(1).name));
    A1 = getfield(S1, 'hur_case', 'rain'); 
    A1 = prepare_matrix(A1); 
    [m, n] = size(A1);
    stack = zeros(m, n, numel(f), 'like', A1);
    stack(:,:,1) = A1;

          
    % Keep track of file paths
    filelist = cell(numel(f), 1);
    filelist{1} = fullfile(f(1).folder, f(1).name);

    % Fill the rest
    for k = 1:(numel(f))
    %for k = 1:(numel(f)-1200)
        fp = fullfile(f(k).folder, f(k).name);
        Sk = load(fp);
        Ak = getfield(Sk,'hur_case', 'rain');
        Ak = prepare_matrix(Ak);

        if ~isequal(size(Ak), [m, n])
            error('Size mismatch in "%s": expected %dx%d, got %dx%d.', ...
                  fp, m, n, size(Ak,1), size(Ak,2));
        end

        stack(:,:,k) = Ak;
        filelist{k} = fp;
    end
end
