unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, Menus, Buttons, RXSpin, StdCtrls, Mask, ToolEdit, IniFiles,
  Placemnt, Math, SHellAPI;

type
  TFMain = class(TForm)
    PTopPanel: TPanel;
    MMMain: TMainMenu;
    MIProgram: TMenuItem;
    MIClose: TMenuItem;
    SBInfo: TStatusBar;
    Image1: TImage;
    SBSettings: TSpeedButton;
    SBFormat: TSpeedButton;
    FEFiles: TFilenameEdit;
    SPCount: TRxSpinEdit;
    SBRecord: TSpeedButton;
    TBSeeing: TTrackBar;
    FPMainForm: TFormPlacement;
    MIFilters: TMenuItem;
    MIContrast: TMenuItem;
    TBDamping: TTrackBar;
    MIWindows: TMenuItem;
    Help1: TMenuItem;
    MIOptions: TMenuItem;
    MIinverse: TMenuItem;
    MIRGBAlign: TMenuItem;
    MIPreview: TMenuItem;
    MIOptometric: TMenuItem;
    MIControl: TMenuItem;
    MIOutput: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure SBSettingsClick(Sender: TObject);
    procedure SBFormatClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SBRecordClick(Sender: TObject);
    procedure MIContrastClick(Sender: TObject);
    procedure TBDampingChange(Sender: TObject);
    procedure MIinverseClick(Sender: TObject);
    procedure MIRGBAlignClick(Sender: TObject);
    procedure MIPreviewClick(Sender: TObject);
    procedure MIOptometricClick(Sender: TObject);
    procedure MIControlClick(Sender: TObject);
    procedure MIOutputClick(Sender: TObject);
    procedure Help1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    bwidth,bheight,
    fwidth,fheight:integer;
    Dragging, Drag_x1, Drag_x2, Drag_y1, Drag_y2,
    isFirstImage: Boolean;
    TmpBmp,TmpBmp1: TBitmap;
    damping: double;
    procedure FindCenter(Bitmap: TBitmap;var c_x,c_y: double);
    procedure DrawCrossHair(cx,cy: integer; chcolor: TColor);
    procedure SetCenter;

    procedure Contrast(Bitmap: TBitmap);
    function  getrpixel(x,y,w,h: integer): byte;
    function  getgpixel(x,y,w,h: integer): byte;
    function  getbpixel(x,y,w,h: integer): byte;
    procedure RGBalign(Bitmap: TBitmap);
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
  public
    { Public-Deklarationen }
    center_x,center_y: double;
    x1,y1,x2,y2: integer;

    FilesToCapture: Integer;
    SeeingOK: Boolean;
    IniFile: TInifile;
    procedure ProcessImage;
  end;

type
  TRGBValue = packed record     // rgbtriple
    Blue: Byte;
    Green: Byte;
    Red: Byte;
  end;

var
  FMain: TFMain;

implementation

uses UOutput, UInfo, UControl, UDXSource;

{$R *.DFM}

procedure TFMain.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin // avoid clearing the background (causes flickering and speed penalty)
  Message.Result:=0
end;


procedure TFMain.FormShow(Sender: TObject);
begin
  FDXSource.Show;
  FOutput.Show;
  FInfo.Show;
  FControl.Show;
end;

procedure TFMain.FindCenter(Bitmap: TBitmap;var c_x,c_y: double);
var x,y,w,h:Integer;
    r,g,b,c,cmax:Byte;
    c_c,c_m: double;
    Pixel : ^TRGBValue;
    invert: boolean;
begin
  c_x := 0;
  c_y := 0;
  c_c := 0;
  c_m := 0;
  cmax := 0;
  invert := MIinverse.checked;
  w := Bitmap.width;
  h := Bitmap.Height;
  if w*h<=1 then exit;
  for y := 0 to h-1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w-1 do
    begin
      r := Pixel.Red;
      g := Pixel.Green;
      b := Pixel.Blue;
      c := (r+g+b) div 3;
      if invert then c := 255-c;
      if c>cmax then cmax := c;
      c_m := c_m + c;
      Inc(Pixel);
    end;
  end;
  if c_m<=1 then exit;
  c_m := c_m /(w*h);
  TBDamping.SelEnd := Round(c_m);
  for y := 0 to h-1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w-1 do
    begin
      r := Pixel.Red;
      g := Pixel.Green;
      b := Pixel.Blue;
      c := (r+g+b) div 3;
      if invert then c := 255-c;
      if c>(damping*c_m)+((1-damping)*cmax) then
      begin
        c_x := c_x + x*sqr(c/255);
        c_y := c_y + y*sqr(c/255);
        c_c := c_c + sqr(c/255);
      end;
      Inc(Pixel);
    end;
  end;
  if (c_c>0) then
  begin
    c_x := c_x/c_c;
    c_y := c_y/c_c;
  end;
end;

function TFMain.getrpixel(x,y,w,h: integer): byte;
var  Pixel: ^TRGBValue;
begin
  Result := 127;
  if (y>=0) and (y<h) and
     (x>=0) and (x<w) then
  begin
    Pixel := tmpbmp1.Scanline[y];
    Inc(Pixel,x);
    result := Pixel.red;
  end;
end;

function TFMain.getgpixel(x,y,w,h: integer): byte;
var  Pixel: ^TRGBValue;
begin
  Result := 127;
  if (y>=0) and (y<h) and
     (x>=0) and (x<w) then
  begin
    Pixel := tmpbmp1.Scanline[y];
    Inc(Pixel,x);
    result := Pixel.green;
  end;
end;

function TFMain.getbpixel(x,y,w,h: integer): byte;
var  Pixel: ^TRGBValue;
begin
  Result := 127;
  if (y>=0) and (y<h) and
     (x>=0) and (x<w) then
  begin
    Pixel := tmpbmp1.Scanline[y];
    Inc(Pixel,x);
    result := Pixel.blue;
  end;
end;

procedure TFMain.RGBalign(Bitmap: TBitmap);
var x,y,w,h,
    dxr,dyr,dxb,dyb:Integer;
    r,g,b:Byte;
    r_x,r_y,r_c,
    g_x,g_y,g_c,
    b_x,b_y,b_c: double;
    Pixel: ^TRGBValue;
begin
  w := Bitmap.width;
  h := Bitmap.Height;
  Tmpbmp1.Width := w;
  tmpbmp1.Height := h;
  r_x := 0; r_y := 0; r_c := 0;
  g_x := 0; g_y := 0; g_c := 0;
  b_x := 0; b_y := 0; b_c := 0;
  if w*h<=1 then exit;
  for y := 0 to h-1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w-1 do
    begin
      r := Pixel.Red;
      g := Pixel.Green;
      b := Pixel.Blue;
      r_x := r_x + x*sqr(r/255);
      r_y := r_y + y*sqr(r/255);
      r_c := r_c +   sqr(r/255);
      g_x := g_x + x*sqr(g/255);
      g_y := g_y + y*sqr(g/255);
      g_c := g_c +   sqr(g/255);
      b_x := b_x + x*sqr(b/255);
      b_y := b_y + y*sqr(b/255);
      b_c := b_c +   sqr(b/255);
      Inc(Pixel);
    end;
  end;
  if (r_c>0) then
  begin
    r_x := r_x/r_c;
    r_y := r_y/r_c;
  end;
  if (g_c>0) then
  begin
    g_x := g_x/g_c;
    g_y := g_y/g_c;
  end;
  if (b_c>0) then
  begin
    b_x := b_x/b_c;
    b_y := b_y/b_c;
  end;
  BitBlt( tmpbmp1.Canvas.Handle,0,0,w,h,Bitmap.Canvas.Handle,0,0,SRCCOPY);
  dxr := Round(g_x-r_x);
  dyr := Round(g_y-r_y);
  dxb := Round(g_x-b_x);
  dyb := Round(g_y-b_y);

  for y := 0 to h-1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w-1 do
    begin
      Pixel.Green := getgpixel(x,y,w,h);
      Pixel.red   := getrpixel(x-dxr,y-dyr,w,h);
      Pixel.blue  := getbpixel(x-dxb,y-dyb,w,h);
      Inc(Pixel);
    end;
  end;

end;

procedure TFMain.Contrast(Bitmap: TBitmap);
var x,y,r,g,b,w,h,
    min_r,min_g,min_b,
    max_r,max_g,max_b: Integer;
    Pixel : ^TRGBValue;
begin
  w := Bitmap.width;
  h := Bitmap.Height;
  min_r := 256; min_g := 256; min_b := 256;
  max_r :=   0; max_g :=   0; max_b :=   0;
  for y := 0 to h -1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w -1 do
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
  for y := 0 to h -1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w -1 do
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

procedure TFMain.ProcessImage;
var //dx,dy: integer;
    dx,dy,cnx,cny: double;
begin
  if Dragging then Exit;
  if Drag_x1 or Drag_x2 or Drag_y1 or Drag_y2 then Exit;
  bwidth := Image1.Picture.Bitmap.Width;
  bheight := Image1.Picture.Bitmap.Height;
  if isFirstImage then
  begin
    x1 := 0; y1 := 0;
    x2 := bwidth-1; y2 := bheight-1;
    fwidth := x2-x1+1;
    fheight := y2-y1+1;
    center_x := fwidth div 2;
    center_y := fheight div 2;
    SetCenter;
    isFirstImage := False;
  end;
  SBInfo.Panels[0].Text := Format('%d*%d',[bwidth,bheight]);
  BitBlt( TmpBmp.Canvas.Handle,
          0,0,
          fwidth,fheight,
          Image1.Picture.Bitmap.Canvas.Handle,
          x1,y1,
          SRCCOPY);
  FindCenter(TmpBmp,cnx,cny);
  dx := 0.95*(cnx-center_x);
  dy := 0.95*(cny-center_y);
  SBInfo.Panels[1].Text := Format('d(%f;%f)',[dx,dy]);
  SBInfo.Panels[3].Text := Format('new(%f;%f)',[cnx+x1,cny+y1]);
  SBInfo.Panels[4].Text := Format('org(%f;%f)',[center_x+x1,center_y+y1]);
  if (x1+dx>0) and (x2+dx<bwidth) then
  begin
    x1 := Round(x1+dx); x2 := Round(x2+dx);
    center_x := cnx-dx;
  end;
  if (y1+dy>0) and (y2+dy<bheight) then
  begin
    y1 := Round(y1+dy); y2 := Round(y2+dy);
    center_y := cny-dy;
  end;
  BitBlt( TmpBmp.Canvas.Handle,
          0,0,
          fwidth,fheight,
          Image1.Picture.Bitmap.Canvas.Handle,
          x1,y1,
          SRCCOPY);
  if FInfo.Visible then FInfo.Optometric(TmpBmp)
  else
    SeeingOK := True;
  if MIContrast.Checked then Contrast(TmpBmp);
  if MIRGBAlign.Checked then RGBAlign(TmpBmp);
  if SeeingOK then
  begin
    BitBlt( FOutput.Image1.Picture.Bitmap.Canvas.Handle,
            0,0,
            fwidth,fheight,
            TmpBmp.Canvas.Handle,
            0,0,
            SRCCOPY);
    FOutput.Image1.Refresh;
  end;
  //DrawCrossHair(Round(cnx)+x1,Round(cny)+y1,clFuchsia);
  DrawCrossHair(Round(center_x)+x1,Round(center_y)+y1,clYellow);
  Image1.Canvas.Pen.Color := clAqua;
  Image1.Canvas.Rectangle(x1,y1,x2,y2);
  if (FilesToCapture>0) and SeeingOK then
  begin
    FOutput.Capture;
    Dec(FilesToCapture);
    if FilesToCapture=0 then
    begin
      SBRecord.Enabled := True;
      MessageBeep(MB_ICONASTERISK);
    end;
  end;
  FControl.Guide;
end;

procedure TFMain.DrawCrosshair(cx,cy: integer; chColor: TColor);
begin
  with Image1.Picture.Bitmap.Canvas do
  begin
    Pen.Mode := pmCopy;
    Pen.Color := chColor;
    MoveTo(cx-5,cy); LineTo(cx-15,cy);
    MoveTo(cx+5,cy); LineTo(cx+15,cy);
    MoveTo(cx,cy-5); LineTo(cx,cy-15);
    MoveTo(cx,cy+5); LineTo(cx,cy+15);
    Ellipse(cx-10,cy-10,cx+10,cy+10);
  end;
end;


procedure TFMain.SBSettingsClick(Sender: TObject);
begin
{  if FSource.VideoCap1.HasDlgSource then
    FSource.VideoCap1.DlgVSource;}
end;

procedure TFMain.SBFormatClick(Sender: TObject);
begin
{  if FSource.VideoCap1.HasDlgFormat then
    FSource.VideoCap1.DlgVFormat;}
  isFirstImage := True;
end;

procedure TFMain.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Shift = [ssLeft]) and (abs(x-x1)<=2) then Drag_x1 := True;
  if (Shift = [ssLeft]) and (abs(y-y1)<=2) then Drag_y1 := True;
  if (Shift = [ssLeft]) and (abs(x-x2)<=2) then Drag_x2 := True;
  if (Shift = [ssLeft]) and (abs(y-y2)<=2) then Drag_y2 := True;
  if Drag_x1 or Drag_x2 or Drag_y1 or Drag_y2 then Exit;
  if Shift = [ssLeft] then
  begin
    x1 := x; y1 := y;
    x2 := x; y2 := y;
    Dragging := True;
  end;
end;

procedure swapvar(var a,b: integer);
var t: integer;
begin
  t := a;
  a := b;
  b := t;
end;

procedure TFMain.SetCenter;
begin
  fwidth := x2-x1+1;
  fheight := y2-y1+1;
  SBInfo.Panels[2].Text := Format('%d*%d',[fwidth,fheight]);
  FOutput.Image1.Picture.Bitmap.Width := fwidth;
  FOutput.Image1.Picture.Bitmap.Height := fheight;
  TmpBmp.Width := fwidth;
  TmpBmp.Height := fheight;
  BitBlt( TmpBmp.Canvas.Handle,
          0,0,
          fwidth,fheight,
          Image1.Picture.Bitmap.Canvas.Handle,
          x1,y1,
          SRCCOPY);
  FindCenter(TmpBmp,center_x,center_y);
  BitBlt( FOutput.Image1.Picture.Bitmap.Canvas.Handle,
          0,0,
          fwidth,fheight,
          Image1.Picture.Bitmap.Canvas.Handle,
          x1,y1,
          SRCCOPY);
  FOutput.Image1.Refresh;
end;

procedure TFMain.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Drag_x1 or Drag_x2 or Drag_y1 or Drag_y2 then
  begin
    if Drag_x1 then x1 := x;
    if Drag_x2 then x2 := x;
    if Drag_y1 then y1 := y;
    if Drag_y2 then y2 := y;
    if (x1=x2) or (y1=y2) then
    begin
      x1 := 0; y1 := 0;
      x2 := bwidth-1; y2 := bheight-1;
    end;
    if x2<x1 then swapvar(x1,x2);
    if y2<y1 then swapvar(y1,y2);
    SetCenter;
    Drag_x1 := False;
    Drag_x2 := False;
    Drag_y1 := False;
    Drag_y2 := False;
  end;
  if Dragging then
  begin
    x2 := x; y2 := y;
    if (x1=x2) or (y1=y2) then
    begin
      x1 := 0; y1 := 0;
      x2 := bwidth-1; y2 := bheight-1;
    end;
    if x2<x1 then swapvar(x1,x2);
    if y2<y1 then swapvar(y1,y2);
    Dragging := False;
    SetCenter;
  end;
end;

procedure TFMain.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (Shift = [ssLeft]) and (Drag_x1 or Drag_x2 or Drag_y1 or Drag_y2) then
  begin
    //Image1.Canvas.Pen.Mode := pmNotCopy;
    //Image1.Canvas.Rectangle(x1,y1,x2,y2);
    if Drag_x1 then x1 := x;
    if Drag_x2 then x2 := x;
    if Drag_y1 then y1 := y;
    if Drag_y2 then y2 := y;
    SetCenter;
    Image1.Canvas.Pen.Mode := pmCopy;
    Image1.Canvas.Rectangle(x1,y1,x2,y2);
  end;
  if (Shift = [ssLeft]) and Dragging then
  begin
    //Image1.Canvas.Pen.Mode := pmNotCopy;
    //Image1.Canvas.Rectangle(x1,y1,x2,y2);
    x2 := x; y2 := y;
    if x2<x1 then swapvar(x1,x2);
    if y2<y1 then swapvar(y1,y2);
    SetCenter;
    Image1.Canvas.Pen.Mode := pmCopy;
    Image1.Canvas.Rectangle(x1,y1,x2,y2);
  end;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  Dragging := False;
  Drag_x1 := False;
  Drag_x2 := False;
  Drag_y1 := False;
  Drag_y2 := False;

  Image1.canvas.brush.style := bsclear;
  Image1.Canvas.Pen.Mode := pmNotCopy;
  TmpBmp := TBitmap.Create;
  TmpBmp.PixelFormat := pf24Bit;
  TmpBmp1 := TBitmap.Create;
  TmpBmp1.PixelFormat := pf24Bit;
  x1 := 1; y1 := 1;
  x2 := 638; y2 := 478;
  fwidth := x2-x1+1;
  fheight := y2-y1+1;
  bwidth := fwidth;
  bheight := fheight;
  center_x := fwidth div 2;
  center_y := fheight div 2;
  FilesToCapture := 0;
  SeeingOK := True;
  damping := 0.5;
  IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0))+'AstroCap.Ini');
  FEFiles.Text := IniFile.ReadString('Settings','Filename','C:\Cap.bmp');
  SPCount.Value := IniFile.ReadInteger('Settings','Bitmaps',20);
  isFirstImage := True;
end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with Inifile do
  begin
    WriteString('Settings','Filename',FEFiles.Text);
    WriteInteger('Settings','Bitmaps',SPCount.AsInteger);
//    WriteInteger('VideoCap','DriverIndex',FSource.VideoCap1.DriverIndex);
//    WriteString('VideoCap','DriverName',FSource.VideoCap1.DriverName);
//    WriteInteger('VideoCap','FrameRate',FSource.VideoCap1.FrameRate);
//    WriteInteger('VideoCap','PreviewRate',FSource.VideoCap1.PreviewRate);
    WriteString('Guide','TimeRA',FloatToStr(FControl.SERect.Value));
    WriteString('Guide','TimeDe',FloatToStr(FControl.SEDecl.Value));
    Free;
  end;
  TmpBmp.Free;
  TmpBmp1.Free;
end;

procedure TFMain.SBRecordClick(Sender: TObject);
begin
  FilesToCapture := SPCount.AsInteger;
  FOutput.Filename := FEFiles.Text;
  SBRecord.Enabled := False;
  FOutput.Fileno := 0;
end;

procedure TFMain.MIContrastClick(Sender: TObject);
begin
  MIContrast.Checked := not MIContrast.Checked;
end;

procedure TFMain.TBDampingChange(Sender: TObject);
begin
  damping := TBDamping.Position/TBDamping.Max;
end;

procedure TFMain.MIinverseClick(Sender: TObject);
begin
  MIinverse.checked := not MIinverse.checked;
end;

procedure TFMain.MIRGBAlignClick(Sender: TObject);
begin
  MIRGBAlign.Checked := not MIRGBAlign.Checked;
end;

procedure TFMain.MIPreviewClick(Sender: TObject);
begin
  if FDXSource.visible then FDXSource.Hide else FDXSource.Show;
end;

procedure TFMain.MIOptometricClick(Sender: TObject);
begin
  if FInfo.visible then FInfo.Hide else FInfo.Show;
end;

procedure TFMain.MIControlClick(Sender: TObject);
begin
  if FControl.visible then FControl.Hide else FControl.Show;
end;

procedure TFMain.MIOutputClick(Sender: TObject);
begin
  if FOutput.visible then FOutput.Hide else FOutput.Show;
end;

procedure TFMain.Help1Click(Sender: TObject);
begin
  ShellAbout(FMain.Handle,'AstroCap 4','2003 (c) Jörg Weingrill',FMain.Icon.Handle);
end;

end.
