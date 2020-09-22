terraform {
  # The modules used in this guide require Terraform 0.12, additionally we depend on a bug fixed in version 0.12.7.
  required_version = ">= 0.13.2"
}

data google_project p {
  project_id = var.project_id
}


provider "google" {
//  project = data.google_project.p.id
//  region = var.project_region
  version = "3.30.0"
}

provider "google-beta" {
//  project = data.google_project.p.id
//  region = var.project_region
  version = "3.30.0"
}



resource "google_project_service" "cloudfunctions" {
  # https://console.developers.google.com/apis/api/cloudfunctions.googleapis.com/overview?project=############
  project = data.google_project.p.name
  service = "cloudfunctions.googleapis.com"
}

resource "google_project_service" "cloudbuild" {
  # https://console.developers.google.com/apis/api/cloudbuild.googleapis.com/overview?project=############
  project = data.google_project.p.name
  service = "cloudbuild.googleapis.com"
}
