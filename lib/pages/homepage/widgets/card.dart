part of './widgets.dart';

Card CustomerCard(
    BuildContext context, List<Mark> marks, int index, Function refresh) {
  return Card(
    margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
    color: Color(0xffFFFFFF),
    elevation: 2.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    clipBehavior: Clip.antiAlias,
    semanticContainer: false,
    child: Column(
      children: <Widget>[
        Container(
          height: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: NetworkImage(marks[index].picture),
            fit: BoxFit.cover,
          )),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          // height: 240,
          // color: Color(colorCodes[index % colorCodes.length]),
          child: ListTile(
            leading: GestureDetector(
              onTap: () {
                launchURL(marks[index].url);
              },
              child: Container(
                height: 35,
                width: 35,
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: marks[index].icon.startsWith("http")
                            ? () {
                                ImageProvider<Object> result;
                                try {
                                  result = NetworkImage(marks[index].icon);
                                } catch (Expection) {
                                  result =
                                      AssetImage("assets/images/default.png");
                                }
                                return result;
                              }()
                            : AssetImage("assets/images/default.png"),
                        fit: BoxFit.fill)),
              ),
            ),
            title: GestureDetector(
              onTap: () {
                launchURL(marks[index].url);
              },
              child: Text(
                marks[index].title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18),
              ),
            ),
            subtitle: Container(
              margin: EdgeInsets.only(top: 5),
              child: Column(
                children: <Widget>[
                  Text(
                    marks[index].sub_title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    // height: 60,
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Tags(
                              itemCount: marks[index].tags.length,
                              itemBuilder: (int tagIndex) {
                                final item = marks[index].tags[tagIndex];

                                return Container(
                                  height: 22,
                                  margin: EdgeInsets.only(top: 6),
                                  child: ItemTags(
                                    elevation: 2,
                                    border:
                                        Border.all(color: Color(0xffFFFFFF)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 0),
                                    key: Key(tagIndex.toString()),
                                    index: tagIndex,
                                    title: item.name,
                                    textStyle: TextStyle(
                                      color: Color(0xff000000),
                                      fontSize: 12,
                                    ),
                                    active: false,
                                    color: Color(0xffFFFFFF),
                                    textColor: Color(0xff000000),
                                    textActiveColor: Color(0xff000000),
                                    activeColor: Color(0xff607D8B),
                                    combine: ItemTagsCombine.withTextBefore,
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                        // Stack(children: <Widget>[
                        Container(
                            height: 32,
                            width: 32,
                            margin: EdgeInsets.fromLTRB(251, 0, 0, 0),
                            child: IconButton(
                                onPressed: () {
                                  moreFunction(
                                      context, index, marks[index].id, refresh);
                                },
                                icon: Image.asset(
                                    'assets/images/morefunction.png')))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

moreFunction(
    BuildContext context, int index, int id, Function() refresh) async {
  await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text('其他功能'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              addTag(context, index, id, refresh);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: const Text('增加标签'),
            ),
          ),
        ],
      );
    },
  );
}
