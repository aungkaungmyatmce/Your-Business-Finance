import '../../language_change/app_localizations.dart';
import '../constants/colors.dart';
import '../constants/decoration.dart';
import '../constants/style.dart';
import '../services/create_pdf.dart';
import '../services/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class CreatePdfScreen extends StatefulWidget {
  const CreatePdfScreen({Key key}) : super(key: key);

  @override
  _CreatePdfScreenState createState() => _CreatePdfScreenState();
}

class _CreatePdfScreenState extends State<CreatePdfScreen> {
  DateTime _startDate;
  DateTime _endDate;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    Future<void> createPdf() async {
      setState(() {
        _isLoading = true;
      });
      await CreatePdf().create(startDate: _startDate, endDate: _endDate);

      setState(() {
        _isLoading = false;
      });
    }

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('createPdf'),
          style: boldTextStyle(size: 16, color: Colors.white),
        ),
        actions: [
          Icon(
            Icons.picture_as_pdf_outlined,
            color: Colors.white,
          ),
          SizedBox(width: 30)
        ],
      ),
      body: Container(
        decoration: boxDecorationWithRoundedCorners(
            borderRadius: BorderRadius.only(topRight: Radius.circular(50))),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(AppLocalizations.of(context).translate('from'),
                          style: boldTextStyle()),
                      InkWell(
                        onTap: () {
                          showMonthPicker(
                            context: context,
                            firstDate: DateTime(DateTime.now().year - 1, 5),
                            lastDate: DateTime(DateTime.now().year + 1, 9),
                            initialDate: DateTime.now(),
                          ).then((date) {
                            if (date != null) {
                              setState(() {
                                _startDate = date;
                              });
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.7))),
                          child: Text(
                              _startDate == null
                                  ? AppLocalizations.of(context)
                                      .translate('selectDate')
                                  : DateFormat.yMMM().format(_startDate),
                              style: secondaryTextStyle(
                                  color: primaryColor, height: 1)),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(AppLocalizations.of(context).translate('to'),
                          style: boldTextStyle()),
                      InkWell(
                        onTap: () {
                          showMonthPicker(
                            context: context,
                            firstDate: DateTime(DateTime.now().year - 1, 5),
                            lastDate: DateTime(DateTime.now().year + 1, 9),
                            initialDate: DateTime.now(),
                          ).then((date) {
                            if (date != null) {
                              setState(() {
                                _endDate = date;
                              });
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.7))),
                          child: Text(
                              _endDate == null
                                  ? AppLocalizations.of(context)
                                      .translate('selectDate')
                                  : DateFormat.yMMM().format(_endDate),
                              style: secondaryTextStyle(
                                  color: primaryColor, height: 1)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => ShopNameEditScreen(),
                        //     ));

                        if (_startDate == null || _endDate == null) {
                          UIHelper.showSuccessFlushbar(
                              context, 'Select the dates first!',
                              icon: Icons.warning_amber_rounded);
                          return;
                        }

                        if (_startDate.isAfter(_endDate)) {
                          UIHelper.showSuccessFlushbar(
                              context, 'Incorrect Date Input!',
                              icon: Icons.warning_amber_rounded);
                          return;
                        }
                        createPdf();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              )
                            : Text(
                                AppLocalizations.of(context)
                                    .translate('createPdfFile'),
                                style: primaryTextStyle(
                                    size: 14, color: Colors.white, height: 1),
                              ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
