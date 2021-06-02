output "instance_id" {
    value = aws_launch_template.rs-asg-lt.id
    description = "Id of Launch Template"
}