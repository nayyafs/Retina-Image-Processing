clc; clear;
load lokalisasi_citra_od

red_image = cropped_local(:, :, 1);

%figure;
%imshow(red_image);

kernel_filter = [10 10];

image_filtered = medfilt2(red_image, kernel_filter);

%figure;
%imshow(image_filtered);

se = strel('disk', 10);
image_open = imopen(image_filtered, se);

figure;
imshow(image_open);

se_2 = strel('disk', 10);
image_close = imclose(image_open, se_2);


kernel_filter_avg = [3 3];
h = fspecial('average', kernel_filter_avg);

image_avg = imfilter(image_close, h);


figure;
imshow(image_avg);

mean_val = mean2(image_avg);
std_val = std2(image_avg);

k = 0.2;
T = mean_val + (k*std_val);
BW = image_avg > T;


%figure;
%imshow(BW);

%% post processing
% Assume 'BW' is your binary image

% Compute the properties of the connected components in the image
stats = regionprops('table', BW, 'Centroid', 'MajorAxisLength', 'MinorAxisLength', 'Orientation');

% Get the properties of the largest connected component (assumed to be the optic disk)
[~, idx] = max(stats.MajorAxisLength);
props = stats(idx, :);
centroid = stats.Centroid;
major_axis = stats.MajorAxisLength;
minor_axis = stats.MinorAxisLength;

% Create a new figure
figure;

% Display the original image
imshow(BW);
hold on;

mask = false(size(BW));

% Plot the fitted ellipse
phi = linspace(0, 2*pi, 50);
cosphi = cos(phi);
sinphi = sin(phi);
xbar = props.Centroid(1);
ybar = props.Centroid(2);
a = props.MajorAxisLength/2;
b = props.MinorAxisLength/2;
theta = pi*props.Orientation/180;
R = [ cos(theta)   sin(theta)
     -sin(theta)   cos(theta)];
xy = [a*cosphi; b*sinphi];
xy = R*xy;
x = xy(1,:) + xbar;
y = xy(2,:) + ybar;
plot(x, y, 'r', 'LineWidth', 2);

%fill(x, y, 'w');
% Release the hold on the figure
hold off;

mask = poly2mask(x, y, size(BW, 1), size(BW, 2));

new_img = BW;
new_img(mask) = 1;
new_img(~mask) = 0;

figure;
imshow(new_img);












