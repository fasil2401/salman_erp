import 'dart:convert';

LoginError loginErrorFromJson(String str) => LoginError.fromJson(json.decode(str));

String loginErrorToJson(LoginError data) => json.encode(data.toJson());

class LoginError {
    LoginError({
       required this.res,
       required this.msg,
    });

    int res;
    String msg;

    factory LoginError.fromJson(Map<String, dynamic> json) => LoginError(
        res: json["res"],
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "msg": msg,
    };
}
