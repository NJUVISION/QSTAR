%Date 2020.6.17
%Author: Yu Meng (Any question, please contact:mengyu@smail.nju.edu.cn)
%Affiliation: Nanjing University
%Before running this code, please ensure that the environment variables of
%your computer include the FFmepg.
%This version is designed for video size at 3840x1920,If you need calculate
%the video at other size, the parameters in this file and in
%viewport_extract.m should be changed.

clc;
clear all;

%input parameters
Q = 27; % QP
qp = 2^((Q - 4)/6);
qp = 8/qp;% normalized q with QP = 22
S = 0.8; %normalized SR
T = 0.5; %normalized TR


%viewport size
v_width = 1280;
v_height = 960;
%video size
width = 3840;
height = 1920;

frame_num = 300;

saliecny_res = saliency_compute('Train.jpg', v_width);% saliency input
[viewport_location, weight] = viewport_compute(saliecny_res); % locate the viewport
viewport_name = viewport_extract(viewport_location, 'Train.mp4', width,height,v_width,v_height);%viewport video extraction based on FFmpeg
v_cnt = length(viewport_name(:,1)); % get the total number of viewports
v_mos = zeros(v_cnt,1);

for v = 1:v_cnt
    y_name = cell2mat(viewport_name(v,:));
    Y = fopen(y_name ,'rb');% open the YUV file of viewport
    q_pam = QSTAR_plus_pam(Y ,frame_num,v_width,v_height);% get the model parameters
    fclose(Y);
    delete(y_name);
    v_mos(v) = QSTAR_plus(q_pam, S,qp ,T,Q);
end
weight = weight./sum(weight);

w_mos = sum(weight* v_mos);

%get the QS quality
a = 0.8670;
b = 0.3427;
c = 0.5791;
d = 0.6652;

% get the predited result
res = (1 - d)*((a^(1 - S)) * (b^(1 - T)) * (c^(1-qp))) + d*w_mos;