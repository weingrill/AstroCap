object FDXSource: TFDXSource
  Left = 492
  Top = 151
  BorderStyle = bsToolWindow
  Caption = 'DXSource'
  ClientHeight = 240
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object VideoWindow: TVideoWindow
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    FilterGraph = FilterGraph
    VMROptions.Mode = vmrWindowed
    VMROptions.Preferences = []
    Color = clBlack
    Align = alClient
    OnClick = VideoWindowClick
  end
  object FilterGraph: TFilterGraph
    Mode = gmCapture
    GraphEdit = True
    Left = 20
    Top = 16
  end
  object MainMenu1: TMainMenu
    Left = 84
    Top = 16
    object Devices: TMenuItem
      Caption = 'Devices'
    end
  end
  object SampleGrabber: TSampleGrabber
    OnBuffer = SampleGrabberBuffer
    FilterGraph = FilterGraph
    MediaType.data = {
      7669647300001000800000AA00389B714959555600001000800000AA00389B71
      FFFFFFFF00000000010000000000000000000000000000000000000000000000
      0000000000000000}
    Left = 52
    Top = 48
  end
  object FPSourceForm: TFormPlacement
    IniFileName = 'Software\Weingrill\AstroCap'
    UseRegistry = True
    Left = 84
    Top = 48
  end
  object Filter: TFilter
    BaseFilter.data = {00000000}
    FilterGraph = FilterGraph
    Left = 52
    Top = 16
  end
end
