clc; clear;
load lokalisasi_citra_od

%[X, MAP] = imread(cropped_image);
RGB = cropped_local;
%RGB = ind2rgb(X, MAP);

LAB = rgb2lab(RGB);

L = LAB(:, :, 1)/100;

L = adapthisteq(L, 'NumTiles', [8 8], 'ClipLimit', 0.01);
LAB(:, :, 1) = L*100;

J = lab2rgb(LAB);
J_green = J(:, :, 2);

figure;
imshow(J);
figure;
imshow(J_green);

R = J(:, :, 1);
G = J(:, :, 2);
B = J(:, :, 3);

kernel = [3 3];

%R_median = medfilt2(R, kernel);
%G_median = medfilt2(G, kernel);
%B_median = medfilt2(B, kernel);

h = fspecial('average', kernel);

R_avg = imfilter(R, h);
G_avg = imfilter(G, h);
B_avg = imfilter(B, h);

filtered_img = cat(3, R_avg, G_avg, B_avg);
filtered_G = filtered_img(:, :, 2);

figure;
imshow(filtered_G);

%filtered_img_gray = rgb2gray(filtered_img);

%figure;
%imshow(filtered_img_gray);
%figure;
%imhist(filtered_G);

%mean_img = mean2(filtered_G);
%std_img = std2(filtered_G);

%x = 0.001;
%Y = mean_img + (x*std_img);
%threshold_img = filtered_G > Y;


threshold_img = zeros(size(filtered_G));
threshold_img(filtered_G < 0.001) = 1;

figure;
imshow(threshold_img);

%se = strel('disk', 5);
%opened_img = imopen(threshold_img, se);
%figure;
%imshow(opened_img);


%% inpainting image
n = 100;
padded_mask = padarray(threshold_img, [floor(n/2) floor(n/2)], 'both');

for i = 1:size(RGB, 1)
    for j = 1:size(RGB, 2);
        if threshold_img(i, j) == 1
            if i+n-1 <= size(RGB, 1) && j+n-1 <= size(RGB, 2);
                for k = 1:3
                    neighborhood = RGB(i:i+n-1, j:j+n-1, k);
                    non_vessel = neighborhood(padded_mask(i:i+n-1, j:j+n-1) == 0);
                    RGB(i, j, k) = median(non_vessel);
                end
            end
        end 
    end
end

figure;
imshow(RGB);

N = 6;
R_smooth_img = medfilt2(RGB(:, :, 1), [N N]);
G_smooth_img = medfilt2(RGB(:, :, 2), [N N]);
B_smooth_img = medfilt2(RGB(:, :, 3), [N N]);

smooth_img = cat(3, R_smooth_img, G_smooth_img, B_smooth_img);

figure;
imshow(smooth_img);

gray_img = rgb2gray(smooth_img);

%equal_img = histeq(gray_img);
%figure;
%imshow(equal_img);

figure;
imshow(gray_img);

blurred_img = imgaussfilt(gray_img, 2);

figure;
imshow(blurred_img);

%% segmentasi

[idx, centers] = kmeans(double(blurred_img(:)), 4);
image_kmeans = reshape(idx, size(blurred_img));

[sorted_centers, sorted_idx] = sort(centers);
first_label = sorted_idx(end);
second_label = sorted_idx(end-1);

optic_cup = zeros(size(blurred_img));
optic_cup(image_kmeans == first_label) = 255;

figure;
imshow(optic_cup);

se = strel('disk', 25);
dilated_img = imdilate(optic_cup, se);

figure;
imshow(dilated_img);


%% make circle

stats = regionprops(dilated_img, 'Centroid', 'EquivDiameter', 'Area');

[~, idx] = max([stats.Area]);

centroid = stats(idx).Centroid;
radius = stats(idx).EquivDiameter / 2;

%blank_img = zeros(size(dilated_img));

%figure;
%imshow(blank_img, 'InitialMagnification', 'fit');
%hold on;
%rectangle('Position',[centroid(1) - radius, centroid(2) - radius, 2*radius, 2*radius], ...
%    'Curvature', [1 1], ...
%    'FaceColor', 'w');
%hold off;

%frame = getframe(gca);
%captured_oc = frame2im(frame);

%figure;
%imshow(captured_oc);

mask = false(size(dilated_img));

[columns_img, rows_img] = meshgrid(1:size(dilated_img, 2), 1:size(dilated_img, 1));
circlePixels = (rows_img - centroid(2)).^2 + (columns_img - centroid(1)).^2 <= radius.^2;

mask(circlePixels) = true;

captured_oc = dilated_img;

captured_oc(mask) = 1;
captured_oc(~mask) = 0;

figure;
imshow(captured_oc);






