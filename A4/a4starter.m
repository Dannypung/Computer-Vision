%%% Skeleton script for 378H assignment 4 to illustrate loading 
%%% data and displaying matches.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Kristen Grauman, UT-Austin
%%% Using the VLFeat library.  http://www.vlfeat.org.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ****Be sure to add vl feats to the search path: ****
% >>> run('VLFEATROOT/toolbox/vl_setup');
% where VLFEATROOT is the directory where the code was downloaded.
% See http://www.vlfeat.org/install-matlab.html
fprintf('Be sure to add VLFeat path.\n');


clear;
close all;


% Some flags
DISPLAY_PATCHES = 1;
SHOW_ALL_MATCHES_AT_ONCE = 1;

% Constants
N = 25;  % how many SIFT features to display for visualization of features

% Data directories

basedir = 'v45q002/data/';


typenames = {'video_frames', 'print', 'book_covers', 'landmarks'};


% loop over the genres of images
for t = 1:length(typenames)

  topdir = [basedir typenames{t} '/'];  
  refimnames = dir([topdir '/Reference/*.jpg']);

  fprintf('There are %d reference images for object type %s\n', ...
          length(refimnames), typenames{t});

  for r=1:length(refimnames)

    % read in a reference (database) image
    refim = im2single(rgb2gray(imread([topdir '/Reference/' refimnames(r).name])));
    
    
    % read in its SIFT descriptors (pre-computed) from the mat file
    load([topdir '/Reference/' refimnames(r).name '.sift.mat'], 'frames', ...
         'desc');

    refFrames = frames;
    refDesc = desc;

    camnames = dir(topdir);

    % read in the corresponding mobile phone image from each camera
    % type.  each mobile phone has a query image for this reference
    % image.  

    % Important: Note that this skeleton is only looping over and attempting to
    % compute matches between true positive matches (i.e., the right
    % reference and the right queries).  Your actual system will
    % treat this as unknown, evaluating the quality of
    % matches/similarity between the query and ALL reference images.

    for c = 3:length(camnames) % starting at 3 because 1 and
                                      % 2 are . and .. directories

      if(~isequal(camnames(c).name, 'Reference')&&~isequal(camnames(c).name, '.DS_Store')) % don't use the
                                                  % reference
                                                  % images as queries
      
        % get the next phone image query that goes with the current 
        % reference image

        phoneim = im2single(rgb2gray(imread([topdir '/' camnames(c).name ...
                            '/' refimnames(r).name])));
        
        % get its precomputed SIFT descriptors from mat file
        load([topdir '/' camnames(c).name '/' refimnames(r).name ...
              '.sift.mat'], 'frames', 'desc');
        
        phoneFrames = frames;
        phoneDesc = desc;
        
      
        % Precomputed SIFT features format: 
        %
        % 'frames' refers to a matrix of "frames".  It is 4 x n, where n is the number
        % of SIFT features detected.  Thus, each column refers to one SIFT descriptor.  
        % The first row gives the x positions, second row gives the y positions, 
        % third row gives the scales, fourth row gives the orientations.  You will
        % need the x and y positions for this assignment.
        %
        % 'desc' refers to a matrix of "descriptors".  It is 128 x n.  Each column 
        % is a 128-dimensional SIFT descriptor.
        %
        % See VLFeats for more details on the contents of the frames and
        % descriptors.
        

        % count number of descriptors found in the two images
        refN = size(refDesc,2);
        phoneN = size(phoneDesc,2);
        
        fprintf('Reference image has %d descriptors, current phone image %d has %d descriptors\n', refN, c, phoneN);

        % Example to show how to pull out a specified patch from
        % the image.  Here we extract the image patch for the 1st
        % descriptor in the reference image. 
        refPatch = getPatchFromSIFTParameters(refFrames(1:2,1), ...
                                              refFrames(3,1), refFrames(4,1), ...
                                              refim);
 

        % Show a random subset of the SIFT patches for the two images
        if(DISPLAY_PATCHES)
          
          displayDetectedSIFTFeatures(refim, phoneim, refFrames, phoneFrames, refDesc, phoneDesc, N);
                          
          fprintf('Showing a random sample of the sift descriptors.  Type dbcont to continue.\n');
          keyboard;
        end

    
    
        % Simple example just to illustrate extraction of data and
        % display functions
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Find the nearest neighbor descriptor in phone im for some random descriptor
        % from ref im:
      
        % Extract a random descriptor (just for illustration)
        randomIndices = randperm(refN);
        aSingleSIFTDescriptor = refDesc(:,randomIndices(1));
      
        % Compute the Euclidean distance between that descriptor
        % and all descriptors in phone image.
        % This function is an efficient implementation to compute all pairwise Euclidean
        % distances between two sets of vectors.  See the header.
        dists = dist2(double(aSingleSIFTDescriptor)', double(phoneDesc)');
    
        % Sort those distances
        [sortedDists, sortedIndices] = sort(dists, 'ascend');
        
        % Take the first neighbor as a candidate match.
        % Record the match as a column in the matrix 'matchMatrix',
        % where the first row gives the index of the feature from the first
        % image, the second row gives the index of the feature matched to it in
        % the second image, and the third row records the distance between
        % them.
        matchMatrix = [randomIndices(1); sortedIndices(1); sortedDists(1)];
      
      
        % We have just one match here, but to use the display functions below, you
        % can simply expand this matrix to include one column for each match.
        numMatches = size(matchMatrix,2);
    
        
        % Display the matched patch
        clf;
        showMatchingPatches(matchMatrix, refDesc, phoneDesc, refFrames, phoneFrames, refim, phoneim, SHOW_ALL_MATCHES_AT_ONCE);
        fprintf('Showing an example of a nearest neighbor patch match.  Type dbcont to continue.\n');
        keyboard;
    
        
        % An alternate display - show lines connecting the matches (no patches)
        % Allows you to visualize the smoothness of the connections without
        % clutter of the patches.
        clf;
        showLinesBetweenMatches(refim, phoneim, refFrames, phoneFrames, ...
                                matchMatrix);
        fprintf('Showing the matches with lines connecting.  Type dbcont to continue.\n');
        keyboard;
      
      end
    end
    
  end
end

