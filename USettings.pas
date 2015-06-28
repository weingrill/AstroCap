unit USettings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ToolEdit, ComCtrls, Inifiles, VideoCap, RXSpin,math,
  Buttons;

type
  TFSettings = class(TForm)
    Label1: TLabel;
    CBDriver: TComboBox;
    Label3: TLabel;
    LFpB: TLabel;
    TBFpB: TTrackBar;
    LBpS: TLabel;
    TBBpS: TTrackBar;
    Label2: TLabel;
    DEBasis: TDirectoryEdit;
    Label4: TLabel;
    ESeries: TEdit;
    EFilename: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    SEFpB: TRxSpinEdit;
    SEBpS: TRxSpinEdit;
    Label7: TLabel;
    CBSize: TComboBox;
    SBBias: TScrollBar;
    SBGain: TScrollBar;
    LBias: TLabel;
    LGain: TLabel;
    TBSeeing: TTrackBar;
    CBSeeing: TCheckBox;
    BAufnahme: TButton;
    procedure CBDriverChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure TBFpBChange(Sender: TObject);
    procedure TBBpSChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SEFpBChange(Sender: TObject);
    procedure SEBpSChange(Sender: TObject);
    procedure EFilenameChange(Sender: TObject);
    procedure CBSizeChange(Sender: TObject);
    procedure SBBiasChange(Sender: TObject);
    procedure SBGainChange(Sender: TObject);
    procedure CBSeeingClick(Sender: TObject);
    procedure BAufnahmeClick(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure Load;
    procedure Save;
  public
    { Public-Deklarationen }
    procedure ChangeSize;
  end;

var
  FSettings: TFSettings;

implementation

uses UPreview, UHaupt, UFrame;

{$R *.DFM}

procedure TFSettings.CBDriverChange(Sender: TObject);
begin
  if CBDriver.Itemindex < 0 then Exit;

  FPreview.VideoCap1.DriverIndex:= CBDriver.ItemIndex;
  FHaupt.MIFormat.Enabled := FPreview.VideoCap1.HasDlgFormat;
  FHaupt.MIDisplay.Enabled := FPreview.VideoCap1.HasDlgDisplay;
  FHaupt.MIOverlay.Enabled := FPreview.VideoCap1.HasVideoOverlay;
  FHaupt.MISource.Enabled := FPreview.VideoCap1.HasDlgSource;
  FPreview.VideoCap1.DriverOpen:= true;
  FPreview.VideoCap1.VideoPreview := True;
  FHaupt.ShowInfos;
  ChangeSize;
end;

procedure TFSettings.FormCreate(Sender: TObject);
begin
  Load;
end;

procedure TFSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Save;
end;

procedure TFSettings.Load;
var
  MyIni: TIniFile;
  DrvList:TStrings;
begin
  drvList :=  GetDriverList;
  CBDriver.Items := drvList;
  FPreview.VideoCap1.DriverOpen := false;
  drvList.Clear;
  drvList.Free;

  MyIni := TIniFile.Create(ExtractFilePath(ParamStr(0))+'AstroCap.Ini');
  CBDriver.ItemIndex := MyIni.ReadInteger('Settings','Driverindex',-1);
//  TBBuffer.Position := MyIni.ReadInteger('Settings','Buffer',0);
  EFileName.Text := MyIni.ReadString('Settings','Filename','Cap');
  ESeries.Text := MyIni.ReadString('Settings','Series','Serie');
  DEBasis.Text := MyIni.ReadString('Settings','Directory','C:\');
  TBFpB.Position := MyIni.ReadInteger('Settings','Frames',1);
  SEFpB.Value := MyIni.ReadInteger('Settings','Frames',1);
  TBBpS.Position := MyIni.ReadInteger('Settings','Bitmaps',1);
  SEBpS.Value := MyIni.ReadInteger('Settings','Bitmaps',1);
  CBSize.ItemIndex := MyIni.ReadInteger('Settings','Size',-1);
  MyIni.Free;

end;

procedure TFSettings.Save;
var
  MyIni: TIniFile;
begin
  MyIni := TIniFile.Create(ExtractFilePath(ParamStr(0))+'AstroCap.Ini');
  MyIni.WriteInteger('Settings','Driverindex',CBDriver.ItemIndex);
//  MyIni.WriteInteger('Settings','Buffer',TBBuffer.Position);
  MyIni.WriteString('Settings','Directory',DEBasis.Text);
  MyIni.WriteString('Settings','Series',ESeries.Text);
  MyIni.WriteString('Settings','Filename',EFileName.Text);
  MyIni.WriteInteger('Settings','Frames',TBFpB.Position);
  MyIni.WriteInteger('Settings','Bitmaps',TBBpS.Position);
  MyIni.WriteInteger('Settings','Size',CBSize.ItemIndex);
  MyIni.Free;
end;


procedure TFSettings.FormDestroy(Sender: TObject);
begin
  Save;
end;

procedure TFSettings.TBFpBChange(Sender: TObject);
begin
  if TBFpB.Position=1 then
  begin
    FHaupt.MIIntegrate.Enabled := False;
    FHaupt.MIMedian.Enabled := False;
    FHaupt.MIMinimum.Enabled := False;
    FHaupt.MIMaximum.Enabled := False;

    FHaupt.MIIntegrate.Checked := False;
    FHaupt.MIMedian.Checked := False;
    FHaupt.MIMinimum.Checked := False;
    FHaupt.MIMaximum.Checked := False;
  end
  else
  begin
    FHaupt.MIIntegrate.Enabled := True;
    FHaupt.MIMedian.Enabled := True;
    FHaupt.MIMinimum.Enabled := True;
    FHaupt.MIMaximum.Enabled := True;
  end;
  FHaupt.maxFrames := TBFpB.Position;
  if SEFpB.Value <> TBFpB.Position then
    SEFpB.Value := TBFpB.Position;
end;

procedure TFSettings.TBBpSChange(Sender: TObject);
begin
  FHaupt.maxBitmaps := TBBpS.Position;
  if TBBpS.Position <> SEBpS.Value then
  SEBpS.Value := TBBpS.Position;
end;

procedure TFSettings.FormShow(Sender: TObject);
begin
  FSettings.Top := FPreview.Height;
  FSettings.Left := FHaupt.ClientWidth-FPreview.ClientWidth-10;
end;

procedure TFSettings.SEFpBChange(Sender: TObject);
begin
  if SEFpB.Value=1 then
  begin
    FHaupt.MIIntegrate.Enabled := False;
    FHaupt.MIMedian.Enabled := False;
    FHaupt.MIMinimum.Enabled := False;
    FHaupt.MIMaximum.Enabled := False;

    FHaupt.MIIntegrate.Checked := False;
    FHaupt.MIMedian.Checked := False;
    FHaupt.MIMinimum.Checked := False;
    FHaupt.MIMaximum.Checked := False;
  end
  else
  begin
    FHaupt.MIIntegrate.Enabled := True;
    FHaupt.MIMedian.Enabled := True;
    FHaupt.MIMinimum.Enabled := True;
    FHaupt.MIMaximum.Enabled := True;
  end;
  FHaupt.maxFrames := Round(SEFpB.Value);
  if Round(SEFpB.Value) <> TBFpB.Position then
  TBFpB.Position := Round(SEFpB.Value);
end;

procedure TFSettings.SEBpSChange(Sender: TObject);
begin
  FHaupt.maxBitmaps := Round(SEBpS.Value);
  if TBBpS.Position <> Round(SEBpS.Value) then
  TBBpS.Position := Round(SEBpS.Value);
end;

procedure TFSettings.EFilenameChange(Sender: TObject);
begin
  FPreview.VideoCap1.SingleImageFile := EFileName.Text+'.BMP';
  if Length(ESeries.Text)>0 then
    FHaupt.Datei := DEBasis.Text+'\'+ESeries.Text+'\'+EFileName.Text+'.BMP'
  else
    FHaupt.Datei := DEBasis.Text+'\'+EFileName.Text+'.BMP';
  EFilename.Hint := FHaupt.Datei;
  FHaupt.FileNo := 0;
end;

procedure TFSettings.ChangeSize;
var width: integer;
begin
  case CBSize.ItemIndex of
    0: width := 768;
    1: width := 704;
    2: width := 640;
    3: width := 576;
    4: width := 512;
    5: width := 448;
    6: width := 384;
    7: width := 320;
    8: width := 256;
    9: width := 192;
    10: width := 128;
    11: width := 64;
  else
    width := 640;
  end;
  if FHaupt.w>0 then
    FHaupt.nw := min(width,FHaupt.w)
  else
    FHaupt.nw := width;
  if FHaupt.h>0 then
    FHaupt.nh := min((width*3) DIV 4,FHaupt.h)
  else
    FHaupt.nh := (width*3) DIV 4;
end;


procedure TFSettings.CBSizeChange(Sender: TObject);
begin
  ChangeSize;
end;

procedure TFSettings.SBBiasChange(Sender: TObject);
begin
  FHaupt.Bias := SBBias.Position;
end;

procedure TFSettings.SBGainChange(Sender: TObject);
begin
  FHaupt.Gain := SBGain.Position
end;

procedure TFSettings.CBSeeingClick(Sender: TObject);
begin
  FHaupt.MaxSobel := 0.0; FHaupt.MinSobel := 1000.0;
end;

procedure TFSettings.BAufnahmeClick(Sender: TObject);
begin
  FHaupt.MIMultiframeClick(Sender);
end;

end.
