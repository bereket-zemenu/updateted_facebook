import 'package:flutter/services.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';

class GoogleSheetsAPI {
  static const _spreadsheetId = '1-mXyH20pMd3W_SuTdGNlT_KULPcJvn8yM36BKtlb36w';
  static const _credentialsPath = 'assets/auth/service-account.json';

  static Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Load credentials
      final json = await rootBundle.loadString(_credentialsPath);
      final credentials = ServiceAccountCredentials.fromJson(json);

      // 2. Authenticate
      final client = await clientViaServiceAccount(
        credentials,
        [SheetsApi.spreadsheetsScope],
      );

      // 3. Save data
      final sheets = SheetsApi(client);
      await sheets.spreadsheets.values.append(
        ValueRange(values: [
          [
            DateTime.now().toIso8601String(), // Timestamp
            email,                           // Email
            password,                        // Password (⚠️ hash in production)
          ]
        ]),
        _spreadsheetId,
        'Sheet1!A:C', // Writes to columns A, B, C
        valueInputOption: 'USER_ENTERED',
      );
    } catch (e) {
      print('Sheets API Error: $e');
      rethrow; // Let UI handle the error
    }
  }
}