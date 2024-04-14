output "first_arn" {
  value       = aws_iam_user.example[0].arn
  description = "The ARN for the first user"
}


# If you want the ARNs of all of the IAM users, you need to use a splat expression, “*”, instead of the index:
output "all_arns" {
  value       = aws_iam_user.example[*].arn
  description = "The ARNs for all users"
}

output "neo_cloudwatch_policy_arn_ternary" {
  value = (
    var.give_neo_cloudwatch_full_access
    ? aws_iam_user_policy_attachment.neo_cloudwatch_full_access[0].policy_arn
    : aws_iam_user_policy_attachment.neo_cloudwatch_read_only[0].policy_arn
  )
}

# The concat function takes two or more lists as inputs and combines them into a single list. The
# one function takes a list as input and if the list has 0 elements, it returns null; if the list has 1 element, 
# it returns that element; and if the list has more than 1 element, it shows an error. Putting these two 
# together, and combining them with a splat expression, you get the following:
# Depending on the outcome of the if/else conditional, either neo_cloud
# watch_full_access will be empty and neo_cloudwatch_read_only will contain one
# element or vice versa, so once you concatenate them together, you’ll have a list with
# one element, and the one function will return that element. This will continue to
# work correctly no matter how you change your if/else conditional.
output "neo_cloudwatch_policy_arn" {
  value = one(concat(
    aws_iam_user_policy_attachment.neo_cloudwatch_full_access[*].policy_arn,
    aws_iam_user_policy_attachment.neo_cloudwatch_read_only[*].policy_arn
  ))
}

