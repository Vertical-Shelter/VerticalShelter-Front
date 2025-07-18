import 'package:app/core/app_export.dart';
import 'package:app/data/models/SentWall/sentWallResp.dart';
import 'package:app/widgets/profil/profilMinivertical.dart';
import 'package:app/widgets/vid%C3%A9oCapture.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class BetaWidget extends StatefulWidget {
  SentWallResp sentWallResp;

  BetaWidget({required this.sentWallResp});

  @override
  _BetaWidgetState createState() => _BetaWidgetState();
}

class _BetaWidgetState extends State<BetaWidget> {
  late SentWallResp sentWallResp;
  // RxString thumbnailUrl = "".obs;
  String thumbnailUrl = "";

  @override
  void initState() {
    sentWallResp = widget.sentWallResp;
    _initUrl(sentWallResp);
    super.initState();
  }

  Future<void> _initUrl(SentWallResp sentWallResp) async {
    try {
      String instagramUrl = sentWallResp.beta_url!;
      var data = await MetadataFetch.extract(instagramUrl);
      if (data != null && data.image != null && data.image!.isNotEmpty) {
        setState(() {
          thumbnailUrl = data.image!;
        });
      } else {
        print("Error: No image found in metadata.");
      }
    } catch (e) {
      print("Error fetching metadata: $e");
    }
  }

//   @override
  Widget build(BuildContext context) {
    //print(Uri.parse(sentWallResp.beta_url!));
    //InitUrl();
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.surface),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: EdgeInsets.all(10),
                child: ProfileMiniVertical(
                    id: sentWallResp.user!.id,
                    name: sentWallResp.user!.username,
                    image: sentWallResp.user!.image)),
            _isValidInstagramUrl(sentWallResp.beta!) == false
                ? VideoCapture(
                    'betaUsers',
                    wantKeepAlive: true,
                    controller: VideoPlayerController.networkUrl(
                      Uri.parse(sentWallResp.beta!),
                    ),
                    isReadOnly: true,
                  )
                : Center(
                    child: GestureDetector(
                      onTap: () => _launchURL(sentWallResp.beta_url!),
                      child: !thumbnailUrl.isEmpty
                          ? Image.network(
                              thumbnailUrl,
                              fit: BoxFit.fitHeight,
                            )
                          : Center(child: CircularProgressIndicator()),
                    ),
                  )

            // _isValidInstagramUrl(sentWallResp.beta!) == false ?
            // VideoCapture(
            //   'betaUsers',
            //   wantKeepAlive: true,
            //   controller: VideoPlayerController.networkUrl(
            //     Uri.parse(sentWallResp.beta!),
            //   ),
            //   isReadOnly: true,
            // )
            // : Obx(() =>  Center(
            //   child: GestureDetector(
            //       onTap: () => _launchURL(sentWallResp.beta_url!),
            //       child:
            //       !controller.thumbnailUrl.isEmpty ?
            //       Image.network(
            //         controller.thumbnailUrl.value,
            //         height: 200,
            //         fit: BoxFit.cover,
            //       )
            //       : Center(child: CircularProgressIndicator())
            //     ),
            // ),),
          ]),
    );
  }

  // void InitUrl() async {
  //   String instagramUrl = sentWallResp.beta_url!;
  //         // Obtenez les métadonnées
  //         var data = await MetadataFetch.extract(instagramUrl);
  //         if (data != null && data.image != null && data.image!.isNotEmpty) {
  //             thumbnailUrl.value = data.image!;  // Récupère l'image de prévisualisation
  //         }
  // }
  Future<VideoPlayerController?> _initializeVideoPlayer(String url) async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    try {
      await controller.initialize();
      return controller;
    } catch (e) {
      print("Erreur lors de l'initialisation de la vidéo : $e");
      return null;
    }
  }

  bool _isValidInstagramUrl(String url) {
    // Vérifie que l'URL commence par https://www.instagram.com/
    final instagramRegex = RegExp(r"^(https?:\/\/)?(www\.)?instagram\.com\/");
    return instagramRegex.hasMatch(url);
  }

Future<void> _launchURL(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Impossible d\'ouvrir l\'URL : $url';
  }
}

 
}
