function [textons] = createTextons(imStack, bank, k) 
    % do sampling of 1/199
    sampleSize = 199;
    allChosenPixels = [];
    % iterate through imStack, generate chosen pixels
    for i=1:size(imStack,2)
        tempIm = imStack{1,i};
        tempImFeature = zeros(size(tempIm,1),size(tempIm,2),size(bank,3));
        for j = 1:size(bank,3)            
            tempImFeature(:,:,j) = imfilter(double(tempIm),bank(:,:,j),'replicate');
        end
        [r, c, d] = size(tempImFeature);
        tempImFeature = reshape(tempImFeature, r*c, d);
        % randome sampling pixels
        y = randsample(r*c,int16(r*c/sampleSize));
        
        for j = 1:size(y,1)
                allChosenPixels(size(allChosenPixels,1) + 1,:) = tempImFeature(j,:);
        end
    end
    % use k mean to assign chosen pixels to group, then get the mean of
    % each group
    kmeanResult = kmeans(double(allChosenPixels),k);
    textons = zeros(k,size(bank,3));
    for i = 1:k
        temp = [];
        for j = 1:size(kmeanResult,1)
            if kmeanResult(j,1) == i
                temp(size(temp,1)+1,:) = allChosenPixels(j,:);
            end
        end
        textons(i,:) = mean(temp);
    end
end
