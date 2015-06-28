object FPreview: TFPreview
  Left = 456
  Top = 165
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Vorschau'
  ClientHeight = 240
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
  PopupMenu = PMPreview
  Position = poDefault
  Scaled = False
  ShowHint = True
  Visible = True
  WindowMenu = FHaupt.MIWindow
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object VideoCap1: TVideoCap
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Hint = 'Rechts-Klick um die Bildrate zu verändern'
    align = alClient
    color = clBlack
    DriverOpen = False
    DriverIndex = -1
    VideoOverlay = False
    VideoPreview = False
    PreviewScaleToWindow = True
    PreviewScaleProportional = False
    PreviewRate = 30
    MicroSecPerFrame = 33333
    FrameRate = 30
    CapAudio = False
    VideoFileName = 'Video.avi'
    SingleImageFile = 'Capture.bmp'
    CapTimeLimit = 0
    CapIndexSize = 0
    CapToFile = False
    BufferFileSize = 0
    OnFrameCallback = VideoCap1FrameCallback
  end
  object PMPreview: TPopupMenu
    Left = 20
    Top = 8
    object MI5fps: TMenuItem
      Caption = '5 fps'
      GroupIndex = 1
      RadioItem = True
      OnClick = MIfpsClick
    end
    object MI10fps: TMenuItem
      Caption = '10 fps'
      GroupIndex = 1
      RadioItem = True
      OnClick = MIfpsClick
    end
    object MI15fps: TMenuItem
      Caption = '15 fps'
      GroupIndex = 1
      RadioItem = True
      OnClick = MIfpsClick
    end
    object MI20fps: TMenuItem
      Caption = '20 fps'
      GroupIndex = 1
      RadioItem = True
      OnClick = MIfpsClick
    end
    object MI25fps: TMenuItem
      Caption = '25 fps'
      GroupIndex = 1
      RadioItem = True
      OnClick = MIfpsClick
    end
  end
end
