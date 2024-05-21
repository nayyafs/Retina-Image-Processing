myFolder = 'C:\Users\Firda Sabrina\Documents\Kuli-Ah\TUGAS KULIAH\TUGAS SEM 6\Pengolahan Citra Biomedika\TUBES\MATLAB';

% check if the folder exists
if ~isfolder(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n %s', myFolder);
    uiwait(warndlg(errorMessage));
    return;
end

% get all the files
filePattern = fullfile(myFolder, '*.png');
theFiles = dir(filePattern);

fileID = fopen('output.txt', 'w');
csvData = [];

for k = 1:length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);

    % load image 
    image = imread(fullFileName);

    % calculate area of OC
    oc_area = nnz(image);
    fprintf('Area: %d\n', oc_area);
    %imshow(image);
    % determine the bounding box

    % Label connected components343
    labeled_image = bwlabel(image);
    stat = regionprops(labeled_image, 'BoundingBox');

    % calculate bounding box
    b_box = stat.BoundingBox(1,:);

    % Draw the bounding box on the original image
    figure, imshow(image);
    hold on;
    rectangle('Position', [b_box(1),b_box(2),b_box(3),b_box(4)], 'EdgeColor','r','LineWidth',2);
    hold off;

    img_width = b_box(3);
    img_heigth = b_box(4);

    center_x = round(b_box(1) + b_box(3)/2);
    center_y = round(b_box(2) + b_box(4)/2);

    fprintf('Row: %d\n', img_heigth);
    fprintf('Column: %d\n', img_width);

    fprintf('Koordinat center row: %d\n', center_y);
    fprintf('Koordinat center column: %d\n', center_x);

    fprintf(fileID, 'Row: %d\n', img_heigth);
    fprintf(fileID, 'Column: %d\n', img_width);
    fprintf(fileID, 'Koordinat center row: %d\n', center_y);
    fprintf(fileID, 'Koordinat center column: %d\n', center_x);

    % Add data to csvData
    csvData = [csvData; oc_area, img_heigth, img_width, center_y, center_x];

end

fclose(fileID);
writematrix(csvData, 'output.csv');
