import 'package:flutter/material.dart';
import '../service.dart';

class ProfilePage extends StatefulWidget {
  final String accessToken;
  const ProfilePage({Key? key, required this.accessToken}) : super(key: key);
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final double profileHeight = 144;
  final double coverHeight = 125;
  List _mySub = [];

  Future<Map<String, String>> _getProfil() async {
    Map<String, String> profil = await getProfil(widget.accessToken);
    var mySub = await subredditsSubscribed(widget.accessToken);
    if (mounted) {
      setState(() {
        _mySub = mySub;
      });
    }
    return profil;
  }

  Widget buildCoverImage(String url) => Container(
          child: Image.network(url,
              width: double.infinity,
              height: coverHeight,
              fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
        return Image.network(
            'https://img.freepik.com/photos-gratuite/vieux-fond-noir-texture-grunge-fond-ecran-sombre-tableau-noir-tableau-noir-mur-salle_1258-28313.jpg?size=626&ext=jpg&ga=GA1.2.222193752.1635033600');
      }));

  Widget buildProfileImage(String url) => CircleAvatar(
        backgroundImage: NetworkImage(
          url,
        ),
        radius: profileHeight / 2,
      );

  Widget buildTop(AsyncSnapshot snapshot) {
    final top = coverHeight - profileHeight / 2;
    final bottom = profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: bottom),
            child: buildCoverImage(snapshot.data['header_img'])),
        Positioned(top: top, child: buildProfileImage(snapshot.data['img']))
      ],
    );
  }

  Widget buildNumber(AsyncSnapshot snapshot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(snapshot.data['subscribers'],
                style: const TextStyle(fontSize: 15)),
            Text(
                snapshot.data['subscribers'] == "0"
                    ? "Subcriber"
                    : "Subcribers",
                style: const TextStyle(fontSize: 10))
          ],
        ),
        const SizedBox(width: 30),
        Column(
          children: [
            Text(snapshot.data['coins'], style: const TextStyle(fontSize: 15)),
            Text(snapshot.data['coins'] == "0" ? "coin" : "coins",
                style: const TextStyle(fontSize: 10))
          ],
        )
      ],
    );
  }

  void _unsub(String subName) async {
    var id = await getID(subName);
    var response = await unsubscribe(id, widget.accessToken);
    var mySub = await subredditsSubscribed(widget.accessToken);
    setState(() {
      _mySub = mySub;
    });
  }

  Widget buildSubreddit(AsyncSnapshot snapshot) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _mySub.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_mySub[index]),
            trailing: IconButton(
              icon: const Icon(Icons.star),
              onPressed: () {
                _unsub(_mySub[index]);
              },
            ),
          );
        });
  }

  Widget buildContent(AsyncSnapshot snapshot) {
    return Column(
      children: [
        Center(
            child: Text(
          snapshot.data['username'],
          style: const TextStyle(fontSize: 20),
        )),
        const SizedBox(height: 16),
        buildNumber(snapshot),
        const SizedBox(height: 16),
        buildSubreddit(snapshot)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: _getProfil(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[buildTop(snapshot), buildContent(snapshot)],
            );
          } else {
            return Text("Loading..");
          }
        });
  }
}
