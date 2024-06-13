import 'dart:developer';

import 'package:app/chatmodel.dart';
import 'package:app/classes.dart';
import 'package:app/firebase_options.dart';
// import 'package:app/first.dart';
import 'package:app/memberprovider.dart';
import 'package:app/splash-screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  // call the useSystemCallingUI
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );

    runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(create: (context) => ChatImgProvider()),
          ChangeNotifierProvider(create: (context) => MemberProvider()),
        ],
        child: MyApp(
          navigatorKey: navigatorKey,
        )));
  });
}

class MyApp extends StatefulWidget {
  MyApp({super.key, required this.navigatorKey});
  GlobalKey<NavigatorState> navigatorKey;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    //
    Provider.of<UserProvider>(context,listen: false).getuserdata();
    initZegoLogin();
  }

  initZegoLogin() async {
    if (FirebaseAuth.instance.currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      Model user = Model.fromMap(snapshot.data()!);
      log('User Provider ${snapshot.data()}');
      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: 1663029138,
        appSign:
            '6e17e25436ebb75f3873dc684df07e4583f90e4313b73be77f86c0431ab2c70e',
        userID: user.uid1,
        userName: user.name,
        plugins: [ZegoUIKitSignalingPlugin()],
        // notificationConfig: ZegoCallInvitationNotificationConfig(
        //   androidNotificationConfig: ZegoCallAndroidNotificationConfig(
        //     showFullScreen: true,
        //     channelID: "ZegoUIKit",
        //     channelName: "Call Notifications",
        //     sound: "call",
        //     icon: "call",
        //   ),
        //   iOSNotificationConfig: ZegoCallIOSNotificationConfig(
        //     systemCallingIconName: 'CallKitIcon',
        //   ),
        // ),
        requireConfig: (ZegoCallInvitationData data) {
          final config = (data.invitees.length > 1)
              ? ZegoCallType.videoCall == data.type
                  ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                  : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
              : ZegoCallType.videoCall == data.type
                  ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                  : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

          /// custom avatar
          // config.avatarBuilder = customAvatarBuilder;

          /// support minimizing, show minimizing button
          // config.topMenuBar.isVisible = true;
          // config.topMenuBar.buttons
          //     .insert(0, ZegoCallMenuBarButtonName.minimizingButton);

          return config;
        },
      );
    }
  }

  Widget customAvatarBuilder(
    BuildContext context,
    Size size,
    ZegoUIKitUser? user,
    Map<String, dynamic> extraInfo,
  ) {
    return CachedNetworkImage(
      imageUrl:
          Provider.of<UserProvider>(context, listen: false).user!.imageurl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) {
        ZegoLoggerService.logInfo(
          '$user avatar url is invalid',
          tag: 'live audio',
          subTag: 'live page',
        );
        return ZegoAvatar(user: user, avatarSize: size);
      },
    );
  }

  getdata() {
    if (FirebaseAuth.instance.currentUser != null) {
      Provider.of<UserProvider>(context, listen: false).getuserdata();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      key: widget.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          // useMaterial3: true,
          ),
      home: const Splash(),
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: [
            child!,

            /// support minimizing
            ZegoUIKitPrebuiltCallMiniOverlayPage(
              contextQuery: () {
                return widget.navigatorKey.currentState!.context;
              },
            ),
          ],
        );
      },
    );
  }
}
