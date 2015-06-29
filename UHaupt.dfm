object FHaupt: TFHaupt
  Left = 247
  Top = 149
  Width = 648
  Height = 582
  Caption = 'AstroCap3'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MMHaupt
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 640
    Height = 480
    Cursor = crCross
    Align = alClient
    IncrementalDisplay = True
    OnMouseDown = Image1MouseDown
    OnMouseMove = Image1MouseMove
    OnMouseUp = Image1MouseUp
  end
  object Panel1: TPanel
    Left = 0
    Top = 480
    Width = 640
    Height = 37
    Align = alBottom
    TabOrder = 0
    object FEDatei: TFilenameEdit
      Left = 4
      Top = 8
      Width = 229
      Height = 21
      Hint = 'Dateiname'
      DefaultExt = '.BMP'
      Filter = 'Alle Dateien (*.*)|*.*|Bitmaps|*.bmp'
      DialogOptions = [ofHideReadOnly, ofPathMustExist]
      NumGlyphs = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = 'cap0000.bmp'
      OnExit = FEDateiExit
    end
    object RSEFrames: TRxSpinEdit
      Left = 284
      Top = 8
      Width = 61
      Height = 21
      Hint = 'Bilder pro Serie'
      Decimal = 0
      MaxValue = 999
      MinValue = 1
      Value = 1
      MaxLength = 3
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object BCapture: TButton
      Left = 560
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Aufnahme'
      TabOrder = 2
      OnClick = BCaptureClick
    end
  end
  object SBInfo: TStatusBar
    Left = 0
    Top = 517
    Width = 640
    Height = 19
    Panels = <
      item
        Width = 75
      end
      item
        Width = 127
      end
      item
        Width = 75
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object MMHaupt: TMainMenu
    Left = 84
    Top = 20
    object MIProgramm: TMenuItem
      Caption = 'Programm'
      object MIVideoquelle: TMenuItem
        Caption = 'Videoquelle'
        OnClick = MIVideoquelleClick
      end
      object MIQuit: TMenuItem
        Caption = 'Beenden'
        OnClick = MIQuitClick
      end
    end
    object Guiding1: TMenuItem
      Caption = 'Guiding'
      object MIGuideOff: TMenuItem
        Caption = 'Off'
        Checked = True
        GroupIndex = 1
        RadioItem = True
        OnClick = MIGuideClick
      end
      object MIcenter: TMenuItem
        Caption = 'Zentrieren'
        GroupIndex = 1
        RadioItem = True
        OnClick = MIGuideClick
      end
      object MIstabilize: TMenuItem
        Caption = 'Bild stabilisieren'
        GroupIndex = 1
        RadioItem = True
        OnClick = MIGuideClick
      end
    end
    object Ansicht1: TMenuItem
      Caption = 'Ansicht'
      object MIcrosshair: TMenuItem
        Caption = 'Fadenkreuz'
        OnClick = MenuItemCheck
      end
    end
    object MIFilter: TMenuItem
      Caption = 'Filter'
      object MIRed: TMenuItem
        Caption = 'Rot'
        GroupIndex = 2
        RadioItem = True
        OnClick = MenuItemCheck
      end
      object MIGreen: TMenuItem
        Caption = 'Grün'
        GroupIndex = 2
        RadioItem = True
        OnClick = MenuItemCheck
      end
      object MIBlue: TMenuItem
        Caption = 'Blau'
        GroupIndex = 2
        RadioItem = True
        OnClick = MenuItemCheck
      end
      object kein1: TMenuItem
        Caption = '(kein)'
        Checked = True
        GroupIndex = 2
        RadioItem = True
        OnClick = MenuItemCheck
      end
    end
    object MIEffekte: TMenuItem
      Caption = 'Effekte'
      object MIKontrast: TMenuItem
        Caption = 'AutoKontrast'
        OnClick = MenuItemCheck
      end
    end
  end
end
