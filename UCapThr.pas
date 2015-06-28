unit UCapThr;

interface

uses
  Classes;

type
  CaptureThread = class(TThread)
  private
    { Private-Deklarationen }
  protected
    procedure Show;
    procedure Execute; override;
  end;

implementation

{ Wichtig: Methoden und Eigenschaften von Objekten in der VCL können nur in einer
  Methode namens Synchronize verwendet werden; Beispiel:
      Synchronize(UpdateCaption);

  wobei UpdateCaption so aussehen könnte:

    procedure CaptureThread.UpdateCaption;
    begin
      Form1.Caption := 'Aktualisiert in einem Thread';
    end; }

{ CaptureThread }

procedure CaptureThread.Show;
begin
  FFrame.Image1.Refresh;
end;

procedure CaptureThread.Execute;
  FrameToBitmap(FFrame.Image1.Picture.Bitmap,lpVhdr.lpData,Videocap1.BitMapInfo);
  Synchronize(Show);
begin

end;

end.
