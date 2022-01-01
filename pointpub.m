function pointpub(x,y,z,i)
%rosinit('http://192.168.0.101:11311')
persistent chatpub
if isempty(chatpub)
    %rosinit('http://192.168.0.101:11311');
    chatpub = rospublisher('/point_raw','sensor_msgs/PointCloud');
end
s = size(x);
Length = s(1)*s(2);
msg = rosmessage('sensor_msgs/PointCloud');
Point = arrayfun(@(~) rosmessage('geometry_msgs/Point32'),zeros(1,Length));
In = arrayfun(@(~) rosmessage('sensor_msgs/ChannelFloat32'),zeros(1,Length));
for i=1:Length
%     In(i).Name = 'intensity';
%     In(i).Values = i(i);
    Point(i).X = x(i);
    Point(i).Y = y(i);
    Point(i).Z = z(i);
end

msg.Points = Point;
msg.Header.FrameId='PointCloud';
% msg.Channels = In;
t = rostime('now');
msg.Header.Stamp=t;

send(chatpub,msg);
