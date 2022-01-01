#include <ros/ros.h>
#include <tablet_socket_msgs/gear_cmd.h>
#include <autoware_msgs/AccelCmd.h>
#include <autoware_msgs/BrakeCmd.h>
#include <autoware_msgs/SteerCmd.h>
#include <autoware_msgs/CanInfo.h>


autoware_msgs::CanInfo vehicle;

void steerCMDCallback(const autoware_msgs::SteerCmd& steer)
{
    vehicle.steering = steer.steer;
    printf("[ROS CMD] steering_angle cmd: %d\n", steer.steer);
}

void brakeCMDCallback(const autoware_msgs::BrakeCmd &brake)
{
   vehicle.brake = brake.brake;
   printf("[ROS CMD] brake_stroke cmd: %d \n", brake.brake);
}

void accellCMDCallback(const autoware_msgs::AccelCmd& accell)
{
   vehicle.throttle = accell.accel;
   printf("[ROS CMD] accel_stroke cmd: %d\n", accell.accel);
}

void gearCMDCallback(const tablet_socket_msgs::gear_cmd& gear)
{
   vehicle.gear = gear.gear;
   printf("[ROS CMD] gear cmd: %d\n", gear.gear);
}

int main(int argc, char **argv)
{
    ros::init(argc ,argv, "PreScan_vehicle");
    ros::NodeHandle nh;
    ros::Publisher pub = nh.advertise<autoware_msgs::CanInfo>("can_info",1000);
    ros::Subscriber sub[4];
    sub[0] = nh.subscribe("/gear_cmd",  1, gearCMDCallback);
    sub[1] = nh.subscribe("/accel_cmd", 1, accellCMDCallback); // Make it as throttle 
    sub[2] = nh.subscribe("/steer_cmd", 1, steerCMDCallback);
    sub[3] = nh.subscribe("/brake_cmd", 1, brakeCMDCallback);
    ros::Rate rate(10);

    while(ros::ok())
    {
        pub.publish(vehicle);
        ros::spinOnce();
        rate.sleep();
        
    }
    return 0;
}