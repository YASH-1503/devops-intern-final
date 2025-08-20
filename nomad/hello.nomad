job "hello-devops" {
  datacenters = ["dc1"]
  type = "service"

  group "hello" {
    count = 1

    network {
      port "http" {
        to = 8080
      }
    }

    task "hello-container" {
      driver = "docker"

      config {
        image = "hello-devops:latest"
      }

      resources {
        cpu    = 100
        memory = 64
      }

      logs {
        max_files     = 5
        max_file_size = 10
      }
    }
  }
}
