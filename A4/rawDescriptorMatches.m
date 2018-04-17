path1 = 'v45q002/data/book_covers/5800/001.jpg';
path2 = 'v45q002/data/book_covers/Reference/001.jpg';

load([path1 '.sift.mat'], 'frames', 'desc');
frame1 = frames;
desc1 = desc;
SHOW_ALL_MATCHES_AT_ONCE = 1;

load([path2 '.sift.mat'], 'frames', 'desc');
frame2 = frames;
desc2 = desc;

randomIndices = randperm(size(desc1,2));
aSingleSIFTDescriptor = desc1(:,randomIndices(1));

dists = dist2(double(desc1)', double(desc2)');
[sortedDists, sortedIndices] = sort(dists', 'ascend');

matchMatrix = zeros(3,size(frame1,2));
matchMatrix(1,:) = [1:size(frame1,2)];
matchMatrix(2,:) = sortedIndices(1,:);
matchMatrix(3,:) = sortedDists(1,:);

ncol = 10;
x = randperm(size(matchMatrix,2),ncol);
    
showMatchingPatches(matchMatrix(:,x), desc1, desc2, frame1, frame2, ...
    imread(path1), imread(path2), SHOW_ALL_MATCHES_AT_ONCE);
