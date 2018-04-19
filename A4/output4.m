load('referenceHistogram.mat','referenceHistogram');
load('variables.mat','refFrames' ,'membership', 'means', 'refPath');
uniquePath = unique(refPath);

% queryPath = 'v45q002/data/video_frames/iPhone/091.jpg';
queryPath = 'v45q002/data/video_frames/iPhone/082.jpg';
fileName = bagOfWordsQueries(queryPath, referenceHistogram, uniquePath, means, 5);

figure;
subplot(2, 3, 1);
imshow(queryPath);
title('Query image');

for i=1:5
	subplot(2, 3, i+1);
	imshow(fileName{i});
	title(sprintf('match %d ', i));
end