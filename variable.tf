variable "AWS_ACCOUNT_ID" {
    default = "" # Add your AWS ACCOUND ID here
}

variable "images" {
  type = list(string)
  default = [ "thehufaaz/todo-client-side", "thehufaaz/todo-server-side" ]
}