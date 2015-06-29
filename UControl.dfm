object FControl: TFControl
  Left = 633
  Top = 292
  BorderStyle = bsToolWindow
  Caption = 'Telescope Control'
  ClientHeight = 153
  ClientWidth = 229
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  HelpFile = 'AstroCap.hlp'
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 41
    Height = 13
    Caption = 'delta RA'
  end
  object Label2: TLabel
    Left = 8
    Top = 36
    Width = 46
    Height = 13
    Caption = 'delta Dec'
  end
  object SBUp: TSpeedButton
    Left = 172
    Top = 8
    Width = 23
    Height = 22
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
      FFFFF0000000000000FFF7000000000007FFFF00000000000FFFFF7000000000
      7FFFFFF000000000FFFFFFF700000007FFFFFFFF0000000FFFFFFFFF7000007F
      FFFFFFFFF00000FFFFFFFFFFF70007FFFFFFFFFFFF000FFFFFFFFFFFFF707FFF
      FFFFFFFFFFF0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    OnClick = SBUpClick
  end
  object SBDown: TSpeedButton
    Left = 172
    Top = 56
    Width = 23
    Height = 22
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFF707FFFFFFFFFFFFF000FF
      FFFFFFFFFF70007FFFFFFFFFFF00000FFFFFFFFFF7000007FFFFFFFFF0000000
      FFFFFFFF700000007FFFFFFF000000000FFFFFF70000000007FFFFF000000000
      00FFFF7000000000007FFF0000000000000FFFFFFFFFFFFFFFFF}
    OnClick = SBDownClick
  end
  object SBLeft: TSpeedButton
    Left = 148
    Top = 32
    Width = 23
    Height = 22
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFF70FFFFFFFFFFFF7000FFFFFFFFFF700000FFFFFFFF70000
      000FFFFFF7000000000FFFF700000000000FFF0000000000000FFFF700000000
      000FFFFFF7000000000FFFFFFFF70000000FFFFFFFFFF700000FFFFFFFFFFFF7
      000FFFFFFFFFFFFFF70FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    OnClick = SBLeftClick
  end
  object SBRight: TSpeedButton
    Left = 196
    Top = 32
    Width = 23
    Height = 22
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFF07FFFFFFFFFFFFFF0007FFFFFFFFFFFF000007FFFFF
      FFFFF00000007FFFFFFFF0000000007FFFFFF000000000007FFFF00000000000
      00FFF000000000007FFFF0000000007FFFFFF00000007FFFFFFFF000007FFFFF
      FFFFF0007FFFFFFFFFFFF07FFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    OnClick = SBRightClick
  end
  object SBStop: TSpeedButton
    Left = 172
    Top = 32
    Width = 23
    Height = 22
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFF99999FFFFFFFFFF9999999FFFFFFFF999999999
      FFFFFF99999999999FFFF9999999999999FFF9999999999999FFF99999999999
      99FFF9999999999999FFF9999999999999FFFF99999999999FFFFFF999999999
      FFFFFFFF9999999FFFFFFFFFF99999FFFFFFFFFFFFFFFFFFFFFF}
    OnClick = SBStopClick
  end
  object Label3: TLabel
    Left = 8
    Top = 64
    Width = 50
    Height = 13
    Caption = 'dead zone'
  end
  object Label4: TLabel
    Left = 8
    Top = 92
    Width = 51
    Height = 13
    Caption = 'max. move'
  end
  object BCalibrate: TButton
    Left = 8
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Calibrate'
    TabOrder = 0
    OnClick = BCalibrateClick
  end
  object SERect: TRxSpinEdit
    Left = 68
    Top = 4
    Width = 69
    Height = 21
    Hint = 'pixel/ms'
    ValueType = vtFloat
    Value = -10
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object SEDecl: TRxSpinEdit
    Left = 68
    Top = 32
    Width = 69
    Height = 21
    Hint = 'pixel/ms'
    ValueType = vtFloat
    Value = 12
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
  object TBInterval: TTrackBar
    Left = 92
    Top = 116
    Width = 129
    Height = 29
    Hint = '2000 ms'
    LineSize = 100
    Max = 10000
    Min = 500
    Orientation = trHorizontal
    ParentShowHint = False
    PageSize = 500
    Frequency = 500
    Position = 2000
    SelEnd = 0
    SelStart = 0
    ShowHint = True
    TabOrder = 3
    TickMarks = tmBottomRight
    TickStyle = tsAuto
    OnChange = TBIntervalChange
  end
  object CBGuide: TCheckBox
    Left = 156
    Top = 88
    Width = 57
    Height = 17
    Caption = 'Guide'
    TabOrder = 4
    OnClick = CBGuideClick
  end
  object SEMin: TRxSpinEdit
    Left = 68
    Top = 60
    Width = 69
    Height = 21
    Hint = 'minimum pixel deviation'
    Decimal = 0
    ValueType = vtFloat
    Value = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnChange = SEMinMaxChange
  end
  object SEMax: TRxSpinEdit
    Left = 68
    Top = 88
    Width = 69
    Height = 21
    Hint = 'maximum pixel deviation'
    Decimal = 0
    MaxValue = 240
    ValueType = vtFloat
    Value = 240
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnChange = SEMinMaxChange
  end
  object FPControl: TFormPlacement
    IniFileName = 'Software\Weingrill\AstroCap'
    IniSection = 'ControlForm'
    UseRegistry = True
    Left = 152
    Top = 116
  end
  object MainMenu1: TMainMenu
    Left = 192
    Top = 116
    object Telescope1: TMenuItem
      Caption = 'Telescope'
      object MIConnect: TMenuItem
        Caption = 'Connect'
        OnClick = MIConnectClick
      end
      object MIDisconnect: TMenuItem
        Caption = 'DisConnect'
        OnClick = MIDisconnectClick
      end
    end
    object MIPort: TMenuItem
      Caption = 'Port'
      object MICOM1: TMenuItem
        Caption = 'COM1'
        Checked = True
        GroupIndex = 2
        RadioItem = True
        OnClick = MICOM1Click
      end
      object MICOM2: TMenuItem
        Caption = 'COM2'
        GroupIndex = 2
        RadioItem = True
        OnClick = MICOM2Click
      end
    end
    object MIType: TMenuItem
      Caption = 'Type'
      object MIMTS: TMenuItem
        Caption = 'PowerFlex'
        Checked = True
        GroupIndex = 1
        Hint = 'Boxdörfer Powerflex MTS-3'
        RadioItem = True
        OnClick = MIMTSClick
      end
      object MILX200: TMenuItem
        Caption = 'LX200'
        GroupIndex = 1
        Hint = 'Meade LX200 and compatible'
        RadioItem = True
        OnClick = MILX200Click
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 120
    Top = 116
  end
end
