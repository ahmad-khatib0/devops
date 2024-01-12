
# using the values built-in function (which returns just the values from a
# map) and a splat expression:
# Outputs:
# all_arns = [
#     "arn:aws:iam::123456789012:user/morpheus",
#     "arn:aws:iam::123456789012:user/neo",
#     "arn:aws:iam::123456789012:user/trinity",
# ]
output "all_arns" {
  value = values(aws_iam_user.example)[*].arn
}

output "all_users" {
  value = aws_iam_user.example
}
