import 'package:flutter/material.dart';
import 'package:portafolio_webapp_2026/widgets/build_experience_card.dart';
import 'package:portafolio_webapp_2026/widgets/build_info_tile.dart';
import 'package:portafolio_webapp_2026/widgets/certificados_card.dart';
import 'package:portafolio_webapp_2026/widgets/section_title.dart';

class CertificadosScreenMobile extends StatelessWidget {
  const CertificadosScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical:20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
          "Certificados",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Column(
          children: [
            const CertificateCard(
              certificateAsset: "lib/assets/img/certificado_flutter.jpg", 
              title: "Flutter - Móvil: De cero a experto",
              platform: "Udemy",
              date: "April 2024",
              logoAsset: "lib/assets/img/udemy_logo.png",
              certificateUrl: "https://www.udemy.com/certificate/UC-9ee9f467-6e2a-4b06-95a5-419973528cf4/",
            ),
            
            const CertificateCard(
              certificateAsset : "lib/assets/img/certificado_roblox.jpg", 
              title: "Learn How To Code Games In Roblox Studio ",
              platform: "Udemy",
              date: "Jul 2024",
              logoAsset: "lib/assets/img/udemy_logo.png",
              certificateUrl: "https://www.udemy.com/certificate/UC-009ff324-d7f4-4800-ac37-6ed8f10a6021/",
            ),
            const CertificateCard(
              certificateAsset : "lib/assets/img/certificado_ingles_b2.png", 
              title: "English Certificate B2 Upper Intermediate",
              platform: "EF SET",
              date: "Sept 2024",
              logoAsset: "lib/assets/img/efset_logo.jpg",
              certificateUrl: "https://cert.efset.org/rZDUUR",
            ),
            
          ],
        ),
        ],
      ),
    );
  }

}