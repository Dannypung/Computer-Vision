function files = spatialVerification(topK,uniquePath,queryPath,means,referenceHistogram)
    
    
    if ~exist('referenceHistogram','var')
     % parameter does not exist, so default it to something
        load('referenceHistogram.mat','referenceHistogram');  
    end
    
    files = {};
    T = 10;
    R = 100;
    % get the top T files from bagOfWordsQueries
    fileName = bagOfWordsQueries(queryPath, referenceHistogram, uniquePath,...
        means, T);

    load([queryPath '.sift.mat'], 'frames', 'desc');
    frame1 = frames;
    desc1 = desc;


    counts=zeros(1, T);

    %%%%%%%%%%%%%%%
    for i = 1:size(fileName,2)
        
        load([fileName{i} '.sift.mat'], 'frames', 'desc');
        frame2 = frames;
        desc2 = desc;

        dists = dist2(double(desc1)', double(desc2)');

        [~,minIndex] = min(dists');
        points1 = zeros(2,4);
        points2 = zeros(2,4);
        for j=1:R
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
                if diff'*diff <= 58
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

    subplot(5, 4, 1);
    imshow(queryPath);
    for i=1:T
        subplot(5, 4, i+1);
        imshow(fileName{i});
        title(sprintf('match %d count %d', i, counts(i)));
    end
    
    [~,index]= sort(counts,'descend');

    for i =1:topK
        files{end + 1} = fileName{index(i)};
    end
        
end
