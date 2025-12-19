class ApiConfig {
  static const String baseUrl = 'https://fesnukberust.azurewebsites.net/api/v1';
  static const String imageBaseUrl =
      'https://fesnukberust.blob.core.windows.net/storage/attachments';
  
  // Azure Blob Storage upload URL with SAS token
  // Note: This token may expire. Consider fetching from backend if needed.
  static const String azureUploadUrl =
      'https://fesnukberust.blob.core.windows.net/storage/attachments';
  
  static String getImageUrl(String filename) {
    return '$imageBaseUrl/$filename';
  }
  
  static String getAzureUploadUrl(String filename) {
    // SAS token parameters - may need to be fetched from backend
    const String sasParams =
        '?sp=rcl&st=2025-10-05T06:39:13Z&se=2045-10-05T14:54:13Z&spr=https&sv=2024-11-04&sr=c&sig=ujGh09%2BexMGTeOwF9XEoFgOOBQzizcr3ouJHKyAnOJ8%3D';
    return '$azureUploadUrl/$filename$sasParams';
  }
}

