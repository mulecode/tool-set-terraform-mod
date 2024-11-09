locals {
  files_to_upload = flatten([
    for bucket_name, config in var.aws_s3_buckets_put_files : [
      for file in fileset(config.folder_path, "**/*.*") : {
        bucket_name = bucket_name
        bucket_id   = "${var.project_prefix}-${bucket_name}-${var.account_id}"
        file_path   = "${config.folder_path}/${file}"
        key         = file
        tags        = config.tags
      }
    ]
  ])
}

resource "aws_s3_object" "upload_files2" {
  for_each = { for file in local.files_to_upload : "${file.bucket_id}-${file.key}" => file }
  bucket   = each.value.bucket_id
  key      = each.value.key
  source   = each.value.file_path
  etag     = filemd5(each.value.file_path)

  content_type = lookup(
    {
      "html" = "text/html",
      "css"  = "text/css",
      "js"   = "application/javascript",
      "json" = "application/json",
      "xml"  = "application/xml",
      "png"  = "image/png",
      "jpg"  = "image/jpeg",
      "jpeg" = "image/jpeg",
      "svg"  = "image/svg+xml",
      "gif"  = "image/gif",
      "bmp"  = "image/bmp",
      "tiff" = "image/tiff",
      "webp" = "image/webp",
      "pdf"  = "application/pdf",
      "csv"  = "text/csv",
      "mp3"  = "audio/mpeg",
      "wav"  = "audio/wav",
      "ogg"  = "audio/ogg",
      "mp4"  = "video/mp4",
      "avi"  = "video/x-msvideo",
      "webm" = "video/webm",
      "mov"  = "video/quicktime",
      "zip"  = "application/zip",
      "gz"   = "application/gzip",
      "tar"  = "application/x-tar",
      "7z"   = "application/x-7z-compressed",
      "txt"  = "text/plain",
      "md"   = "text/markdown",
      "rtf"  = "application/rtf",
      "log"  = "text/plain",
      "ico"  = "image/x-icon"
    },
    regex("[^.]+$", each.value.file_path), # Extracts the file extension and matches it
    "application/octet-stream"             # Default content type if not found
  )
  tags = merge(
    each.value.tags, {
      CreatedBy  = "terraform"
      ModuleName = "bucket_put_files"
    }
  )
}
