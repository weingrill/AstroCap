object FInfo: TFInfo
  Left = 245
  Top = 277
  Hint = 'Optometrie'
  BorderStyle = bsSingle
  Caption = 'Optometrie'
  ClientHeight = 149
  ClientWidth = 687
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
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TCInfo: TTabControl
    Left = 0
    Top = 0
    Width = 687
    Height = 149
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
      'Spectrum')
    TabIndex = 0
    OnChange = TCInfoChange
    object Histogramm: TChart
      Left = 4
      Top = 6
      Width = 679
      Height = 121
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
      LeftAxis.Automatic = False
      LeftAxis.AutomaticMaximum = False
      LeftAxis.Axis.Color = clWhite
      LeftAxis.Axis.Visible = False
      LeftAxis.LabelsFont.Charset = DEFAULT_CHARSET
      LeftAxis.LabelsFont.Color = clWhite
      LeftAxis.LabelsFont.Height = -11
      LeftAxis.LabelsFont.Name = 'Arial'
      LeftAxis.LabelsFont.Style = []
      LeftAxis.Maximum = 1097
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
end
