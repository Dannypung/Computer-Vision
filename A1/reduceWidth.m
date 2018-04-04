function [output,outputWithSeams, energyResult] = reduceWidth(im, numPixels)
    xEnergy = [-1,1];
    %xEnergy = fspecial('sobel'); for question 4
    yEnergy = xEnergy';
    output = im;
    outputWithSeams = im;
    originalWidth = size(im,2);
    originalHeight = size(im,1);
    removedPointMatrix = zeros(originalHeight,numPixels);
    
    for rd = 1:numPixels
        disp(rd);
        grayscale = rgb2gray(output);
        energyFunction = abs(imfilter(double(grayscale), xEnergy, ...
            'replicate')) + abs(imfilter(double(grayscale), yEnergy, ...
            'replicate'));
        row = size(energyFunction,1);
        column = size(energyFunction,2);
        cumulativEnergy = zeros(row,column);
        cumulativEnergy(1,:) = energyFunction(1,:);
        pathMatrix = zeros(row,column);
        % get energy function by dynamic programming
        for r = 2:row
            for c = 1:column
                if c == 1
                    [~,n] = min(cumulativEnergy(r-1,c:c+1));
                    cumulativEnergy(r,c) = energyFunction(r,c)...
                        + cumulativEnergy(r-1,c - 1 + n);
                    pathMatrix(r,c) = (c - 1 + n);
                elseif c == column
                    [~,n] = min(cumulativEnergy(r-1,c-1:c));
                    cumulativEnergy(r,c) = energyFunction(r,c)...
                        + cumulativEnergy(r-1,c - 2 + n);
                    pathMatrix(r,c) = (c - 2 + n);
                else
                    [~,n] = min(cumulativEnergy(r-1,c-1:c+1));
                    cumulativEnergy(r,c) = energyFunction(r,c)...
                        + cumulativEnergy(r-1,c - 2 + n);
                    pathMatrix(r,c) = (c - 2 + n);
                end
            end
        end
        energyResult = cumulativEnergy;
        toRemoveList = zeros(row,1);
        [~,n] = min(cumulativEnergy(row,:));
        toRemoveList(row,1) = n;

        for i = row:-1:2
           toRemoveList(i-1,1) = pathMatrix(i,toRemoveList(i));
        end
        % generate the matrix contains pixels to remove
        if rd == 1
            removedPointMatrix(:,1) = toRemoveList;
        else
            for s = 1:row
                tempIndex = toRemoveList(s,1);
                removedIndex = removedPointMatrix(s,:);
                tempMatrix = zeros(1,originalWidth);
                for ss = 1:(rd -1)
                    tempMatrix(1,removedIndex(1,ss)) = removedIndex(1,ss);
                end
                [~, col] = find(tempMatrix==0);
                trueIndex = col(tempIndex);
                removedPointMatrix(s,rd) = trueIndex;   
            end
        end
        % generate new image
        newImage = zeros(row,column-1,3);
        for dimension = 1:3
            for i = 1:row
                temp = output(i,:,dimension);
                temp(toRemoveList(i,1))=[];
                newImage(i,:,dimension) = temp;  
            end
        end
        output = uint8(newImage);
    end
    % generate the output image with seams
    for i = 1:originalHeight
        for j = 1:numPixels
            outputWithSeams(i,removedPointMatrix(i,j),:) = [255,0,0];
        end
    end
    outputWithSeams = uint8(outputWithSeams);
    output = uint8(output);
end