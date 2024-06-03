% membuat histogram template

template_img = imread('OD/drishtiGS_032_ODAvgBoundary_OD_img.png');

%downsampling
factor = 6;
down_binary = imresize(template_img, 1/factor, 'bicubic');

%figure;
%imshow(down_bicubic);
%figure;
%imshow(down_binary);

% median filter
%h = fspecial('average', kernel_filter);

%R_average = imfilter(R, h);
%G_average = imfilter(G, h);
%B_average = imfilter(B, h);



%rekonstruksi ulang
%image_filtered = cat(3, R_average, G_average, B_average)

%figure;
%imshow(image_filtered);

% Baca citra biner ground truth dan pastikan tipe datanya logical
%binary_image = logical(imread('training_binary\drishtiGS_032_CupAvgBoundary_OC_img.png'));
binary_template = logical(down_binary);

% Temukan bounding box dari citra biner ground truth
stats = regionprops(binary_template, 'BoundingBox');
boundingBox = round(stats.BoundingBox);

% Potong citra retina sesuai dengan bounding box
cropped_image = imcrop(binary_template, boundingBox);

figure;
%imshow(binary_image);
imshow(cropped_image);


save('image_matching_template', 'cropped_image');
