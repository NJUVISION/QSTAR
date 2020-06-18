%Date 2020.6.17
%Author: Yu Meng (Any question, please contact:mengyu@smail.nju.edu.cn)
%Affiliation: Nanjing University

function [saliency_vector] = saliency_compute(intput_path,col)%输入 saliency map 的路径， viewport的宽
input_img = imread(intput_path);
%input_img = rgb2gray(input_img);
saliency_sum = sum(input_img);
saliency_sum = saliency_sum ./max(saliency_sum);
len = length(saliency_sum);

target = [saliency_sum(len - col/2 -1:len),  saliency_sum ,saliency_sum(1:col)];  
saliency_vector = zeros(1,len);

for i = 1 : len
    saliency_vector(i) = sum(target(i : i + col));
end
saliency_vector = saliency_vector./max(saliency_vector);

