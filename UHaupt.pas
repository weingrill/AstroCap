unit UHaupt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus,Clipbrd, ExtDlgs, VCLUtils, ExtCtrls, ComCtrls, FileCtrl,math;

type
  TFHaupt = class(TForm)
    MMHaupt: TMainMenu;
    Programm1: TMenuItem;
    MIQuit: TMenuItem;
    MIEffects: TMenuItem;
    MIBinning: TMenuItem;
    MIContrast: TMenuItem;
    MIInvert: TMenuItem;
    MIBinning22: TMenuItem;
    MIBinning21: TMenuItem;
    MIGrayscale: TMenuItem;
    MISingleframe: TMenuItem;
    N1: TMenuItem;
    Treiber1: TMenuItem;
    MISource: TMenuItem;
    MIFormat: TMenuItem;
    MIDisplay: TMenuItem;
    MICompression: TMenuItem;
    N2: TMenuItem;
    MIOverlay: TMenuItem;
    MIPreview: TMenuItem;
    MIDarkframe: TMenuItem;
    MIFlatfield: TMenuItem;
    OpenPictureDialog: TOpenPictureDialog;
    N3: TMenuItem;
    MiMedian: TMenuItem;
    MIIntegrate: TMenuItem;
    MIMultiframe: TMenuItem;
    MIOptometrie: TMenuItem;
    MIWindow: TMenuItem;
    MITile: TMenuItem;
    MICascade: TMenuItem;
    SBInfo: TStatusBar;
    MIModus: TMenuItem;
    MIAufnahme: TMenuItem;
    MIFokus: TMenuItem;
    MIVorschau: TMenuItem;
    MIHilfe: TMenuItem;
    MIHelp: TMenuItem;
    N4: TMenuItem;
    MIInfo: TMenuItem;
    Timer1: TTimer;
    MIMinimum: TMenuItem;
    MIMaximum: TMenuItem;
    Moduswechsel1: TMenuItem;
    N5: TMenuItem;
    MIStartDriver: TMenuItem;
    N6: TMenuItem;
    Filter1: TMenuItem;
    MINoise: TMenuItem;
    MIColRot: TMenuItem;
    MIFalseColor: TMenuItem;
    MIHighpass: TMenuItem;
    N7: TMenuItem;
    MIRed: TMenuItem;
    MIGreen: TMenuItem;
    MIBlue: TMenuItem;
    MINone: TMenuItem;
    procedure MIQuitClick(Sender: TObject);
    procedure MISingleframeClick(Sender: TObject);
    procedure MISourceClick(Sender: TObject);
    procedure MIFormatClick(Sender: TObject);
    procedure MIDisplayClick(Sender: TObject);
    procedure MICompressionClick(Sender: TObject);
    procedure MIOverlayClick(Sender: TObject);
    procedure MIPreviewClick(Sender: TObject);
    procedure MIDarkframeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MIFlatfieldClick(Sender: TObject);
    procedure MIMultiframeClick(Sender: TObject);
    procedure MITileClick(Sender: TObject);
    procedure MICascadeClick(Sender: TObject);
    procedure MIAufnahmeClick(Sender: TObject);
    procedure MIFokusClick(Sender: TObject);
    procedure MIModusClick(Sender: TObject);
    procedure MIInfoClick(Sender: TObject);
    procedure MIStartDriverClick(Sender: TObject);
    procedure MIEffectClick(Sender: TObject);
    procedure MIHelpClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FrameNo,BitmapNo: Integer;
    function SetFrameName: String;
    procedure GetXYValue(Bitmap: TBitmap; x,y:Integer;var r,g,b: Byte);
  public
    { Public-Deklarationen }
    SeeingOK: Boolean;
    h,w,nh,nw,
    maxFrames,maxBitmaps, FileNo: Integer;
    MinSobel,MaxSobel: Extended;
    bias,gain: Word;
    Current,Dark,Flat, TmpBmp: TBitmap;
    Datei,CurFile: String;
    procedure Binning(Bitmap: TBitmap);
    procedure Kontrast(Bitmap: TBitmap);
    procedure Invert(Bitmap: TBitmap);
    procedure Colrot(Bitmap: TBitmap);
    procedure FalseColor(Bitmap: TBitmap);
    procedure BiasGain(Bitmap: TBitmap);
    procedure Binning22(Bitmap: TBitmap);
    procedure Binning21(Bitmap: TBitmap);
    procedure Grayscale(Bitmap: TBitmap);
    procedure JustRed(Bitmap: TBitmap);
    procedure JustGreen(Bitmap: TBitmap);
    procedure JustBlue(Bitmap: TBitmap);


    procedure Darkflat(Bitmap: TBitmap);
    procedure CaptureSingleFrame;
    procedure MedianFilter(InBitmap,OutBitmap: TBitmap);
    procedure HighPass(InBitmap,OutBitmap: TBitmap);
    procedure Integrate(InBitmap,OutBitmap: TBitmap);
    procedure Median(InBitmap,OutBitmap: TBitmap);
    procedure Minimum(InBitmap,OutBitmap: TBitmap);
    procedure Maximum(InBitmap,OutBitmap: TBitmap);
    procedure ShowInfos;
    procedure SaveMetaFile;
  end;

var
  FHaupt: TFHaupt;

type
  TRGBValue = packed record
    Blue: Byte;
    Green: Byte;
    Red: Byte;
    reserved: Byte;
  end;


implementation

uses UPreview, UFrame, UInfo, UAbout, USettings;

{$R *.DFM}

function Normalize(value: integer):integer;
begin
  Result := value;
  if value < 0 then Result := 0
  else if value > 255 then Result := 255;
end;

function TFHaupt.SetFrameName: String;
var path,name,ext: String;
    p,l : integer;
begin
  path := ExtractFilePath(Datei);
  ForceDirectories(path);
  name := ExtractFileName(Datei);
  ext := ExtractFileExt(Datei);
  p := Pos(ext,name);
  l := Length(ext);
  Delete(name,p,l);
  repeat
    Result := Format('%s%s%5.5d%s',[path,name,FileNo,ext]);
    inc(Fileno);
  until not FileExists(Result);
  SBInfo.Panels[5].Text := Result;
end;

procedure TFHAupt.Binning(Bitmap: TBitmap);
var x,y,r,g,b,k: Integer;
    Pixel : ^TRGBValue;
begin
  for y := 0 to h -1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w -1 do
    begin
      r := Pixel.Red;
      g := Pixel.Green;
      b := Pixel.Blue;
      k := r+g+b;
      if k>255 then
      begin
        Pixel.Red := 255;
        Pixel.Green := 255;
        Pixel.Blue := 255;
      end
      else
      begin
        Pixel.Red := k;
        Pixel.Green := k;
        Pixel.Blue := k;
      end;
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

procedure TFHAupt.Invert(Bitmap: TBitmap);
var x,y,r,g,b: Integer;
    Pixel : ^TRGBValue;
begin
  for y := 0 to h -1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w -1 do
    begin
      r := Pixel.Red;
      g := Pixel.Green;
      b := Pixel.Blue;
      Pixel.Blue := 255-b;
      Pixel.Green := 255-g;
      Pixel.Red := 255-r;
      Inc(Pixel);
    end;
  end;
end;

procedure TFHaupt.ColRot(Bitmap: TBitmap);
var x,y,r,g,b: Integer;
    Pixel : ^TRGBValue;
begin
  for y := 0 to h -1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w -1 do
    begin
      r := Pixel.Red;
      g := Pixel.Green;
      b := Pixel.Blue;
      Pixel.Red := g;
      Pixel.Green := b;
      Pixel.Blue := r;
      Inc(Pixel);
    end;
  end;
end;

procedure TFHaupt.FalseColor(Bitmap: TBitmap);
var x,y,r,g,b,i: Integer;
    Pixel : ^TRGBValue;
begin
  for y := 0 to h -1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w -1 do
    begin
      r := Pixel.Red;
      g := Pixel.Green;
      b := Pixel.Blue;
      i := (r+g+b) div 3;
      if i in [0..97] then
      begin
        r := 0;
        g := (i*255) div 97;
        b := 255 - g;
      end;
      if i in [98..141] then
      begin
        r := ((i-98)*255) div 43;
        g := 255;
        b := 0;
      end;
      if i in [142..255] then
      begin
        r := 255;
        g := 255 - (((i-142)*255) div 113);
        b := 0;
      end;
      Pixel.Red := r;
      Pixel.Green := g;
      Pixel.Blue := b;
      Inc(Pixel);
    end;
  end;
end;

procedure TFHaupt.BiasGain(Bitmap: TBitmap);
var x,y,r,g,b: Integer;
    Pixel : ^TRGBValue;
begin
  for y := 0 to h -1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w -1 do
    begin
      r := Pixel.Red;
      g := Pixel.Green;
      b := Pixel.Blue;
      if r < bias then r := 0 else r := r - bias;
      if g < bias then g := 0 else g := g - bias;
      if b < bias then b := 0 else b := b - bias;
      Pixel.Red := Normalize(r * gain);
      Pixel.Green := Normalize(g * gain);
      Pixel.Blue := Normalize(b * gain);
      Inc(Pixel);
    end;
  end;
end;


procedure TFHAupt.Binning22(Bitmap: TBitmap);
var x,y,r,g,b: Integer;
    Pixel, Pixel1: ^TRGBValue;
begin
  for y := 0 to h -2 do
  begin
    Pixel := Bitmap.Scanline[y];
    Pixel1 := Bitmap.Scanline[y+1];
    for x := 0 to w -2 do
    begin
      r := Pixel.Red;
      g := Pixel.Green;
      b := Pixel.Blue;
      r := r + Pixel1.Red;
      g := g + Pixel1.Green;
      b := b + Pixel1.Blue;
      Inc(Pixel);
      Inc(Pixel1);
      r := r + Pixel.Red;
      g := g + Pixel.Green;
      b := b + Pixel.Blue;
      r := r + Pixel1.Red;
      g := g + Pixel1.Green;
      b := b + Pixel1.Blue;
      Dec(Pixel);
      Dec(Pixel1);
      if r>255 then Pixel.Red := 255 else Pixel.Red := r;
      if g>255 then Pixel.Green := 255 else Pixel.Green := g;
      if b>255 then Pixel.Blue := 255 else Pixel.Blue := b;
      Inc(Pixel);
      Inc(Pixel1);
    end;
  end;
end;

procedure TFHAupt.Binning21(Bitmap: TBitmap);
var x,y,r,g,b: Integer;
    Pixel: ^TRGBValue;
begin
  for y := 0 to h -2 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w -2 do
    begin
      r := Pixel.Red;
      g := Pixel.Green;
      b := Pixel.Blue;
      Inc(Pixel);
      r := r + Pixel.Red;
      g := g + Pixel.Green;
      b := b + Pixel.Blue;
      Dec(Pixel);
      if r>255 then Pixel.Red := 255 else Pixel.Red := r;
      if g>255 then Pixel.Green := 255 else Pixel.Green := g;
      if b>255 then Pixel.Blue := 255 else Pixel.Blue := b;
      Inc(Pixel);
    end;
  end;
end;

procedure TFHAupt.Grayscale(Bitmap: TBitmap);
var x,y,r,g,b,k: Integer;
    Pixel : ^TRGBValue;
begin
  for y := 0 to h -1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w -1 do
    begin
      r := Pixel.Red;
      g := Pixel.Green;
      b := Pixel.Blue;
      k := Hibyte(r*77+g*151+b*28);
      Pixel.Red := k;
      Pixel.Green := k;
      Pixel.Blue := k;
      Inc(Pixel);
    end;
  end;
end;

procedure TFHAupt.JustRed(Bitmap: TBitmap);
var x,y,k: Integer;
    Pixel : ^TRGBValue;
begin
  for y := 0 to h -1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w -1 do
    begin
      k := Pixel.Red;
      Pixel.Red := k;
      Pixel.Green := k;
      Pixel.Blue := k;
      Inc(Pixel);
    end;
  end;
end;

procedure TFHAupt.JustGreen(Bitmap: TBitmap);
var x,y,k: Integer;
    Pixel : ^TRGBValue;
begin
  for y := 0 to h -1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w -1 do
    begin
      k := Pixel.Green;
      Pixel.Red := k;
      Pixel.Green := k;
      Pixel.Blue := k;
      Inc(Pixel);
    end;
  end;
end;

procedure TFHAupt.JustBlue(Bitmap: TBitmap);
var x,y,k: Integer;
    Pixel : ^TRGBValue;
begin
  for y := 0 to h -1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w -1 do
    begin
      k := Pixel.Blue;
      Pixel.Red := k;
      Pixel.Green := k;
      Pixel.Blue := k;
      Inc(Pixel);
    end;
  end;
end;


procedure TFHaupt.GetXYValue(Bitmap: TBitmap; x,y:Integer;var r,g,b: Byte);
var Pixel : ^TRGBValue;
begin
  Pixel := Bitmap.Scanline[y];
  Inc(Pixel,x);
  r := Pixel.red;
  g := Pixel.Green;
  b := Pixel.Blue;
end;
//******************************

function MedianCut(a: array of byte): byte;
  procedure partit(lo,up:byte);
  var i,j,h,x: byte;
  begin
    i := lo;
    j := up;
    x := a[(lo+up) div 2];
    repeat
      while a[i]<x do inc(i);
      while a[j]>x do dec(j);
      if i<=j then
      begin
        h := a[i]; a[i] := a[j]; a[j] := h;
        inc(i); dec(j);
      end;
    until i>j;
    if lo<j then partit(lo,j);
    if i<up then partit(i,up);
  end;
begin
  partit(1,9);
  result := a[5];
end;

procedure TFHaupt.MedianFilter(InBitmap,OutBitmap: TBitmap);
var x,y: Integer;
    r,g,b: array[1..9] of byte;
    PixelI,PixelO: ^TRGBValue;
begin
  for y := 1 to h - 2 do
  begin
    // PixelI := InBitmap.Scanline[y];
    PixelO := OutBitmap.Scanline[y];
    Inc(PixelO);
    for x := 1 to w - 2 do
    begin
      PixelI := InBitmap.Scanline[y-1];
      Inc(PixelI,x);
      Dec(PixelI);
      r[1] := PixelI.Red; g[1] := PixelI.Green; b[1] := PixelI.Blue;
      Inc(PixelI);
      r[2] := PixelI.Red; g[2] := PixelI.Green; b[2] := PixelI.Blue;
      Inc(PixelI);
      r[3] := PixelI.Red; g[3] := PixelI.Green; b[3] := PixelI.Blue;

      PixelI := InBitmap.Scanline[y];
      Inc(PixelI,x);
      Dec(PixelI);
      r[4] := PixelI.Red; g[4] := PixelI.Green; b[4] := PixelI.Blue;
      Inc(PixelI);
      r[5] := PixelI.Red; g[5] := PixelI.Green; b[5] := PixelI.Blue;
      Inc(PixelI);
      r[6] := PixelI.Red; g[6] := PixelI.Green; b[6] := PixelI.Blue;

      PixelI := InBitmap.Scanline[y+1];
      Inc(PixelI,x);
      Dec(PixelI);
      r[7] := PixelI.Red; g[7] := PixelI.Green; b[7] := PixelI.Blue;
      Inc(PixelI);
      r[8] := PixelI.Red; g[8] := PixelI.Green; b[8] := PixelI.Blue;
      Inc(PixelI);
      r[9] := PixelI.Red; g[9] := PixelI.Green; b[9] := PixelI.Blue;

      GetXYValue(InBitmap,x-1,y-1,r[1],g[1],b[1]);
      GetXYValue(InBitmap,x  ,y-1,r[2],g[2],b[2]);
      GetXYValue(InBitmap,x+1,y-1,r[3],g[3],b[3]);
      {
      GetXYValue(InBitmap,x-1,y-1,r[1],g[1],b[1]);
      GetXYValue(InBitmap,x  ,y-1,r[2],g[2],b[2]);
      GetXYValue(InBitmap,x+1,y-1,r[3],g[3],b[3]);
      GetXYValue(InBitmap,x-1,y  ,r[4],g[4],b[4]);
      GetXYValue(InBitmap,x  ,y  ,r[5],g[5],b[5]);
      GetXYValue(InBitmap,x+1,y  ,r[6],g[6],b[6]);
      GetXYValue(InBitmap,x-1,y+1,r[7],g[7],b[7]);
      GetXYValue(InBitmap,x  ,y+1,r[8],g[8],b[8]);
      GetXYValue(InBitmap,x+1,y+1,r[9],g[9],b[9]);
      }
      PixelO.Red := MedianCut(r);
      PixelO.Green := MedianCut(g);
      PixelO.Blue := MedianCut(b);
      Inc(PixelI);
      Inc(PixelO);
    end;
  end;
end;

procedure TFHaupt.HighPass(InBitmap,OutBitmap: TBitmap);
var x,y: Integer;
    intensity,s1,sobel: extended;
    PixelI,PixelO: ^TRGBValue;
begin
  sobel := 0;
  for y := 1 to h - 2 do
  begin
    PixelI := InBitmap.Scanline[y];
    PixelO := OutBitmap.Scanline[y];
    Inc(PixelO);
    for x := 1 to w - 2 do
    begin
      PixelI := InBitmap.Scanline[y];
      Inc(PixelI,x);
      // Current PixelI (x,y)
      intensity := PixelI.Red+PixelI.Green+PixelI.Blue;
      s1 := intensity;
      Dec(PixelI); // (x-1,y)
      intensity := PixelI.Red+PixelI.Green+PixelI.Blue;
      sobel := abs(s1-intensity);
      Inc(PixelI,2); // (x+1,y)
      intensity := PixelI.Red+PixelI.Green+PixelI.Blue;
      sobel := sobel + abs(s1-intensity);

      PixelI := InBitmap.Scanline[y-1];
      Inc(PixelI,x-1); // (x-1,y-1)
      intensity := PixelI.Red+PixelI.Green+PixelI.Blue;
      sobel := sobel + abs(s1-intensity);
      Inc(PixelI); // (x,y-1)
      intensity := PixelI.Red+PixelI.Green+PixelI.Blue;
      sobel := sobel + abs(s1-intensity);
      Inc(PixelI); // (x+1,y-1)
      intensity := PixelI.Red+PixelI.Green+PixelI.Blue;
      sobel := sobel + abs(s1-intensity);

      PixelI := InBitmap.Scanline[y+1];
      Inc(PixelI,x-1); // (x-1,y+1)
      intensity := PixelI.Red+PixelI.Green+PixelI.Blue;
      sobel := sobel + abs(s1-intensity);
      Inc(PixelI); // (x,y+1)
      intensity := PixelI.Red+PixelI.Green+PixelI.Blue;
      sobel := sobel + abs(s1-intensity);
      Inc(PixelI); // (x+1,y+1)
      intensity := PixelI.Red+PixelI.Green+PixelI.Blue;
      sobel := sobel + abs(s1-intensity);
      PixelO.Red := Round(sobel / 3.0);
      PixelO.Green := Round(sobel / 3.0);
      PixelO.Blue := Round(sobel / 3.0);
      Inc(PixelO);
    end;
  end;
end;

procedure TFHaupt.Darkflat(Bitmap: TBitmap);
var x,y,r,g,b,r1,g1,b1,r2,g2,b2: Integer;
    Pixel, Pixel1, Pixel2: ^TRGBValue;
begin
  for y := 0 to h - 1 do
  begin
    Pixel := Bitmap.Scanline[y];
    if MIDarkframe.Checked then Pixel1 := Dark.Scanline[y];
    if MIFlatfield.Checked then Pixel2 := Flat.Scanline[y];
    for x := 0 to w - 1 do
    begin
      if MIDarkframe.Checked then
      begin
        r1 := Pixel1.Red;
        g1 := Pixel1.Green;
        b1 := Pixel1.Blue;
      end
      else
      begin
        r1 := 0; g1 := 0; b1 := 0; // Darkfield assumed a perfect dark pic
      end;
      if MIFlatfield.Checked then
      begin
        r2 := Pixel2.Red;
        g2 := Pixel2.Green;
        b2 := Pixel2.Blue;
      end
      else
      begin
        r2 := 255; g2 := 255; b2 := 255; // Flatfield assumed a perfect white pic
      end;
      if r2 > r1 then r := Round(255*(Pixel.Red-r1)/(r2-r1)) else r := 0;
      if g2 > g1 then g := Round(255*(Pixel.Green-g1)/(g2-g1)) else g := 0;
      if b2 > b1 then b := Round(255*(Pixel.Blue-b1)/(b2-b1)) else b := 0;
      Pixel.Red := Normalize(r);
      Pixel.Green := Normalize(g);
      Pixel.Blue := Normalize(b);
      Inc(Pixel);
      if MIDarkframe.Checked then Inc(Pixel1);
      if MIFlatfield.Checked then Inc(Pixel2);
    end;
  end;
end;

procedure TFHaupt.Integrate(InBitmap,OutBitmap: TBitmap);
var x,y: Integer;
    PixelI, PixelO: ^TRGBValue;
begin
  for y := 0 to h - 1 do
  begin
    PixelI := InBitmap.Scanline[y];
    PixelO := OutBitmap.Scanline[y];
    for x := 0 to w - 1 do
    begin
      PixelO.Red := Normalize(PixelI.Red+PixelO.Red);
      PixelO.Green := Normalize(PixelI.Green+PixelO.Green);
      PixelO.Blue := Normalize(PixelI.Blue+PixelO.Blue);
      Inc(PixelI);
      Inc(PixelO);
    end;
  end;
end;

procedure TFHaupt.Median(InBitmap,OutBitmap: TBitmap);
var x,y: Integer;
    PixelI, PixelO: ^TRGBValue;
begin
  for y := 0 to h - 1 do
  begin
    PixelI := InBitmap.Scanline[y];
    PixelO := OutBitmap.Scanline[y];
    for x := 0 to w - 1 do
    begin
      PixelO.Red := Normalize(Round(PixelI.Red/maxFrames+PixelO.Red));
      PixelO.Green := Normalize(Round(PixelI.Green/maxFrames+PixelO.Green));
      PixelO.Blue := Normalize(Round(PixelI.Blue/maxFrames+PixelO.Blue));
      Inc(PixelI);
      Inc(PixelO);
    end;
  end;
end;

procedure TFHaupt.Minimum(InBitmap,OutBitmap: TBitmap);
var x,y: Integer;
    PixelI, PixelO: ^TRGBValue;
begin
  for y := 0 to h - 1 do
  begin
    PixelI := InBitmap.Scanline[y];
    PixelO := OutBitmap.Scanline[y];
    for x := 0 to w - 1 do
    begin
      PixelO.Red := min(PixelI.Red,PixelO.Red);
      PixelO.Green := min(PixelI.Green,PixelO.Green);
      PixelO.Blue := min(PixelI.Blue,PixelO.Blue);
      Inc(PixelI);
      Inc(PixelO);
    end;
  end;
end;

procedure TFHaupt.Maximum(InBitmap,OutBitmap: TBitmap);
var x,y: Integer;
    PixelI, PixelO: ^TRGBValue;
begin
  for y := 0 to h - 1 do
  begin
    PixelI := InBitmap.Scanline[y];
    PixelO := OutBitmap.Scanline[y];
    for x := 0 to w - 1 do
    begin
      PixelO.Red := max(PixelI.Red,PixelO.Red);
      PixelO.Green := max(PixelI.Green,PixelO.Green);
      PixelO.Blue := max(PixelI.Blue,PixelO.Blue);
      Inc(PixelI);
      Inc(PixelO);
    end;
  end;
end;


procedure TFHaupt.MIQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TFHaupt.MISingleframeClick(Sender: TObject);
begin
  FrameNo := 1;
  BitmapNo := 1;
  MISingleframe.Checked := not MISingleframe.Checked;
end;

procedure TFHaupt.MISourceClick(Sender: TObject);
begin
  FPreview.VideoCap1.DlgVSource;
end;

procedure TFHaupt.MIFormatClick(Sender: TObject);
begin
  FPreview.VideoCap1.DlgVFormat;
  ShowInfos;
end;

procedure TFHaupt.MIDisplayClick(Sender: TObject);
begin
  FPreview.VideoCap1.DlgVDisplay;
end;

procedure TFHaupt.MICompressionClick(Sender: TObject);
begin
  FPreview.VideoCap1.DlgVCompression;
end;

procedure TFHaupt.MIOverlayClick(Sender: TObject);
begin
  FPreview.VideoCap1.VideoOverLay := True;
  MIOverlay.Checked := True;
end;

procedure TFHaupt.MIPreviewClick(Sender: TObject);
begin
  FPreview.VideoCap1.VideoPreview := True;
  MIPreview.Checked := True;
end;

procedure TFHaupt.MIDarkframeClick(Sender: TObject);
begin
  if not MiDarkframe.Checked then
  begin
    with OpenPictureDialog do
    begin
      DefaultExt := 'bmp';
      Filterindex := 0;
      Title := 'Wählen Sie ein Darkframe aus';
      if Execute then
      begin
        Dark.LoadFromFile(OpenPictureDialog.Filename);
        Dark.PixelFormat := pf32bit;
      end;
    end; // OPD
    MIDarkframe.Checked := true;
  end
  else
    MIDarkframe.Checked := false;
end;

procedure TFHaupt.FormCreate(Sender: TObject);
begin
  Current := TBitmap.Create;
  Dark := TBitmap.Create;
  Flat := TBitmap.Create;
  TmpBmp := TBitmap.Create;
  maxFrames := 1;
  maxBitmaps := 1;
  MIIntegrate.Enabled := False;
  MIMedian.Enabled := False;
  MIMinimum.Checked := False;
  MIMaximum.Checked := False;
  SBInfo.Panels[5].Text := 'Wählen Sie einen Treiber aus oder drücken Sie F8 um ihn zu aktivieren';
  nw := 640;
  nh := 480;
  Bias := 0; Gain := 1;
  SeeingOK := False;
  MaxSobel := 0.0; MinSobel := 1000.0;
end;

procedure TFHaupt.FormDestroy(Sender: TObject);
begin
  Current.Free;
  Dark.Free;
  Flat.Free;
  TmpBmp.Free;
end;

procedure TFHaupt.MIFlatfieldClick(Sender: TObject);
begin
  MIFlatfield.Checked := not MIFlatfield.Checked;
  if MiFlatfield.Checked then
  begin
    with OpenPictureDialog do
    begin
      DefaultExt := 'bmp';
      Filterindex := 0;
      Title := 'Wählen Sie ein Flatfield aus';
      if Execute then
      begin
        Flat.LoadFromFile(OpenPictureDialog.Filename);
        Flat.PixelFormat := pf32bit;
      end;
    end // OPD
  end;
end;

procedure TFHaupt.CaptureSingleFrame;
begin
  Current.Pixelformat := pf32bit;
  tmpbmp.Pixelformat := pf32bit;
  h := Current.Height;
  w := Current.Width;
  tmpbmp.Height := h;
  tmpbmp.Width := w;
//  FFrame.Image1.Picture.Bitmap.Height := h;
//  FFrame.Image1.Picture.Bitmap.Width := w;

  if MIDarkframe.Checked or MIFlatfield.Checked then Darkflat(Current);
  if (Bias>0) or (Gain>1) then BiasGain(Current);
  if MIBinning.Checked then Binning(Current);
  if MIBinning22.Checked then Binning22(Current);
  if MIBinning21.Checked then Binning21(Current);
  if MIContrast.Checked then Kontrast(Current);
  if MIInvert.Checked then Invert(Current);
  if MIColrot.Checked then Colrot(Current);
  if MIFalseColor.Checked then FalseColor(Current);
  if MIGrayscale.Checked then Grayscale(Current);

  if MIRed.Checked then JustRed(Current);
  if MIGreen.Checked then JustGreen(Current);
  if MIBlue.Checked then JustBlue(Current);

  if FrameNo = 1 then begin
    tmpbmp.canvas.brush.Color := clblack;
    if MIMinimum.Checked then tmpbmp.canvas.brush.Color := clwhite;
    tmpbmp.Canvas.FillRect(Rect(0,0,w,h));
  end;
  if MIIntegrate.Checked then Integrate(Current,TmpBmp);
  if MIMedian.Checked then Median(Current,TmpBmp);
  if MIMinimum.Checked then Minimum(Current,TmpBmp);
  if MIMaximum.Checked then Maximum(Current,TmpBmp);
  if MINoise.Checked then MedianFilter(Current,TmpBmp);
  if MIHighpass.Checked then Highpass(Current,TmpBmp);

  if MIIntegrate.Checked or
     MIMedian.Checked or
     MIMinimum.Checked or
     MIMaximum.Checked or
     MINoise.Checked or
     MIHighpass.Checked then
    BitBlt(Current.canvas.handle,0,0,w,h,TmpBmp.Canvas.Handle,0,0,SRCCOPY);
  Inc(FrameNo);
  if FrameNo <= maxFrames then Exit; // Break here if we are not ready yet;
  if FSettings.CBSeeing.Checked and (not SeeingOK) then Exit;
  FFrame.Image1.Picture.Bitmap.Width := nw;
  FFrame.Image1.Picture.Bitmap.Height := nh;
  BitBlt(FFrame.Image1.Canvas.Handle,0,0,nw,nh,Current.canvas.handle,(w-nw) div 2,(h-nh) div 2,SRCCOPY);
  FFRame.EraseBkgnd := False;
  FFrame.Image1.Invalidate;
  FFrame.Image1.Picture.Bitmap.Pixelformat:= pf24bit;
  FrameNo := 1;
  if MISingleFrame.Checked or
     MIMultiframe.Checked then
  begin
    Inc(BitmapNo);
    FrameNo := 1;
    Curfile := SetFrameName;
    FFrame.Image1.Picture.SaveToFile(CurFile);
    SaveMetaFile;
    MISingleFrame.Checked := False;
  end;
  if BitmapNo > maxBitmaps then
  begin
    BitmapNo := 1;
    FrameNo := 1;
    MIMultiFrame.Checked := False;
    MessageBeep($FFFFFFFF);
  end;
end;

procedure TFHaupt.MIMultiframeClick(Sender: TObject);
begin
  FrameNo := 1;
  BitmapNo := 1;
  MIMultiframe.Checked := not MIMultiframe.Checked;
end;

procedure TFHaupt.MITileClick(Sender: TObject);
begin
  Tile;
end;

procedure TFHaupt.MICascadeClick(Sender: TObject);
begin
  Cascade;
end;

procedure TFHaupt.ShowInfos;
var i: integer;
    Vheader: TBitMapInfoHeader;
begin
  Vheader:=FPreview.Videocap1.BitMapInfoHeader;
  SBInfo.Panels[0].Text := IntToStr(Vheader.biWidth)+'x'+IntToStr(Vheader.biHeight);
  SBInfo.Panels[1].Text := IntToStr(Vheader.biPlanes)+' Bitplanes';
  SBInfo.Panels[2].Text := IntToStr(Vheader.biBitCount)+' Bits/pixel';
  case Vheader.biCompression of
    BI_RGB: SBInfo.Panels[3].Text := 'RGB';
    BI_RLE8: SBInfo.Panels[3].Text := 'RLE8';
    BI_RLE4: SBInfo.Panels[3].Text := 'RLE4';
    BI_BITFIELDS: SBInfo.Panels[3].Text := '16/24';
  else
    SBInfo.Panels[3].Text := Format('(%x)',[Vheader.biCompression]);
  end;
  SBInfo.Panels[4].Text := IntToStr(Vheader.biSizeImage)+' Bytes';
  for i:= 0 to 5 do
  begin
    SBInfo.Panels[i].Width := SBInfo.Canvas.TextWidth(SBInfo.Panels[i].Text)+7;
  end;
end;

procedure TFHaupt.MIAufnahmeClick(Sender: TObject);
begin
  MIAufnahme.Checked := True;
  with FFrame do
  begin
    Top := 0;
    Left := 0;
    ClientWidth := 640;
    ClientHeight := 480;
  end;
  with FPreview do
  begin
    Top := 0;
    ClientWidth := 320;
    ClientHeight := 240;
    Left := FHaupt.ClientWidth-Width-4;
  end;
end;

procedure TFHaupt.MIFokusClick(Sender: TObject);
begin
  MIFokus.Checked := True;
  with FPreview do
  begin
    Top := 0;
    Left := 0;
    ClientWidth := 640;
    ClientHeight := 480;
  end;
  with FFrame do
  begin
    Top := 0;
    ClientWidth := 320;
    ClientHeight := 240;
    Left := FHaupt.ClientWidth-Width-4;
  end;
end;

procedure TFHaupt.MIModusClick(Sender: TObject);
begin
  if MIFokus.Checked then MIAufnahmeClick(FHaupt)
  else MIFokusClick(FHaupt);
end;

procedure TFHaupt.MIInfoClick(Sender: TObject);
begin
  FAbout.ShowModal;
end;

procedure TFHaupt.SaveMetaFile;
var F: Textfile;
    s, Dateiname: String;
begin
  Dateiname := ExtractFilePath(CurFile)+'descript.ion';
  AssignFile(F,Dateiname);
  if FileExists(Dateiname) then
    Append(F) else Rewrite(F);
  S:= ExtractFileName(CurFile)+' '+DateTimeToStr(Now)+' '+IntToStr(maxFrames)+'FpB';
  if MIDarkframe.Checked then S := S+ ' Dark';
  if MIFlatfield.Checked then S := S+ ' Flat';
  if MIBinning.Checked then S := S+ ' BinC';
  if MIBinning22.Checked then S := S+ ' Bin2';
  if MIBinning21.Checked then S := S+ ' Bin1';
  if MIContrast.Checked then S := S+ ' Con';
  if MIInvert.Checked then S := S+ ' Inv';
  if MIGrayscale.Checked then S := S+ ' Gray';
  if MIIntegrate.Checked then S := S+ ' Int';
  if MIMedian.Checked then S := S+ ' Med';
  if MIMinimum.Checked then S := S+ ' Min';
  if MIMaximum.Checked then S := S+ ' Max';
  if MINoise.Checked then S := S+ ' Noi';
  WriteLn(F,S);
  CloseFile(F);
end;

procedure TFHaupt.MIStartDriverClick(Sender: TObject);
begin
  SBInfo.Panels[5].Text := 'Treiber wird aktiviert ...';
  SBInfo.Repaint;
  Screen.Cursor := crHourglass;
  with FPreview do
  begin
    VideoCap1.DriverIndex:= FSettings.CBDriver.ItemIndex;
    MIFormat.Enabled := VideoCap1.HasDlgFormat;
    MIDisplay.Enabled := VideoCap1.HasDlgDisplay;
    MIOverlay.Enabled := VideoCap1.HasVideoOverlay;
    MISource.Enabled := VideoCap1.HasDlgSource;
    VideoCap1.DriverOpen:= true;
    VideoCap1.VideoPreview := True;
  end;
  Screen.CUrsor := crDefault;
  FSettings.ChangeSize;
  ShowInfos;
  SBInfo.Panels[5].Text := 'Wählen Sie F2 um ein Einzelbild aufzunehmen, oder F4 für die Vorschau';
end;

procedure TFHaupt.MIEffectClick(Sender: TObject);
begin
  (Sender As TMenuitem).Checked := not (Sender As TMenuitem).Checked;
end;

procedure TFHaupt.MIHelpClick(Sender: TObject);
begin
  Application.HelpJump('IDH_Wasist');
end;

end.
