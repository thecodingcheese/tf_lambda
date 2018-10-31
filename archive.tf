# Generates a filename for the zip archive based on the contents of the files
# in source_path.

data "archive_file" "lambda_zip" {
    type          = "zip"
    source_file   = "${var.source_path}"
    output_path   = "${var.function_name}.zip"
}
