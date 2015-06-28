object FAbout: TFAbout
  Left = 332
  Top = 213
  ActiveControl = BOk
  BorderStyle = bsDialog
  Caption = 'Info über AstroCap 2.0'
  ClientHeight = 174
  ClientWidth = 269
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 79
    Top = 16
    Width = 110
    Height = 52
    Alignment = taCenter
    Caption = 
      'Capturesoftware '#13#10'für '#13#10'astronomische Zwecke'#13#10'2001 © Jörg Weingr' +
      'ill'
  end
  object Label2: TLabel
    Left = 55
    Top = 80
    Width = 160
    Height = 13
    Alignment = taCenter
    Caption = 'TVideo Komponente © J. Huebler'
  end
  object LVersion: TLabel
    Left = 98
    Top = 108
    Width = 74
    Height = 13
    Alignment = taCenter
    Caption = 'Version: 0.0.0.0'
  end
  object BOk: TButton
    Left = 97
    Top = 132
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
    OnClick = BOkClick
  end
end
