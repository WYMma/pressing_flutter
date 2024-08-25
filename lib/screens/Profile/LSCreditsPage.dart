import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry/main.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSImages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class LSCreditsPage extends StatelessWidget {
  const LSCreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final instituteData = {
      'logo': LSLogoBig,
      'name': 'Pressing Neffatti',
      'street': 'Av. de la République, Gabes, Tunisie',
      'facebook': 'https://www.facebook.com/PressingNeffatiMsbghtAlnfaty/?locale=fr_FR',
      'email': 'cleannaffati@gmail.com',
      'phoneNum': '+21622869369',
    };

    return Scaffold(
      appBar: appBarWidget('Credits', center: true, color: context.cardColor),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 50.0, 16.0, 25.0),
              child: Card(
                elevation: 4,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Row(
                    children: [
                      8.width,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: Container(
                          decoration: boxDecorationWithShadow(borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.all(16),
                          child: Image.asset(
                            instituteData['logo']!,
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.contain,
                          )
                        ),
                      ),
                      16.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              instituteData['name']!,
                              style: GoogleFonts.roboto(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              '${instituteData['street']}',
                              style: GoogleFonts.roboto(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.facebook_rounded,
                                    color: Colors.grey[600],
                                    size: 28.0,
                                  ),
                                  onPressed: () async {
                                    await launchUrl(Uri.parse(instituteData['facebook']!));
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.email_rounded,
                                    color: Colors.grey[600],
                                    size: 28.0,
                                  ),
                                  onPressed: () async {
                                    await launchUrl(Uri(
                                      scheme: 'mailto',
                                      path: instituteData['email']!,
                                    ));
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.call_rounded,
                                    color: Colors.grey[600],
                                    size: 28.0,
                                  ),
                                  onPressed: () async {
                                    await launchUrl(Uri(
                                      scheme: 'tel',
                                      path: instituteData['phoneNum']!,
                                    ));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 1.0,
              color: Colors.grey[400],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 25.0, 16.0, 50.0),
              child: Card(
                elevation: 4,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset(
                          'images/yassin.png',
                          width: 120.0,
                          height: 120.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Développé & conçu par',
                        style: GoogleFonts.roboto(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Yassin MANITA',
                        style: GoogleFonts.lexend(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.public_rounded,
                              color: Colors.grey[600],
                              size: 28.0,
                            ),
                            onPressed: () async {
                              await launchUrl(Uri.parse('https://www.example.com'));
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.email_rounded,
                              color: Colors.grey[600],
                              size: 28.0,
                            ),
                            onPressed: () async {
                              await launchUrl(Uri(
                                scheme: 'mailto',
                                path: 'yassinmanita12@gmail.com',
                              ));
                            },
                          ),
                          IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.linkedin,
                              color: Colors.grey[600],
                              size: 28.0,
                            ),
                            onPressed: () async {
                              await launchUrl(Uri.parse('https://www.linkedin.com/in/yassin-manita'));
                            },
                          ),
                          IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.github,
                              color: Colors.grey[600],
                              size: 28.0,
                            ),
                            onPressed: () async {
                              await launchUrl(Uri.parse('https://github.com/WYMma'));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
