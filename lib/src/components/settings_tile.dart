import 'package:flutter/material.dart';

class SettingsCustomTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const SettingsCustomTile({
    Key? key,
    required this.title,
    required this.icon,
    this.initialValue = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<SettingsCustomTile> createState() => _SettingsCustomTileState();
}

class _SettingsCustomTileState extends State<SettingsCustomTile> {
  late bool _lights;

  @override
  void initState() {
    super.initState();
    _lights = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(widget.title),
      value: _lights,
      onChanged: (bool value) {
        setState(() {
          _lights = value;
        });
        widget.onChanged?.call(value);
      },
      secondary: Icon(widget.icon),
    );
  }
}

class ExpansionTileExample extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData leadingIcon;
  final IconData expandedIcon;
  final IconData collapsedIcon;
  final bool initiallyExpanded;
  final List<Widget> children;

  const ExpansionTileExample({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    required this.expandedIcon,
    required this.collapsedIcon,
    this.initiallyExpanded = false,
    required this.children,
  }) : super(key: key);

  @override
  State<ExpansionTileExample> createState() => _ExpansionTileExampleState();
}

class _ExpansionTileExampleState extends State<ExpansionTileExample> {
  bool _customTileExpanded = false;

  @override
  void initState() {
    super.initState();
    _customTileExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          title: Text(widget.title),
          subtitle: Text(widget.subtitle),
          children: widget.children,
        ),
        ExpansionTile(
          title: Text(widget.title),
          subtitle: Text(widget.subtitle),
          trailing: Icon(
            _customTileExpanded ? widget.expandedIcon : widget.collapsedIcon,
          ),
          children: widget.children,
          onExpansionChanged: (bool expanded) {
            setState(() {
              _customTileExpanded = expanded;
            });
          },
        ),
      ],
    );
  }
}
