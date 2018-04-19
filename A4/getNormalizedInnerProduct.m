function index = getNormalizedInnerProduct(queryHist, referenceHist, topK)

    result = zeros(1,size(referenceHist,1));
    for i =1:size(referenceHist,1)
        b = sqrt(queryHist*queryHist');
        c = sqrt(referenceHist(i,:)*referenceHist(i,:)');
        a = queryHist*referenceHist(i,:)';
        result(1,i) = double(a/(b*c));
    end
    [~,index] = sort(result,'descend');
    index = index(1:topK);
    
end