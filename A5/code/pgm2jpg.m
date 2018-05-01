
for i = 1:40
    additional_train_path_pos = ['../data/orl_faces/s' int2str(i)];
    image_files = dir( fullfile( additional_train_path_pos, '*.pgm') );
    disp(image_files);
    num_images = length(image_files);
    for j=1:num_images
        IM = imread([additional_train_path_pos '/' image_files(j).name]);
        IM = imresize(IM,[36 36]);
        newName = [int2str(i) '_' int2str(j) '.jpg'];
        imwrite( IM , newName);
    end
end