object FGuiding: TFGuiding
  Left = 824
  Top = 195
  BorderStyle = bsToolWindow
  Caption = 'Guiding'
  ClientHeight = 161
  ClientWidth = 160
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 160
    Height = 120
    Align = alClient
    Stretch = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 120
    Width = 160
    Height = 41
    Align = alBottom
    TabOrder = 0
    object CBinvert: TCheckBox
      Left = 12
      Top = 12
      Width = 49
      Height = 17
      Caption = 'invert'
      TabOrder = 0
    end
    object TBlevel: TTrackBar
      Left = 64
      Top = 8
      Width = 94
      Height = 25
      Max = 255
      Orientation = trHorizontal
      PageSize = 16
      Frequency = 16
      Position = 128
      SelEnd = 0
      SelStart = 0
      TabOrder = 1
      TickMarks = tmBottomRight
      TickStyle = tsNone
    end
  end
  object FormPlacement1: TFormPlacement
    IniFileName = 'Software\Weingrill\AstroCap'
    IniSection = 'GuideForm'
    UseRegistry = True
    Left = 52
    Top = 28
  end
end
