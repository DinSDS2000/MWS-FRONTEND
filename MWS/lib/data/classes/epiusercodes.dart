class UserCodesResponse {
  final List<UserCodes> value;
  final bool success;
  final List<String> errors;

  UserCodesResponse({
    required this.value,
    required this.success,
    required this.errors,
  });

  // Factory method to parse server JSON response map
  factory UserCodesResponse.fromJson(Map<String, dynamic> json) {
    return UserCodesResponse(
      value: (json['value'] as List?)
              ?.map((item) => UserCodes.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      success: json['Success'] ?? false,
      errors:
          (json['Errors'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class UserCodes {
  final String codeId;
  final String codeDesc;

  UserCodes({
    required this.codeId,
    required this.codeDesc,
  });

  factory UserCodes.fromJson(Map<String, dynamic> json) {
    return UserCodes(
      codeId: json['CodeID'] ?? '',
      codeDesc: json['CodeDesc'] ?? '',
    );
  }
}
