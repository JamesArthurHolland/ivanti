variable "name" {
  description = "Name of the environment"
}

variable "linode_token" {
  description = "Your Linode API Personal Access Token. (required)"
}

variable "k8s_version" {
  description = "The Kubernetes version to use for this cluster. (required)"
  default = "1.31"
}

variable "label" {
  description = "The unique label to assign to this cluster. (required)"
  default = "ivanti-lke-cluster"
}

variable "region" {
  description = "The region where your cluster will be located. (required)"
  default = "us-east"
}

variable "tags" {
  description = "Tags to apply to your cluster for organizational purposes. (optional)"
  type = list(string)
  default = ["testing"]
}

variable "pools" {
  description = "The Node Pool specifications for the Kubernetes cluster. (required)"
  type = list(object({
    type = string
    count = number
  }))
  default = [
    {
      type = "g6-standard-4"
      count = 3
    },
    {
      type = "g6-standard-8"
      count = 3
    }
  ]
}
