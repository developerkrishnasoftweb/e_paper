class FeedData {
  String id;
  String title;
  String description;
  String previewImage;
  String pdfFile;
  String status;
  String publishedAt;
  String createdBy;
  String createdAt;
  String updatedAt;

  FeedData(
      {this.id,
        this.title,
        this.description,
        this.previewImage,
        this.pdfFile,
        this.status,
        this.publishedAt,
        this.createdBy,
        this.createdAt,
        this.updatedAt});

  FeedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    previewImage = json['preview_image'];
    pdfFile = json['pdf_file'];
    status = json['status'];
    publishedAt = json['published_at'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['preview_image'] = this.previewImage;
    data['pdf_file'] = this.pdfFile;
    data['status'] = this.status;
    data['published_at'] = this.publishedAt;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
