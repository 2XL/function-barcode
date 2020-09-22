# An example resource that does nothing.
resource "null_resource" "example" {
  triggers = {
    value = "A example resource that does nothing!"
  }
}

data template_file package_json {
  template = file("${path.module}/package.json")
}
data template_file index_js {
  template = file("${path.module}/index.js")
}


# Archive multiple files.
data "archive_file" "index" {
  type = "zip"
  output_path = "${path.module}/${var.function_path}/${var.function_name}/index.zip"

  source {
    content = data.template_file.package_json.rendered
    filename = "package.json"
  }
  source {
    content = data.template_file.index_js.rendered
    filename = "index.js"
  }

}


resource "google_storage_bucket" "bucket" {
  project = data.google_project.p.name
  name = "${data.google_project.p.name}-${var.function_bucket_name}"
}

resource "google_storage_bucket_object" "archive" {
  name = "index.zip"
  bucket = google_storage_bucket.bucket.name
  source = "${path.module}/${var.function_path}/${var.function_name}/index.zip"
}

resource "google_cloudfunctions_function" "function" {
  region = var.project_region
  project = data.google_project.p.name
  name = var.function_name
  description = var.function_description
  runtime = var.function_runtime

  available_memory_mb = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http = true
  entry_point = var.function_entrypoint
  # convertBarcode
  ingress_settings = "ALLOW_ALL" # | ALLOW_INTERNAL_ONLY

  depends_on = [google_project_service.cloudfunctions]
}
//
# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project = google_cloudfunctions_function.function.project
  region = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role = "roles/cloudfunctions.invoker"
  member = "allUsers"
}