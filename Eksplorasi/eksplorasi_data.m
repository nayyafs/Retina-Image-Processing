%% load image 
image = imread("drishtiGS_081_CupAvgBoundary_OC_img.png");

%% calculate area of OC
oc_area = nnz(image);
fprintf('Area: %d\n', oc_area);
%imshow(image);
%% determine the bounding box

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

width = b_box(3);
heigth = b_box(4);

center_x = round(b_box(1) + b_box(3)/2);
center_y = round(b_box(2) + b_box(4)/2);

fprintf('Row: %d\n', heigth);
fprintf('Column: %d\n', width);

fprintf('Koordinat center row: %d\n', center_y);
fprintf('Koordinat center column: %d\n', center_x);
