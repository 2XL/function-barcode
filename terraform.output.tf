output "archive_file" {
  value = "archive_file.index.zip ${data.archive_file.index.output_base64sha256}"
}


output "function_endpoint" {
  value = google_cloudfunctions_function.function.https_trigger_url
}

output "function_endpoint_example_query" {
  value = "${google_cloudfunctions_function.function.https_trigger_url}/?format=upc&value=796030114977"
}