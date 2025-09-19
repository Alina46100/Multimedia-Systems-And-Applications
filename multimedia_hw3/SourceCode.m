input_image = imread('Histogram+Edge.bmp.crdownload');

if size(input_image, 3) == 3
    gray_image = rgb2gray(input_image);
else
    gray_image = input_image;
end

equalized_image = histeq(input_image);

original_histogram = imhist(input_image);

equalized_histogram = imhist(equalized_image);

edges = edge(gray_image, 'Canny');


figure;

subplot(3, 2, 1);
imshow(gray_image);
title('Original Image');

subplot(3, 2, 2);
imshow(equalized_image);
title('processed Image');

subplot(3, 2, 3);
bar(original_histogram);
title('Original Histogram');
xlim([0 255]);

subplot(3, 2, 4);
bar(equalized_histogram);
title('Equalized Histogram');
xlim([0 255]);

subplot(3, 2, 5);
imshow(edges);
title('Edge Detected Image');

% Save the equalized image and the edge-detected image
imwrite(equalized_image, 'processed_image.bmp');
imwrite(edges, 'edge_detected_image.bmp');
