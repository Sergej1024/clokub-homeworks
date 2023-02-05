resource "yandex_storage_bucket" "bucket" {
  bucket     = "n15"
  access_key = yandex_iam_service_account_static_access_key.n15-2.access_key
  secret_key = yandex_iam_service_account_static_access_key.n15-2.secret_key

  anonymous_access_flags {
    read = true
    list = true
  }
}

resource "yandex_storage_object" "logo" {
  bucket     = yandex_storage_bucket.bucket.bucket
  key        = "logo.png"
  source     = "logo.png"
  access_key = yandex_iam_service_account_static_access_key.n15-2.access_key
  secret_key = yandex_iam_service_account_static_access_key.n15-2.secret_key
  acl        = "public-read"
}