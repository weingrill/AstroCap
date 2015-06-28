unit UDispThr;

interface

uses
  Classes,UFrame,VideoCap, Videohdr, Windows;

type
  TDisplayThread = class(TThread)
  private
    { Private-Deklarationen }
    DisplpVhdr: PVIDEOHDR;
    DispBMI: tBitmapInfo;
  protected
    procedure Show;
    procedure Execute; override;
  public
    Constructor Create(lpVhdr: PVIDEOHDR; bmi: tBitmapInfo);
  end;

implementation

{ TDisplayThread }

constructor TDisplayThread.Create(lpVhdr: PVIDEOHDR; bmi: tBitmapInfo);
begin
  DisplpVhdr := lpVhdr;
  DispBMI := bmi;
end;

procedure TDisplayThread.Show;
begin
  FFrame.Image1.Refresh;
end;

procedure TDisplayThread.Execute;
begin
  FrameToBitmap(FFrame.Image1.Picture.Bitmap,DisplpVhdr.lpData,Dispbmi);
  Synchronize(Show);
end;

end.
