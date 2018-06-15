%frequency video writer
v=VideoWriter('v1.avi');
v.FrameRate=25;
open(v);
for i=1:200
   frame=imread(['freq',num2str(i),'.jpg']);
   writeVideo(v,frame);
end
close(v);