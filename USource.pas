unit USource;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Videocap, VideoHdr, Placemnt;

type
  TFSource = class(TForm)
    VideoCap1: TVideoCap;
    FPPreview: TFormPlacement;
    procedure VideoCap1FrameCallback(sender: TObject; lpVhdr: PVIDEOHDR);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FSource: TFSource;

implementation

uses UMain;

{$R *.DFM}

procedure TFSource.VideoCap1FrameCallback(sender: TObject; lpVhdr: PVIDEOHDR);
begin
  FrameToBitmap(FMain.Image1.Picture.Bitmap,lpVhdr.lpData,Videocap1.BitMapInfo);
  FMain.Image1.Picture.Bitmap.PixelFormat := pf24bit;
  FMain.Image1.Refresh;
  FMain.ProcessImage;
end;

procedure TFSource.FormCreate(Sender: TObject);
begin
  with FMain.IniFile do
  begin
    VideoCap1.DriverIndex := ReadInteger('VideoCap','DriverIndex',0);
    VideoCap1.FrameRate := ReadInteger('VideoCap','FrameRate',15);
    VideoCap1.PreviewRate := ReadInteger('VideoCap','PreviewRate',15);
  end;
  VideoCap1.DriverOpen := True;
  VideoCap1.VideoPreview := True;
end;

procedure TFSource.FormClose(Sender: TObject; var Action: TCloseAction);
begin   
  VideoCap1.DriverOpen := False;
end;

end.
