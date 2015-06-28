object FTimer: TFTimer
  Left = 334
  Top = 220
  BorderStyle = bsToolWindow
  Caption = 'Timeraufnahme'
  ClientHeight = 83
  ClientWidth = 146
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 20
    Width = 37
    Height = 13
    Caption = 'Intervall'
  end
  object SEIntervall: TRxSpinEdit
    Left = 76
    Top = 16
    Width = 61
    Height = 21
    Decimal = 0
    Increment = 10
    MaxValue = 3600
    MinValue = 1
    Value = 10
    MaxLength = 4
    TabOrder = 0
  end
  object BStart: TButton
    Left = 36
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 1
    OnClick = BStartClick
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = Timer1Timer
    Left = 4
    Top = 8
  end
end
