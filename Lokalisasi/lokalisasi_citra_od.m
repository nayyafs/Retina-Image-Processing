load image_matching_template

citra_retina = imread('training\drishtiGS_042.png');

%downsampling
factor = 6;
down_bicubic = imresize(citra_retina, 1/factor, 'bicubic');

se = strel('disk', 5);
opened_image = imopen(down_bicubic, se);

%figure;
%imshow(down_bicubic);

% separate RGB
R = opened_image(:, :, 1);
G = opened_image(:, :, 2);
B = opened_image(:, :, 3);


%median filter
kernel_filter = [6 6];

R_median = medfilt2(R, kernel_filter);
G_median = medfilt2(G, kernel_filter);
B_median = medfilt2(B, kernel_filter);

image_filtered = cat(3, R_median, G_median, B_median);

%gray_image = rgb2gray(image_filtered);
red_filter = image_filtered(:, :, 1);

figure;
imshow(red_filter);
%green_channel = image_filtered(:, :, 2);
%threshold = 150;

mean_val= mean2(red_filter);
std_val=std2(red_filter);

k = 1.5;

T= mean_val+(k*std_val);

red_channel = red_filter > T;

figure;
imshow(red_channel);


%red_channel = red_filter;
%red_channel(red_channel <= threshold) = 0;

%level = graythresh(red_filter);
%red_channel = imbinarize(red_filter, level);

%red_channel(red_channel > threshold) = red_channel(red_channel > threshold) * 2;

% Ensure no values exceed the maximum
%red_channel(red_channel > 255) = 255;

% tentukan ROI
%roi_center = [1.2*size(gray_image, 2)/2, 1*size(image_filtered, 1)/2];
roi_center = [156, 96];
roi_size = [310, 200];

% hitung korelasi
roi_x_start =max(1, roi_center(1) - roi_size(1)/2);
roi_y_start = max(1, roi_center(2) - roi_size(1)/2);
roi_x_end = min(size(image_filtered, 2), roi_center(1)+roi_size(1)/2);
roi_y_end = min(size(image_filtered, 1), roi_center(2)+roi_size(2)/2);

%roi_retina = image_filtered(roi_y_start: roi_y_end, roi_x_start:roi_x_end);
roi_red = red_channel(roi_y_start:roi_y_end, roi_x_start:roi_x_end);
%roi_green = green_channel(roi_y_start: roi_y_end, roi_x_start:roi_x_end);

ncc_red = normxcorr2(cropped_image, roi_red);
%ncc_green = normxcorr2(G_crop, roi_green);

% lokasi NCC max
[~, imax_red] = max(abs(ncc_red(:)));
[y_peak_red, x_peak_red] = ind2sub(size(ncc_red), imax_red);
%[~, imax_green] = max(abs(ncc_green(:)));
%[y_peak_green, x_peak_green] = ind2sub(size(ncc_green), imax_green);

% offset ROI
% Tambahkan offset ROI ke koordinat lokasi Optic Disk
x_peak_red = x_peak_red + roi_x_start - 1;
y_peak_red = y_peak_red + roi_y_start - 1;
%x_peak_green = x_peak_green + roi_x_start - 1;
%y_peak_green = y_peak_green + roi_y_start - 1;

x_peak_red_upsampled = x_peak_red * factor;
y_peak_red_upsampled = y_peak_red * factor;
%x_peak_green_upsampled = x_peak_green * factor;
%y_peak_green_upsampled = y_peak_green * factor;

box_red = [x_peak_red-size(cropped_image, 2), y_peak_red-size(cropped_image, 1), size(cropped_image, 2), size(cropped_image, 1)];
%box_green = [x_peak_green-size(cropped_image(:, :, 2),2), y_peak_green-size(cropped_image(:, :, 2),1), size(cropped_image(:, :, 2),2), size(cropped_image(:, :, 2),1)];

box_red_upsampled = box_red * factor;
%box_green_upsampled = box_green * factor;

%x_peak_avg = (wr*x_peak_red + wg*x_peak_green)/(2);
%y_peak_avg = (vr*y_peak_red + vg*y_peak_green) /(2);

%x_peak_avg_upsampled = x_peak_avg * factor;
%y_peak_avg_upsampled = y_peak_avg * factor;

%box_avg = [x_peak_avg - size(cropped_image(:, :, 1), 2)/2, y_peak_avg - size(cropped_image(:, :, 1), 1)/2, size(cropped_image(:, :, 1), 2), size(cropped_image(:, :, 1), 1)];
%box_avg_upsampled = box_avg * factor;

center_x = box_red_upsampled(1) + box_red_upsampled(3)/2;
center_y = box_red_upsampled(2) + box_red_upsampled(4)/2;


figure;
imshow(citra_retina);
rectangle('Position', box_red_upsampled, 'EdgeColor', 'r', 'LineWidth', 2); % untuk kanal merah
%rectangle('Position', box_green_upsampled, 'EdgeColor', 'g', 'LineWidth', 2); % untuk kanal hijau
%rectangle('Position', box_avg_upsampled, 'EdgeColor', 'y', 'LineWidth', 2); % untuk kanal avg
hold on;
plot(center_x, center_y, 'k+', 'LineWidth', 0.5); 
hold off;
title('Lokalisasi Optic Disk');

cropped_local = imcrop(citra_retina, box_red_upsampled);
figure;
imshow(cropped_local);

save('lokalisasi_citra_od', 'cropped_local', 'box_red_upsampled', 'box_red');
