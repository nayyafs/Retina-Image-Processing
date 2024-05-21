%DATA TRAINING

% Baca citra biner ground truth dan pastikan tipe datanya logical
citraBinerGT = logical(imread('drishtiGS_017_ODAvgBoundary_OD_img.png'));

citraRetina = imread('drishtiGS_017.png');

% Temukan bounding box dari citra biner ground truth
stats = regionprops(citraBinerGT, 'BoundingBox');
boundingBox = round(stats.BoundingBox);

% Potong citra retina sesuai dengan bounding box
citraRetinaCropped = imcrop(citraRetina, boundingBox);

% Potong citra biner ground truth sesuai dengan bounding box
citraBinerGTCropped = imcrop(citraBinerGT, boundingBox);

% Masking kanal merah dan hijau dari citra retina yang sudah dipotong
citraMaskedRed = citraRetinaCropped(:,:,1) .* uint8(citraBinerGTCropped);
citraMaskedGreen = citraRetinaCropped(:,:,2) .* uint8(citraBinerGTCropped);

% Tampilkan gambar kanal merah setelah di-mask dengan bounding box
figure;
subplot(2,2,1);
imshow(citraMaskedRed);
hold on;
rectangle('Position', [1, 1, size(citraMaskedRed, 2), size(citraMaskedRed, 1)], 'EdgeColor', 'r', 'LineWidth', 2);
hold off;
title('Kanal Merah dengan Bounding Box Optik Disk');

% Tampilkan histogram untuk kanal merah yang telah dimasking
subplot(2,2,2);
histogram(citraMaskedRed(citraBinerGTCropped), 'BinLimits', [0, 255], 'BinWidth', 1);
title('Histogram Kanal Merah');

% Tampilkan gambar kanal hijau setelah di-mask dengan bounding box
subplot(2,2,3);
imshow(citraMaskedGreen);
hold on;
rectangle('Position', [1, 1, size(citraMaskedGreen, 2), size(citraMaskedGreen, 1)], 'EdgeColor', 'g', 'LineWidth', 2);
hold off;
title('Kanal Hijau dengan Bounding Box Optik Disk');

% Tampilkan histogram untuk kanal hijau yang telah dimasking
subplot(2,2,4);
histogram(citraMaskedGreen(citraBinerGTCropped), 'BinLimits', [0, 255], 'BinWidth', 1);
title('Histogram Kanal Hijau');

% Hitung dan tampilkan ukuran lebar dan panjang bounding box
lebar = boundingBox(3);
panjang = boundingBox(4);
fprintf('Ukuran lebar bounding box: %d\n', lebar);
fprintf('Ukuran panjang bounding box: %d\n', panjang);
