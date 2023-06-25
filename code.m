% Original image is read and transformed to grayscale.
original_img = rgb2gray(imread("otter.png", "png"));
%imshow(original_img);

% Dimensions of the original image.
original_height = size(original_img, 1);
original_width = size(original_img, 2);

% Downsampling of the original image.
% Selection is made with odd numbered rows and columns since selection is
% started from index 1 and incremented by 2 for both columns and rows. (This
% is a requirement that is stated in the homework description.)
downsampled_img = original_img(1:2:original_height,1:2:original_width);

% 4 Downsampled copies is concetenated into one image
downsampled_copies = [downsampled_img downsampled_img ; downsampled_img downsampled_img];
%imshow(downsampled_copies);

% Changes selection style with respect to n.
% Image is shifted '8-n' bits and mask is used to retrieve n bit data.

n = 5;
if n == 2
    selection = 0b11111100; % selection of two bits.
    downsampled_copies_n = uint8(bitand(bitshift(downsampled_copies, -6), 0b11));
elseif n == 3
    selection = 0b11111000; % selection of three bits.
    downsampled_copies_n = uint8(bitand(bitshift(downsampled_copies, -5), 0b111));
elseif n == 4
    selection = 0b11110000; % selection of four bits.
    downsampled_copies_n = uint8(bitand(bitshift(downsampled_copies, -4), 0b1111));
elseif n == 5
    selection = 0b11100000; % selection of five bits.
    downsampled_copies_n = uint8(bitand(bitshift(downsampled_copies, -3), 0b11111));
end

transmitted_img = bitor(bitand(original_img, selection), downsampled_copies_n);
%imshow(transmitted_img);

start_row = 33; % My student number is 2019400033 thus, 33th row.
end_row = 62;
rng(1);

corrupted_transmitted_img = transmitted_img;

% Random rows are inserted to the image
for ind = start_row:end_row
    corrupted_transmitted_img(ind, :) = randi([0 256], 1, 512);
end

%imshow(corrupted_transmitted_img);

% 4th quadrant of the image is chosen as retrieval place.
recovered_img = corrupted_transmitted_img(257:end, 257:end);

% We have n bits, so they needed to be shifted '8-n' bits, to make them
% again most significant bits.
recovered_img = bitshift(recovered_img, 8-n);

recovered_height = size(recovered_img, 1);
recovered_width = size(recovered_img, 2);

% Recovered_img is upsampled as requested.
recovered_up = zeros(recovered_width * 2, recovered_height * 2, "uint8");
recovered_up(1:2:recovered_height*2, 1:2:recovered_width*2) = recovered_img;
recovered_up(2:2:recovered_height*2, 2:2:recovered_width*2) = recovered_img;
recovered_up(1:2:recovered_height*2, 2:2:recovered_width*2) = recovered_img;
recovered_up(2:2:recovered_height*2, 1:2:recovered_width*2) = recovered_img;

%imshow(recovered_up);

difference1 = double(original_img) - double(transmitted_img); % Step 2 of the algorithm.
difference2 = double(original_img) - double(corrupted_transmitted_img); % Corrupted image.
difference3 = double(original_img) - double(recovered_up); % Recovered image.

% Calculation of RMSE values. 
rmse1 = sqrt(mean(difference1(:).^2));
rmse2 = sqrt(mean(difference2(:).^2));
rmse3 = sqrt(mean(difference3(:).^2));





   


