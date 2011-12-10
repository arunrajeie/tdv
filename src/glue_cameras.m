%% Load data

fprintf('Loading image data and image-to-image correspondences\n');
load('../data/images_and_sparse_correspondences.mat', 'images', 'm', 'pc');

%% Choose initial camera pair (i1,i2) with most image-to-image correspodences

ncams = length(images);

corresp_count = zeros(ncams, ncams);
max_corresp_count = -1;
i1 = -1; i2 = -1;

for i = 1:ncams
    for j = i+1:ncams
        corresp_count(i,j) = size(m{i,j},2);
	if corresp_count(i,j) > max_corresp_count
	    max_corresp_count = corresp_count(i,j);
	    i1 = i; i2 = j;
	end
    end
end

fprintf([ ...
'The camera pair with the maximum number of image-to-image correspondences' ...
'\nis the pair (%u,%u) with %u correspondences\n'], ...
	i1, i2, max_corresp_count);

%% Estimate epipolar geometry for the initial camera pair (i1,i2);