terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = "AQAAAAAVYfbHAATuwVtkYVYIQUxyg2YcpEzFYUY"
  cloud_id  = "b1gna86k5nfpb693gn8u"
  folder_id = "b1gah9daaqvrbcism5fa"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "vm-4" {
  name = "prometheus-grafana"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 8
  }

  boot_disk {
    initialize_params {
      image_id = "fd83869rbingor0in0ui"
      size     = 50
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-2.id
    nat       = true
  }

  metadata = {
    #    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = "${file("~/sf_12.Prometheus_Grafana/meta1.txt")}"
  }
}


resource "yandex_compute_instance" "vm-5" {
  name = "nginx"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd83869rbingor0in0ui"
      size     = 30
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-2.id
    nat       = true
  }

  metadata = {
    #    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = "${file("~/sf_12.Prometheus_Grafana/meta2.txt")}"
  }
}


resource "yandex_vpc_network" "network-2" {
  name = "network2"
}

resource "yandex_vpc_subnet" "subnet-2" {
  name           = "subnet2"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-2.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}

output "internal_ip_address_vm_4" {
  value = yandex_compute_instance.vm-4.network_interface.0.ip_address
}
output "internal_ip_address_vm_5" {
  value = yandex_compute_instance.vm-5.network_interface.0.ip_address
}

output "external_ip_address_vm_4" {
  value = yandex_compute_instance.vm-4.network_interface.0.nat_ip_address
}
output "external_ip_address_vm_5" {
  value = yandex_compute_instance.vm-5.network_interface.0.nat_ip_address
}


### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("${path.module}/inventory.tmpl",
    {
      server1-ip = yandex_compute_instance.vm-4.network_interface.0.nat_ip_address,
      server2-ip = yandex_compute_instance.vm-5.network_interface.0.nat_ip_address
    }
  )
  filename = "${path.module}/inventory.yml"
}
### The Ansible playlist launch
resource "null_resource" "ansible" {
  provisioner "local-exec" {
    command = "sleep 120; ansible-playbook -i ${path.module}/inventory.yml role-playlist.yml"
  }
  depends_on = [local_file.AnsibleInventory]
}
