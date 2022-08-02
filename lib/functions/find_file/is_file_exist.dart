import 'dart:io';

/// find a file is exist
bool isFileExist(String path) {
  return File(path).existsSync();
}
