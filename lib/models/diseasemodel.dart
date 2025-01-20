class DiseasesModel {
  final String name; // Use String type for name
  final String image; // Use String type for image
  final dynamic tag; // Use dynamic or a specific type for tag, depending on your use case

  // Constructor
  DiseasesModel({
    required this.name,
    required this.image,
    this.tag,
  });
}