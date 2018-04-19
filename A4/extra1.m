path1 = '/v/filer4b/v45q002/data/video_frames/5800/088.jpg';
path2 = '/v/filer4b/v45q002/data/video_frames/Reference/088.jpg';

nLineToShow = 200;


im1=im2single(rgb2gray(imread(path1)));
im2=im2single(rgb2gray(imread(path2)));

load([path1 '.sift.mat']);

frames1 = frames;
desc1 = desc;

load([path2 '.sift.mat']);

frames2 = frames;
desc2 = desc;

index = randperm(size(frames1,2),nLineToShow); 

matchMatrix=[];
for i = 1: nLineToShow
    temp = zeros(3,1);

    dist = dist2(double(desc1(:,index(i)))', double(desc2)');
    [sortedDists, sortedIndices] = sort(dist, 'ascend');
    temp(:,1) = [i; sortedIndices(1); sortedDists(1)];
    
    if(sortedDists(1)/sortedDists(2)<0.8)
     matchMatrix=[matchMatrix temp];
    end

end

showLinesBetweenMatches(im1,im2,frames1,frames2,matchMatrix)
