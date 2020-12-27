import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:iati/core/services/firestore_service.dart';
import 'package:iati/locator.dart';
import 'package:iati/models/post.dart';
import 'package:iati/routes/routes_const.dart';
import 'package:iati/ui/views/post_views/post_view.dart';
import 'package:stacked_services/stacked_services.dart';

class DynamicLinksService{

  final NavigationService _navigationService=locator<NavigationService>();
  final FirestoreService _firestoreService =locator<FirestoreService>();
  Future<Map> handleDynamicLinks()async{
    Map<String,dynamic> deepLinkData=Map<String,dynamic>();
    final pendingDynamicLinkData=await FirebaseDynamicLinks.instance.getInitialLink();
    deepLinkData=await _handleDeepLinks( pendingDynamicLinkData);

     FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLinkData)async{
        deepLinkData=await _handleDeepLinks(dynamicLinkData);
      },
      onError: (OnLinkErrorException e)async{
        print("dynamic link failed ${e.message}");
    }
    );
     return deepLinkData;
  }

  Future<Map> _handleDeepLinks(PendingDynamicLinkData data)async{
    final Uri deepLink=data?.link;
    Map<String,dynamic> urlData=Map<String,dynamic>();
    if(deepLink!=null){
      urlData[deepLink.pathSegments.first]=deepLink.pathSegments.last;
      if(urlData.containsKey("user")){
        await _navigationService.navigateTo(userProfileView,arguments: urlData['user']);
      }else if(urlData.containsKey("post")){
        Post post= await _firestoreService.getSinglePost(urlData['post']);
        await _navigationService.navigateToView(PostView(post: post,));
      }
      print("handle deep link | deeplink $deepLink");
    }

  }


  Future<String> createUserLink(String userId)async{
    final DynamicLinkParameters parameters=DynamicLinkParameters(uriPrefix: "https://iatiapp.page.link",
      link: Uri.parse("https://iatiapp.com/user/$userId"),
      androidParameters: AndroidParameters(
        packageName: 'com.iatiapp.iati',
      ),
      iosParameters: IosParameters(
        bundleId: 'com.iatiapp.iatindustry',
        minimumVersion: '1.0.3',
        appStoreId: '1536165810',
      ),
    );

    final ShortDynamicLink dynamicLink=await parameters.buildShortLink();

    final Uri shortUrl = dynamicLink.shortUrl;

    return shortUrl.toString();
  }

  Future<String> createPostLink(String postId)async{
    final DynamicLinkParameters parameters=DynamicLinkParameters(uriPrefix: "https://iatiapp.page.link",
        link: Uri.parse("https://iatiapp.com/post/$postId"),
      androidParameters: AndroidParameters(
        packageName: 'com.iatiapp.iati',
      ),
      iosParameters: IosParameters(
        bundleId: 'com.iatiapp.iatindustry',
        minimumVersion: '1.0.3',
        appStoreId: '1536165810',
      ),
    );

    final ShortDynamicLink dynamicLink=await parameters.buildShortLink();

    final Uri shortUrl = dynamicLink.shortUrl;

    return shortUrl.toString();
  }
}