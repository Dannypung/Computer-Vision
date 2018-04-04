function [labelIm] = quantizeFeats(featIm, meanFeats)
    [row,column,~] = size(featIm);
    labelIm = zeros(row,column);
    % use dist2 function to calculate distances
    for r = 1:row
        for c = 1:column
            disVector = dist2(meanFeats,permute(featIm(r,c,:),[1 3 2]));
            [~, minRowIndex] = min(disVector);
            % label Im
            labelIm(r,c) = minRowIndex;
        end
    end    
end