function [output,outputWithSeams, energyResult] = reduceHeight(im, numPixels)
    xEnergy = [-1,1];
    yEnergy = xEnergy';
    outputWithSeams = im;
    output = im;
    originalWidth = size(im,2);
    originalHeight = size(im,1);
    removedPointMatrix = zeros(numPixels,originalWidth);

    for rd = 1:numPixels
        disp(rd)
        grayscale = rgb2gray(output);
        energyFunction = abs(imfilter(double(grayscale), xEnergy, ...
            'replicate')) + abs(imfilter(double(grayscale), yEnergy,...
            'replicate'));
        row = size(energyFunction,1);
        column = size(energyFunction,2);
        
        cumulativEnergy = zeros(row,column);
        cumulativEnergy(:,1) = energyFunction(:,1);
        pathMatrix = zeros(row,column);
        % get energy function by dynamic programming
        for c = 2:column
            for r = 1:row
                if r == 1
                    [~,n] = min(cumulativEnergy(r:r+1,c-1));
                    cumulativEnergy(r,c) = energyFunction(r,c)...
                        + cumulativEnergy(r - 1 + n,c - 1);
                    pathMatrix(r,c) = (r - 1 + n);
                elseif r == row
                    [~,n] = min(cumulativEnergy(r-1:r,c-1));
                    cumulativEnergy(r,c) = energyFunction(r,c)...
                        + cumulativEnergy(r - 2 + n,c - 1);
                    pathMatrix(r,c) = (r - 2 + n);
                else
                    [~,n] = min(cumulativEnergy(r-1:r+1,c-1));
                    cumulativEnergy(r,c) = energyFunction(r,c)...
                        + cumulativEnergy(r - 2 + n,c-1);
                    pathMatrix(r,c) = (r - 2 + n);
                end
            end
        end

        toRemoveList = zeros(1,column);
        [~,n] = min(cumulativEnergy(:,column));
        toRemoveList(1,column) = n;

        for i = column:-1:2
           toRemoveList(1,i-1) = pathMatrix(toRemoveList(i),i);
        end     
        % generate the matrix contains pixels to remove
        if rd == 1
            removedPointMatrix(1,:) = toRemoveList;
        else
            for s = 1:column
                tempIndex = toRemoveList(1,s);
                removedIndex = removedPointMatrix(:,s);

                tempMatrix = zeros(originalHeight,1);
                for ss = 1:(rd -1)
                    tempMatrix(removedIndex(ss,1),1) = removedIndex(ss,1);
                end
                [rr, ~] = find(tempMatrix==0);
                trueIndex = rr(tempIndex);

                
                removedPointMatrix(rd,s) = trueIndex;   
            end
        end
        energyResult = cumulativEnergy;
        % generate new image
        newImage = zeros(row-1,column,3);
        for dimension = 1:3
            for i = 1:column
                temp = output(:,i,dimension);
                temp(toRemoveList(1,i))=[];
                newImage(:,i,dimension) = temp;                    
            end
        end
        output = uint8(newImage);
    end
    % generate the output image with seams
    for i = 1:originalWidth
        for j = 1:numPixels
            outputWithSeams(removedPointMatrix(j,i),i,:) = [255,0,0];
        end
    end
    outputWithSeams = uint8(outputWithSeams);
    output = uint8(output);
end