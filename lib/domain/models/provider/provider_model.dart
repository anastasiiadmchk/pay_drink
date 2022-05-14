import 'package:json_annotation/json_annotation.dart';

part 'provider_model.g.dart';

@JsonSerializable()
class Provider {
  final String id;
  final String name;
  final String country;

  Provider(this.id, this.name, this.country);
  factory Provider.fromJson(Map<String, dynamic> json) =>
      _$ProviderFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderToJson(this);
}
