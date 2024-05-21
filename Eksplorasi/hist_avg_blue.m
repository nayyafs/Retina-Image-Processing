image_dir = 'C:\Users\Firda Sabrina\Documents\Kuli-Ah\TUGAS KULIAH\TUGAS SEM 6\Pengolahan Citra Biomedika\TUBES\MATLAB\testing';

image_files = dir(fullfile(image_dir, '*.png'));

sum_histogram = zeros(256, 1);

for idx = 1:length(image_files)
    fullFileName = fullfile(image_files(idx).folder, image_files(idx).name);

    img = imread(fullFileName);

    blueChannel = rgb_image(:,:,3);
    [counts, ~] = imhist(blueChannel);
    sum_histogram = sum_histogram + counts;
end

%calculate avg histogram
average_hist = sum_histogram/length(image_files);
figure;
bar(average_hist);
title("Average of Blue Channel");