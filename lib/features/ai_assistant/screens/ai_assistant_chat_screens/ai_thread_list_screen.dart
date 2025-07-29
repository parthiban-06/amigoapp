import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:loading_more_list/loading_more_list.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_chat_screens/ai_message.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_chat_screens/widgets/ai_assistant_edit_chat_widget.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_chat_screens/widgets/ai_assistant_eva_chat_message_widget.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_chat_screens/widgets/ai_assistant_explore_chip_widget.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_chat_screens/widgets/ai_assistant_loading_widget.dart';
import 'package:visaamigo/features/home/providers/navigation_provider.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../../../custom_widgets/visa_ai_assistant_search_box.dart';
import '../../../../../custom_widgets/visa_appbar.dart';
import '../../../../../custom_widgets/visa_custom_inital_letter.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../../../utils/responsive_util.dart';
import '../../../../custom_widgets/visa_chat_loading_message.dart';
import '../../../../router/app_routes_const.dart';
import '../../providers/ai_chat_provider.dart';
import 'widgets/ai_assistant_chat_widget.dart';
import 'widgets/ai_assistant_edit_chat_buttons_widget.dart';

// ignore: must_be_immutable
class AiChatScreen extends StatefulWidget {
  String evaQuestion;
  String location;
  String section;
  String sessionId;

  AiChatScreen(this.evaQuestion, this.location, this.section, this.sessionId,
      {super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  late final NavigationProvider navigationBar;
  late final ResponsiveUtil responsive;
  late double vsSpacing;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Announce When EVA Chat Screen Open
      Utils.announceMessage(S.of(context).eva_chat_screen_opened);
      Provider.of<ChatProvider>(context, listen: false).init(
          context,
          widget.evaQuestion,
          widget.location,
          widget.section,
          widget.sessionId);
      widget.evaQuestion = "";
      widget.location = "";
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    navigationBar = Provider.of<NavigationProvider>(context, listen: false);
    responsive = GetIt.I<ResponsiveUtil>(param1: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (b, f) {
            // For Android Back Button Handling
            chatProvider.clearAllPreviousState(false);
          },
          child: Container(
            color: VisaColors.white,
            child: Column(
              children: [
                VisaAppBar(
                  isHamburgerIconShow: responsive.kISWeb() &&
                      (responsive.isMobile(context: context) ||
                          responsive.isTablet(context: context)),
                  isActionButtonShow: true,
                  isRightSideHamburgerIconShow: false,
                  isCancelWithTextButtonShow: true,
                  onCancelPress: () {
                    chatProvider.isContinueButtonSelected = false;
                    chatProvider.textController.clear();
                    chatProvider.messages.clear();
                    chatProvider.clearAllPreviousState(true);
                    navigationBar.goBranch(AppRoutes.evaScreenIndex,
                        loadInitial: true);
                  },
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // OnTapOutSide
                      chatProvider.cancelEditChat();
                      // Hide Keyboard when tap outside
                      Utils.hideKeyboard(context);
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      padding: EdgeInsets.all(AppSizes.sixteenRadius),
                      child: Column(
                        children: [
                          Expanded(
                            child: chatProvider.messages.isEmpty
                                ? const SizedBox.shrink()
                                : Stack(
                                    children: [
                                      // Use LoadingMoreCustomScrollView with reverse: true
                                      /*LoadingMoreCustomScrollView(
                                  controller: chatProvider.scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  reverse: true,f
                                  // Display in reverse (newest at bottom)
                                  // slivers: <Widget>[
                                  slivers: <Widget>[
                                    // if (chatProvider.isChatloading)
                                    // Positioned(
                                    //   bottom: 0,
                                    //   left: 0,
                                    //   right: 0,
                                    //   child: SliverToBoxAdapter(
                                    //     child: Padding(
                                    //       padding:
                                    //           const EdgeInsets.symmetric(
                                    //                   vertical: 8.0)
                                    //               .r,
                                    //       child: AiAssistantLoadingWidget(),
                                    //     ),
                                    //   ),
                                    // ),
                                    LoadingMoreSliverList(
                                      SliverListConfig<Message>(
                                        extendedListDelegate:
                                            const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1,
                                        ),
                                        itemBuilder: (BuildContext context,
                                            Message message, int index) {
                                          return _buildMessageItem(context,
                                              message, index, chatProvider);
                                        },
                                        sourceList:
                                            chatProvider.messagesList!,
                                        indicatorBuilder:
                                            (context, status) {
                                          return _buildLoadingIndicator(
                                              context, status);
                                        },
                                        // padding:
                                        //     EdgeInsets.only(bottom: 30.h),
                                      ),
                                    ),
                                  ],
                                  // ],
                                ),*/

                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: AppSizes.eightRadius),
                                        child: NotificationListener<
                                            ScrollNotification>(
                                          onNotification: (scrollNotification) {
                                            if (scrollNotification
                                                is ScrollStartNotification) {
                                              Utils.hideKeyboard(
                                                  context); // Hides the keyboard
                                            }
                                            return false;
                                          },
                                          child: LoadingMoreList(
                                            ListConfig<Message>(
                                                extendedListDelegate:
                                                    const ExtendedListDelegate(
                                                  closeToTrailing: true,
                                                ),
                                                controller: chatProvider
                                                    .scrollController,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        Message message,
                                                        int index) {
                                                  return _buildMessageItem(
                                                      context,
                                                      message,
                                                      index,
                                                      chatProvider);
                                                },
                                                reverse: true,
                                                sourceList:
                                                    chatProvider.messagesList!,
                                                indicatorBuilder:
                                                    (context, status) {
                                                  return _buildLoadingIndicator(
                                                      context, status);
                                                }),
                                          ),
                                        ),
                                      ),

                                      // Loading indicator when sending a new message
                                      // Gradient effects for top and bottom
                                      ValueListenableBuilder(
                                          valueListenable:
                                              chatProvider.isAtBottom,
                                          builder: (context, value, child) {
                                            return (chatProvider
                                                        .messages.length >=
                                                    5)
                                                ? !value
                                                    ? Positioned(
                                                        bottom: 0,
                                                        // Changed from top to bottom since list is reversed
                                                        child: IgnorePointer(
                                                          child: Container(
                                                            height: 30.h,
                                                            width: context
                                                                .screenWidth,
                                                            decoration:
                                                                BoxDecoration(
                                                                    gradient:
                                                                        LinearGradient(
                                                                            colors: [
                                                                              VisaColors.white.withAlpha(0),
                                                                              VisaColors.white.withAlpha(200)
                                                                            ],
                                                                            begin: Alignment
                                                                                .topCenter,
                                                                            // Changed gradient direction
                                                                            end: Alignment
                                                                                .bottomCenter,
                                                                            stops: const [
                                                                              0.2,
                                                                              1
                                                                            ])),
                                                          ),
                                                        ))
                                                    : Positioned(
                                                        top: 0,
                                                        // Changed from bottom to top since list is reversed
                                                        child: IgnorePointer(
                                                          child: Container(
                                                            height: 40.h,
                                                            width: context
                                                                .screenWidth,
                                                            decoration:
                                                                BoxDecoration(
                                                                    gradient:
                                                                        LinearGradient(
                                                                            colors: [
                                                                              VisaColors.white,
                                                                              VisaColors.white.withAlpha(0)
                                                                            ],
                                                                            begin: Alignment
                                                                                .topCenter,
                                                                            // Changed gradient direction
                                                                            end: Alignment
                                                                                .bottomCenter,
                                                                            stops: const [
                                                                              0,
                                                                              1
                                                                            ])),
                                                          ),
                                                        ),
                                                      )
                                                : const SizedBox();
                                          }),
                                    ],
                                  ),
                          ),
                          if (chatProvider.isEdit != true)
                            _buildMessageComposer(context, chatProvider)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator(BuildContext context, IndicatorStatus status) {
    final threeRadius = AppSizes.threeRadius;
    final ten = AppSizes.tenRadius;
    switch (status) {
      case IndicatorStatus.loadingMoreBusying:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(
                  top: ten, bottom: threeRadius, end: ten),
              child: AiAssistantLoadingWidget(),
            ),
          ],
        );
      case IndicatorStatus.fullScreenBusying:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(
                  top: ten, bottom: threeRadius, end: ten),
              child: AiAssistantLoadingWidget(),
            ),
          ],
        );
      case IndicatorStatus.error:
        return const SizedBox.shrink();
      case IndicatorStatus.noMoreLoad:
        return SizedBox(height: AppSizes.ten);
      case IndicatorStatus.empty:
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMessageComposer(
      BuildContext context, ChatProvider chatProvider) {
    return Column(
      children: [
        VisaAiAssistantSearchBox(
          controller: chatProvider.textController,
          hintText: S.of(context).ask_eva,
          autofocus: false,
          isEdit: chatProvider.isEdit ?? false,
          isEanble: !chatProvider.isTyping,
          maxLines: 2,
          onTap: () {
            // Nothing special to do on tap
          },
          onClear: () {
            chatProvider.cancelEditChat();
          },
          onSearch: () {
            Utils.hideKeyboard(context);
            chatProvider.sendMessage(
                chatProvider.textController.text.trim(), '',
                editMessageId: chatProvider.editingMessageId);
          },
        ),
        // VSpacings.small,
      ],
    );
  }
}

Widget _buildMessageItem(BuildContext context, Message message, int index,
    ChatProvider chatProvider) {
  if (message.id == "loaderItem") {
    return _buildLoaderItem();
  }

  if (message.id == "loaderShimmerEffect") {
    return const VisaChatLoadingMessage();
  }

  return _buildChatMessage(context, message, index, chatProvider);
}

Widget _buildLoaderItem() {
  final twenty = AppSizes.twentyRadius;
  final fourtyRadius = AppSizes.fourtyRadius;
  final threeRadius = AppSizes.threeRadius;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsetsDirectional.only(
            top: twenty, bottom: threeRadius, end: fourtyRadius),
        child: AiAssistantLoadingWidget(),
      ),
    ],
  );
}

Widget _buildChatMessage(BuildContext context, Message message, int index,
    ChatProvider chatProvider) {
  final userMessages =
      chatProvider.messages.where((msg) => msg.isUser).toList();
  final isLastUserMessage = _isLastUserMessage(message, userMessages);
  final isLastEVAMessage = _isLastEVAMessage(message, userMessages);

  return Align(
    alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.all(0.0).r,
      decoration: BoxDecoration(
        color: message.isUser ? null : null,
        borderRadius: BorderRadius.circular(20).r,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (!message.isUser)
            _buildAssistantMessage(
                message, chatProvider, isLastEVAMessage, index),
          SizedBox(height: 4.h),
          if (message.isUser)
            _buildUserMessage(message, chatProvider, isLastUserMessage, index),
          if (!message.isUser) _buildAssistantMessageSpacing(message),
        ],
      ),
    ),
  );
}

bool _isLastUserMessage(Message message, List<Message> userMessages) {
  return message.isUser &&
      userMessages.isNotEmpty &&
      userMessages.first.id == message.id;
}

bool _isLastEVAMessage(Message message, List<Message> userMessages) {
  return !message.isUser &&
      userMessages.isNotEmpty &&
      userMessages.first.editId == message.editId;
}

Widget _buildAssistantMessage(Message message, ChatProvider chatProvider,
    bool isLastEVAMessage, int index) {
  final twenty = AppSizes.twentyRadius;
  final fourtyRadius = AppSizes.fourtyRadius;
  final threeRadius = AppSizes.threeRadius;

  return Opacity(
    opacity: _getAssistantMessageOpacity(chatProvider, isLastEVAMessage),
    child: Padding(
      padding: _getAssistantMessagePadding(
          message, chatProvider, twenty, fourtyRadius, threeRadius),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.w,
        children: [
          _buildAssistantMessageIcon(message),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AiAssistantEvaChatMessageWidget(
                  message: message,
                  chatProvider: chatProvider,
                ),
                AiAssistantExploreChipWidget(
                  chatProvider: chatProvider,
                  message: message,
                  index: index,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

double _getAssistantMessageOpacity(
    ChatProvider chatProvider, bool isLastEVAMessage) {
  return chatProvider.isEdit != null && chatProvider.isEdit! && isLastEVAMessage
      ? 0.25
      : 1.0;
}

EdgeInsetsDirectional _getAssistantMessagePadding(
    Message message,
    ChatProvider chatProvider,
    double twenty,
    double fourtyRadius,
    double threeRadius) {
  if (chatProvider.isTyping && !message.isFinalText) {
    return EdgeInsetsDirectional.only(
      top: twenty,
      bottom: threeRadius,
      end: fourtyRadius,
    );
  }

  if (message.isFinalText) {
    return EdgeInsetsDirectional.only(
      top: 0,
      end: fourtyRadius,
    );
  }

  return EdgeInsetsDirectional.only(
    top: twenty,
    bottom: threeRadius,
    end: fourtyRadius,
  );
}

Widget _buildAssistantMessageIcon(Message message) {
  if (message.isFinalText || message.isFinalTextEmpty) {
    return _buildFinalTextIcon(message);
  }

  if (message.isTyping) {
    return AiAssistantLoadingWidget();
  }

  if (message.text.isNotEmpty) {
    return AiAssistantLoadingWidget(isPlay: false);
  }

  return const SizedBox.shrink();
}

Widget _buildFinalTextIcon(Message message) {
  if (message.isInitialTextEmpty) {
    return AiAssistantLoadingWidget(isPlay: false);
  }

  return SizedBox(
    width: Sizes.twentyFour,
    height: message.text.isNotEmpty ? Sizes.twentyFour : AppSizes.zero,
  );
}

Widget _buildUserMessage(Message message, ChatProvider chatProvider,
    bool isLastUserMessage, int index) {
  return Padding(
    padding: EdgeInsets.only(top: index != 0 ? 20 : 0),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildUserMessageContent(message, chatProvider, isLastUserMessage),
            HSpacings.xsmall,
            CircleLetterWidget(
              letter: chatProvider.userNameInitial ?? "",
            )
          ],
        ),
        AiAssistantEditChatButtonsWidget(
          message: message,
          chatProvider: chatProvider,
          isLastUserMessage: isLastUserMessage,
        ),
      ],
    ),
  );
}

Widget _buildUserMessageContent(
    Message message, ChatProvider chatProvider, bool isLastUserMessage) {
  if (chatProvider.isEdit! && isLastUserMessage) {
    return AiAssistantEditChatWidget(
      message: message,
      chatProvider: chatProvider,
    );
  }

  return AiAssistantChatWidget(
    message: message,
    chatProvider: chatProvider,
    isLastUserMessage: isLastUserMessage,
  );
}

Widget _buildAssistantMessageSpacing(Message message) {
  if (message.isFinalText) {
    return AppSizes.xxsmallVS;
  }

  return const SizedBox();
}
