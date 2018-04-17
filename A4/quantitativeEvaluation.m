basedir = 'v45q002/data/';

topK = 5;

typenames = {'video_frames', 'print', 'book_covers', 'landmarks'};

queryfilenames = {'5800','iPhone','N97','N900';...
                   'Canon','Droid','E63','Palm';...
                   '5800','Canon','Droid','iPhone';...
                   'Query','Null','Null','Null'};
typeTotal = [0,0,0,0];
typeCorrent5 = [0,0,0,0];
typeCorrent3 = [0,0,0,0];
typeCorrent1 = [0,0,0,0];

load('variables.mat','refFrames' ,'membership', 'means', 'refPath');

uniquePath = unique(refPath);
     
referenceHistogram = zeros(size(uniquePath,2),size(means,2));
     
for i=1:length(uniquePath)
    temp = membership(find(contains(refPath,uniquePath{i})));
    [a,~]= hist(temp,1:size(means,2));
    referenceHistogram(i,:) = a;
end
save('referenceHistogram.mat','referenceHistogram');     

for i=1:size(typenames,2)
    for j =1:size(queryfilenames,2)
        
        if contains(queryfilenames{i,j},'Null') == 0
                        
            topDir = [basedir typenames{i} '/' queryfilenames{i,j}];
            %disp(topDir);
            refimnames = dir([topDir '/*.jpg']);
            typeTotal(i) = length(refimnames) + typeTotal(i); 
            %disp(length(refimnames));
            for r=1:length(refimnames)
                queryPath = [topDir '/' refimnames(r).name];
                correctPath = strrep(queryPath,queryfilenames{i,j},'/Reference');
                %disp(queryPath);
                %disp(correctPath);
                cellReturned = bagOfWordsQueries(queryPath, referenceHistogram, uniquePath, means, topK);
                if any(strcmp(cellReturned,correctPath))
                    typeCorrent5(i) = typeCorrent5(i) + 1;
                end
                if any(strcmp(cellReturned(1:3),correctPath))
                    typeCorrent3(i) = typeCorrent3(i) + 1;
                end
                if any(strcmp(cellReturned(1),correctPath))
                    typeCorrent1(i) = typeCorrent1(i) + 1;
                end
            end
            
        end
        
    end
    
end
A5 = 100*typeCorrent5./typeTotal;
A3 = 100*typeCorrent3./typeTotal;
A1 = 100*typeCorrent1./typeTotal;

fprintf('\tvideo_frames\tprint\tbook_covers\tlandmarks\n');
fprintf('top1\t%.2f%%\t\t%.2f%%\t%.2f%%\t\t%.2f%%\n',A1(1),A1(2),A1(3),A1(4));
fprintf('top3\t%.2f%%\t\t%.2f%%\t%.2f%%\t\t%.2f%%\n',A3(1),A3(2),A3(3),A3(4));
fprintf('top5\t%.2f%%\t\t%.2f%%\t%.2f%%\t\t%.2f%%\n',A5(1),A5(2),A5(3),A5(4));

