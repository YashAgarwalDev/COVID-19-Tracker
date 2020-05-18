import 'package:covid19_tracker_application/bloc/zones_bloc.dart';
import 'package:covid19_tracker_application/ui/widgets/search_districts.dart';
import 'package:covid19_tracker_application/ui/widgets/zone_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Zones extends StatefulWidget {
  @override
  _ZonesState createState() => _ZonesState();
}

class _ZonesState extends State<Zones> with AutomaticKeepAliveClientMixin {
  @override
  void didChangeDependencies() {
    BlocProvider.of<ZonesBloc>(context).add(FetchZone());

    //do whatever you want with the bloc here.
    super.didChangeDependencies();
  }

  var zoneData;
  var zoneDataLength;
  bool zoneLoad = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () => zoneLoad
            ? showSearch(
                context: context,
                delegate: SearchDistricts(zoneDataLength, zoneData))
            : null,
      ),
      body: BlocBuilder<ZonesBloc, ZonesState>(
        builder: (BuildContext context, ZonesState state) {
          if (state is ZoneLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ZoneLoaded) {
            zoneLoad = true;
            zoneData = state.zoneData;
            zoneDataLength = state.zoneDataLength;
            // final Color a = zoneData['zones'][1]['zone'].toLowerCase();
            // print(a);

            zoneColor(int index) {
              if (zoneData['zones'][index]['zone'] == 'Green') {
                return Color(0xFFE1F2E8);
              } else if (zoneData['zones'][index]['zone'] == 'Red') {
                return Color(0xFFFDE1E1);
              } else if (zoneData['zones'][index]['zone'] == 'Orange') {
                return Colors.orange.withOpacity(.2);
              }
            }

            textColor(int index) {
              if (zoneData['zones'][index]['zone'] == 'Green') {
                return Color(0xFF41A745);
              } else if (zoneData['zones'][index]['zone'] == 'Red') {
                return Color(0xFFF83F38);
              } else if (zoneData['zones'][index]['zone'] == 'Orange') {
                return Colors.orange;
              }
            }

            // print(zoneData);

            return ListView.builder(
              itemCount: zoneDataLength.length,
              shrinkWrap: true,
              // physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ZoneCard(
                  color: zoneColor(index),
                  district: zoneData['zones'][index]['district'],
                  state: zoneData['zones'][index]['state'],
                  textColor: textColor(index),
                );
              },
            );
          }
          if (state is ZoneError) {
            return Text('Something went wrong!');
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
