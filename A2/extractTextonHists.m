function [featIm] = extractTextonHists(origIm, bank, textons, winSize)
    tempImFeature = zeros(size(origIm,1),size(origIm,2),size(bank,3));
    % use filter bank to generate d space matrix
    for i = 1:size(bank,3)
        tempImFeature(:,:,i) = imfilter(double(origIm),bank(:,:,i),'replicate');
    end
    % label the features
    labelResult = quantizeFeats(tempImFeature,textons);
    featIm = zeros(size(origIm,1),size(origIm,2),size(textons,1));
    for i = 1:size(labelResult,1)
        for j = 1:size(labelResult,2)
            startx = j - winSize;
            endx = j + winSize;
            starty = i - winSize;
            endy = i + winSize;
            tempHist = zeros(1,1,size(textons,1));
            if startx < 1
                startx = 1;
            end
            if starty < 1
                starty = 1;
            end
            if endx > size(labelResult,2)
                endx = size(labelResult,2);
            end
            if endy > size(labelResult,1)
                endy = size(labelResult,1);
            end
            for k = startx:endx
                for l = starty:endy
                    % generate histgram for current pixel
                    tempHist(1,1,labelResult(l,k)) = tempHist(1,1,labelResult(l,k)) + 1;
                end
            end
            % update histgram to output
            featIm(i,j,:) = tempHist;
        end
    end
end
