import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:formz/formz.dart';
import 'package:meteoapp/domain/theme/consts.dart';
import 'package:meteoapp/src/pages/home_page/homepage_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/services/route.dart';

// Cubit pro správu stavu přezdívky
class NicknameCubit extends HydratedCubit<NicknameState> {
  NicknameCubit() : super(const NicknameState());

  // Funkce pro změnu hodnoty přezdívky
  void changeNickname(String value) {
    emit(state.copyWith(nickname: Nickname.dirty(value)));
  }

  void confirmNickname(String value) {
    // Check if the nickname is dirty (changed by the user) and valid
    if (!state.nickname.isPure && _isNicknameValid(value)) {
      emit(state.copyWith(status: NicknameStatus.submitted));
      saveNicknameLocally(value);
    }
  }

  // Validace délky přezdívky
  bool _isNicknameValid(String nickname) {
    return nickname.length <= 13;
  }

  // Uložení přezdívky do lokálního úložiště
  Future<void> saveNicknameLocally(String nickname) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('nickname', nickname);
  }

  @override
  NicknameState fromJson(Map<String, dynamic> json) {
    return NicknameState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(NicknameState state) {
    return state.toJson();
  }
}

// Stav přezdívky
class NicknameState extends Equatable {
  final Nickname nickname;
  final NicknameStatus status;

  const NicknameState({
    this.nickname = const Nickname.pure(),
    this.status = NicknameStatus.pure,
  });

  // Kopírovací konstruktor pro aktualizaci stavu
  NicknameState copyWith({
    Nickname? nickname,
    NicknameStatus? status,
  }) {
    return NicknameState(
      nickname: nickname ?? this.nickname,
      status: status ?? this.status,
    );
  }

  // Funkce pro serializaci stavu do JSON
  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname.value,
      'status': status.toString(),
    };
  }

  // Funkce pro deserializaci stavu z JSON
  factory NicknameState.fromJson(Map<String, dynamic> json) {
    return NicknameState(
      nickname: Nickname.dirty(json['nickname']),
      status: json['status'] == 'pure'
          ? NicknameStatus.pure
          : json['status'] == 'submitted'
              ? NicknameStatus.submitted
              : NicknameStatus.pure,
    );
  }

  @override
  List<Object?> get props => [nickname, status];
}

// Validace přezdívky
class Nickname extends FormzInput<String, String> {
  const Nickname.pure() : super.pure('');
  const Nickname.dirty([String value = '']) : super.dirty(value);

  @override
  String? validator(String value) {
    return value.isNotEmpty ? null : 'Zadejte svou přezdívku';
  }
}

// Stavy potvrzení přezdívky
enum NicknameStatus { pure, submitted }

// Stránka pro zadání přezdívky
class NicknamePage extends StatelessWidget {
  static const routeName = "/nickname";

  const NicknamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: AppLocalizations.of(context).create,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: AppLocalizations.of(context).your_username,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
      restorationId: routeName,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider(
          create: (context) => NicknameCubit(),
          child: NicknameForm(),
        ),
      ),
    );
  }
}

class NicknameForm extends StatelessWidget {
  final TextEditingController _nicknameController = TextEditingController();

  NicknameForm({Key? key}) : super(key: key);

  void _onConfirmNickname(BuildContext context) {
    final nickname = _nicknameController.text;
    context.read<NicknameCubit>().confirmNickname(nickname);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NicknameCubit, NicknameState>(
      listener: (context, state) {
        if (state.status == NicknameStatus.submitted) {
          Navigator.of(context).pushAndRemoveUntil(
              CustomPageRoute(builder: (context) => const HomepageRouter()),
              (route) => false);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacers.heightBox(MediaQuery.of(context).size.height * 0.1),
          SizedBox(
            height: 60,
            child: TextField(
              controller: _nicknameController,
              onChanged: (newValue) {
                context.read<NicknameCubit>().changeNickname(newValue);
              },
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 1.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0),
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: Theme.of(context).iconTheme.color,
                ),
                iconColor: Colors.black,
                labelStyle: kSubtitle,
                labelText: AppLocalizations.of(context).username,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _nicknameController.text.isNotEmpty
                ? _onConfirmNickname(context)
                : _showConfirmationDialog,
            style: ElevatedButton.styleFrom(
                backgroundColor: _nicknameController.text.isNotEmpty
                    ? Colors.green
                    : Colors.grey),
            child: Text(
              AppLocalizations.of(context).continueToApp,
              style: kUnselected,
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Opravdu si přejete pokračovat bez vyplnění?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _onConfirmNickname(context);
              },
              child: Text("Ano, pokračovat na přihlášení"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Ne"),
            ),
          ],
        );
      },
    );
  }
}
