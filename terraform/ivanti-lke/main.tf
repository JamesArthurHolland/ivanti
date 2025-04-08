terraform {
  backend "s3" {
    bucket = "ivanti-tf-state"
    key    = "terraform.tfstate"
    region = "gb-lon-1"
    workspace_key_prefix = "ivanti"
    skip_credentials_validation = true
    skip_region_validation = true
    skip_requesting_account_id = true
    skip_get_ec2_platforms = true
    skip_metadata_api_check = true
    endpoint = "gb-lon-1.linodeobjects.com"
  }

  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.16.0"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

resource "linode_lke_cluster" "ivanti" {
    k8s_version = var.k8s_version
    label = var.label
    region = var.region
    tags = var.tags

    dynamic "pool" {
        for_each = var.pools
        content {
            type  = pool.value["type"]
            count = pool.value["count"]
        }
    }
}

output "kubeconfig" {
    value = linode_lke_cluster.ivanti.kubeconfig
    sensitive = true
}

output "api_endpoints" {
   value = linode_lke_cluster.ivanti.api_endpoints
}

output "status" {
   value = linode_lke_cluster.ivanti.status
}

output "id" {
   value = linode_lke_cluster.ivanti.id
}

output "pool" {
   value = linode_lke_cluster.ivanti.pool
}
