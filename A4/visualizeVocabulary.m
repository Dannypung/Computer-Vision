basedir = 'v45q002/data/';

typenames = {'video_frames', 'print', 'book_covers', 'landmarks'};

refFrames = {};
refDesc = {};
path = {};
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

disp(size(refFrames));
disp(size(refDesc));
disp(size(path));

refFrames = refFrames(:,2:2:size(refFrames,2));
refDesc = refDesc(:,2:2:size(refDesc,2));
refPath = path(:,2:2:length(path));

disp(size(refFrames));
disp(size(refDesc));
disp(size(refPath));

[membership,means,rms] = kmeansML(1000,double(refDesc));

disp(size(membership));
disp(size(means));

patchesPerWord = 15;

  chosenIndex = find(membership == 60);
 % chosenIndex = find(membership == 188);
 
 chosenFrames = refFrames(:,chosenIndex);
 chosenDesc = refDesc(:,chosenIndex);
 chosenPath = refPath(:,chosenIndex);

 disp(size(chosenFrames));
 disp(size(chosenDesc));
 disp(size(chosenPath));

nPatch = min(patchesPerWord, size(chosenIndex,1));
for i=1:nPatch 
    patch = getPatchFromSIFTParameters(chosenFrames(1:2,i), ...
            chosenFrames(3,i), chosenFrames(4,i), ...
            im2single(rgb2gray(imread(chosenPath{i}))));
    subplot(double(idivide(int32(nPatch), int32(5), 'ceil')), double(5), i);
    imshow(patch);                       
end


disp(size(refFrames));
disp(size(membership));
disp(size(means));
disp(size(refPath));

save('variables.mat','refFrames' ,'membership', 'means', 'refPath');
