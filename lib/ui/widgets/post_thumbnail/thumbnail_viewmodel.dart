import 'package:flutter/foundation.dart';
import 'package:iati/locator.dart';
import 'package:iati/models/post.dart';
import 'package:iati/ui/views/post_views/post_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ThumbnailViewModel extends BaseViewModel{
  final NavigationService _navigationService = locator<NavigationService>();
  goToPostPreview({@required Post post}){
    _navigationService.navigateToView(PostView(post: post,));
  }
}