%Date 2020.6.17
%Author: Yu Meng (Any question, please contact:mengyu@smail.nju.edu.cn)
%Affiliation: Nanjing University

function [viewport_location,weight] = viewport_compute(saliency_vector)%输入 saliency map纵向和的vector
Lmax = diff(sign(diff(saliency_vector)))== -2;
Lmax = [false, Lmax, false];
len = length(saliency_vector);
t = 0:len-1;
tmax = t(Lmax);
vmax = saliency_vector(Lmax);
if length(vmax) == 0
    [vmax,tmax] = max(saliency_vector);
end
plot(t,saliency_vector);
hold on;
plot(tmax,vmax,'r+');
viewport_location = tmax;
weight = vmax;
