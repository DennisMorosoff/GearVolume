object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1052#1086#1076#1091#1083#1100' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1087#1086#1089#1090#1086#1088#1077#1085#1080#1103' '#1074#1085#1091#1090#1088#1077#1085#1085#1077#1075#1086' '#1079#1072#1094#1077#1087#1083#1077#1085#1080#1103
  ClientHeight = 491
  ClientWidth = 545
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 337
    Height = 209
    Caption = #1043#1077#1086#1084#1077#1090#1088#1080#1095#1077#1089#1082#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1082#1086#1083#1077#1089#1072
    TabOrder = 0
    object Label1: TLabel
      Left = 6
      Top = 25
      Width = 92
      Height = 13
      Caption = #1044#1080#1072#1084#1077#1090#1088' '#1074#1087#1072#1076#1080#1085#1099
    end
    object Label2: TLabel
      Left = 6
      Top = 71
      Width = 116
      Height = 13
      Caption = #1044#1077#1083#1080#1090#1077#1083#1100#1085#1099#1081' '#1076#1080#1072#1084#1077#1090#1088
    end
    object Label3: TLabel
      Left = 6
      Top = 117
      Width = 93
      Height = 13
      Caption = #1044#1080#1072#1084#1077#1090#1088' '#1074#1077#1088#1096#1080#1085#1099
    end
    object Label5: TLabel
      Left = 170
      Top = 71
      Width = 58
      Height = 13
      Caption = #1044#1083#1080#1085#1072' '#1079#1091#1073#1072
    end
    object Label6: TLabel
      Left = 170
      Top = 117
      Width = 106
      Height = 13
      Caption = #1063#1080#1089#1083#1086' '#1079#1091#1073#1100#1077#1074' '#1082#1086#1083#1077#1089#1072
    end
    object Label7: TLabel
      Left = 170
      Top = 25
      Width = 142
      Height = 13
      Caption = #1059#1075#1086#1083' '#1085#1072#1082#1083#1086#1085#1072' '#1087#1088#1086#1092#1080#1083#1103' '#1079#1091#1073#1072
    end
    object Edit1: TEdit
      Left = 6
      Top = 44
      Width = 150
      Height = 21
      TabOrder = 0
      Text = '260'
      OnKeyPress = Edit1KeyPress
    end
    object Edit2: TEdit
      Left = 6
      Top = 90
      Width = 150
      Height = 21
      TabOrder = 1
      Text = '240'
      OnKeyPress = Edit1KeyPress
    end
    object Edit3: TEdit
      Left = 6
      Top = 136
      Width = 150
      Height = 21
      TabOrder = 2
      Text = '180'
      OnKeyPress = Edit1KeyPress
    end
    object Edit4: TEdit
      Left = 170
      Top = 44
      Width = 150
      Height = 21
      TabOrder = 3
      Text = '55'
      OnKeyPress = Edit1KeyPress
    end
    object Edit5: TEdit
      Left = 170
      Top = 90
      Width = 150
      Height = 21
      TabOrder = 4
      Text = '200'
      OnKeyPress = Edit1KeyPress
    end
    object Edit6: TEdit
      Left = 170
      Top = 136
      Width = 150
      Height = 21
      TabOrder = 5
      Text = '8'
    end
    object Button1: TButton
      Left = 170
      Top = 170
      Width = 150
      Height = 25
      Caption = #1055#1086#1089#1090#1088#1086#1080#1090#1100' '#1082#1086#1083#1077#1089#1086
      TabOrder = 6
      OnClick = Button1Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 223
    Width = 337
    Height = 260
    Caption = #1043#1077#1086#1084#1077#1090#1088#1080#1095#1077#1089#1082#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1096#1077#1089#1090#1077#1088#1085#1080
    TabOrder = 1
    object LabeledEdit1: TLabeledEdit
      Left = 6
      Top = 48
      Width = 150
      Height = 21
      EditLabel.Width = 93
      EditLabel.Height = 13
      EditLabel.Caption = #1044#1080#1072#1084#1077#1090#1088' '#1074#1077#1088#1096#1080#1085#1099
      TabOrder = 0
      Text = '140'
    end
    object LabeledEdit2: TLabeledEdit
      Left = 6
      Top = 90
      Width = 150
      Height = 21
      EditLabel.Width = 116
      EditLabel.Height = 13
      EditLabel.Caption = #1044#1077#1083#1080#1090#1077#1083#1100#1085#1099#1081' '#1076#1080#1072#1084#1077#1090#1088
      TabOrder = 1
      Text = '120'
    end
    object LabeledEdit3: TLabeledEdit
      Left = 6
      Top = 136
      Width = 150
      Height = 21
      EditLabel.Width = 92
      EditLabel.Height = 13
      EditLabel.Caption = #1044#1080#1072#1084#1077#1090#1088' '#1074#1087#1072#1076#1080#1085#1099
      TabOrder = 2
      Text = '60'
    end
    object LabeledEdit4: TLabeledEdit
      Left = 6
      Top = 184
      Width = 150
      Height = 21
      EditLabel.Width = 142
      EditLabel.Height = 13
      EditLabel.Caption = #1059#1075#1086#1083' '#1085#1072#1082#1083#1086#1085#1072' '#1087#1088#1086#1092#1080#1083#1103' '#1079#1091#1073#1072
      TabOrder = 3
      Text = '55'
    end
    object LabeledEdit5: TLabeledEdit
      Left = 170
      Top = 48
      Width = 150
      Height = 21
      EditLabel.Width = 58
      EditLabel.Height = 13
      EditLabel.Caption = #1044#1083#1080#1085#1072' '#1079#1091#1073#1072
      TabOrder = 4
      Text = '200'
    end
    object LabeledEdit6: TLabeledEdit
      Left = 170
      Top = 90
      Width = 150
      Height = 21
      EditLabel.Width = 120
      EditLabel.Height = 13
      EditLabel.Caption = #1063#1080#1089#1083#1086' '#1079#1091#1073#1100#1077#1074' '#1096#1077#1089#1090#1077#1088#1085#1080
      TabOrder = 5
      Text = '4'
    end
    object LabeledEdit7: TLabeledEdit
      Left = 170
      Top = 136
      Width = 150
      Height = 21
      EditLabel.Width = 77
      EditLabel.Height = 13
      EditLabel.Caption = #1064#1080#1088#1080#1085#1072' '#1094#1072#1087#1092#1099
      TabOrder = 6
      Text = '14'
    end
    object LabeledEdit8: TLabeledEdit
      Left = 170
      Top = 184
      Width = 150
      Height = 21
      EditLabel.Width = 130
      EditLabel.Height = 13
      EditLabel.Caption = #1044#1083#1080#1085#1072' '#1089#1090#1086#1088#1086#1085#1099' '#1082#1074#1072#1076#1088#1072#1090#1072
      TabOrder = 7
      Text = '50'
    end
    object Button2: TButton
      Left = 173
      Top = 219
      Width = 147
      Height = 25
      Caption = #1055#1086#1089#1090#1088#1086#1080#1090#1100' '#1096#1077#1089#1090#1077#1088#1085#1102
      TabOrder = 8
      OnClick = Button2Click
    end
  end
  object GroupBox3: TGroupBox
    Left = 351
    Top = 8
    Width = 186
    Height = 111
    Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099
    TabOrder = 2
    object RadioButton1: TRadioButton
      Left = 16
      Top = 70
      Width = 161
      Height = 17
      Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1073#1077#1079' '#1087#1088#1086#1089#1084#1086#1090#1088#1072
      TabOrder = 0
    end
    object RadioButton2: TRadioButton
      Left = 16
      Top = 47
      Width = 153
      Height = 17
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1073#1077#1079' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103
      Checked = True
      TabOrder = 1
      TabStop = True
    end
  end
  object GroupBox4: TGroupBox
    Left = 351
    Top = 125
    Width = 186
    Height = 276
    Caption = #1056#1072#1089#1095#1105#1090' '#1086#1073#1098#1105#1084#1072
    TabOrder = 3
    object LabeledEdit9: TLabeledEdit
      Left = 16
      Top = 55
      Width = 150
      Height = 21
      Hint = #1055#1086#1076#1086#1073#1088#1072#1085' '#1090#1072#1082', '#1095#1090#1086#1073#1099' '#1079#1072' 10 '#1096#1072#1075#1086#1074' '#1082#1072#1082' '#1088#1072#1079' '#1076#1086#1089#1090#1080#1095#1100' '#1084#1080#1085#1080#1084#1091#1084#1072' '#1086#1073#1098#1077#1084#1072
      EditLabel.Width = 144
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1072#1095#1072#1083#1100#1085#1099#1081' '#1091#1075#1086#1083' '#1074' '#1088#1072#1076#1080#1072#1085#1072#1093
      TabOrder = 0
      Text = '-0,5'
    end
    object Button4: TButton
      Left = 14
      Top = 186
      Width = 150
      Height = 25
      Caption = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1086#1073#1098#1105#1084
      TabOrder = 1
      OnClick = Button4Click
    end
    object LabeledEdit10: TLabeledEdit
      Left = 16
      Top = 98
      Width = 150
      Height = 21
      Hint = #1055#1086#1076#1086#1073#1088#1072#1085' '#1090#1072#1082', '#1095#1090#1086#1073#1099' '#1079#1072' 10 '#1096#1072#1075#1086#1074' '#1082#1072#1082' '#1088#1072#1079' '#1076#1086#1089#1090#1080#1095#1100' '#1084#1080#1085#1080#1084#1091#1084#1072' '#1086#1073#1098#1077#1084#1072
      EditLabel.Width = 82
      EditLabel.Height = 13
      EditLabel.Caption = #1064#1072#1075' '#1074' '#1088#1072#1076#1080#1072#1085#1072#1093
      TabOrder = 2
      Text = '0,1'
    end
    object LabeledEdit11: TLabeledEdit
      Left = 16
      Top = 146
      Width = 150
      Height = 21
      Hint = #1055#1086#1076#1086#1073#1088#1072#1085' '#1090#1072#1082', '#1095#1090#1086#1073#1099' '#1079#1072' 10 '#1096#1072#1075#1086#1074' '#1082#1072#1082' '#1088#1072#1079' '#1076#1086#1089#1090#1080#1095#1100' '#1084#1080#1085#1080#1084#1091#1084#1072' '#1086#1073#1098#1077#1084#1072
      EditLabel.Width = 94
      EditLabel.Height = 13
      EditLabel.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1096#1072#1075#1086#1074
      TabOrder = 3
      Text = '10'
    end
    object Button5: TButton
      Left = 14
      Top = 217
      Width = 150
      Height = 25
      Caption = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1086#1073#1098#1105#1084' 2'
      TabOrder = 4
    end
  end
  object Button3: TButton
    Left = 367
    Top = 442
    Width = 150
    Height = 25
    Caption = #1058#1086#1083#1100#1082#1086' '#1087#1088#1086#1092#1080#1083#1100
    TabOrder = 4
    OnClick = Button3Click
  end
  object SD1: TSaveDialog
    DefaultExt = 'sldprt'
    FileName = #1044#1077#1090#1072#1083#1100
    Filter = #1044#1077#1090#1072#1083#1100' (*.prt;*.sldprt)|*.prt,*.sldprt'
    FilterIndex = 0
    Left = 416
    Top = 280
  end
end
