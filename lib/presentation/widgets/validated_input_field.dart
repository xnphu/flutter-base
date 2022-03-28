import 'dart:async';

import 'package:base/core/utils/validations.dart';
import 'package:base/presentation/resources/index.dart';
import 'package:base/presentation/styles/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import 'index.dart';

class PropertyController {
  final ReplaySubject<String> text = ReplaySubject<String>();
  final ReplaySubject<String> errorMessage = ReplaySubject<String>(maxSize: 1);
  final ReplaySubject<bool> isValid = ReplaySubject<bool>();

  PropertyController({
    String initTextValue = '',
    String initMessage = '',
    bool initValidValue = true,
  }) {
    text.add(initTextValue);
    errorMessage.add(initMessage);
    isValid.add(initValidValue);
  }
}

class ValidatedInputField extends StatefulWidget {
  final TextStyle? style;

  final String? hintText;
  final TextStyle? hintStyle;

  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  final ValidatorFunction? validator;

  final Function(String)? onInputChanged;
  final Function(String)? onInputSubmitted;

  final bool readOnly;

  final Function(bool)? onFocusChanged;

  final bool obscureText;
  final bool isShowObscureControl;

  final PropertyController? propertyController;
  final ImageProvider? suffixImage;
  final ImageProvider? prefixImage;

  final EdgeInsetsGeometry? contentPadding;

  final Color? backgrondColor;
  final String? confirmText;
  final bool? upperCase;

  ValidatedInputField(
      {this.style,
      this.hintStyle,
      this.hintText,
      this.keyboardType,
      this.inputFormatters,
      this.validator,
      this.onInputChanged,
      this.readOnly = false,
      this.onFocusChanged,
      this.obscureText = false,
      this.isShowObscureControl = false,
      this.propertyController,
      this.suffixImage,
      this.contentPadding,
      this.backgrondColor,
      this.prefixImage,
      this.confirmText,
      this.upperCase,
      this.onInputSubmitted});

  @override
  State<StatefulWidget> createState() => _ValidatedInputWidgetState();
}

class _ValidatedInputWidgetState extends State<ValidatedInputField> {
  bool _obscureText = false;
  PropertyController? _propertyController;
  TextEditingController _textEditingController = TextEditingController();
  String _errorMesssage = '';
  bool _isValid = true;

  StreamSubscription? _messageValuSub;
  StreamSubscription? _isValidValudSub;
  StreamSubscription? _textValueSub;

  @override
  void initState() {
    super.initState();
    _propertyController = widget.propertyController ?? PropertyController();
    _obscureText = widget.obscureText;
    _textValueSub = _propertyController?.errorMessage.listen((value) {
      setState(() {
        _errorMesssage = value;
      });
    });
    _isValidValudSub = _propertyController?.isValid.listen((value) {
      setState(() {
        _isValid = value;
      });
    });
    _messageValuSub = _propertyController?.text.listen((value) {
      _textEditingController.text = value;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageValuSub?.cancel();
    _isValidValudSub?.cancel();
    _textValueSub?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: widget.backgrondColor ??
                  (widget.readOnly
                      ? AppColors.colorUnActive
                      : Colors.transparent),
              border: Border(
                bottom: BorderSide(
                    color: !_isValid
                        ? AppColors.colorHelper
                        : AppColors.colorBorderTextField),
              ),
              //borderRadius: BorderRadius.circular(5),
            ),
            child: Focus(
              onFocusChange: (hasFocus) {
                if (widget.onFocusChanged != null)
                  widget.onFocusChanged!(hasFocus);
              },
              child: Row(
                children: [
                  widget.prefixImage != null
                      ? _buildIcon(widget.prefixImage!)
                      : Container(),
                  _buildInputTextField(),
                  widget.suffixImage != null
                      ? _buildIcon(widget.suffixImage!)
                      : Container(),
                  _buildShowHideIcon(),
                ],
              ),
            ),
          ),
          Visibility(
              visible: !_isValid,
              child: Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: ErrorMessageWidget(_errorMesssage)))
        ],
      ),
    );
  }

  _buildInputTextField() {
    return Expanded(
      child: TextField(
        style: widget.style ??
            getTextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w400,
                fontSize: 17),
        obscureText: _obscureText,
        readOnly: widget.readOnly,
        controller: _textEditingController,
        inputFormatters: widget.inputFormatters,
        textCapitalization: (widget.upperCase ?? false)
            ? TextCapitalization.characters
            : TextCapitalization.none,
        keyboardType: widget.keyboardType,
        onSubmitted: (value) {
          if (widget.onInputSubmitted != null) {
            widget.onInputSubmitted!(value);
          }
        },
        onChanged: (text) {
          if (widget.validator != null) {
            setState(() {
              if (widget.validator != null)
                _isValid = widget.validator!(text, widget.confirmText);
            });
          }
          if (widget.onInputChanged != null) widget.onInputChanged!(text);
        },
        decoration: InputDecoration(
            contentPadding: widget.contentPadding ??
                EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: widget.hintStyle ??
                getTextStyle(
                    color: AppColors.white10,
                    fontWeight: FontWeight.w400,
                    fontSize: 17)),
      ),
    );
  }

  _buildIcon(ImageProvider image) {
    return SizedBox(
      width: 20,
      height: 20,
      child: Image(
        fit: BoxFit.contain,
        image: image,
        color: Colors.white,
      ),
    );
  }

  _buildShowHideIcon() {
    return widget.isShowObscureControl
        ? IconButton(
            icon: !_obscureText
                ? ImageIcon(
                    AppImages.iconShowPassword,
                    color: AppColors.white,
                  )
                : ImageIcon(
                    AppImages.iconHidePassword,
                    color: AppColors.white,
                  ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
        : Container();
  }
}
