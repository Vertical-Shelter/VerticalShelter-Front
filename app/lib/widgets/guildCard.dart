import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/APIrequest.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/VSL/GuildResp.dart';
import 'package:app/data/models/VSL/UserVSLResp.dart';
import 'package:app/widgets/climbingLocationMinimalist.dart';

class GuildCard extends StatelessWidget {
  final BuildContext context;
  final GuildResp guild;
  final ClimbingLocationResp? climbingLocationMinimalResp;
  final Function()? onPressed;

  const GuildCard({
    required this.context,
    required this.guild,
    required this.climbingLocationMinimalResp,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 150,
      decoration: BoxDecoration(
        color: ColorsConstantDarkTheme.purple,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorsConstantDarkTheme.secondary,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: width*0.30,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(18), bottomLeft: Radius.circular(18)),
              child: Image.network(guild.image_url!, fit: BoxFit.cover,)
            ),
            
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  guild.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              climbingLocationMinimalResp == null ? getClimbingLocation(context)
              : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 30,
              child: FittedBox(
                child: ClimbingLocationMinimalistWidget(context, climbingLocationMinimalResp!, onPressed: onPressed,),
              ),
            ),),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      rolepreview(context, null, null, true),
                      rolepreview(context, guild.ninja,'ninja', false),
                      SizedBox(width: 10),
                      rolepreview(context, guild.slabmaster,'gecko', false),
                      SizedBox(width: 10),
                      rolepreview(context, guild.hulk,'gorille', false),
                    ],
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget getClimbingLocation(BuildContext context){
    return FutureBuilder<ClimbingLocationResp>(
      future: climbingLocation_get(guild.climbingLocation_id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Center(child: CircularProgressIndicator(color: ColorsConstantDarkTheme.secondary,)),
          );
        } else{
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 30,
              child: FittedBox(
                child: ClimbingLocationMinimalistWidget(context, snapshot.data!, onPressed: onPressed,),
              ),
            ),
          );
        }
      }
    );
  }

  Widget rolepreview(BuildContext context, UserVSLResp? role, String? name, bool isCount){
    return Stack(
      children: [
        SizedBox(height: 70),
        
        isCount ? SizedBox(width: 50,)
        : Image.asset('assets/images/mascot_$name.png', height: 50),

        Positioned(
          bottom: 0,
          left: 20,
          child: isCount ? Text('${nbMember()}/3')
          : role != null? Text("H")
          :SizedBox()),

        if (role == null && !isCount)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: ColorsConstantDarkTheme.purple.withOpacity(0.6),
              ),
            )
          )
      ],
    );
  }

  int nbMember(){
    int nb = 0;
    if(guild.hulk != null){
      nb ++;
    }
    if(guild.slabmaster != null){
      nb ++;
    }
    if(guild.ninja != null){
      nb ++;
    }
    return nb;
  }
}
