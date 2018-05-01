% Starter code prepared by James Hays for CS 143, Brown University
% This function returns detections on all of the images in a given path.
% You will want to use non-maximum suppression on your detections or your
% performance will be poor (the evaluation counts a duplicate detection as
% wrong). The non-maximum suppression is done on a per-image basis. The
% starter code includes a call to a provided non-max suppression function.
function [bboxes, confidences, image_ids] = .... 
    run_detector(test_scn_path, w, b, feature_params)
% 'test_scn_path' is a string. This directory contains images which may or
%    may not have faces in them. This function should work for the MIT+CMU
%    test set but also for any other images (e.g. class photos)
% 'w' and 'b' are the linear classifier parameters
% 'feature_params' is a struct, with fields
%   feature_params.template_size (probably 36), the number of pixels
%      spanned by each train / test template and
%   feature_params.hog_cell_size (default 6), the number of pixels in each
%      HoG cell. template size should be evenly divisible by hog_cell_size.
%      Smaller HoG cell sizes tend to work better, but they make things
%      slower because the feature dimensionality increases and more
%      importantly the step size of the classifier decreases at test time.

% 'bboxes' is Nx4. N is the number of detections. bboxes(i,:) is
%   [x_min, y_min, x_max, y_max] for detection i. 
%   Remember 'y' is dimension 1 in Matlab!
% 'confidences' is Nx1. confidences(i) is the real valued confidence of
%   detection i.
% 'image_ids' is an Nx1 cell array. image_ids{i} is the image file name
%   for detection i. (not the full path, just 'albert.jpg')

% The placeholder version of this code will return random bounding boxes in
% each test image. It will even do non-maximum suppression on the random
% bounding boxes to give you an example of how to call the function.

% Your actual code should convert each test image to HoG feature space with
% a _single_ call to vl_hog for each scale. Then step over the HoG cells,
% taking groups of cells that are the same size as your learned template,
% and classifying them. If the classification is above some confidence,
% keep the detection and then pass all the detections for an image to
% non-maximum suppression. For your initial debugging, you can operate only
% at a single scale and you can skip calling non-maximum suppression.

test_scenes = dir( fullfile( test_scn_path, '*.jpg' ));

%initialize these as empty and incrementally expand them.
bboxes = zeros(0,4);
confidences = zeros(0,1);
image_ids = cell(0,1);
hog_cell_size = feature_params.hog_cell_size;
template_size = feature_params.template_size;
% set scales and treshhold values
SCALE = 0.1:0.1:1.1;
thresh = 0.88; 

for i = 1:length(test_scenes)
      
    fprintf('Detecting faces in %s\n', test_scenes(i).name)
    img = imread( fullfile( test_scn_path, test_scenes(i).name ));
    img = single(img)/255;
    if(size(img,3) > 1)
        img = rgb2gray(img);
    end
    
    cur_image_ids = cell(0,1);
    cur_bboxes = [];
    cur_confidences = [];
    
    for scale = SCALE
        % resize image
        resizedImg = imresize(img,scale);
        % if resized image not less than template size
        if min(size(resizedImg)) >= template_size
            % get HOG
            HOG = vl_hog(resizedImg, hog_cell_size);
            % calculate the max row and column indexs for cropping
            window_r = size(HOG,1) - fix(template_size/hog_cell_size) + 1;
            window_c = size(HOG,2) - fix(template_size/hog_cell_size) + 1;
            
            tempFeature = zeros(window_r*window_c,(template_size/...
                                        hog_cell_size) ^ 2 * 31);
            tempIndex = zeros(window_r*window_c,4);
            % counter for temp variables
            tempCount = 1;
            for j = 1:window_c
                for k = 1:window_r
                    % get the HOG in window size
                    thisFeature = HOG(k : k + template_size/hog_cell_size...
                        - 1, j : (j + template_size/hog_cell_size - 1), :);
                    tempFeature(tempCount,:) = reshape(thisFeature, 1, ...
                        fix(template_size/hog_cell_size) ^ 2 * 31);
                    % calculate index in resized image
                    x_min = (j-1)*hog_cell_size + 1;
                    y_min = (k-1)*hog_cell_size + 1;
                    x_max = (j + template_size/hog_cell_size - 1) * hog_cell_size;
                    y_max = (k + template_size/hog_cell_size - 1) * hog_cell_size;
                    % calculate index in original image and store
                    tempIndex(tempCount,:) = [x_min, y_min, x_max, y_max]./ scale;
                    tempCount = tempCount + 1;
                end
            end
            % find the scores greater than treshhold value
            thisScore = tempFeature * w + b;
            index = find(thisScore >= thresh);
            if ~isempty(index)
                cur_bboxes = [cur_bboxes;tempIndex(index,:)];
                cur_confidences = [cur_confidences; thisScore(index)]; 
                %confidences in the range [-2 2]
                ids = cell(max(size(index)),1);
                ids(:) = {test_scenes(i).name};
                cur_image_ids = [cur_image_ids; ids];
            end
        end
    end
    %non_max_supr_bbox can actually get somewhat slow with thousands of
    %initial detections. You could pre-filter the detections by confidence,
    %e.g. a detection with confidence -1.1 will probably never be
    %meaningful. You probably _don't_ want to threshold at 0.0, though. You
    %can get higher recall with a lower threshold. You don't need to modify
    %anything in non_max_supr_bbox, but you can.
    if ~isempty(cur_bboxes)
        [is_maximum] = non_max_supr_bbox(cur_bboxes, cur_confidences, size(img));

        cur_confidences = cur_confidences(is_maximum,:);
        cur_bboxes      = cur_bboxes(is_maximum,:);
        cur_image_ids   = cur_image_ids(is_maximum,:);

        bboxes      = [bboxes;      cur_bboxes];
        confidences = [confidences; cur_confidences];
        image_ids   = [image_ids;   cur_image_ids];
    end
end




