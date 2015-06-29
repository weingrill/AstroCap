unit UInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, TeEngine, Series, ExtCtrls, TeeProcs, Chart, Math, U_FTG2,
  Placemnt;

type
  TRGBValue = packed record
    Blue: Byte;
    Green: Byte;
    Red: Byte;
    reserved: Byte;
  end;

type
  TFInfo = class(TForm)
    TCInfo: TTabControl;
    Histogramm: TChart;
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
    Series3: TFastLineSeries;
    Series4: TFastLineSeries;
    FPInfo: TFormPlacement;
    procedure TCInfoChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
    r,g,b,ia: array [0..640] of integer;
    Pixel : ^TRGBValue;
    rintegral,
    gintegral,
    bintegral,
    integral,
    size,s1,rs1,gs1,bs1,
    sobel,
    rsobel,
    gsobel,
    bsobel,
    intensity: Extended;
    F: Textfile;
    cin,cout,cspec: array [0..1024] of tcomplex;
    function FnSobel(Bitmap: TBitmap): Extended;
    function FnFWHM(Bitmap: TBitmap): Extended;
  public
    { Public-Deklarationen }
    x0,y0: double;
    procedure Optometric(Bitmap: TBitmap);
  end;

var
  FInfo: TFInfo;

implementation

uses UMain;

{$R *.DFM}


function avg(x,y: extended): extended;
begin
  result := (x+y)/2;
end;

procedure TFInfo.TCInfoChange(Sender: TObject);
var n: integer;
begin
  Series1.Clear;
  Series2.Clear;
  Series3.Clear;
  Series4.Clear;
  for n := 0 to 1024 do
    begin
      cspec[n].r := 0;
      cspec[n].i := 0;
    end;
  x0 := FMain.center_x+FMain.x1;
  y0 := FMain.center_y+FMain.y1;
end;

function TFInfo.FnSobel(Bitmap: TBitmap): Extended;
var x,y,w,h: integer;
begin
  w := Bitmap.Width;
  h := Bitmap.Height;
  size := w*h;
  sobel := 0.0;
  integral := 0.0;
  for y := 1 to h - 2 do
  begin
    for x := 1 to w - 2 do
    begin
      Pixel := Bitmap.Scanline[y];
      Inc(Pixel,x);
      // Current Pixel (x,y)
      intensity := Pixel.Red+Pixel.Green+Pixel.Blue;
      s1 := intensity;
      integral := integral + intensity;
      Dec(Pixel); // (x-1,y)
      intensity := Pixel.Red+Pixel.Green+Pixel.Blue;
      sobel := sobel + abs(s1-intensity);
      Inc(Pixel,2); // (x+1,y)
      intensity := Pixel.Red+Pixel.Green+Pixel.Blue;
      sobel := sobel + abs(s1-intensity);

      Pixel := Bitmap.Scanline[y-1];
      Inc(Pixel,x-1); // (x-1,y-1)
      intensity := Pixel.Red+Pixel.Green+Pixel.Blue;
      sobel := sobel + abs(s1-intensity);
      Inc(Pixel); // (x,y-1)
      intensity := Pixel.Red+Pixel.Green+Pixel.Blue;
      sobel := sobel + abs(s1-intensity);
      Inc(Pixel); // (x+1,y-1)
      intensity := Pixel.Red+Pixel.Green+Pixel.Blue;
      sobel := sobel + abs(s1-intensity);

      Pixel := Bitmap.Scanline[y+1];
      Inc(Pixel,x-1); // (x-1,y+1)
      intensity := Pixel.Red+Pixel.Green+Pixel.Blue;
      sobel := sobel + abs(s1-intensity);
      Inc(Pixel); // (x,y+1)
      intensity := Pixel.Red+Pixel.Green+Pixel.Blue;
      sobel := sobel + abs(s1-intensity);
      Inc(Pixel); // (x+1,y+1)
      intensity := Pixel.Red+Pixel.Green+Pixel.Blue;
      sobel := sobel + abs(s1-intensity);
    end; // x
  end; // y
  Result := sobel/ (size*3);
end;

function TFInfo.FnFWHM(Bitmap: TBitmap): Extended;
var x,y,w,h: integer;
    average, fwhm: double;
begin
  w := Bitmap.Width;
  h := Bitmap.Height;
  size := w*h;
  average := 0; // avg
  fwhm := 0; // fwhm
  for y := 0 to h-1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w -1 do
    begin
      intensity := (Pixel.Red+Pixel.Green+Pixel.Blue) / 3;
      average := average + intensity;
      Inc(Pixel);
    end;
  end;
  average := average/(w*h);
  for y := 0 to h-1 do
  begin
    Pixel := Bitmap.Scanline[y];
    for x := 0 to w -1 do
    begin
      intensity := (Pixel.Red+Pixel.Green+Pixel.Blue) / 3;
      if (intensity)>average then
        fwhm := fwhm+1;
      Inc(Pixel);
    end;
  end;
  Result := sqrt(fwhm);
end;


procedure TFInfo.Optometric(Bitmap: TBitmap);
var x,y,w,h: integer;
begin
  w := Bitmap.Width;
  h := Bitmap.Height;
  size := w*h;
  if w*h<=1 then exit;
  case TCInfo.TabIndex of
  0:
  begin
    for x := 0 to 255 do
    begin
      r[x] := 0; g[x] := 0; b[x] := 0;
    end;
    for y := 1 to h -1 do
    begin
      Pixel := Bitmap.Scanline[y];
      for x := 0 to w -1 do
      begin
        Inc(r[Pixel.Red]);
        Inc(g[Pixel.Green]);
        Inc(b[Pixel.Blue]);
        Inc(Pixel);
      end;
    end;
    Histogramm.LeftAxis.Automatic := true;
{    Histogramm.LeftAxis.Automatic := false;
    Histogramm.LeftAxis.Maximum := size/255;}
    Series1.Clear;
    Series2.Clear;
    Series3.Clear;
    Series4.Clear;

    FMain.TBSeeing.Min := 0;
    FMain.TBSeeing.Max := 255;
    FMain.TBSeeing.SelStart := 0;
    FMain.TBSeeing.SelEnd := 255;
    for x := 0 to 255 do
    begin
      Series1.Add(8*Log2(r[x]+1),'');
      Series2.Add(8*Log2(g[x]+1),'');
      Series3.Add(8*Log2(b[x]+1),'');
      Series4.Add(8*Log2(r[x]+g[x]+b[x]+1),'');
    end;
    for x := 0 to 255 do
    begin
      if (r[x]>1) then
      begin
        FMain.TBSeeing.SelStart := x;
        break;
      end;
    end;
    for x := 255 downto 0 do
    begin
      if (r[x]>1) then
      begin
        FMain.TBSeeing.SelEnd := x;
        break;
      end;
    end;
    FMain.SeeingOK := (FMain.TBSeeing.Position >= FMain.TBSeeing.SelStart) and
                      (FMain.TBSeeing.Position <= FMain.TBSeeing.SelEnd);
  end; // Tabindex 0
  1: // Integral
  begin
    Histogramm.LeftAxis.Automatic := true;
    rintegral := 0.0;
    gintegral := 0.0;
    bintegral := 0.0;
    integral := 0.0;
    for y := 0 to h -1 do
    begin
      Pixel := Bitmap.Scanline[y];
      for x := 0 to w -1 do
      begin
        rintegral := rintegral+Pixel.Red;
        gintegral := gintegral+Pixel.Green;
        bintegral := bintegral+Pixel.Blue;
        integral := integral+Pixel.Red+Pixel.Green+Pixel.Blue;
        Inc(Pixel);
      end;
    end;
    rintegral := rintegral/size;
    gintegral := gintegral/size;
    bintegral := bintegral/size;
    integral := integral/(size*3);
{    if Series1.XValues.Count>255 then Series1.Clear;
    if Series2.XValues.Count>255 then Series2.Clear;
    if Series3.XValues.Count>255 then Series3.Clear;
    if Series4.XValues.Count>255 then Series4.Clear;}
    if Series1.XValues.Count>255 then Series1.Delete(0);
    if Series2.XValues.Count>255 then Series2.Delete(0);
    if Series3.XValues.Count>255 then Series3.Delete(0);
    if Series4.XValues.Count>255 then Series4.Delete(0);

    if Series1.XValues.Count=0 then
    begin
      Series1.AddXY(0,rintegral,'',clRed);
      Series2.AddXY(0,gintegral,'',clGreen);
      Series3.AddXY(0,bintegral,'',clBlue);
      Series4.AddXY(0,integral,'',clWhite);
    end
    else
    begin
      Series1.AddXY(Series1.XValues.Last+1,rintegral,'',clRed);
      Series2.AddXY(Series2.XValues.Last+1,gintegral,'',clGreen);
      Series3.AddXY(Series3.XValues.Last+1,bintegral,'',clBlue);
      Series4.AddXY(Series4.XValues.Last+1,integral,'',clWhite);
    end;
    FMain.TBSeeing.Min := Round(Histogramm.LeftAxis.Minimum*100);
    FMain.TBSeeing.Max := Round(Histogramm.LeftAxis.Maximum*100);
    FMain.TBSeeing.SelStart := FMain.TBSeeing.Min;
    FMain.TBSeeing.SelEnd := Round(integral*100);
//    FMain.TBSeeing.SelEnd := Round(100.0*(sobel - minsobel)/(maxsobel-minsobel));
    FMain.SeeingOK := true; //(FMain.TBSeeing.SelEnd <= FMain.TBSeeing.Position);
    write(F,FormatDateTime('c;',Now));
    writeln(F,Format('%f;%f;%f;%f',[rintegral,gintegral,bintegral,integral]));

    Histogramm.Refresh;
  end; // Tabindex 1
  2: //Sobel
  begin
    Histogramm.LeftAxis.Automatic := true;
    sobel := 0.0; rsobel := 0.0; gsobel := 0.0; bsobel := 0.0;
    integral := 0.0;
    for y := 1 to h - 2 do
    begin
      for x := 1 to w - 2 do
      begin
        Pixel := Bitmap.Scanline[y];
        Inc(Pixel,x);
        // Current Pixel (x,y)
        intensity := Pixel.Red+Pixel.Green+Pixel.Blue;
        s1 := intensity;
        rs1 := Pixel.Red;
        gs1 := Pixel.Green;
        bs1 := Pixel.Blue;
        integral := integral + intensity;
        Dec(Pixel); // (x-1,y)
        intensity := Pixel.Red+Pixel.Green+Pixel.Blue;
        sobel := sobel + abs(s1-intensity);
        rsobel := rsobel + abs(rs1-Pixel.Red);
        gsobel := gsobel + abs(gs1-Pixel.Green);
        bsobel := bsobel + abs(bs1-Pixel.Blue);
        Inc(Pixel,2); // (x+1,y)
        intensity := Pixel.Red+Pixel.Green+Pixel.Blue;
        sobel := sobel + abs(s1-intensity);
        rsobel := rsobel + abs(rs1-Pixel.Red);
        gsobel := gsobel + abs(gs1-Pixel.Green);
        bsobel := bsobel + abs(bs1-Pixel.Blue);

        Pixel := Bitmap.Scanline[y-1];
        Inc(Pixel,x-1); // (x-1,y-1)
        intensity := Pixel.Red+Pixel.Green+Pixel.Blue;
        sobel := sobel + abs(s1-intensity);
        rsobel := rsobel + abs(rs1-Pixel.Red);
        gsobel := gsobel + abs(gs1-Pixel.Green);
        bsobel := bsobel + abs(bs1-Pixel.Blue);
        Inc(Pixel); // (x,y-1)
        intensity := Pixel.Red+Pixel.Green+Pixel.Blue;
        sobel := sobel + abs(s1-intensity);
        rsobel := rsobel + abs(rs1-Pixel.Red);
        gsobel := gsobel + abs(gs1-Pixel.Green);
        bsobel := bsobel + abs(bs1-Pixel.Blue);
        Inc(Pixel); // (x+1,y-1)
        intensity := Pixel.Red+Pixel.Green+Pixel.Blue;
        sobel := sobel + abs(s1-intensity);
        rsobel := rsobel + abs(rs1-Pixel.Red);
        gsobel := gsobel + abs(gs1-Pixel.Green);
        bsobel := bsobel + abs(bs1-Pixel.Blue);

        Pixel := Bitmap.Scanline[y+1];
        Inc(Pixel,x-1); // (x-1,y+1)
        intensity := Pixel.Red+Pixel.Green+Pixel.Blue;
        sobel := sobel + abs(s1-intensity);
        rsobel := rsobel + abs(rs1-Pixel.Red);
        gsobel := gsobel + abs(gs1-Pixel.Green);
        bsobel := bsobel + abs(bs1-Pixel.Blue);
        Inc(Pixel); // (x,y+1)
        intensity := Pixel.Red+Pixel.Green+Pixel.Blue;
        sobel := sobel + abs(s1-intensity);
        rsobel := rsobel + abs(rs1-Pixel.Red);
        gsobel := gsobel + abs(gs1-Pixel.Green);
        bsobel := bsobel + abs(bs1-Pixel.Blue);
        Inc(Pixel); // (x+1,y+1)
        intensity := Pixel.Red+Pixel.Green+Pixel.Blue;
        sobel := sobel + abs(s1-intensity);
        rsobel := rsobel + abs(rs1-Pixel.Red);
        gsobel := gsobel + abs(gs1-Pixel.Green);
        bsobel := bsobel + abs(bs1-Pixel.Blue);
      end; // x
    end; // y
    sobel := sobel / (size*3);
    rsobel := rsobel / size;
    gsobel := gsobel / size;
    bsobel := bsobel / size;
//    if Sobel < Minsobel then Minsobel := sobel;
//    if sobel > MaxSobel then MaxSobel := sobel;
//    if maxsobel-minsobel<0.5 then Maxsobel := minsobel+0.5;
    FMain.TBSeeing.Min := Round(Histogramm.LeftAxis.Minimum*100);
    FMain.TBSeeing.Max := Round(Histogramm.LeftAxis.Maximum*100);
    FMain.TBSeeing.SelStart := FMain.TBSeeing.Min;
    FMain.TBSeeing.SelEnd := Round(sobel*100);
//    FMain.TBSeeing.SelEnd := Round(100.0*(sobel - minsobel)/(maxsobel-minsobel));
    FMain.SeeingOK := (FMain.TBSeeing.SelEnd >= FMain.TBSeeing.Position);
    {if Series1.XValues.Count>255 then Series1.Delete(0);
    if Series2.XValues.Count>255 then Series2.Delete(0);
    if Series3.XValues.Count>255 then Series3.Delete(0);
    }if Series4.XValues.Count>255 then Series4.Delete(0);

   { if Series1.XValues.Count = 0 then Series1.AddXY(0,rsobel,'',clRed);
    if Series2.XValues.Count = 0 then Series2.AddXY(0,gsobel,'',clGreen);
    if Series3.XValues.Count = 0 then Series3.AddXY(0,bsobel,'',clBlue);
    }if Series4.XValues.Count = 0 then Series4.AddXY(0,sobel,'',clWhite);

    {if Series1.XValues.Count > 0 then Series1.AddXY(Series1.XValues.Last+1,rsobel,'',clRed);
    if Series2.XValues.Count > 0 then Series2.AddXY(Series2.XValues.Last+1,gsobel,'',clGreen);
    if Series3.XValues.Count > 0 then Series3.AddXY(Series3.XValues.Last+1,bsobel,'',clBlue);
    }if Series4.XValues.Count > 0 then Series4.AddXY(Series4.XValues.Last+1,sobel,'',clWhite);
    write(F,FormatDateTime('c;',Now));
    writeln(F,Format('%f;%f;%f;%f',[rsobel,gsobel,bsobel,sobel]));
    Histogramm.Refresh;
  end; // Tabindex 2
  3: // Profil
  begin
    Series1.Clear;
    Series2.Clear;
    Series3.Clear;
    Series4.Clear;
    Histogramm.LeftAxis.Automatic := true;
    for x := 0 to 255 do
    begin
      r[x] := 0; g[x] := 0; b[x] := 0; ia[x] := 0;
    end;
    for y := 1 to h -1 do
    begin
      Pixel := Bitmap.Scanline[y];
      for x := 0 to w -1 do
      begin
        r[x] := r[x]+Pixel.Red;
        g[x] := g[x]+Pixel.Green;
        b[x] := b[x]+Pixel.Blue;
        ia[x] := Round((r[x]+b[x]+g[x]) / 3) + ia[x];
        Inc(Pixel);
      end;
    end;
//    FMain.TBSeeing.SelEnd := Round(100.0*(sobel - minsobel)/(maxsobel-minsobel));
    FMain.TBSeeing.Min := 0;
    FMain.TBSeeing.Max := w*255;
    FMain.TBSeeing.SelStart := w*255;
    FMain.TBSeeing.SelEnd := w*255;
    for x := 0 to w-1 do
    begin
      //Series1.AddXY(x,r[x]/w,'',clRed);
      //Series2.AddXY(x,g[x]/w,'',clGreen);
      //Series3.AddXY(x,b[x]/w,'',clBlue);
      Series4.AddXY(x,ia[x]/w,'',clWhite);
      if ia[x]/w< FMain.TBSeeing.SelStart then
        FMain.TBSeeing.SelStart := Round(ia[x]/w);
      if ia[x]/w> FMain.TBSeeing.SelEnd then
        FMain.TBSeeing.SelEnd := Round(ia[x]/w);
    end;
    FMain.SeeingOK := (FMain.TBSeeing.Position >= FMain.TBSeeing.SelStart) and
                      (FMain.TBSeeing.Position <= FMain.TBSeeing.SelEnd);

    Histogramm.Refresh;
  end; // Tabindex 3
  4:
  begin
    Series1.Clear;
    Series2.Clear;
    Series3.Clear;
    Series4.Clear;
    Histogramm.LeftAxis.Automatic := true;
    integral := 0;
    intensity := 0;
    Pixel := Bitmap.Scanline[ h div 2];
    for x := 0 to w -1 do
    begin
      intensity := (Pixel.Red+Pixel.Green+Pixel.Blue) div 3;
      integral := max(integral,intensity);
      Inc(Pixel);
      Series1.AddXY(x,Pixel.Red,'',clRed);
      Series2.AddXY(x,Pixel.Green,'',clGreen);
      Series3.AddXY(x,Pixel.Blue,'',clBlue);
      Series4.AddXY(x,intensity,'',clWhite);
    end;
    FMain.TBSeeing.Min := Round(Histogramm.LeftAxis.Minimum*100);
    FMain.TBSeeing.Max := Round(Histogramm.LeftAxis.Maximum*100);
    FMain.TBSeeing.SelStart := FMain.TBSeeing.Min;
    FMain.TBSeeing.SelEnd := Round(integral*100);
    FMain.SeeingOK := (FMain.TBSeeing.SelEnd >= FMain.TBSeeing.Position);
    write(F,FormatDateTime('c;',Now));
    writeln(F,Format('%f',[integral]));

    Histogramm.Refresh;
  end; // Tabindex 4
  5:
  begin
{    Series1.Clear;
    Series2.Clear;
    Series3.Clear;
    Series4.Clear; }
    Histogramm.LeftAxis.Automatic := true;
    Pixel := Bitmap.Scanline[ h div 2];
    sobel := 0; intensity := 0;
    for x := 0 to w -1 do
    begin
      r[x] := Pixel.Red;
      g[x] := Pixel.Green;
      b[x] := Pixel.Blue;
      ia[x] := (r[x]+b[x]+g[x]) div 3;
      intensity := intensity+ ia[x];
      Inc(Pixel);
      if x>1 then
      begin
        sobel := sobel + 100*abs(ia[x]-ia[x-1])+ 50*abs(ia[x]-ia[x-2]);
      end;
    end;
    if intensity>1 then sobel := sobel/intensity;
    if Series4.XValues.Count=0 then
      Series4.AddXY(0,sobel,'',clWhite);
    Series4.AddXY(Series4.XValues.Last+1,sobel,'',clWhite);
    if Series4.XValues.Count>128 then Series4.Delete(0);

    FMain.TBSeeing.Min := Round(Histogramm.LeftAxis.Minimum*100);
    FMain.TBSeeing.Max := Round(Histogramm.LeftAxis.Maximum*100);
    FMain.TBSeeing.SelStart := FMain.TBSeeing.Min;
    FMain.TBSeeing.SelEnd := Round(100*sobel);
    FMain.SeeingOK := (FMain.TBSeeing.SelEnd >= FMain.TBSeeing.Position);

    Histogramm.Refresh;
  end; // Tabindex 5
  6:
  begin
{    Series1.Clear;
    Series2.Clear;
    Series3.Clear;
    Series4.Clear; }
    Histogramm.LeftAxis.Automatic := true;
    sobel := 0; // stdev
    intensity := 0; // avg
    for y := 0 to h-1 do
    begin
      Pixel := Bitmap.Scanline[y];
      for x := 0 to w -1 do
      begin
        intensity := intensity+ ((Pixel.Red+Pixel.Green+Pixel.Blue) div 3);
        Inc(Pixel);
      end;
    end;
    intensity := intensity / (w*h);
    for y := 0 to h-1 do
    begin
      Pixel := Bitmap.Scanline[y];
      for x := 0 to w -1 do
      begin
        sobel := sobel + sqr((Pixel.Red+Pixel.Green+Pixel.Blue) div 3 - intensity);
        Inc(Pixel);
      end;
    end;
    if sobel>0 then
      sobel := intensity/sqrt(sobel/(w*h-1));
    if Series4.XValues.Count=0 then
      Series4.AddXY(0,sobel,'',clWhite)
    else
      Series4.AddXY(Series4.XValues.Last+1,sobel,'',clWhite);
    if Series4.XValues.Count>128 then Series4.Delete(0);

    FMain.TBSeeing.Min := Round(Histogramm.LeftAxis.Minimum*100);
    FMain.TBSeeing.Max := Round(Histogramm.LeftAxis.Maximum*100);
    FMain.TBSeeing.SelStart := FMain.TBSeeing.Min;
    FMain.TBSeeing.SelEnd := Round(100*sobel);
//    FMain.TBSeeing.SelEnd := Round(100.0*(sobel - minsobel)/(maxsobel-minsobel));
    FMain.SeeingOK := (FMain.TBSeeing.SelEnd <= FMain.TBSeeing.Position);

    Histogramm.Refresh;
  end; // Tabindex 6
  7:
  begin
{    Series1.Clear;
    Series2.Clear;
    Series3.Clear;
    Series4.Clear; }
    Histogramm.LeftAxis.Automatic := true;
    sobel := 0; // stdev
    intensity := 0; // avg
    for y := 0 to h-1 do
    begin
      Pixel := Bitmap.Scanline[y];
      for x := 0 to w -1 do
      begin
        intensity := intensity+ ((Pixel.Red+Pixel.Green+Pixel.Blue) div 3);
        Inc(Pixel);
      end;
    end;
    intensity := intensity / (w*h);
    for y := 0 to h-1 do
    begin
      Pixel := Bitmap.Scanline[y];
      for x := 0 to w -1 do
      begin
        sobel := sobel + sqr((Pixel.Red+Pixel.Green+Pixel.Blue) div 3 - intensity);
        Inc(Pixel);
      end;
    end;
    if sobel>0 then
      sobel := sqrt(sobel/(w*h-1));
    if Series4.XValues.Count=0 then
      Series4.AddXY(0,sobel,'',clWhite)
    else
      Series4.AddXY(Series4.XValues.Last+1,sobel,'',clWhite);
    if Series4.XValues.Count>128 then Series4.Delete(0);

    FMain.TBSeeing.Min := Round(Histogramm.LeftAxis.Minimum*100);
    FMain.TBSeeing.Max := Round(Histogramm.LeftAxis.Maximum*100);
    FMain.TBSeeing.SelStart := FMain.TBSeeing.Min;
    FMain.TBSeeing.SelEnd := Round(100*sobel);
//    FMain.TBSeeing.SelEnd := Round(100.0*(sobel - minsobel)/(maxsobel-minsobel));
    FMain.SeeingOK := (FMain.TBSeeing.SelEnd <= FMain.TBSeeing.Position);

    Histogramm.Refresh;
  end; // Tabindex 7

  8:
  begin
{    Series1.Clear;
    Series2.Clear;
    Series3.Clear;
    Series4.Clear; }
    Histogramm.LeftAxis.Automatic := true;
    rintegral := 0; // avg
    gintegral := 0; // avg
    bintegral := 0; // avg
    sobel := 0; // fwhm
    for y := 0 to h-1 do
    begin
      Pixel := Bitmap.Scanline[y];
      for x := 0 to w -1 do
      begin
        intensity := (Pixel.Red+Pixel.Green+Pixel.Blue) div 3;
        rintegral := rintegral + sqr(intensity);
        gintegral := gintegral + intensity;
        if intensity > 0 then bintegral := bintegral+ (1/intensity);
        Inc(Pixel);
      end;
    end;
    rintegral := sqrt(rintegral/(w*h));
    gintegral := gintegral/(w*h);
    if bintegral> 0 then bintegral := 1/(bintegral);
    for y := 0 to h-1 do
    begin
      Pixel := Bitmap.Scanline[y];
      for x := 0 to w -1 do
      begin
        intensity := (Pixel.Red+Pixel.Green+Pixel.Blue) div 3;
        if (intensity)>gintegral then
          sobel := sobel+1;

        Inc(Pixel);
      end;
    end;
    sobel := sqrt(sobel);

    if Series4.XValues.Count=0 then
      Series4.AddXY(0,sobel,'',clWhite)
    else
      Series4.AddXY(Series4.XValues.Last+1,sobel,'',clWhite);
    if Series4.XValues.Count>128 then Series4.Delete(0);

    FMain.TBSeeing.Min := Round(Histogramm.LeftAxis.Minimum*100);
    FMain.TBSeeing.Max := Round(Histogramm.LeftAxis.Maximum*100);
    FMain.TBSeeing.SelStart := FMain.TBSeeing.Min;
    FMain.TBSeeing.SelEnd := Round(sobel*100);
//    FMain.TBSeeing.SelEnd := Round(100.0*(sobel - minsobel)/(maxsobel-minsobel));
    FMain.SeeingOK := (FMain.TBSeeing.SelEnd <= FMain.TBSeeing.Position);
    write(F,FormatDateTime('c;',Now));
    writeln(F,Format('%f',[sobel]));

    Histogramm.Refresh;
  end; // Tabindex 8
  9:
  begin
    Histogramm.LeftAxis.Automatic := true;
    integral := 0;
    intensity := 0;
    for x := 0 to w -1 do
    begin
      cspec[x].r := 0;
      cspec[x].i := 0;
    end;
    for y := (h DIV 4) to 3*(h DIV 4) do
    begin
      Pixel := Bitmap.Scanline[y];
      for x := 0 to w -1 do
      begin
        cin[x].r := (Pixel.Red+Pixel.Green+Pixel.Blue)/3;
        cin[x].i := 0;
        Inc(Pixel);
      end;
      CFTG(cin,cout,cin,w); // Forward FFT;
      for x := 0 to (w -1) DIV 2 do
      begin
        CxAdd(cspec[x],cspec[x],cout[x]);
      end;
    end;
    for x := 0 to (w -1) DIV 2 do
    begin
      intensity := intensity+(x*sqrt(sqr(cspec[x].r)+sqr(cspec[x].i)));
    end;
    intensity := intensity / w;
    if Series4.XValues.Count=0 then
      Series4.AddXY(0,intensity,'',clWhite)
    else
      Series4.AddXY(Series4.XValues.Last+1,intensity,'',clWhite);
    if Series4.XValues.Count>64 then Series4.Delete(0);

    FMain.TBSeeing.Min := Round(Histogramm.LeftAxis.Minimum*100);
    FMain.TBSeeing.Max := Round(Histogramm.LeftAxis.Maximum*100);
    FMain.TBSeeing.SelStart := FMain.TBSeeing.Min;
    FMain.TBSeeing.SelEnd := Round(intensity*100);
    FMain.SeeingOK := (FMain.TBSeeing.SelEnd >= FMain.TBSeeing.Position);
    write(F,FormatDateTime('c;',Now));
    writeln(F,Format('%f',[intensity]));

    Histogramm.Refresh;
  end; // Tabindex 9
  10:
  begin
    Histogramm.LeftAxis.Automatic := true;
    integral := 0;
    intensity := 0;
   { for x := 0 to w -1 do
    begin
      cspec[x].r := 0;
      cspec[x].i := 0;
    end;}
    for y := 0 to h-1 do
    begin
      Pixel := Bitmap.Scanline[y];
      for x := 0 to w -1 do
      begin
        cin[x].r := (Pixel.Red+Pixel.Green+Pixel.Blue)/3;
        cin[x].i := 0;
        Inc(Pixel);
      end;
      CFTG(cin,cout,cin,w); // Forward FFT;
      for x := 0 to (w -1) DIV 2 do
      begin
        cspec[x].r := avg(cspec[x].r,cout[x].r);
        cspec[x].i := avg(cspec[x].i,cout[x].i);
      end;
    end;
    Series4.Clear;
    for x := 0 to (w -1) DIV 2 do
    begin
      intensity := sqrt(sqr(cspec[x].r)+sqr(cspec[x].i));
      Series4.AddXY(x,log2(intensity+1),'',clwhite);
    end;

    FMain.TBSeeing.Min := Round(Histogramm.LeftAxis.Minimum*100);
    FMain.TBSeeing.Max := Round(Histogramm.LeftAxis.Maximum*100);
    FMain.TBSeeing.SelStart := FMain.TBSeeing.Min;
    FMain.TBSeeing.SelEnd := Round(intensity*100);
    FMain.SeeingOK := (FMain.TBSeeing.SelEnd >= FMain.TBSeeing.Position);

    Histogramm.Refresh;
  end; // Tabindex 10
  11: // Position
  begin
    Histogramm.LeftAxis.Automatic := true;

    if Series1.XValues.Count>255 then Series1.Delete(0);
    //if Series2.XValues.Count>255 then Series2.Delete(0);
    if Series3.XValues.Count>255 then Series3.Delete(0);
    if Series4.XValues.Count>255 then Series4.Delete(0);
    integral := sqrt(sqr(FMain.center_x+FMain.x1-x0)+sqr(FMain.center_y+FMain.y1-y0));
    intensity := max(FMain.center_x+FMain.x1-x0,FMain.center_y+FMain.y1-y0);
    if Series1.XValues.Count=0 then
    begin
      Series1.AddXY(0,FMain.center_x+FMain.x1-x0,'',clRed);
      //Series2.AddXY(0,integral,'',clGreen);
      Series3.AddXY(0,FMain.center_y+FMain.y1-y0,'',clBlue);
      Series4.AddXY(0,intensity,'',clwhite);
    end
    else
    begin
      Series1.AddXY(Series1.XValues.Last+1,FMain.center_x+FMain.x1-x0,'',clRed);
      //Series2.AddXY(Series1.XValues.Last+1,integral,'',clGreen);
      Series3.AddXY(Series3.XValues.Last+1,FMain.center_y+FMain.y1-y0,'',clBlue);
      Series4.AddXY(Series1.XValues.Last+1,intensity,'',clwhite);
    end;
    FMain.TBSeeing.Min := Round(Histogramm.LeftAxis.Minimum*100);
    FMain.TBSeeing.Max := Round(Histogramm.LeftAxis.Maximum*100);
    FMain.TBSeeing.SelStart := FMain.TBSeeing.Min;
    FMain.TBSeeing.SelEnd := Round(intensity*100);
//    FMain.TBSeeing.SelEnd := Round(100.0*(sobel - minsobel)/(maxsobel-minsobel));
    FMain.SeeingOK := (FMain.TBSeeing.SelEnd <= FMain.TBSeeing.Position);

    write(F,FormatDateTime('c;',Now));
    writeln(F,Format('%f;%f',[FMain.center_x+FMain.x1-x0,FMain.center_y+FMain.y1-y0]));

    Histogramm.Refresh;
  end; // Tabindex 11
  12:
  begin
    Histogramm.LeftAxis.Automatic := true;
    Sobel := 100*FnSobel(Bitmap)/FnFWHM(Bitmap);
    if Series4.XValues.Count=0 then
      Series4.AddXY(0,sobel,'',clWhite)
    else
      Series4.AddXY(Series4.XValues.Last+1,sobel,'',clWhite);
    if Series4.XValues.Count>128 then Series4.Delete(0);

    FMain.TBSeeing.Min := Round(Histogramm.LeftAxis.Minimum*100);
    FMain.TBSeeing.Max := Round(Histogramm.LeftAxis.Maximum*100);
    FMain.TBSeeing.SelStart := FMain.TBSeeing.Min;
    FMain.TBSeeing.SelEnd := Round(100*sobel);
//    FMain.TBSeeing.SelEnd := Round(100.0*(sobel - minsobel)/(maxsobel-minsobel));
    FMain.SeeingOK := (FMain.TBSeeing.SelEnd >= FMain.TBSeeing.Position);

    Histogramm.Refresh;
  end; // Tabindex 12
  end; // case
  FMain.TBSeeing.Frequency := (FMain.TBSeeing.Max-FMain.TBSeeing.Min) div 10;
end;

procedure TFInfo.FormCreate(Sender: TObject);
begin
  AssignFile(F,ExtractFilePath(ParamStr(0))+'stat.csv');
  Rewrite(F);
end;

procedure TFInfo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseFile(F);
end;

end.
