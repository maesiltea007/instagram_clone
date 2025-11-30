class User {
  String id;
  String userNickName;
  String userName;
  String profileImagePath;
  String bio;
  int followerCount;
  int followingCount;

  User({
    required this.id,
    required this.userNickName,
    required this.userName,
    required this.profileImagePath,
    required this.bio,
    required this.followerCount,
    required this.followingCount,
  });
}