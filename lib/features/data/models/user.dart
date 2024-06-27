

import '../../domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    int ? id,
    String ? email,
    String ? avatar,
    String ? firstname,
    String ? lastname,
    List ? roles,
    String ? username,
    String ? provider,
    String ? phoneNumber,
    String ? bio,
  }) : super(
    id: id,
    email: email,
    avatar: avatar,
    firstname: firstname,
    lastname: lastname,
    roles: roles,
    username: username,
    provider: provider,
    phoneNumber: phoneNumber,
    bio: bio
  );
  
  factory UserModel.fromJson(Map<String, dynamic >map) {
    return UserModel(
      id: map['ID'] ?? "",
      email: map['Email'] ?? "",
      avatar: map['Avatar'] ?? "",
      firstname: map['Firstname'] ?? "",
      lastname: map['Lastname'] ?? "",
      roles: map['roles'] ?? [],
      username: map['Username'] ?? "",
      provider: map['Provider'] ?? "",
      phoneNumber: map['PhoneNumber'] ?? "",
      bio: map['Bio'] ?? "",
    );
  }

  factory UserModel.fromEntity(UserModel entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      avatar: entity.avatar,
      firstname: entity.firstname,
      lastname: entity.lastname,
      roles: entity.roles,
      username: entity.username,
      provider: entity.provider,
      phoneNumber: entity.phoneNumber,
      bio: entity.bio
    );
  }
}