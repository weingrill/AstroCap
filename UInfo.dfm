object FInfo: TFInfo
  Left = 228
  Top = 534
  Width = 695
  Height = 145
  Hint = 'Optometrie'
  BorderStyle = bsSizeToolWin
  Caption = 'Optometric'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  HelpFile = 'AstroCap.hlp'
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
  OldCreateOrder = False
  Position = poDefault
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TCInfo: TTabControl
    Left = 0
    Top = 0
    Width = 687
    Height = 118
    Align = alClient
    TabOrder = 0
    TabPosition = tpBottom
    Tabs.Strings = (
      'Histogramm'
      'Integral'
      'Sobel'
      'Profil'
      'QProfil'
      'QSobel'
      'SNR'
      'Noise'
      'FWHM'
      'Fourier'
      'Spectrum'
      'Position'
      'Goodness')
    TabIndex = 0
    OnChange = TCInfoChange
    object Histogramm: TChart
      Left = 4
      Top = 6
      Width = 679
      Height = 90
      Hint = 'Histogramm'
      AllowZoom = False
      BackWall.Brush.Color = clWhite
      BackWall.Brush.Style = bsClear
      MarginBottom = 0
      MarginLeft = 0
      MarginRight = 0
      MarginTop = 0
      Title.Text.Strings = (
        '')
      Title.Visible = False
      BottomAxis.LabelsFont.Charset = DEFAULT_CHARSET
      BottomAxis.LabelsFont.Color = clSilver
      BottomAxis.LabelsFont.Height = -11
      BottomAxis.LabelsFont.Name = 'Arial'
      BottomAxis.LabelsFont.Style = []
      LeftAxis.Axis.Color = clWhite
      LeftAxis.Axis.Visible = False
      LeftAxis.LabelsFont.Charset = DEFAULT_CHARSET
      LeftAxis.LabelsFont.Color = clWhite
      LeftAxis.LabelsFont.Height = -11
      LeftAxis.LabelsFont.Name = 'Arial'
      LeftAxis.LabelsFont.Style = []
      LeftAxis.MinorGrid.Color = clGray
      LeftAxis.Title.Font.Charset = DEFAULT_CHARSET
      LeftAxis.Title.Font.Color = clWhite
      LeftAxis.Title.Font.Height = -11
      LeftAxis.Title.Font.Name = 'Arial'
      LeftAxis.Title.Font.Style = []
      Legend.Visible = False
      View3D = False
      Align = alClient
      Color = clBlack
      TabOrder = 0
      object Series1: TFastLineSeries
        Marks.ArrowLength = 8
        Marks.Visible = False
        SeriesColor = clRed
        LinePen.Color = clRed
        XValues.DateTime = False
        XValues.Name = 'X'
        XValues.Multiplier = 1
        XValues.Order = loAscending
        YValues.DateTime = False
        YValues.Name = 'Y'
        YValues.Multiplier = 1
        YValues.Order = loNone
      end
      object Series2: TFastLineSeries
        Marks.ArrowLength = 8
        Marks.Visible = False
        SeriesColor = clGreen
        LinePen.Color = clGreen
        XValues.DateTime = False
        XValues.Name = 'X'
        XValues.Multiplier = 1
        XValues.Order = loAscending
        YValues.DateTime = False
        YValues.Name = 'Y'
        YValues.Multiplier = 1
        YValues.Order = loNone
      end
      object Series3: TFastLineSeries
        Marks.ArrowLength = 8
        Marks.Visible = False
        SeriesColor = clBlue
        LinePen.Color = clBlue
        XValues.DateTime = False
        XValues.Name = 'X'
        XValues.Multiplier = 1
        XValues.Order = loAscending
        YValues.DateTime = False
        YValues.Name = 'Y'
        YValues.Multiplier = 1
        YValues.Order = loNone
      end
      object Series4: TFastLineSeries
        Marks.ArrowLength = 8
        Marks.Visible = False
        SeriesColor = clSilver
        LinePen.Color = clSilver
        XValues.DateTime = False
        XValues.Name = 'X'
        XValues.Multiplier = 1
        XValues.Order = loAscending
        YValues.DateTime = False
        YValues.Name = 'Y'
        YValues.Multiplier = 1
        YValues.Order = loNone
      end
    end
  end
  object FPInfo: TFormPlacement
    IniFileName = 'Software\Weingrill\AstroCap'
    IniSection = 'InfoForm'
    UseRegistry = True
    Left = 76
    Top = 26
  end
end
