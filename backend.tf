terraform {
      backend "s3" {
        bucket         = "terraform-state-rk01"  
        key            = "pub-bucket/terraform.tfstate"
        region         = "us-east-1"           
      }
    }
