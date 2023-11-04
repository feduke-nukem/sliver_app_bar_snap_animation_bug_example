import 'package:flutter/material.dart';

void main() => runApp(const NestedScrollViewExampleApp());

class NestedScrollViewExampleApp extends StatelessWidget {
  const NestedScrollViewExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NestedScrollViewExample(),
    );
  }
}

class NestedScrollViewExample extends StatefulWidget {
  const NestedScrollViewExample({super.key});

  @override
  State<NestedScrollViewExample> createState() =>
      _NestedScrollViewExampleState();
}

class _NestedScrollViewExampleState extends State<NestedScrollViewExample> {
  @override
  Widget build(BuildContext context) {
    final List<String> tabs = <String>['Tab 1', 'Tab 2'];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  surfaceTintColor: Colors.transparent,
                  leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.close),
                  ),
                  title: const Text('Books'),
                  pinned: true,
                  snap: true,
                  floating: true,
                  expandedHeight: 180.0,
                  forceElevated: innerBoxIsScrolled,
                  bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(128),
                    child: _Bottom(),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: tabs.map((String name) {
              return SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      key: PageStorageKey<String>(name),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(8.0),
                          sliver: SliverFixedExtentList(
                            itemExtent: 48.0,
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return ListTile(
                                  title: Text('Item $index'),
                                );
                              },
                              childCount: 30,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _Bottom extends StatefulWidget {
  const _Bottom();

  @override
  State<_Bottom> createState() => _BottomState();
}

class _BottomState extends State<_Bottom> {
  final controller = TextEditingController();
  final _scrollController = ScrollController();
  final focusNode = FocusNode();
  final _textKey = GlobalKey<EditableTextState>();

  final TextStyle style = const TextStyle(
    fontSize: 20,
    color: Colors.black,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Focus(
          child: EditableText(
            key: _textKey,
            scrollController: _scrollController,
            controller: controller,
            focusNode: focusNode,
            style: style,
            cursorColor: Colors.red,
            backgroundCursorColor: Colors.black,
          ),
        ),
        TabBar(
          // These are the widgets to put in each tab in the tab bar.
          tabs: <String>['Tab 1', 'Tab 2']
              .map((String name) => Tab(text: name))
              .toList(),
        )
      ],
    );
  }
}
