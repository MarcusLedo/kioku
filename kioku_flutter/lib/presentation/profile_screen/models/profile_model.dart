class ProfileModel {
  String username;
  String userId;
  String profileImageUrl;
  String backgroundImageUrl;
  int sharedDecksCount;
  bool hasPremium;

  ProfileModel({
    this.username = 'AngryCat',
    this.userId = '@angrycat_2022',
    this.profileImageUrl =
        'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg',
    this.backgroundImageUrl =
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
    this.sharedDecksCount = 4,
    this.hasPremium = true,
  });
}
