clear all;close all;
image=imread('F:\cvcvideoclinicdbtestpart1\1_cropped_image\1-4.png');
% z=input('Enter the z value:'); test
% alpha=input('Enter the alpha value:');
% Beta=input('Enter the Beta value:');
% sigma=input('Enter the sigma value:');
[x y z]=size(image);
image_r=image(:,:,1);
image_g=image(:,:,2);
image_b=image(:,:,3);
image_r_normalized=im2double(image_r);
image_g_normalized=im2double(image_g);
image_b_normalized=im2double(image_b);
%% TSE
%Red_plane
blur_image_r=filter2(fspecial('average',3),image_r_normalized);
final_image_r=image_r_normalized-blur_image_r;
sum_image_r=sum(image_r_normalized(:))./(x.*y);
sharpening_factor=10.*sum_image_r;
sharpened_image_r=image_r_normalized+sharpening_factor.*final_image_r;
%figure,imshow(uint8(255*sharpened_image_r))
%green_plane
blur_image_g=filter2(fspecial('average',3),image_g_normalized);
final_image_g=image_g_normalized-blur_image_g;
sum_image_g=sum(image_g_normalized(:))./(x.*y);
sharpening_factor=10.*sum_image_g;
sharpened_image_g=image_g_normalized+sharpening_factor.*final_image_g;
%figure,imshow(uint8(255*sharpened_image_r))
% blue_plane
blur_image_b=filter2(fspecial('average',3),image_b_normalized);
final_image_b=image_b_normalized-blur_image_b;
sum_image_b=sum(image_b_normalized(:))./(x.*y);
sharpening_factor=10.*sum_image_b;
sharpened_image_b=image_b_normalized+sharpening_factor.*final_image_b;
%figure,imshow(uint8(255*sharpened_image_r))
final_image=cat(3,sharpened_image_r,sharpened_image_g,sharpened_image_b);
figure,imshow(image),title('Original_image')
figure,imshow(final_image),title('Tissue and surface enhancement')
%% MLE
cutoff=0.2+((1./2).*(sum(sharpened_image_r(:)))./(x.*y));
gain=10.*log(23./10).*(sum(sharpened_image_r(:)))./(x.*y);
for i=1:x
    for j=1:y
        denominator=exp(gain.*(cutoff-sharpened_image_r(i,j)));
        MLE(i,j)=1./(1+denominator);
    end
end
MLE_final=cat(3,MLE,sharpened_image_g,sharpened_image_b);
figure,imshow(MLE_final),title('Mucosa layer enhancement')
%% Color_tone_enhancement
MLE_r=histeq(imcomplement(MLE));
MLE_g=histeq(imcomplement(sharpened_image_g));
MLE_b=histeq(imcomplement(sharpened_image_b));
triscan_image_final=cat(3,MLE_r,MLE_g,MLE_b);
figure,imshow(triscan_image_final),title('Tri-scan')




