function showMatchingPatches(M, d1, d2, f1, f2, im1, im2, showall)
% displays SIFT matches either 
% one at a time and pausing after each (showall=0),
% or else all of them at once (showall=1).

% M is 3 x n matchMatrix containing n matches.  
% -- first row: indices in im1
% -- second row: indices in im2 that they matched to
% -- third row: distances

% d1, d2, f1, f2 are descriptors and frames from VLFeat
% im1 and im2 are the original images

if(showall)
    clf;
    subplot(1,2,1);
    imshow(im1);
    axis equal ; axis off ; axis tight ;
    hold on;
    subplot(1,2,2);
    imshow(im2);
    axis equal ; axis off ; axis tight ;
    hold on ;
end


for sel=1:size(M,2)
    
    if(~showall)
        clf;
        subplot(1,2,1);
        imshow(im1);
        axis equal ; axis off ; axis tight ;
    end
    
    subplot(1,2,1);
    hold on ;
    h3 = vl_plotsiftdescriptor(d1(:,M(1,sel)),f1(:,M(1,sel))) ;
    set(h3,'color','g','linewidth',1) ;
    
    if(~showall)
        subplot(1,2,2);
        imshow(im2);
        axis equal ; axis off ; axis tight ;
    end
    
    subplot(1,2,2);
    hold on ;
    h3 = vl_plotsiftdescriptor(d2(:,M(2,sel)),f2(:,M(2,sel))) ;
    set(h3,'color','g','linewidth',1) ;
    
    if(~showall)
        fprintf('Showing match %d of %d, distance=%f.  Press any key to see next one.\n', sel, size(M,2), M(3,sel));
        pause;
    end
end

if(showall)
    fprintf('Showing all %d matching patches.\n', size(M,2));
end