import 'package:alphalist/list_alphabets.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';

enum LetterAlignment {left, right}

class AlphabetScrollView extends StatefulWidget{
  final List<AlphaModel> list;
  final double itemExtent;
  final LetterAlignment alignment;
  final bool isAlphabetsFiltered;
  final TextStyle selectedTextStyle;
  final TextStyle unselectedTextStyle;
  Widget Function(BuildContext,int,String) itemBuilder;

   AlphabetScrollView(
      {Key? key,
      required this.list,
        this.itemExtent = 40,
        this.alignment = LetterAlignment.right,
        this.isAlphabetsFiltered = true,
        required this.selectedTextStyle,
        required this.unselectedTextStyle,
        required this.itemBuilder
      }) : super(key: key);

  @override
  _AlphabetScrollView createState() => _AlphabetScrollView();
}

class _AlphabetScrollView extends State<AlphabetScrollView>{

  ScrollController listController = ScrollController();
  final _selectedIndexNotifier = ValueNotifier<int>(0);
  final positionNotifier = ValueNotifier<Offset>( Offset(0,0));
  final Map<String,int> firstIndexPosition = {};
  List<String> _filteredAlphabets = [];
  final letterKey = GlobalKey();
  List<AlphaModel> _list = [];
  bool isLoading = false;
  bool isFocused = false;
  final key = GlobalKey();
  double? maxScroll;

  void init(){
    widget.list.sort((x,y) => x.key.toLowerCase().compareTo(y.key.toLowerCase()));
    _list = widget.list;
    if( widget.isAlphabetsFiltered ){
      List<String> temp = [];
      for (var letter in alphabets) {
        AlphaModel? firstAlphabetElement = _list.firstWhereOrNull(
            (item) => item.key.toLowerCase().startsWith(letter.toLowerCase()));
        if( firstAlphabetElement != null ){
          temp.add(letter);
        }
      }
      _filteredAlphabets = temp;
    }
    else{
      _filteredAlphabets = alphabets;
    }
    calculateFirstIndex();
  }

  @override
  void initState() {
    init();
    if (listController.hasClients) {
      maxScroll = listController.position.maxScrollExtent;
    }
    super.initState();
  }
  @override
  void didUpdateWidget(covariant AlphabetScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.list != widget.list ||
        oldWidget.isAlphabetsFiltered != widget.isAlphabetsFiltered) {
      _list.clear();
      firstIndexPosition.clear();
      init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
            controller: listController,
            scrollDirection: Axis.vertical,
            itemCount: _list.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, x) {
              return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: widget.itemExtent),
                  child: widget.itemBuilder(_, x, _list[x].key));
            }
        ),
        Align(
          alignment: widget.alignment == LetterAlignment.left
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Container(
            key: key,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: SingleChildScrollView(
              child: GestureDetector(
                onVerticalDragStart: (z) => onVerticalDrag(z.localPosition),
                onVerticalDragUpdate: (z) => onVerticalDrag(z.localPosition),
                onVerticalDragEnd: (z) {
                  setState(() {
                    isFocused = false;
                  });
                },
                child: ValueListenableBuilder<int>(
                    valueListenable: _selectedIndexNotifier,
                    builder: (context, int selected, Widget? child) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _filteredAlphabets.length,
                                (x) => GestureDetector(
                              key: x == selected ? letterKey : null,
                              onTap: () {
                                _selectedIndexNotifier.value = x;
                                scrollToIndex(x, positionNotifier.value);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      _filteredAlphabets[x].toUpperCase(),
                                      style: selected == x
                                          ? widget.selectedTextStyle
                                          : widget.unselectedTextStyle,
                                    ),

                                  ],
                                )
                              ),
                            ),
                          ));
                    }),
              ),
            ),
          ),
        ),
      ],
    );
  }
  int getCurrentIndex(double vPosition) {
    double kAlphabetHeight = letterKey.currentContext!.size!.height;
    return (vPosition ~/ kAlphabetHeight);
  }

  void calculateFirstIndex() {
    _filteredAlphabets.forEach((letter) {
      AlphaModel? firstElement = _list.firstWhereOrNull(
              (item) => item.key.toLowerCase().startsWith(letter));
      if (firstElement != null) {
        int index = _list.indexOf(firstElement);
        firstIndexPosition[letter] = index;
      }
    });
  }
  void scrollToIndex(int x, Offset offset) {
    int index = firstIndexPosition[_filteredAlphabets[x].toLowerCase()]!;
    final scrollToPosition = widget.itemExtent * index;
    if (index != null) {
      listController.animateTo((scrollToPosition),
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
    positionNotifier.value = offset;
  }

  void onVerticalDrag(Offset offset) {
    int index = getCurrentIndex(offset.dy);
    if (index < 0 || index >= _filteredAlphabets.length) return;
    _selectedIndexNotifier.value = index;
    setState(() {
      isFocused = true;
    });
    scrollToIndex(index, offset);
  }
}

class AlphaModel {
  final String key;
  AlphaModel(this.key);
}