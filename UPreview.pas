unit UPreview;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Videocap, Menus, VideoHdr;

type
  TFPreview = class(TForm)
    VideoCap1: TVideoCap;
    PMPreview: TPopupMenu;
    MI5fps: TMenuItem;
    MI10fps: TMenuItem;
    MI15fps: TMenuItem;
    MI20fps: TMenuItem;
    MI25fps: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MIfpsClick(Sender: TObject);
    procedure VideoCap1FrameCallback(sender: TObject; lpVhdr: PVIDEOHDR);
  private
    { Private-Deklarationen }
    freq,start,stop: Int64;
    FrameNo: Integer;
  public
    { Public-Deklarationen }
  end;

var
  FPreview: TFPreview;

implementation

uses UHaupt, USettings, UFrame, UInfo;

{$R *.DFM}

procedure TFPreview.FormCreate(Sender: TObject);
begin
  FrameNo := 0;
  if VideoCap1.DriverIndex > -1 then
    VideoCap1.DriverOpen := True;
  FPreview.Top := 0;
  FPreview.Left := FHaupt.ClientWidth-FPreview.ClientWidth-10;
  QueryPerformanceFrequency(freq);
  QueryPerformanceCounter(start);
end;

procedure TFPreview.FormDestroy(Sender: TObject);
begin
  VideoCap1.DriverOpen := False;
end;

procedure TFPreview.MIfpsClick(Sender: TObject);
begin
  if Sender=MI5fps then
  begin
    MI5fps.Checked := true;
    VideoCap1.PreviewRate := 5;
    VideoCap1.FrameRate := 5;
  end;
  if Sender=MI10fps then
  begin
    MI10fps.Checked := true;
    VideoCap1.PreviewRate := 10;
    VideoCap1.FrameRate := 10;
  end;
  if Sender=MI15fps then
  begin
    MI15fps.Checked := true;
    VideoCap1.PreviewRate := 15;
    VideoCap1.FrameRate := 15;
  end;
  if Sender=MI20fps then
  begin
    MI20fps.Checked := true;
    VideoCap1.PreviewRate := 20;
    VideoCap1.FrameRate := 20;
  end;
  if Sender=MI25fps then
  begin
    MI25fps.Checked := true ;
    VideoCap1.PreviewRate := 25;
    VideoCap1.FrameRate := 25;
  end;
end;

procedure TFPreview.VideoCap1FrameCallback(sender: TObject;
  lpVhdr: PVIDEOHDR);
begin
  QueryPerformanceCounter(stop);
  Inc(FrameNo);
  if FHaupt.MIVorschau.Checked or
     FHaupt.MISingleFrame.Checked or
     FHaupt.MIMultiframe.Checked or
     FHaupt.MIOptometrie.Checked then
  begin
   // VideoCap1.VideoPreview := False;
    FrameToBitmap(FHaupt.Current,lpVhdr.lpData,Videocap1.BitMapInfo);
    if FHaupt.MIOptometrie.Checked then
      FInfo.Optometric(FHaupt.Current);

    FHaupt.CaptureSingleFrame;
  //  VideoCap1.VideoPreview := True;
  end;
  if freq > (stop-start) then
    FPreview.Caption := format('Vorschau: %3.3g fps',[freq/(stop-start)])
  else
    FPreview.Caption := format('Vorschau: %3.3g spf',[(stop-start)/freq]);
  VideoCap1.MicroSecPerFrame := Round((stop-start)*1000000/freq);
  QueryPerformanceCounter(start);
end;

end.
