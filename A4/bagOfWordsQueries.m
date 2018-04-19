function fileName = bagOfWordsQueries(queryPath, referenceHistogram, uniquePath, means, topK)
    % input query image path, referenceHistogram, uniquePath, means and topK
    % returns the topK matched Reference images
    % fileName is the cell of the returned image paths
    
    fileName = {};
    load([queryPath '.sift.mat'],'frames','desc');
    distance = dist2(double(desc'),double(means'));
    
    % generate query image histogram
    [~,minIndex] = min(distance');
    [queryHist,~]= hist(minIndex,1:size(means,2));
    
    % getNormalizedInnerProduct.m is the function to caculater similarity
    % of the query image and all reference images
    index = getNormalizedInnerProduct(queryHist, referenceHistogram, topK);
    
    %subplot(2, 3, 1);
    %imshow(queryPath);
    for i=1:size(index,2)
        %subplot(2, 3, i+1);
        %imshow(uniquePath{index(i)});
        fileName{end + 1} = uniquePath{index(i)};
    end
end
