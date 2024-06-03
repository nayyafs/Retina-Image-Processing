clc; clear;

load lokalisasi_citra_od;
load segmentasi_oc;

optical_cup = captured_oc;

reference_img = imread('training_binary\drishtiGS_040_CupAvgBoundary_OC_img.png');

cropped_ref = imcrop(reference_img, box_red_upsampled);

figure;
subplot(1, 2, 1);
imshow(optical_cup);
subplot(1, 2, 2);
imshow(cropped_ref);

mask1 = optical_cup > 0;
mask2 = cropped_ref > 0;
intersection = mask1 & mask2;
num_intersection = sum(intersection(:));

num_white_ref = sum(mask2(:));

false_pos = mask1 & ~mask2;
false_neg = ~mask1 & mask2;

percentage = (num_intersection/num_white_ref) * 100;
true_positive = sum(intersection(:));
false_positive = sum(false_pos(:));
false_negative = sum(false_neg(:));

f_score = true_positive/(true_positive+false_positive+false_negative);

fprintf('persentase OC = %d\n', percentage);
fprintf('TP = %d\n', true_positive);
fprintf('FP = %d\n', false_positive);
fprintf('FN = %d\n', false_negative);
fprintf('F score = %d\n', f_score);