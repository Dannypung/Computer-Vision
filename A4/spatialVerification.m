T = 19;
R = 100;
queryPath = 'v45q002/data/landmarks/Query/056.jpg';
load('variables.mat','refFrames' ,'membership', 'means', 'refPath');
load('referenceHistogram.mat','referenceHistogram');
uniquePath = unique(refPath);

fileName = bagOfWordsQueries(queryPath, referenceHistogram, uniquePath,...
    means, T);

load([queryPath '.sift.mat'], 'frames', 'desc');
frame1 = frames;
desc1 = desc;


counts=zeros(1, T);
subplot(5, 4, 1);
imshow(queryPath);
for i=1:T
    subplot(5, 4, i+1);
    imshow(fileName{i});
    title('')
end

%%%%%%%%%%%%%%%
for i = 1:size(fileName,2)
    fprintf('image %d\n',i);
    load([fileName{i} '.sift.mat'], 'frames', 'desc');
    frame2 = frames;
    desc2 = desc;


    dists = dist2(double(desc1)', double(desc2)');

    [~,minIndex] = min(dists');
    points1 = zeros(2,4);
    points2 = zeros(2,4);
    for j=1:R
        %fprintf('round %d\n',j);
        thisCount = 0;
        randomIndex = randperm(size(minIndex,2),4);
        for k=1:4
            points1(:,k) = frame1(1:2,randomIndex(k));
            points2(:,k) = frame2(1:2,minIndex(randomIndex(k)));
        end
        H = getHomographyMatrix(points1, points2);
        for l=1:size(frame1,2)
            temp = ones(3,1);
            temp(1:2,1) = frame1(1:2,l);
            predictedIndex2 = H*temp;
            predictedIndex2 = predictedIndex2/predictedIndex2(3);
            realIndex2 = frame2(1:2,minIndex(l));
            diff = predictedIndex2(1:2,1)-realIndex2;
            if diff'*diff < 32
                thisCount = thisCount + 1;
            end
        end

        if thisCount > counts(i)
%             disp(counts(i));
%             disp(thisCount);
            counts(i) = thisCount;
            
        end
    end   
end
disp(counts);
