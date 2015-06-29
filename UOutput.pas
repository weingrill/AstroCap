unit UOutput;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,FileCtrl,JPEG, Placemnt;

type
  TFOutput = class(TForm)
    Image1: TImage;
    FPOutput: TFormPlacement;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    function SetFrameName: String;
  public
    { Public-Deklarationen }
    filename: string;
    fileno: integer;
    procedure Capture;
  end;

var
  FOutput: TFOutput;

implementation

{$R *.DFM}

function isJPEG(FileName: string): Boolean;
var ext: string;
begin
  ext := UpperCase(ExtractFileExt(filename));
  if (Pos('.JPEG',ext)>0) or (Pos('.JPG',ext)>0) then
    Result := True
  else
    Result := False;
end;

function TFOutput.SetFrameName: String;
var path,name,ext: String;
    p,l : integer;
    currentdate,currenttime: string;
begin
  currentdate := FormatDateTime('yyyymmdd',Now);
  currenttime := FormatDateTime('hhnnss',Now);
  filename := StringReplace(filename,'%d',currentdate,[rfReplaceAll,rfIgnoreCase]);
  filename := StringReplace(filename,'%t',currenttime,[rfReplaceAll,rfIgnoreCase]);
  path := ExtractFilePath(filename);
  ForceDirectories(path);
  name := ExtractFileName(filename);
  ext := ExtractFileExt(filename);
  p := Pos(ext,name);
  l := Length(ext);
  Delete(name,p,l);
  repeat
    Result := Format('%s%s%5.5d%s',[path,name,FileNo,ext]);
    inc(Fileno);
  until not FileExists(Result);
  FOutput.Caption := 'Output #'+IntToStr(Fileno-1);
end;

procedure TFoutput.Capture;
var jpg: TJpegImage;
begin
  if IsJPEG(Filename) then
  begin
    jpg:=TJPEGImage.Create;
    jpg.CompressionQuality := 100;
    jpg.ProgressiveEncoding := false;
    jpg.PixelFormat := jf24Bit;
    jpg.Smoothing := false;
    jpg.Assign(Image1.Picture.Bitmap);
    jpg.Compress;
    jpg.SaveToFile(SetFrameName);
    jpg.Free;
  end
  else
    Image1.Picture.SaveToFile(SetFrameName);
end;

procedure TFOutput.FormCreate(Sender: TObject);
begin
  fileno := 0;
end;

end.
