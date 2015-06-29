object FOutput: TFOutput
  Left = 830
  Top = 439
  Width = 136
  Height = 155
  BorderStyle = bsSizeToolWin
  Caption = 'OutPut'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 128
    Height = 128
    Hint = 'drag rectangle to enable capturing'
    Align = alClient
    AutoSize = True
    ParentShowHint = False
    ShowHint = True
    Stretch = True
  end
  object FPOutput: TFormPlacement
    IniFileName = 'Software\Weingrill\AstroCap'
    IniSection = 'OutputForm'
    UseRegistry = True
    Left = 32
    Top = 24
  end
end
