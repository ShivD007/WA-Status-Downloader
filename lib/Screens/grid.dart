import 'dart:io';
import 'package:providert/view.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:flutter/material.dart';
import '../Providers/imageVideoProvider.dart';

class Grid extends StatelessWidget {
  const Grid({Key key, @required this.provider, this.flag}) : super(key: key);

  final ImageVideoProviders provider;
  final int flag;
  
  @override
  Widget build(BuildContext context) {
    
     List<String> _tempList=flag == 0 ? provider.getlist:provider.getvideoList;

    _getImage(videoPathUrl) async {
      String thumb = await Thumbnails.getThumbnail(
          thumbnailFolder: '/storage/emulated/0/statusdownloader/.Thumbnails',
          videoFile: videoPathUrl,
          imageType:
              ThumbFormat.PNG, //this image will store in created folderpath
          quality: 5);
      return thumb;
    }

    return GridView.builder(
      
        shrinkWrap: true,
        itemCount: _tempList.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            maxCrossAxisExtent: 140),
        itemBuilder: (ctx, index) {
                return flag == 0
              ? InkWell(
                  child: Container(
                     child: Hero( tag: provider.getlist[index],
                                              child: 
                                              Image.file(
                    File(provider.getlist[index]),
                    fit: BoxFit.cover,
                     filterQuality: FilterQuality.low,
                  ),
                       )
                      ),
                  onTap: () {
                    
                             return Navigator.of(context).pushNamed("/view", arguments: {
                  
                  "index": index,
                  "flag": flag
                });
                  


                  })
              : FutureBuilder(
                  future: _getImage(provider.getvideoList[index]),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Center(child: Text("Please Wait"));
                        break;
                      case ConnectionState.waiting:
                        return Center(child: Image.asset("assets/images/200.gif"));
                        break;
                      case ConnectionState.active:
                        return Center(child: Text("Please Wait"));
                        break;
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else {
                          return InkWell(
                                                      child: Image.file(
                              File(snapshot.data),
                              fit: BoxFit.cover,
                               filterQuality: FilterQuality.low,
                            ),

                            onTap: (){
                              print(snapshot.data);

                             return Navigator.of(context).pushNamed("/view", arguments: {
                  
                  "index": index,
                  "flag": flag
                });
                                  


                          


                            },
                          );
                        }
                        break;
                      default:
                          return Image.file(
                            File(snapshot.data),
                            fit: BoxFit.cover,
                          );
                        }
                  });
        });
  }
}
