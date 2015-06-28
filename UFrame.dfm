object FFrame: TFFrame
  Left = 256
  Top = 167
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Einzelbild'
  ClientHeight = 480
  ClientWidth = 640
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
  Visible = True
  WindowMenu = FHaupt.MIWindow
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 640
    Height = 480
    Align = alClient
    AutoSize = True
    Center = True
    IncrementalDisplay = True
    PopupMenu = PMFrame
  end
  object PMFrame: TPopupMenu
    Left = 120
    Top = 160
    object MIAutosize: TMenuItem
      Caption = 'positionieren'
      Checked = True
      OnClick = MIAutosizeClick
    end
    object MICenter: TMenuItem
      Caption = 'zentrieren'
      Checked = True
      OnClick = MICenterClick
    end
    object MIStretch: TMenuItem
      Caption = 'skalieren'
      OnClick = MIStretchClick
    end
  end
end
