object FTimer: TFTimer
  Left = 822
  Top = 263
  Width = 144
  Height = 145
  BorderStyle = bsSizeToolWin
  Caption = 'Timer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  HelpFile = 'AstroCap.hlp'
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 12
    Width = 22
    Height = 13
    Caption = 'Start'
  end
  object Label2: TLabel
    Left = 12
    Top = 40
    Width = 22
    Height = 13
    Caption = 'Stop'
  end
  object Label3: TLabel
    Left = 12
    Top = 68
    Width = 50
    Height = 13
    Caption = 'Frequency'
  end
  object CBTimer: TCheckBox
    Left = 28
    Top = 92
    Width = 89
    Height = 17
    Caption = 'Timer enabled'
    TabOrder = 0
    OnClick = CBTimerClick
  end
  object MEStart: TMaskEdit
    Left = 68
    Top = 8
    Width = 61
    Height = 21
    EditMask = '!90:00:00;1;_'
    MaxLength = 8
    TabOrder = 1
    Text = '00:00:00'
    OnChange = MEStartStopChange
  end
  object MEStop: TMaskEdit
    Left = 68
    Top = 36
    Width = 61
    Height = 21
    EditMask = '!90:00:00;1;_'
    MaxLength = 8
    TabOrder = 2
    Text = '00:00:00'
    OnChange = MEStartStopChange
  end
  object SEFreq: TRxSpinEdit
    Left = 68
    Top = 64
    Width = 65
    Height = 21
    Increment = 60
    MaxValue = 3600
    MinValue = 1
    Value = 60
    MaxLength = 4
    TabOrder = 3
    OnChange = SEFreqChange
  end
  object FPTimer: TFormPlacement
    IniFileName = 'Software\Weingrill\AstroCap'
    IniSection = 'TimerForm'
    UseRegistry = True
    Left = 36
    Top = 8
  end
  object Timer: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = TimerTimer
    Left = 36
    Top = 40
  end
end
