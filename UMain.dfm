object FMain: TFMain
  Left = 201
  Top = 162
  Width = 648
  Height = 582
  Caption = 'AstroCap 4.0'
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000013333311000000000000000000000033333333333777000000000000
    000013888888B33233777000000000000003888F8F8B33223333770000000000
    00388FFF88833323323377700000000003BB8F888733333BBBB3377700000000
    33BB8887333333BBB3B33337700000013BBBB3333333BBBBBBB2333370000003
    BBB3BBBBBBBBBBBBBBBB33337700003BBB33BBBBBBBBBBBBBBB333333700003B
    BB33BBBBBBBBBBBBBB3333333300003BB333BBBBBBBBBB3BB3333332370003BB
    B333BBBBBBBBBBBB3333333333000BBB3333BBBBBBBBBB3B3333333333300B8B
    B333333BB333333B3333333333300B8BBB3333333333333333333B3B33300B8B
    BB333333333333333333BBBB33300B8BBB3333333333333333BBBB3B32300BBB
    BB33B333333333333BBBBB3B33300BBBBBBBBBB33333333BBB3BBBBBB3000BBB
    BBBBBBBBB333333BBBBBBBBB330002BBBBBBBBBBBB3333BBBBBBBBBB2200003B
    BBBBBBBBBBB33BBBBBBBBBBB2000002BBBBBBBBBBBB33BBBBBBBBBB220000003
    BBBBBBBBBBBB3BBBBBBBBB22000000003BBBBBBBBBBBBBBBBBBBBB3200000000
    2BBBBBBBBBBBBBBBBBBBB33000000000023BBBBBBBBBBBBBBBB3330000000000
    0006BBBBBBBBBBBBBB73200000000000000026BBBBBBBBBBBB62000000000000
    000000666222227764000000000000000000000004666640000000000000FFC0
    007FFE00003FFC00001FF800000FF0000007E0000003C0000003C00000018000
    0001800000008000000080000000000000000000000000000000000000000000
    000000000000000000000000000000000000800000008000000180000001C000
    0003C0000007E000000FF000000FF800003FFC00007FFF0000FFFFE003FF}
  Menu = MMMain
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 37
    Width = 640
    Height = 480
    Cursor = crCross
    Hint = 'drag rectangle around desired object'
    Align = alClient
    AutoSize = True
    IncrementalDisplay = True
    ParentShowHint = False
    ShowHint = False
    OnMouseDown = Image1MouseDown
    OnMouseMove = Image1MouseMove
    OnMouseUp = Image1MouseUp
  end
  object PTopPanel: TPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 37
    Align = alTop
    TabOrder = 0
    object SBSettings: TSpeedButton
      Left = 8
      Top = 8
      Width = 23
      Height = 22
      Hint = 'VideoSettings'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000130B0000130B00001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFF88808888888FCCFFFFF0FFFFFFF
        FCCFFFFFFFFFFFFFFFFFFFFFFFFFF0FFFFFFF88888888088FAAFFFFFFFFFF0FF
        FAAFFFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFF88088888888F99FFFF0FFFFFFFF
        F99FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      ParentShowHint = False
      ShowHint = True
      OnClick = SBSettingsClick
    end
    object SBFormat: TSpeedButton
      Left = 36
      Top = 8
      Width = 23
      Height = 22
      Hint = 'VideoFormat'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000130B0000130B00001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000
        000FF0FFFFFFFFFFFF0FF0FFFFFFFFFFFF0FF0000000000FFF0FF0FFFFFFFF0F
        FF0FF0FFFFFFFF0FFF0FF00000FFFF0FFF0FF0FFF0FFFF0FFF0FF0FFF0FFFF0F
        FF0FF00000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      ParentShowHint = False
      ShowHint = True
      OnClick = SBFormatClick
    end
    object SBRecord: TSpeedButton
      Left = 428
      Top = 8
      Width = 23
      Height = 22
      Hint = 'Record'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000130B0000130B00001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFF99999FFFFFFFFF199999991FFFFFF1999999999
        1FFFFF99999999999FFFF9999999999999FFF9999999999999FFF99999999999
        99FFF9999999999999FFF9999999999999FFFF99999999999FFFFF1999999999
        1FFFFFF199999991FFFFFFFFF99999FFFFFFFFFFFFFFFFFFFFFF}
      ParentShowHint = False
      ShowHint = True
      OnClick = SBRecordClick
    end
    object FEFiles: TFilenameEdit
      Left = 64
      Top = 8
      Width = 265
      Height = 21
      Hint = 
        'path for capture files. can be JPEG or BMP'#13#10#39'%d'#39' will be replace' +
        'd with current date'#13#10#39'%t'#39' will be replaced with current time'
      DefaultExt = 'Bmp'
      Filter = 'Bitmap|*.bmp|JPeg|*.jpg|all files|*.*'
      DialogOptions = [ofHideReadOnly, ofEnableSizing]
      NumGlyphs = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = 'C:\Cap.bmp'
    end
    object SPCount: TRxSpinEdit
      Left = 336
      Top = 8
      Width = 85
      Height = 21
      Hint = 'Number of frames to capture'
      Decimal = 0
      Increment = 10
      MaxValue = 999
      MinValue = 1
      Value = 20
      MaxLength = 3
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object TBSeeing: TTrackBar
      Left = 520
      Top = 4
      Width = 113
      Height = 25
      Hint = 'Seeing dependend filtering'
      Anchors = [akLeft, akTop, akRight]
      Orientation = trHorizontal
      ParentShowHint = False
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      ShowHint = True
      TabOrder = 2
      TickMarks = tmBottomRight
      TickStyle = tsAuto
    end
    object TBDamping: TTrackBar
      Left = 456
      Top = 4
      Width = 64
      Height = 29
      Hint = 'Guide damping'#13#10'(set higher for difficult objects)'
      Max = 100
      Orientation = trHorizontal
      ParentShowHint = False
      PageSize = 10
      Frequency = 10
      Position = 50
      SelEnd = 0
      SelStart = 0
      ShowHint = True
      TabOrder = 3
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = TBDampingChange
    end
  end
  object SBInfo: TStatusBar
    Left = 0
    Top = 517
    Width = 640
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Width = 100
      end
      item
        Width = 100
      end
      item
        Width = 100
      end
      item
        Width = 75
      end>
    SimplePanel = False
  end
  object MMMain: TMainMenu
    Left = 8
    Top = 44
    object MIProgram: TMenuItem
      Caption = 'Program'
      object MIClose: TMenuItem
        Caption = 'Close'
        ShortCut = 16472
      end
    end
    object MIFilters: TMenuItem
      Caption = 'Filters'
      object MIContrast: TMenuItem
        Caption = 'AutoContrast'
        OnClick = MIContrastClick
      end
      object MIRGBAlign: TMenuItem
        Caption = 'RGBAlign'
        OnClick = MIRGBAlignClick
      end
    end
    object MIOptions: TMenuItem
      Caption = 'Options'
      object MIinverse: TMenuItem
        Caption = 'inverse Guiding'
        OnClick = MIinverseClick
      end
    end
    object MIWindows: TMenuItem
      Caption = 'Windows'
      object MIPreview: TMenuItem
        Caption = 'Preview'
        OnClick = MIPreviewClick
      end
      object MIOptometric: TMenuItem
        Caption = 'Optometric'
        OnClick = MIOptometricClick
      end
      object MIControl: TMenuItem
        Caption = 'Control'
        OnClick = MIControlClick
      end
      object MIOutput: TMenuItem
        Caption = 'Output'
        OnClick = MIOutputClick
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      Hint = 'MIHelp'
      OnClick = Help1Click
    end
  end
  object FPMainForm: TFormPlacement
    IniFileName = 'Software\Weingrill\AstroCap'
    IniSection = 'MainForm'
    UseRegistry = True
    Left = 40
    Top = 44
  end
end
