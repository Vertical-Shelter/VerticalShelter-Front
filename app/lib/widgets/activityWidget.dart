import 'package:app/core/app_export.dart';
import 'package:app/widgets/profil/profilImage.dart';
import 'package:app/data/models/User/user_resp.dart';

class ActivityWidget extends StatelessWidget {
  UserMinimalResp user;
  String message;
  ActivityWidget({Key? key, required this.user, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
    profileImage(image: user.image),
    SizedBox(width: width * 0.02),
    Text(
      user.username!,
      style: AppTextStyle.rr14.copyWith(fontWeight: FontWeight.w600),
    ),
    SizedBox(width: width * 0.02),
    Text(message, style: AppTextStyle.rr14),
          ],
        );
  }
}
