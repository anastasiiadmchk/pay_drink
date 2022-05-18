import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pay_drink/core/converters/timestamp_converter.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String? id;
  final DateTime? createdAt;
  final String? email;
  @TimestampConverter()
  final DateTime? birthdate;
  final String? firstName;
  final String? lastName;
  final String? middleName;

  const UserModel({
    this.id,
    this.createdAt,
    this.email,
    this.birthdate,
    this.firstName,
    this.lastName,
    this.middleName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? middleName,
    DateTime? birthdate,
    DateTime? createdAt,
    String? birthPlaceString,
  }) {
    return UserModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      birthdate: birthdate ?? this.birthdate,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
    );
  }

  @override
  List<Object?> get props => [id];
}
