//Packages
import 'package:bubbles_app/constants/bubble_key_types.dart';
import 'package:bubbles_app/models/activity.dart';
import 'package:bubbles_app/providers/bubble_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Widgets
import '../../models/bubble.dart';
import '../../models/message.dart';
import '../../providers/authentication_provider.dart';
import '../../widgets/custom_input_fields.dart';
import '../../widgets/custom_list_view_tiles.dart';
import 'Edit_bubble.dart';

class BubblePage extends StatefulWidget {
  final Bubble bubble;

  const BubblePage({super.key, required this.bubble});

  @override
  State<StatefulWidget> createState() {
    return _BubblePageState();
  }
}

class _BubblePageState extends State<BubblePage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late BubblePageProvider _pageProvider;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messagesListViewController;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messagesListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);

    _auth.appUser.addActivity(Activity(
      "You joined ${widget.bubble.name}",
      DateTime.now(),
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BubblePageProvider>(
          create: (_) => BubblePageProvider(
              widget.bubble.uid, _auth, _messagesListViewController),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext context) {
        _pageProvider = context.watch<BubblePageProvider>();
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor:
                BubbleKeyType.getColorByIndex(widget.bubble.keyType.index),
            title: Row(
              children: [
                CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(widget.bubble.image)),
                const SizedBox(width: 10),
                Text(
                  widget.bubble.name,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return EditPage(
                        bubble: widget.bubble,
                      );
                    },
                  ));
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  color:
                      BubbleKeyType.getColorByIndex(widget.bubble.keyType.index)
                          .withOpacity(0.05),
                  padding: EdgeInsets.symmetric(
                    horizontal: _deviceWidth * 0.03,
                    vertical: _deviceHeight * 0.02,
                  ),
                  height: _deviceHeight,
                  width: _deviceWidth * 0.97,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _messagesListView(),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: sendMessageForm(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _messagesListView() {
    if (_pageProvider.messages != null) {
      if (_pageProvider.messages!.isNotEmpty) {
        return SizedBox(
          height: _deviceHeight * 0.78,
          child: ListView.builder(
            controller: _messagesListViewController,
            itemCount: _pageProvider.messages!.length,
            itemBuilder: (BuildContext context, int index) {
              Message message = _pageProvider.messages![index];
              bool isOwnMessage = message.sender.uid == _auth.appUser.uid;
              return CustomChatListViewTile(
                deviceHeight: _deviceHeight,
                width: _deviceWidth * 0.80,
                message: message,
                isOwnMessage: isOwnMessage,
                sender: message.sender,
              );
            },
          ),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            "Be the first to say Hi!",
            style: TextStyle(color: Colors.white),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
  }

  Widget sendMessageForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      child: Form(
        key: _messageFormState,
        child: TextFormField(
          onSaved: (value) {
            _pageProvider.message = value!;
          },
          decoration: InputDecoration(
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            filled: true,
            hintText: "Message",
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(100.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 0.7),
              borderRadius: BorderRadius.circular(100.0),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    _pageProvider.sendImageMessage();
                  },
                  icon: const Icon(Icons.photo_camera),
                  color: Colors.lightBlue,
                ),
                IconButton(
                  onPressed: () {
                    if (_messageFormState.currentState!.validate()) {
                      _messageFormState.currentState!.save();
                      _pageProvider.sendTextMessage();
                      _messageFormState.currentState!.reset();
                    }
                  },
                  icon: const Icon(Icons.send),
                  color: Colors.lightBlue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
