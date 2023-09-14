import 'package:celta_inventario/api/firebase_helper.dart';
import 'package:celta_inventario/api/url_launcher.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/components/Global_widgets/show_alert_dialog.dart';
import 'package:celta_inventario/providers/login_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  Widget drawerItem({
    required BuildContext context,
    required Function()? onTap,
    required String text,
    required Widget leading,
  }) {
    return InkWell(
      onTap: onTap,
      child: PersonalizedCard.personalizedCard(
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Container(
                height: 35,
                width: 35,
                child: leading,
              ),
              const Padding(padding: EdgeInsets.only(right: 20)),
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image.asset(
                "lib/assets/Images/LogoCeltaTransparente.png",
                fit: BoxFit.cover,
              ),
            ),
            drawerItem(
              context: context,
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  APPROUTES.TECHNICAL_SUPPORT,
                );
              },
              text: "Suporte técnico",
              leading: const Icon(Icons.add_call),
            ),
            drawerItem(
              context: context,
              onTap: () async {
                await UrlLauncher.searchAndLaunchUrl(
                  context: context,
                  url: 'https://www.celtaware.com.br',
                );
                FirebaseHelper.addClickedInLink(
                  firebaseCallEnum: FirebaseCallEnum.aboutUs,
                );
              },
              text: "Sobre nós",
              leading: Image.asset(
                "lib/assets/Images/iconeCeltaware.jpg",
                fit: BoxFit.cover,
              ),
            ),
            drawerItem(
              context: context,
              onTap: () async {
                await UrlLauncher.searchAndLaunchUrl(
                  context: context,
                  url: 'https://www.instagram.com/celtaware_erp',
                );
                FirebaseHelper.addClickedInLink(
                  firebaseCallEnum: FirebaseCallEnum.instagram,
                );
              },
              text: "Instagram",
              leading: Image.asset(
                "lib/assets/Images/instagram.jpg",
                fit: BoxFit.cover,
              ),
            ),
            drawerItem(
              context: context,
              onTap: () async {
                await UrlLauncher.searchAndLaunchUrl(
                  context: context,
                  url: 'https://www.linkedin.com/company/celtaware',
                );
                FirebaseHelper.addClickedInLink(
                  firebaseCallEnum: FirebaseCallEnum.linkedin,
                );
              },
              text: "Linkedin",
              leading: Image.asset(
                "lib/assets/Images/linkedin.jpg",
                fit: BoxFit.cover,
              ),
            ),
            drawerItem(
              context: context,
              onTap: () async {
                await UrlLauncher.searchAndLaunchUrl(
                  context: context,
                  url: 'https://m.facebook.com/Celtaware',
                );
                FirebaseHelper.addClickedInLink(
                  firebaseCallEnum: FirebaseCallEnum.facebook,
                );
              },
              text: "Facebook",
              leading: Image.asset(
                "lib/assets/Images/facebook.jpg",
                fit: BoxFit.cover,
              ),
            ),
            drawerItem(
              context: context,
              onTap: () async {
                Navigator.of(context).pop();
                ShowAlertDialog().showAlertDialog(
                  context: context,
                  title: 'Deseja fazer o logout?',
                  function: () async {
                    await loginProvider.logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        APPROUTES.LOGIN_OR_HOME_PAGE, (route) => false);
                  },
                );
              },
              text: "Sair",
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
