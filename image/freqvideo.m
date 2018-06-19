%frequency video writer
v=VideoWriter('v1.avi');
v.FrameRate=60;
open(v);
for i=1:401
   frame=imread(['LIA',num2str(i),'.jpg']);
   writeVideo(v,frame);
end
close(v);