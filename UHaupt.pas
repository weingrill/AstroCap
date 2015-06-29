unit UHaupt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, StdCtrls, ComCtrls, RXSpin, ToolEdit, Mask, IniFiles,
  Buttons, Math, FileCtrl;

type
  TFHaupt = class(TForm)
    Panel1: TPanel;
    MMHaupt: TMainMenu;
    MIProgramm: TMenuItem;
    MIVideoquelle: TMenuItem;
    MIQuit: TMenuItem;
    Image1: TImage;
    Guiding1: TMenuItem;
    MIGuideOff: TMenuItem;
    MIcenter: TMenuItem;
    SBInfo: TStatusBar;
    FEDatei: TFilenameEdit;
    RSEFrames: TRxSpinEdit;
    BCapture: TButton;
    MIstabilize: TMenuItem;
    Ansicht1: TMenuItem;
    MIcrosshair: TMenuItem;
    MIFilter: TMenuItem;
    MIRed: TMenuItem;
    MIGreen: TMenuItem;
    MIBlue: TMenuItem;
    kein1: TMenuItem;
    MIEffekte: TMenuItem;
    MIKontrast: TMenuItem;
    procedure MIVideoquelleClick(Sender: TObject);
    procedure MIQuitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MIGuideClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuItemCheck(Sender: TObject);
    procedure BCaptureClick(Sender: TObject);
    procedure FEDateiExit(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private-Deklarationen }
    center_x,center_y:double;
    FileNo,x1,y1,x2,y2: Integer;
    TmpBmp: TBitmap;
    MyIni: TIniFile;
    Selection, Dragging: Boolean;
    procedure FindCenter(Bitmap: TBitmap;var c_x,c_y: double);
    procedure JustRed(Bitmap: TBitmap);
    procedure JustGreen(Bitmap: TBitmap);
    procedure JustBlue(Bitmap: TBitmap);
    procedure Kontrast(Bitmap: TBitmap);
  public
    { Public-Deklarationen }
    FrameWidth,FrameHeight: Word;
    DriverIndex: SmallInt;
    DriverName: String;
    IsVideo: Boolean;
    FilesToCapture, FilesCaptured: Integer;
    procedure ProcessFrame(Frame: TBitmap);
    procedure CaptureFrame(Frame: TBitmap);
  end;

type
  TRGBValue = packed record     // rgbtriple
    Blue: Byte;
    Green: Byte;
    Red: Byte;
  end;
  
var
  FHaupt: TFHaupt;

implementation

uses USource, UOutput;

{$R *.DFM}

procedure TFHaupt.FindCenter(Bitmap: TBitmap;var c_x,c_y: double);
var x,y,w,h:Integer;
    r,g,b,c:Byte;
    c_c: double;
    Pixel : ^TRGBValue;
begin
  c_x := 0;
  c_y := 0;
  c_c := 0;
  w := Bitmap.width;
  h := Bitmap.Height;
  if w*h=0 then exit;
  for y := 0 to h-1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w-1 do
    begin
      r := Pixel.Red;
      g := Pixel.Green;
      b := Pixel.Blue;
      c := (r+g+b) div 3;
      c_x := c_x + (x/w)*sqr(c/255);
      c_y := c_y + (y/h)*sqr(c/255);
      c_c := c_c + sqr(c/255);
      Inc(Pixel);
    end;
  end;
  if (c_c>0) then
  begin
    c_x := w*(c_x/c_c);
    c_y := h*(c_y/c_c);
  end;
end;

procedure TFHaupt.JustRed(Bitmap: TBitmap);
var x,y,k: Integer;
    Pixel : ^TRGBValue;
begin
  for y := 0 to Bitmap.Height -1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to Bitmap.Width -1 do
    begin
      k := Pixel.Red;
      Pixel.Red := k;
      Pixel.Green := k;
      Pixel.Blue := k;
      Inc(Pixel);
    end;
  end;
end;

procedure TFHaupt.JustGreen(Bitmap: TBitmap);
var x,y,k: Integer;
    Pixel : ^TRGBValue;
begin
  for y := 0 to Bitmap.Height -1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to Bitmap.Width -1 do
    begin
      k := Pixel.Green;
      Pixel.Red := k;
      Pixel.Green := k;
      Pixel.Blue := k;
      Inc(Pixel);
    end;
  end;
end;

procedure TFHaupt.JustBlue(Bitmap: TBitmap);
var x,y,k: Integer;
    Pixel : ^TRGBValue;
begin
  for y := 0 to Bitmap.Height -1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to Bitmap.Width -1 do
    begin
      k := Pixel.Blue;
      Pixel.Red := k;
      Pixel.Green := k;
      Pixel.Blue := k;
      Inc(Pixel);
    end;
  end;
end;

procedure TFHaupt.Kontrast(Bitmap: TBitmap);
var x,y,r,g,b,
    min_r,min_g,min_b,
    max_r,max_g,max_b: Integer;
    Pixel : ^TRGBValue;
begin
  min_r := 256; min_g := 256; min_b := 256;
  max_r :=   0; max_g :=   0; max_b :=   0;
  for y := 0 to Bitmap.Height -1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to Bitmap.width -1 do
    begin
      r := Pixel.Red;
      if r < min_r then min_r := r;
      if r > max_r then max_r := r;
      g := Pixel.Green;
      if g < min_g then min_g := g;
      if g > max_g then max_g := g;
      b := Pixel.Blue;
      if b < min_b then min_b := b;
      if b > max_b then max_b := b;
      Inc(Pixel);
    end;
  end;
  for y := 0 to Bitmap.Height -1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to Bitmap.width -1 do
    begin
      r := Pixel.Red;
      g := Pixel.Green;
      b := Pixel.Blue;
      if max_r>min_r then
        Pixel.Red := Round((r - min_r)*255/(max_r-min_r));
      if max_g>min_g then
        Pixel.Green := Round((g - min_g)*255/(max_g-min_g));
      if max_b>min_b then
        Pixel.Blue := Round((b - min_b)*255/(max_b-min_b));
      Inc(Pixel);
    end;
  end;
end;

procedure TFHaupt.ProcessFrame(Frame: TBitmap);
// Retrieves Bitmap from VideoSource
var cnx,cny: double;
    dx,dy: integer;
begin
  if Dragging then Exit;
  FrameWidth := Frame.Width;
  FrameHeight := Frame.Height;
  TmpBmp.Width := FrameWidth;
  TmpBmp.Height := FrameHeight;
  SBInfo.Panels[0].Text := Format('%d*%d',[FrameWidth,FrameHeight]);
  BitBlt( TmpBmp.Canvas.Handle, 0, 0, FrameWidth, FrameHeight, Frame.Canvas.handle, 0, 0, SRCCOPY);
  if Selection=True then
  begin
    FindCenter(Frame,cnx,cny);
    dx := Round(cnx-center_x);
    dy := Round(cny-center_y);
    BitBlt( FOutput.Image1.Canvas.Handle, 0, 0, x2-x1, y2-y1, Frame.Canvas.handle, x1+dx, y1+dy, SRCCOPY);
    BitBlt( Image1.Canvas.Handle, 0, 0, FrameWidth, FrameHeight, TmpBmp.Canvas.handle, 0, 0, SRCCOPY);
    Image1.Canvas.Pen.Mode := pmNotXor;
    Image1.Canvas.Pen.Style := psDot;
    Image1.Canvas.Rectangle(x1+dx,y1+dy,x2+dx,y2+dy);
  end
  else
  begin
    BitBlt( Image1.Canvas.Handle, 0, 0, FrameWidth, FrameHeight, TmpBmp.Canvas.handle, 0, 0, SRCCOPY);
  end;
{  if MIRed.Checked then JustRed(Frame);
  if MIGreen.Checked then JustGreen(Frame);
  if MIBlue.Checked then JustBlue(Frame);
  if MIKontrast.Checked then Kontrast(Frame);
  if (FilesToCapture>FilesCaptured) and not IsVideo then
    CaptureFrame(Frame);
  BitBlt( Image1.Canvas.Handle, 0, 0, FrameWidth, FrameHeight, Frame.Canvas.handle, 0, 0, SRCCOPY);
  if MIcrosshair.checked then
  with Image1.Canvas do
  begin
    Pen.Color := clRed;
    MoveTo(FrameWidth div 2, 0);
    LineTo(FrameWidth div 2, FrameHeight);
    MoveTo(0,FrameHeight div 2);
    LineTo(FrameWidth, FrameHeight div 2);
  end;  }
  Image1.Refresh;
end;

procedure TFHaupt.CaptureFrame(Frame: TBitmap);
var path,name,ext,filename,datei: String;
    p,l: integer;
begin
  Datei := FEDatei.Filename;
  path := ExtractFilePath(Datei);
  ForceDirectories(path);
  name := ExtractFileName(Datei);
  ext := ExtractFileExt(Datei);
  p := Pos(ext,name);
  l := Length(ext);
  Delete(name,p,l);
  repeat
    Filename := Format('%s%s%3.3d%s',[path,name,FileNo,ext]);
    inc(Fileno);
  until not FileExists(FileName);
  Frame.SaveToFile(Filename);
  FHaupt.Caption := 'AstroCap 3 - '+Filename;
  Inc(FilesCaptured);
  if FilesToCapture=FilesCaptured then
  begin
    BCapture.Enabled := True;
    MessageBeep(MB_ICONASTERISK);
  end;
end;

procedure TFHaupt.MIVideoquelleClick(Sender: TObject);
begin
  FSource.Show;
end;

procedure TFHaupt.MIQuitClick(Sender: TObject);
begin
  FSource.Close;
  Close;
end;

procedure TFHaupt.FormShow(Sender: TObject);
begin
  FSource.Show;
  FOutput.Show;
  FOutput.BringToFront;
end;

procedure TFHaupt.FormCreate(Sender: TObject);
begin
  MyIni := TIniFile.Create(ExtractFilePath(ParamStr(0))+'AstroCap.Ini');
  DriverIndex := MyIni.ReadInteger('Settings','Driverindex',0);
  DriverName := MyIni.ReadString('Settings','Drivername','Microsoft WDM Image Capture');
  FEDatei.Filename := MyIni.ReadString('Settings','Filename','C:\Cap.bmp');
  RSEFrames.Value := MyIni.ReadInteger('Settings','Bitmaps',1);

  TmpBmp := TBitmap.Create;
  FrameWidth := 640;
  FrameHeight := 480;
  Selection := False;
  Dragging := False;
  x1 := 0; y1 := 0;
  x2 := 0; y2 := 0;

end;

procedure TFHaupt.MIGuideClick(Sender: TObject);
begin
  if Sender = MIGuideOff then MIGuideOff.Checked := True;
  if Sender = MIcenter then MIcenter.Checked := True;
  if Sender = MIstabilize then
  begin
    center_x := 0; center_y := 0;
    MIstabilize.Checked := True;
  end;
end;

procedure TFHaupt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MyIni.WriteInteger('Settings','Driverindex',DriverIndex);
  MyIni.WriteString('Settings','Drivername',DriverName);
  MyIni.WriteString('Settings','Filename',FEDatei.Filename);
  MyIni.WriteInteger('Settings','Bitmaps',Round(RSEFrames.Value));
  MyIni.Free;

  TmpBmp.Free;
end;

procedure TFHaupt.MenuItemCheck(Sender: TObject);
begin
  (Sender As TMenuitem).Checked := not (Sender As TMenuitem).Checked;
end;

procedure TFHaupt.BCaptureClick(Sender: TObject);
begin
  BCapture.Enabled := False;
  FilesCaptured := 0;
  FileNo := 0;
  FilesToCapture := Round(RSEFrames.Value);
end;

procedure TFHaupt.FEDateiExit(Sender: TObject);
begin
  if UpperCase(ExtractFileExt(FEDatei.Filename))='.AVI' then IsVideo := True
  else IsVideo := False;
end;

procedure TFHaupt.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FSource.VideoCap1.VideoPreview := False;
  Image1.Canvas.Pen.Mode := pmNotXor;
  Image1.Canvas.Pen.Style := psDot;
  if shift = [ssLeft] then
  begin
    Image1.canvas.brush.style := bsclear;
    x1 := x;
    y1 := y;
    x2 := x+1;
    y2 := y+1;
    Image1.Canvas.Rectangle(x1,y1,x2,y2);
    SBInfo.Panels[1].Text := Format('(%d;%d)-(%d;%d)',[x1,y1,x2,y1]);
  end;
end;

procedure TFHaupt.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if shift = [ssLeft] then
  begin
    Dragging := True;
    Image1.Canvas.Rectangle(x1,y1,x2,y2);
    x2 := x;
    y2 := y;
    Image1.Canvas.Rectangle(x1,y1,x2,y2);
    SBInfo.Panels[1].Text := Format('(%d;%d)-(%d;%d)',[x1,y1,x2,y2]);
    //FindCenter(TmpBmp,center_x,center_y);
    //SBInfo.Panels[2].Text := Format('%f;%f',[center_x,center_y]);
    //Selection := True;
  end;
end;

procedure TFHaupt.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Image1.Canvas.Rectangle(x1,y1,x2,y2);
  x2 := x;
  y2 := y;
  Image1.Canvas.Rectangle(x1,y1,x2,y2);
  FindCenter(Image1.Picture.Bitmap,center_x,center_y);
  SBInfo.Panels[1].Text := Format('(%d;%d)-(%d;%d)',[x1,y1,x2,y2]);
  SBInfo.Panels[2].Text := Format('%f;%f',[center_x,center_y]);
  Selection := True;
  FSource.VideoCap1.VideoPreview := True;
  Dragging := False;
end;

end.
