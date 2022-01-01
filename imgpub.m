function imgpub(data)
%rosinit('http://192.168.0.147:11311')
persistent chatpub
if isempty(chatpub)
    %rosinit('http://192.168.0.101:11311');   
    chatpub = rospublisher('/Imagemsg','sensor_msgs/Image');
end
msg = rosmessage('sensor_msgs/Image');
msg.Height=uint32(240);
msg.Width=uint32(320);
msg.Header.FrameId='PreImg';
msg.Encoding='rgb8';
msg.Step=uint32(960);
image = permute(data,[3 2 1]);     % Flip dimensions
image = image(:);
msg.Data = image;
send(chatpub,msg);
