function showLinesBetweenMatches(im1, im2, f1, f2, matches)
% displays all the matches with lines between the matched points

% M is 3 x n matchMatrix containing n matches.  
% -- first row: indices in im1
% -- second row: indices in im2 that they matched to
% -- third row: distances

% f1, f2 are SIFT frames from VLFeat
% im1 and im2 are the original images


dh1 = max(size(im2,1)-size(im1,1),0) ;
dh2 = max(size(im1,1)-size(im2,1),0) ;

clf;
imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]) ;
colormap gray;
o = size(im1,2) ;
line([f1(1,matches(1,:));f2(1,matches(2,:))+o], ...
     [f1(2,matches(1,:));f2(2,matches(2,:))]) ;

axis image off ;

drawnow ;