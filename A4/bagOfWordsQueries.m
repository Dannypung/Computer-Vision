function fileName = bagOfWordsQueries(queryPath, referenceHistogram, uniquePath, means, topK)
    
    fileName = {};
    load([queryPath '.sift.mat'],'frames','desc');
    distance = dist2(double(desc'),double(means'));
    
    [~,minIndex] = min(distance');
    [queryHist,~]= hist(minIndex,1:size(means,2));
    
    index = getNormalizedInnerProduct(queryHist, referenceHistogram, topK);
    
    %subplot(2, 3, 1);
    %imshow(queryPath);
    for i=1:size(index,2)
        %subplot(2, 3, i+1);
        %imshow(uniquePath{index(i)});
        fileName{end + 1} = uniquePath{index(i)};
    end
end
