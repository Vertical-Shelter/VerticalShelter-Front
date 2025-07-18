import 'package:app/core/app_export.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Mousquette extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl:
            "https://storage.googleapis.com/vertical-shelter-prod.appspot.com/mousquettes/Mousquette%20rayure%20blanche.png",
        height: 30,
);
        
  }
}
