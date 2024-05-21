myFolder = 'C:\Users\Firda Sabrina\Documents\Kuli-Ah\TUGAS KULIAH\TUGAS SEM 6\Pengolahan Citra Biomedika\TUBES\MATLAB\training';
histogram_dir = 'C:\Users\Firda Sabrina\Documents\Kuli-Ah\TUGAS KULIAH\TUGAS SEM 6\Pengolahan Citra Biomedika\TUBES\MATLAB\training\green channel image';

%check if histogram_dir exist
if ~exist(histogram_dir, 'dir')
    mkdir(histogram_dir);
end

if ~isfolder(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
    uiwait(warndlg(errorMessage));
    return;
end

filePattern = fullfile(myFolder, '*.png');
theFiles = dir(filePattern);

for k = 1:length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);

    %RGB image
    rgb_image = imread(fullFileName);

   % green_image = rgb_image;
    greenChannel = rgb_image(:, :, 2);

    %create image only in red channel
    %green_image(:, :, 1) = 0; %red channel
    %green_image(:, :, 3) = 0; %blue channel

    figure;
    imshow(greenChannel);

    %get the image file name
    [~, name, ~] = fileparts(fullFileName);
    
    %save the histogram
    saveas(gcf, fullfile(histogram_dir, [name, '_green.png']));

    close(gcf);
end