class SiteConfig {
  final String email;
  final String phone;
  final String address;
  final int companyProvinceID;
  final String companyProvinceName;
  final int companyCityID;
  final String companyCityName;
  final int companyDistrictID;
  final String companyDistrictName;
  final int companyPostalCode;
  final String credit;
  final String aboutTitle;
  final String subAboutDescription;
  final String subAbout1Title;
  final String subAbout1Description;
  final String subAbout2Title;
  final String subAbout2Description;
  final String subAbout3Title;
  final String subAbout3Description;
  final String subAbout4Title;
  final String subAbout4Description;
  final String faviconUrl;
  final String logoUrl;

  SiteConfig({
    required this.email,
    required this.phone,
    required this.address,
    required this.companyProvinceID,
    required this.companyProvinceName,
    required this.companyCityID,
    required this.companyCityName,
    required this.companyDistrictID,
    required this.companyDistrictName,
    required this.companyPostalCode,
    required this.credit,
    required this.aboutTitle,
    required this.subAboutDescription,
    required this.subAbout1Title,
    required this.subAbout1Description,
    required this.subAbout2Title,
    required this.subAbout2Description,
    required this.subAbout3Title,
    required this.subAbout3Description,
    required this.subAbout4Title,
    required this.subAbout4Description,
    required this.faviconUrl,
    required this.logoUrl,
  });

  factory SiteConfig.fromJson(Map<String, dynamic> json) {
    return SiteConfig(
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      companyProvinceID: json['company_province_id'] ?? 0,
      companyProvinceName: json['company_province_name'] ?? '',
      companyCityID: json['company_city_id'] ?? 0,
      companyCityName: json['company_city_name'] ?? '',
      companyDistrictID: json['company_district_id'] ?? 0,
      companyDistrictName: json['company_district_name'] ?? '',
      companyPostalCode: json['company_postal_code'] ?? 0,
      credit: json['credit'] ?? '',
      aboutTitle: json['about_title'] ?? '',
      subAboutDescription: json['sub_about_description'] ?? '',
      subAbout1Title: json['sub_about1_title'] ?? '',
      subAbout1Description: json['sub_about1_description'] ?? '',
      subAbout2Title: json['sub_about2_title'] ?? '',
      subAbout2Description: json['sub_about2_description'] ?? '',
      subAbout3Title: json['sub_about3_title'] ?? '',
      subAbout3Description: json['sub_about3_description'] ?? '',
      subAbout4Title: json['sub_about4_title'] ?? '',
      subAbout4Description: json['sub_about4_description'] ?? '',
      faviconUrl: json['favicon_url'] ?? '',
      logoUrl: json['logo_url'] ?? '',
    );
  }
}
