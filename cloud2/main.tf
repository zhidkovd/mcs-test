terraform {
    required_providers {
        vkcs = {
            source = "vk-cs/vkcs"
        }
    }
}

provider "vkcs" {
    username = var.username_tf
    password = var.password_tf
    project_id = var.project_id_tf
    region = "RegionOne"
}
