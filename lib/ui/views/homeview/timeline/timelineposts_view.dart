import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iati/locator.dart';
import 'package:iati/ui/views/homeview/timeline/timelineposts_viewmodel.dart';
import 'package:iati/ui/widgets/app_progress_indicatior.dart';
import 'package:iati/ui/widgets/creation_aware_list_item.dart';
import 'package:stacked/stacked.dart';

import 'postthumbnail/postthumbnail_view.dart';


class TimeLinePostsView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TimeLinePostsViewModel>.reactive(
        disposeViewModel: false,
        initialiseSpecialViewModelsOnce: true,
        fireOnModelReadyOnce: true,
        onModelReady: (model){
          model.listenToData();
        },
        builder: (context,model,child){
      return model.isBusy?Center(child: AppProgressIndication(),):ListView.builder(
        key: PageStorageKey("posts"),
        itemBuilder: (context,index){
        return CreationAwareListItem(
            key: Key(model.timeLinePosts[index].id),
            itemCreated: (){
              print("created $index");
              if((index+1)%5==0 && index !=0){
                print("getting more data");
                model.requestMoreData();
              }
            },
            child: PostThumbnailView(post: model.timeLinePosts[index],));
      },itemCount: model.timeLinePosts.length,);
    }, viewModelBuilder: ()=>locator<TimeLinePostsViewModel>());
  }

}
