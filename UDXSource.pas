unit UDXSource;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, DSPack, DSUtil, DirectShow9, Placemnt;

type
  TFDXSource = class(TForm)
    VideoWindow: TVideoWindow;
    FilterGraph: TFilterGraph;
    MainMenu1: TMainMenu;
    Devices: TMenuItem;
    SampleGrabber: TSampleGrabber;
    FPSourceForm: TFormPlacement;
    Filter: TFilter;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SampleGrabberBuffer(sender: TObject; SampleTime: Double;
      pBuffer: Pointer; BufferLen: Integer);
    procedure VideoWindowClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure OnSelectDevice(sender: TObject);
  end;

var
  FDXSource: TFDXSource;
  SysDev: TSysDevEnum;

implementation

uses UMain;

{$R *.DFM}

procedure TFDXSource.FormCreate(Sender: TObject);
var
  i: integer;
  Device: TMenuItem;
begin
  SysDev:= TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
  if SysDev.CountFilters > 0 then
    for i := 0 to SysDev.CountFilters - 1 do
    begin
      Device := TMenuItem.Create(Devices);
      Device.Caption := SysDev.Filters[i].FriendlyName;
      Device.Tag := i;
      Device.OnClick := OnSelectDevice;
      Devices.Add(Device);
    end;
end;

procedure TFDXSource.OnSelectDevice(sender: TObject);
var
  CaptureGraph: ICaptureGraphBuilder2;
  SourceFilter, DestFilter: IBaseFilter;
begin
  FilterGraph.ClearGraph;
  FilterGraph.Active := false;
  Filter.BaseFilter.Moniker := SysDev.GetMoniker(TMenuItem(Sender).tag);
  FilterGraph.Active := true;
  FilterGraph.QueryInterface(ICaptureGraphBuilder2, CaptureGraph);
  Filter.QueryInterface(IBaseFilter, SourceFilter);
  VideoWindow.QueryInterface(IBaseFilter, DestFilter);
  CaptureGraph.RenderStream(nil, nil, SourceFilter, nil, DestFilter);
  FilterGraph.Play;
  CaptureGraph := nil;
  SourceFilter := nil;
  DestFilter   := nil;
end;

procedure TFDXSource.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  SysDev.Free;
  FilterGraph.ClearGraph;
  FilterGraph.Active := false;
end;

procedure TFDXSource.SampleGrabberBuffer(sender: TObject;
  SampleTime: Double; pBuffer: Pointer; BufferLen: Integer);
begin
  FMain.Image1.Picture.Bitmap.Width := 640;
  FMain.Image1.Picture.Bitmap.Height := 480;
  FMain.Image1.Picture.Bitmap.Canvas.Lock;
  try
    SampleGrabber.GetBitmap(FMain.Image1.Picture.Bitmap, pBuffer, BufferLen);
    //FMain.ProcessImage;
//    FMain.Image1.Picture.Bitmap.PixelFormat := pf24bit;
//    FMain.Image1.Refresh;
{    FilterGraph.Pause;
    FMain.ProcessImage;
    FilterGraph.Play;}
  finally
    FMain.Image1.Picture.Bitmap.Canvas.UnLock;
  end;
end;

procedure TFDXSource.VideoWindowClick(Sender: TObject);
begin
  FMain.Image1.Picture.Bitmap.Width := 640;
  FMain.Image1.Picture.Bitmap.Height := 480;
  SampleGrabber.GetBitmap(FMain.Image1.Picture.Bitmap);
  FMain.Image1.Picture.Bitmap.PixelFormat := pf24bit;
  FMain.Image1.Refresh;
  FMain.ProcessImage;
end;

end.
