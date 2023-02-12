// Create SA
resource "yandex_iam_service_account" "n15" {
  folder_id = var.YC_FOLDER_ID
  name      = "n15"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "viewer" {
  folder_id = var.YC_FOLDER_ID
  role      = "viewer"
  member    = "serviceAccount:${yandex_iam_service_account.n15.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.YC_FOLDER_ID
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.n15.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "n15" {
  service_account_id = yandex_iam_service_account.n15.id
  description        = "static access key for object storage"
}