object FSource: TFSource
  Left = 836
  Top = 105
  BorderStyle = bsToolWindow
  Caption = 'Preview'
  ClientHeight = 120
  ClientWidth = 160
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  HelpFile = 'AstroCap.hlp'
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object VideoCap1: TVideoCap
    Left = 0
    Top = 0
    Width = 160
    Height = 120
    align = alClient
    color = clBlack
    DriverOpen = False
    DriverIndex = 0
    DriverName = 'Microsoft WDM Image Capture (Win32)'
    VideoOverlay = False
    VideoPreview = False
    PreviewScaleToWindow = True
    PreviewScaleProportional = True
    PreviewRate = 30
    MicroSecPerFrame = 66667
    FrameRate = 15
    CapAudio = False
    VideoFileName = 'Video.avi'
    SingleImageFile = 'Capture.bmp'
    CapTimeLimit = 0
    CapIndexSize = 0
    CapToFile = False
    BufferFileSize = 0
    OnFrameCallback = VideoCap1FrameCallback
  end
  object FPPreview: TFormPlacement
    IniFileName = 'Software\Weingrill\AstroCap'
    IniSection = 'PreviewForm'
    UseRegistry = True
    Left = 24
    Top = 20
  end
end
