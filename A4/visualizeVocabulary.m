basedir = '/v/filer4b/v45q002/data/';

typenames = {'video_frames', 'print', 'book_covers', 'landmarks'};

refFrames = {};
refDesc = {};
path = {};
% Set k value HERE
K = 1000;
% set patche amount to display
patchesPerWord = 15;


% loop over the genres of images
for t = 1:length(typenames)

  topdir = [basedir typenames{t} '/'];  
  
  refimnames = dir([topdir '/Reference/*.jpg']);

  %fprintf('There are %d reference images for object type %s\n', ...
          %length(refimnames), typenames{t});

  for r=1:length(refimnames)

    % read in a reference (database) image
    refim = im2single(rgb2gray(imread([topdir '/Reference/' refimnames(r).name])));
       
    % read in its SIFT descriptors (pre-computed) from the mat file
    load([topdir '/Reference/' refimnames(r).name '.sift.mat'], 'frames', ...
         'desc');
    for i =1:size(frames,2)
        path{end + 1} = [topdir '/Reference/' refimnames(r).name];
    end
    refFrames{end + 1} = frames;
    refDesc{end + 1} = desc;
  end
  
end
refFrames = cell2mat(refFrames);
refDesc = cell2mat(refDesc);

% sample descriptors
refFrames = refFrames(:,2:2:size(refFrames,2));
refDesc = refDesc(:,2:2:size(refDesc,2));
refPath = path(:,2:2:length(path));

[membership,means,rms] = kmeansML(K,double(refDesc));

chosenIndex = find(membership == 60);
% chosenIndex = find(membership == 188);
 
chosenFrames = refFrames(:,chosenIndex);
chosenDesc = refDesc(:,chosenIndex);
chosenPath = refPath(:,chosenIndex);


N = min(patchesPerWord, size(chosenIndex,1));
% show patches
for i=1:N 
    patch = getPatchFromSIFTParameters(chosenFrames(1:2,i), ...
            chosenFrames(3,i), chosenFrames(4,i), ...
            im2single(rgb2gray(imread(chosenPath{i}))));
    subplot(double(idivide(int32(N), int32(5), 'ceil')), double(5), i);
    imshow(patch);                       
end

save('variables.mat','refFrames' ,'membership', 'means', 'refPath');
