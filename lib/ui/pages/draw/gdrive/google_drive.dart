import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:http/http.dart' as http;

const _scopes = [
  ga.DriveApi.driveAppdataScope,
  ga.DriveApi.driveFileScope,
];

class GoogleDrive {
  GoogleSignInAccount? _currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: _scopes,
  );

  Future<void> _handleSignIn() async {
    try {
      _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
        if (account != null) {
          _currentUser = account;
        }
      });
      var account = await _googleSignIn.signInSilently();
      if (_currentUser == null) {
        _currentUser = await _googleSignIn.signIn();
      } else {
        _currentUser = account;
      }
    } catch (error) {
      print("SignIn EX: $error");
    }
  }

  Future<bool> uploadFileToGoogleDrive(File file) async {
    await _handleSignIn();
    final headers = await _currentUser?.authHeaders;
    if (headers != null) {
      final client = GoogleAuthClient(headers);
      var drive = ga.DriveApi(client);
      String? folderId = await _getFolderId(drive);
      if (folderId == null) {
        print("Sign-in first Error");
      } else {
        ga.File fileToUpload = ga.File();
        fileToUpload.parents = [folderId];
        final timestamp = DateTime.now().toIso8601String();
        fileToUpload.name = "funny-draw-$timestamp.png";
        // fileToUpload.name = p.basename(file.absolute.path);
        var response = await drive.files.create(
          fileToUpload,
          uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
        );

        if (response.id != null) {
          return true;
        }
      }
    }
    return false;
  }

// check if the directory forlder is already available in drive , if available return its id
// if not available create a folder in drive and return id
//   if not able to create id then it means user authetication has failed
  Future<String?> _getFolderId(ga.DriveApi driveApi) async {
    const mimeType = "application/vnd.google-apps.folder";
    String folderName = "funny-games";

    try {
      final found = await driveApi.files.list(
        q: "mimeType = '$mimeType' and name = '$folderName'",
        $fields: "files(id, name)",
      );
      final files = found.files;
      if (files == null) {
        print("Sign-in first Error");
        return null;
      }

      // The folder already exists
      if (files.isNotEmpty) {
        return files.first.id;
      }

      // Create a folder
      ga.File folder = ga.File();
      folder.name = folderName;
      folder.mimeType = mimeType;
      final folderCreation = await driveApi.files.create(folder);
      print("Folder ID: ${folderCreation.id}");
      return folderCreation.id;
    } catch (e) {
      print("ex: $e");
      return null;
    }
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}
