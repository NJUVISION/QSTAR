%created by Mengyu 2020.2.25
%Used for getting the viewport content based on the input viewport center coordinates, based on FFMPEG processing

function [viewport_name] = viewport_extract(viewport_location, YUV_name, col, row, vcol, vrow)

name = strsplit(YUV_name,'_');

%Cut the entire video into 6 parts.
%If you need calculate the video at other size, the parameters in cmd
%should be changed.
for i = 1:6
    temp_name = [num2str(i),'.mp4'];
    start_location = (i-1)*vcol/2;
    %cmd = sprintf('ffmpeg -s %dx%d -r 30 -pix_fmt yuv420p -i %s -vf crop=%d:%d:%d:0 -crf 0 -s %dx%d %s',col, row,YUV_name,vcol/2,row,start_location,vcol/2, row,temp_name);
    cmd = sprintf('ffmpeg -i %s -vf crop=%d:%d:%d:0 -crf 0 -s %dx%d %s',YUV_name,vcol/2,row,start_location,vcol/2, row,temp_name);
    unix(cmd);

end
%拼接
unix('ffmpeg -i 6.mp4 -i 1.mp4  -filter_complex  "[0:v]pad=iw*2:ih[a]; [a][1:v]overlay=w" -crf 0 61.mp4');%61
delete('1.mp4');
delete('6.mp4');

unix('ffmpeg -i 2.mp4 -i 3.mp4  -filter_complex  "[0:v]pad=iw*2:ih[a]; [a][1:v]overlay=w" -crf 0 23.mp4');%23
delete('2.mp4');
delete('3.mp4');

unix('ffmpeg -i 61.mp4 -i 23.mp4  -filter_complex  "[0:v]pad=iw*2:ih[a]; [a][1:v]overlay=w" -crf 0 6123.mp4');%6123
delete('23.mp4');

unix('ffmpeg -i 4.mp4 -i 5.mp4  -filter_complex  "[0:v]pad=iw*2:ih[a]; [a][1:v]overlay=w" -crf 0 45.mp4');%45
delete('5.mp4');
delete('4.mp4');

unix('ffmpeg -i 45.mp4 -i 61.mp4  -filter_complex  "[0:v]pad=iw*2:ih[a]; [a][1:v]overlay=w" -crf 0 4561.mp4');%4561
delete('45.mp4');
delete('61.mp4');
unix('ffmpeg -i 6123.mp4 -i 4561.mp4  -filter_complex  "[0:v]pad=iw*2:ih[a]; [a][1:v]overlay=w" -crf 0  final.mp4');%6final
delete('6123.mp4');
delete('4561.mp4');
%转YUV
% unix('ffmpeg -i final.mp4 -crf 0 -pix_fmt yuv420p final.yuv');
% delete('final.mp4');

%提取viewport
viewport_name = [];
len = length(viewport_location);

for i = 1: len
    temp_name = [name,'_viewport',num2str(i),'.yuv'];
    viewport_name = [viewport_name; temp_name];
    cmd = sprintf('ffmpeg -i final.mp4 -vf crop=%d:%d:%d:%d -crf 0 -pix_fmt yuv420p -s %dx%d %s',vcol,vrow,viewport_location(i),row*0.25,vcol,vrow,cell2mat(temp_name));
    unix(cmd);
end

delete('final.mp4');

    
    



