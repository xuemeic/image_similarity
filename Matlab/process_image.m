% Originally Written by Justin on March 2025
% Rewritten and Commented by Amy Lan on 07/15/2025
% Modified & Documented by Amy Lan on 07/17/2025
% Deleted the hur_case.rain structure and resturcture the input by Amy on
% 07/17/2025

% Description:
%   Given a folder of .mat files each containing  a 2D cat image matrix,
%   this function:
%     1. Scans the folder (ignores “png” folder)
%     2. Loads each .mat’s primary variable (your cat image)
%     3. Preprocesses it via PrepareMatrix
%     4. Applies a bank of template kernels via max_filter
%     5. Aggregates the per‑template max responses into a table
%     6. Exports the table to a CSV file

function process_image(folder, templates, NAME)
    arguments
        folder    (1,:) char                 % directory of .mat files
        templates (:,:,:) double             % M×N×K 3-D template stack
        NAME      (1,:) string = "outputs.csv"  % CSV output filename
    end

VALUE = 0;                              % default parameter for PrepareMatrix
responsesTable = table();              % initialize output table
[~,~,numTemplates] = size(templates);  % number of filters (templates)

% List all non‑hidden files in folder, ignore subfolders ("png folder")
entries = dir(folder);
entries = entries(~startsWith({entries.name}, '.'));   % drop hidden
entries = entries(~[entries.isdir]);                   % drop directories

for i = 1:numel(entries)
        fullPath = fullfile(folder, entries(i).name); 
        % Create valid path appropriate for our OS
        [~, baseName, ext] = fileparts(entries(i).name);
        % Extracting the base name and extension

     % Process only .mat files
      if strcmpi(ext, ".mat")
            % Find the variable name inside the .mat
            info    = whos('-file', fullPath);
            varName = info(1).name;               % assume first var is the image
            data    = load(fullPath, varName);
            img     = data.(varName);             % extract the 2D image

            % Preprocess
            img = prepare_matrix(img, VALUE);

            % Max‑filter: returns 1×1×K of max responses
            v = max_filter(templates, img);

            % Reshape into a K×1 vector
            v = reshape(v, numTemplates, 1);

            % Add to the table, named by the file’s base name
            responsesTable = addvars(responsesTable, v, ...
                                    'NewVariableNames', baseName);
       end
end

    % Write the compiled responses to CSV
    writetable(responsesTable, NAME);
    fprintf("Output written to: %s\n", NAME);
end
