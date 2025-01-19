
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.16.0"
    }
  }
}

provider "google" {
  credentials = file("../keys/my-creds.json")
  project     = "travoolta-72f04"
  region      = "europe-west2"
}



resource "google_storage_bucket" "data-lake-bucket" {
  name     = "travoolta-72f04-terra-bucket"
  location = "EUROPE-WEST3"

  # Optional, but recommended settings:
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30 // days
    }
  }

  force_destroy = true
}


resource "google_bigquery_dataset" "dataset" {
  dataset_id = "demo_dataset"
  project    = "travoolta-72f04"
  location   = "EUROPE-WEST3"
}
