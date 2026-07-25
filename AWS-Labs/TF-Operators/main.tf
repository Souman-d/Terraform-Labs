terraform {
  
}

#Number List
variable "number_list" {
  type    = list(number)
  default = [1, 2, 3, 4, 5]
}

#Object List of person
variable "person_list" {
  type = list(object({
    fname = string
    lname = string
  }))
  default = [
    {
      fname = "Alice"
      lname = "Smith"
    },
    {
      fname = "Bob"
      lname = "Johnson"
    },
    {
      fname = "Charlie"
      lname = "Williams"
    }
  ]
}

variable "map_list" {
  type = map(number)
  default = {
    "one" = 1
    "two" = 2
    "three" = 3
  }
}

#Calculations  
locals {
  multiply_by_two = [for num in var.number_list : num * 2]
  add_five = [for num in var.number_list : num + 5]
}

output "multiply_by_two" {
  value = local.multiply_by_two
}

output "add_five" {
  value = local.add_five
}

#To get person name
output "full_names" {
  value = [for person in var.person_list : join(" ", [person.fname, person.lname])]
}

output "map_info" {
  value = [for key, value in var.map_list : value * 5]
}
output "double_map" {
  value = { for key, value in var.map_list : key => value * 2 }
}