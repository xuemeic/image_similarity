% written by Amy on 10/12/2025 to precompute phi

function index = build_phi_index(image_collection, template)

% normalize templates
norms = sqrt(sum(template.^2,[1 2]));
Tn    = template ./ norms;

% build phi (KxN)
[~,~,N] = size(image_collection);
phi = zeros(size(Tn,3), N);
for i = 1:N
    Img_i = image_collection(:,:,i);
    nf = norm(Img_i(:),'fro');
    Img_i = Img_i / nf;
    phi(:, i) = max_filter(Tn, Img_i);
end

%phi_db: pre-computed our database
index = struct('phi_db', phi, 'Tn', Tn); 
end

