import 'dart:convert';
import 'dart:developer' as developer;
import 'package:axolon_erp/utils/constants/api_constants.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ApiServices {
  static isConnected() async {
    bool hasInternet = await InternetConnectionChecker().hasConnection;
    return hasInternet;
  }

  static final client = http.Client();
  static Future fetchData({
    String? api,
  }) async {
    try {
      print("frtchdata");
      bool isConnected = await ApiServices.isConnected();
      if (isConnected) {
        String baseUrl = Api.getBaseUrl();
        print(baseUrl + api!);
        var responses = await client.post(
          Uri.parse('${baseUrl}$api'),
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print("somethinngggg");
          print(jsonResponse);///new

          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      // SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }
  static Future fetchDataCustomer({
    String? api,
  }) async {
    try {
      print("frtchdata");
      bool isConnected = await ApiServices.isConnected();
      if (isConnected) {
        String baseUrl = Api.getCustomerBaseUrl();
        print(baseUrl + api!);
        var responses = await client.post(
          Uri.parse('${baseUrl}$api'),
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print("somethinngggg");
          print(jsonResponse);///new

          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      // SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataInventory({
    String? api,
  }) async {
    try {
      bool isConnected = await ApiServices.isConnected();
      if (isConnected) {
        String baseUrl = Api.getInventoryBaseUrl();
        print(baseUrl + api!);
        var responses = await client.post(
          Uri.parse('${baseUrl}$api'),
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      // SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataCRM({
    String? api,
  }) async {
    try {
      bool isConnected = await ApiServices.isConnected();
      if (isConnected) {
        String baseUrl = Api.getCRMBaseUrl();
        print(baseUrl + api!);
        var responses = await client.post(
          Uri.parse('${baseUrl}$api'),
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      // SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataReport({
    String? api,
  }) async {
    try {
      bool isConnected = await ApiServices.isConnected();
      if (isConnected) {
        String baseUrl = Api.getReportBaseUrl();
        print(baseUrl + api!);
        var responses = await client.post(
          Uri.parse('${baseUrl}$api'),
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      // SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataEmployee({
    String? api,
  }) async {
    try {
      bool isConnected = await ApiServices.isConnected();
      if (isConnected) {
        String baseUrl = Api.getEmployeeBaseUrl();
        print(baseUrl + api!);
        var responses = await client.post(
          Uri.parse('${baseUrl}$api'),
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      // SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataProject({
    String? api,
  }) async {
    try {
      bool isConnected = await ApiServices.isConnected();
      if (isConnected) {
        String baseUrl = Api.getProjectBaseUrl();
        print(baseUrl + api!);
        var responses = await client.post(
          Uri.parse('${baseUrl}$api'),
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      // SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataAccount({
    String? api,
  }) async {
    try {
      bool isConnected = await ApiServices.isConnected();
      if (isConnected) {
        String baseUrl = Api.getAccountBaseUrl();
        print(baseUrl + api!);
        var responses = await client.post(
          Uri.parse('${baseUrl}$api'),
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      // SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataRawBody({String? api, String? data}) async {
    try {
      bool isConnected = await ApiServices.isConnected();
      if (isConnected) {
        developer.log(data.toString(), name: 'ApiServices data');
        String baseUrl = Api.getBaseUrl();
        var responses = await client.post(
          Uri.parse('$baseUrl$api'),
          headers: {"Content-Type": "application/json"},
          body: data,
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      // SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  // static Future checkCredentialRawBody({String? api, String? data}) async {
  //   print(data);
  //   String baseUrl = Api.getBaseUrl();
  //   try {
  //     var responses = await client.post(
  //       Uri.parse('$baseUrl$api'),
  //       headers: {"Content-Type": "application/json"},
  //       body: data,
  //     );
  //     if (responses.statusCode == 200) {
  //       var jsonResponse = jsonDecode(responses.body);
  //       print(jsonResponse);
  //       return jsonResponse;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  static Future fetchDataRawBodyEmployee({String? api, String? data}) async {
    try {
      bool isConnected = await ApiServices.isConnected();
      if (isConnected) {
        String baseUrl = Api.getEmployeeBaseUrl();
        var responses = await client.post(
          Uri.parse('$baseUrl$api'),
          headers: {"Content-Type": "application/json"},
          body: data,
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      // SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataRawBodyInventory({String? api, String? data}) async {
    try {
      bool isConnected = await ApiServices.isConnected();
      if (isConnected) {
        String baseUrl = Api.getInventoryBaseUrl();
        var responses = await client.post(
          Uri.parse('$baseUrl$api'),
          headers: {"Content-Type": "application/json"},
          body: data,
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      // SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataRawBodyCRM({String? api, String? data}) async {
    try {
      bool isConnected = await ApiServices.isConnected();
      if (isConnected) {
        String baseUrl = Api.getCRMBaseUrl();
        var responses = await client.post(
          Uri.parse('$baseUrl$api'),
          headers: {"Content-Type": "application/json"},
          body: data,
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      // SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataRawBodyReport({String? api, String? data}) async {
    try {
      bool isConnected = await ApiServices.isConnected();
      if (isConnected) {
        String baseUrl = Api.getReportBaseUrl();
        var responses = await client.post(
          Uri.parse('$baseUrl$api'),
          headers: {"Content-Type": "application/json"},
          body: data,
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      // SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

   static Future fetchDataRawBodyProject({String? api, String? data}) async {
    try {
      bool isConnected = await ApiServices.isConnected();
      if (isConnected) {
        String baseUrl = Api.getProjectBaseUrl();
        var responses = await client.post(
          Uri.parse('$baseUrl$api'),
          headers: {"Content-Type": "application/json"},
          body: data,
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      // SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataVansale({
    String? api,
  }) async {
    try {
      bool isConnected = await ApiServices.isConnected();
      if (isConnected) {
        String baseUrl = Api.getVansaleBaseUrl();
        print(baseUrl + api!);
        var responses = await client.post(
          Uri.parse('${baseUrl}$api'),
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      // SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }
}
