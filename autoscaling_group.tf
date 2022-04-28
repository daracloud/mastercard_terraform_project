#create autoscaling group
resource "aws_autoscaling_group" "EC2_AutoScaling_Group" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 5
  min_size           = 1

  launch_template {
    id      = aws_launch_template.my_template.id
    version = "$Latest"
  }
}
resource "aws_key_pair"  "ssh-key" {
  key_name = "server-key"
  public_key = file(var.public_key_location)
}
  #create autoscaling policy 
resource "aws_autoscaling_policy" "EC2_AutoScaling_Policy" {
  name                   = "EC2-AutoScaling-Policy"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.EC2_AutoScaling_Group.name
  depends_on = [
    aws_autoscaling_group.EC2_AutoScaling_Group
  ]
}
