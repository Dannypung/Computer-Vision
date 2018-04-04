function [colorLabelIm, textureLabelIm] = compareSegmentations(origIm,... 
bank, textons, winSize, numColorRegions, numTextureRegions)     
    
    [a, b, c] = size(origIm);
    reshapedIm = reshape(origIm, a*b, c);
    % generate colors k mean result
    colorFeature= kmeans(double(reshapedIm), numColorRegions);    
    colorLabelIm = reshape(colorFeature, a, b);
    
    
    % generate texture k mean result
    origIm = rgb2gray(origIm);
    textureHist = extractTextonHists(origIm, bank, textons, winSize);
    reshapedHist = reshape(textureHist, a*b, size(textons,1));
    textureFeature = kmeans(double(reshapedHist), numTextureRegions);
    textureLabelIm = reshape(textureFeature, a, b);

end