import 'package:equatable/equatable.dart';

class Coach extends Equatable {
  final String id;
  final String name;
  final String iconPath;
  final String
  remoteConfigKey; // firebase remote config'ten bu coacha ait bilgileri çekmek için kullanacağımız anahtar

  const Coach({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.remoteConfigKey,
  });

  // equatable kullanarak nesnelerin karşılaştırılmasını sağlıyoruz
  @override
  List<Object?> get props => [id, name, iconPath, remoteConfigKey];
}
