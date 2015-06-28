object FSettings: TFSettings
  Left = 404
  Top = 238
  BorderStyle = bsSingle
  Caption = 'Einstellungen'
  ClientHeight = 389
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  HelpFile = 'AstroCap.hlp'
  OldCreateOrder = False
  Position = poDefault
  Scaled = False
  ShowHint = True
  Visible = True
  WindowMenu = FHaupt.MIWindow
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 12
    Width = 56
    Height = 13
    Caption = 'Video&treiber'
    FocusControl = CBDriver
  end
  object Label3: TLabel
    Left = 132
    Top = 116
    Width = 51
    Height = 13
    Caption = 'Datei&name'
    FocusControl = EFilename
  end
  object LFpB: TLabel
    Left = 12
    Top = 168
    Width = 77
    Height = 13
    Caption = '&Frames / Bitmap'
    FocusControl = TBFpB
  end
  object LBpS: TLabel
    Left = 12
    Top = 228
    Width = 72
    Height = 13
    Caption = 'Bitmaps / &Serie'
    FocusControl = TBBpS
  end
  object Label2: TLabel
    Left = 12
    Top = 64
    Width = 78
    Height = 13
    Caption = 'Basisverzeichnis'
  end
  object Label4: TLabel
    Left = 12
    Top = 116
    Width = 91
    Height = 13
    Caption = 'Serienbezeichnung'
    FocusControl = ESeries
  end
  object Label5: TLabel
    Left = 120
    Top = 140
    Width = 7
    Height = 13
    Caption = '\'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 260
    Top = 140
    Width = 31
    Height = 13
    Caption = '.BMP'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 12
    Top = 288
    Width = 65
    Height = 13
    Caption = 'Bildausschnitt'
    FocusControl = CBSize
  end
  object LBias: TLabel
    Left = 12
    Top = 312
    Width = 20
    Height = 13
    Caption = 'Bias'
    FocusControl = SBBias
  end
  object LGain: TLabel
    Left = 12
    Top = 336
    Width = 22
    Height = 13
    Caption = 'Gain'
    FocusControl = SBGain
  end
  object CBDriver: TComboBox
    Left = 12
    Top = 32
    Width = 297
    Height = 21
    Hint = 'Aktueller Videotreiber'
    ItemHeight = 13
    TabOrder = 0
    Text = 'Bitte wählen Sie einen Treiber aus ...'
    OnChange = CBDriverChange
  end
  object TBFpB: TTrackBar
    Left = 76
    Top = 188
    Width = 233
    Height = 29
    Hint = 'Frames pro Bitmap (für Mittelung und Integration)'
    Max = 60
    Min = 1
    Orientation = trHorizontal
    PageSize = 5
    Frequency = 5
    Position = 1
    SelEnd = 0
    SelStart = 0
    TabOrder = 5
    TickMarks = tmBottomRight
    TickStyle = tsAuto
    OnChange = TBFpBChange
  end
  object TBBpS: TTrackBar
    Left = 76
    Top = 248
    Width = 233
    Height = 29
    Hint = 'Bitmaps pro Serie'
    Max = 455
    Min = 1
    Orientation = trHorizontal
    PageSize = 10
    Frequency = 10
    Position = 1
    SelEnd = 0
    SelStart = 0
    TabOrder = 7
    TickMarks = tmBottomRight
    TickStyle = tsAuto
    OnChange = TBBpSChange
  end
  object DEBasis: TDirectoryEdit
    Left = 12
    Top = 84
    Width = 297
    Height = 21
    Hint = 'Basisverzeichnis für alle Aufnahmen'
    DialogText = 'Basisverzeichnis für Aufnahmen'
    DialogOptions = [sdAllowCreate, sdPerformCreate]
    NumGlyphs = 1
    TabOrder = 1
    Text = 'C:\'
    OnChange = EFilenameChange
  end
  object ESeries: TEdit
    Left = 12
    Top = 136
    Width = 101
    Height = 21
    Hint = 'Serienbezeichnung (z.B. Jupiter oder Newton'
    TabOrder = 2
    Text = 'Sonne'
    OnChange = EFilenameChange
  end
  object EFilename: TEdit
    Left = 132
    Top = 136
    Width = 121
    Height = 21
    Hint = 'Dateiname (fünf Ziffern und '#39'.bmp'#39' werden automatisch angehängt)'
    TabOrder = 3
    Text = 'Cap'
    OnChange = EFilenameChange
  end
  object SEFpB: TRxSpinEdit
    Left = 12
    Top = 192
    Width = 49
    Height = 21
    Hint = 'Frames pro Bitmap (für Mittelung und Integration)'
    MaxValue = 60
    MinValue = 1
    Value = 1
    MaxLength = 2
    TabOrder = 4
    OnChange = SEFpBChange
  end
  object SEBpS: TRxSpinEdit
    Left = 12
    Top = 252
    Width = 49
    Height = 21
    Hint = 'Bitmaps pro Serie'
    MaxValue = 455
    MinValue = 1
    Value = 1
    MaxLength = 3
    TabOrder = 6
    OnChange = SEBpSChange
  end
  object CBSize: TComboBox
    Left = 92
    Top = 284
    Width = 145
    Height = 21
    Hint = 'aufzunehmender zentraler Bildauschnitt'
    ItemHeight = 13
    TabOrder = 8
    Text = '640x480'
    OnChange = CBSizeChange
    Items.Strings = (
      '768x512'
      '704x469'
      '640x480'
      '576x432'
      '512x384'
      '448x336'
      '384x288'
      '320x240'
      '256x192'
      '192x144'
      '128x96'
      '64x48')
  end
  object SBBias: TScrollBar
    Left = 40
    Top = 312
    Width = 165
    Height = 12
    Hint = 'Bias'
    Max = 255
    PageSize = 0
    TabOrder = 9
    OnChange = SBBiasChange
  end
  object SBGain: TScrollBar
    Left = 40
    Top = 336
    Width = 165
    Height = 12
    Hint = 'Gain'
    Max = 255
    Min = 1
    PageSize = 0
    Position = 1
    TabOrder = 10
    OnChange = SBGainChange
  end
  object TBSeeing: TTrackBar
    Left = 80
    Top = 356
    Width = 229
    Height = 29
    Hint = 'Prozentsatz der aufzunehmenden Bilder (vom Seeing abhängig)'
    Max = 100
    Orientation = trHorizontal
    PageSize = 10
    Frequency = 5
    Position = 100
    SelEnd = 0
    SelStart = 0
    TabOrder = 11
    TickMarks = tmBottomRight
    TickStyle = tsAuto
  end
  object CBSeeing: TCheckBox
    Left = 8
    Top = 360
    Width = 65
    Height = 17
    Caption = 'Seeing'
    TabOrder = 12
    OnClick = CBSeeingClick
  end
  object BAufnahme: TButton
    Left = 220
    Top = 316
    Width = 75
    Height = 25
    Caption = 'Aufnahme'
    TabOrder = 13
    OnClick = BAufnahmeClick
  end
end
