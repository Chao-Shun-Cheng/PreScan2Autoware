function point2pub(XYZ)
persistent chatpub
if isempty(chatpub)
    %rosinit('http://192.168.0.101:11311');
    chatpub = rospublisher('/points_raw','sensor_msgs/PointCloud2');
end
lidarMsgOut = rosmessage('sensor_msgs/PointCloud2');

% Calculate number of points
numPts = size(XYZ,2);

% Assign metadata
lidarMsgOut.Height = uint32(1);
lidarMsgOut.Width = uint32(numPts);
lidarMsgOut.PointStep = uint32(16); 
lidarMsgOut.RowStep = uint32(numPts*16);

% Assign point field data
fieldNames = {'x','y','z','intensity'};
for idx = 1:4
    fName = fieldNames{idx};
    temp = rosmessage('sensor_msgs/PointField');
    temp.Name(1:numel(fName)) = uint8(fName);
    temp.Offset = uint32((idx-1)*4);
    temp.Datatype = uint8(7);
    temp.Count = uint32(1);
    lidarMsgOut.Fields(idx) = temp;
end

% Assign raw point cloud data in uint8 format
XYZ = reshape(XYZ,1,[]);
XYZ = typecast(XYZ,'uint8');
lidarMsgOut.Data = XYZ;

% Send to ROS
lidarMsgOut.Header.FrameId='PreScan';
t = rostime('now');
lidarMsgOut.Header.Stamp=t;
send(chatpub,lidarMsgOut);