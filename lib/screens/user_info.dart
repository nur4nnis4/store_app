import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/bloc/user_bloc/user_bloc.dart';
import 'package:store_app/core/constants/icons.dart';
import 'package:store_app/core/constants/assets_path.dart';
import 'package:store_app/core/routes/route_name.dart';
import 'package:provider/provider.dart';
import 'package:store_app/widgets/my_alert_dialog.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  elevation: 0,
                  flexibleSpace: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserLoaded) {
                        return FlexibleSpaceBar(
                          background: Image.network(
                            state.userModel.photoUrl!,
                            errorBuilder: (_, __, ___) => Image.asset(
                                ImagePath.profilePlaceholder,
                                fit: BoxFit.cover),
                            fit: BoxFit.cover,
                          ),
                        );
                      } else {
                        return FlexibleSpaceBar(
                          background: Image.asset(ImagePath.profilePlaceholder,
                              fit: BoxFit.cover),
                        );
                      }
                    },
                  )),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 28.0, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //    User bag section

                      _sectionTitle('User Bag'),
                      Card(
                        child: Column(
                          children: [
                            _userBagListTile(
                                'Wishlist',
                                mWishListIcon,
                                mTrailingIcon,
                                context,
                                () => Navigator.of(context)
                                    .pushNamed(RouteName.wishlistScreen)),
                            _userBagListTile(
                                'Cart',
                                mCartIcon,
                                mTrailingIcon,
                                context,
                                () => Navigator.of(context)
                                    .pushNamed(RouteName.cartScreen)),
                          ],
                        ),
                      ),

                      //    User information section

                      _sectionTitle('User Information'),
                      Card(
                        child: BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            if (state is UserLoaded) {
                              return Column(
                                children: [
                                  _userInformationListTile(
                                      state.userModel.name, mUserIcon, context),
                                  _userInformationListTile(
                                      state.userModel.email,
                                      mEmailIcon,
                                      context),
                                  state.userModel.phoneNumber != null
                                      ? _userInformationListTile(
                                          state.userModel.phoneNumber,
                                          mPhoneIcon,
                                          context)
                                      : Container(),
                                  state.userModel.address != null
                                      ? _userInformationListTile(
                                          state.userModel.address,
                                          mShippingAddress,
                                          context)
                                      : Container(),
                                  _userInformationListTile(
                                      'Joined ${state.userModel.joinedAt.year}',
                                      mJoinDateIcon,
                                      context),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  _userInformationListTile(
                                      '', mUserIcon, context),
                                  _userInformationListTile(
                                      '', mEmailIcon, context),
                                  _userInformationListTile(
                                      '', mPhoneIcon, context),
                                  _userInformationListTile(
                                      '', mShippingAddress, context),
                                  _userInformationListTile(
                                      '', mJoinDateIcon, context),
                                ],
                              );
                            }
                          },
                        ),
                      ),

                      //    Settings Section

                      _sectionTitle('Settings'),
                      Card(
                        child: Column(
                          children: [
                            ListTile(
                                title: Text('Sign Out'),
                                leading:
                                    _customIcon(Icons.exit_to_app_outlined),
                                onTap: () {
                                  MyAlertDialog.signOut(context,
                                      onSignOutTap: () {
                                    Provider.of<AuthBloc>(context,
                                            listen: false)
                                        .add(SignOutEvent());
                                    Navigator.pop(context);
                                  });
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating Button Appbar to upload profile picture
          _uploadPictureFab(),
        ],
      ),
    );
  }

  Widget _userInformationListTile(title, icon, context) {
    return ListTile(
      title: Text(title),
      leading: _customIcon(icon),
      onTap: () {},
    );
  }

  Widget _userBagListTile(String title, IconData leadingIcon,
      IconData trailingIcon, BuildContext context, Function() onTap) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.subtitle1),
      leading: _customIcon(leadingIcon),
      trailing: _customIcon(trailingIcon),
      onTap: onTap,
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 0, 0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _customIcon(IconData icon) {
    return Icon(
      icon,
      color: Theme.of(context).iconTheme.color,
    );
  }

  Widget _uploadPictureFab() {
    // Starting Fab position
    final double defaultTopMargin = 200.0 - 20;
    // pixels from top where scalling should start
    final double scaleStart = defaultTopMargin / 2;
    // pixels from top where scalling should end
    final double scaleEnd = scaleStart / 2;

    double _top = defaultTopMargin;
    double scale = 1.0;

    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      _top -= offset;

      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        // offset between scaleStart and scaleEnd => scale down
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        // offset passed scaleEnd => hide Fab
        scale = 0.0;
      }
    }

    return Positioned(
        top: _top,
        right: 16.0,
        child: Transform(
          transform: Matrix4.identity()..scale(scale),
          alignment: Alignment.center,
          child: FloatingActionButton(
            mini: true,
            onPressed: () => MyAlertDialog.imagePicker(context),
            heroTag: 'btn1',
            child: Icon(mCameraIcon),
          ),
        ));
  }
}
