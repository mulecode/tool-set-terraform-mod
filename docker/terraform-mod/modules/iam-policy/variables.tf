variable "prefix" {
  description = "Prefix for the Role resource"
  type        = string
}
variable "name" {
  description = "Name for the Role resource"
  type        = string
}
variable "description" {
  description = "Description for the Role resource"
  type        = string
}
variable "policy" {
  description = "Policy document in json format"
  type        = string
}
variable "tags" {
  default     = {}
  description = "Map of key/value metadata"
  type        = map(string)
}
