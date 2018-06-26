%frequency video writer
v=VideoWriter('v5.avi');
v.FrameRate=30;
open(v);
for i=1:401
   frame=imread(['LIA',num2str(i),'.jpg']);
   writeVideo(v,frame);
end
close(v);