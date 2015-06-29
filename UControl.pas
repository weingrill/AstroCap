unit UControl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RXSpin, Placemnt, Menus, VCLUtils, ExtCtrls, ComCtrls, Buttons, Math;

type
  TFControl = class(TForm)
    BCalibrate: TButton;
    Label1: TLabel;
    Label2: TLabel;
    SERect: TRxSpinEdit;
    SEDecl: TRxSpinEdit;
    FPControl: TFormPlacement;
    MainMenu1: TMainMenu;
    Telescope1: TMenuItem;
    MIConnect: TMenuItem;
    MIDisconnect: TMenuItem;
    Timer1: TTimer;
    TBInterval: TTrackBar;
    CBGuide: TCheckBox;
    SBUp: TSpeedButton;
    SBDown: TSpeedButton;
    SBLeft: TSpeedButton;
    SBRight: TSpeedButton;
    SBStop: TSpeedButton;
    SEMin: TRxSpinEdit;
    SEMax: TRxSpinEdit;
    MIPort: TMenuItem;
    MICOM1: TMenuItem;
    MICOM2: TMenuItem;
    MIType: TMenuItem;
    MIMTS: TMenuItem;
    MILX200: TMenuItem;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure MIConnectClick(Sender: TObject);
    procedure MIDisconnectClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BCalibrateClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TBIntervalChange(Sender: TObject);
    procedure CBGuideClick(Sender: TObject);
    procedure SBUpClick(Sender: TObject);
    procedure SBDownClick(Sender: TObject);
    procedure SBLeftClick(Sender: TObject);
    procedure SBRightClick(Sender: TObject);
    procedure SBStopClick(Sender: TObject);
    procedure SEMinMaxChange(Sender: TObject);
    procedure MICOM1Click(Sender: TObject);
    procedure MICOM2Click(Sender: TObject);
    procedure MIMTSClick(Sender: TObject);
    procedure MILX200Click(Sender: TObject);
  private
    { Private-Deklarationen }
    xpix,ypix: array [0..4] of double;
    x0,y0: double;
    mode: string;
    ComPortHandle: THANDLE;
    ComPortInBufSize, ComPortOutBufSize: word;
    procedure Sendbyte(b:byte);
    procedure sendstring(s: string);
    function receiveLong: longword;
    function receivebyte: byte;
    procedure waitready;
    function readRA: longword;
    function readDE: longword;
    function readTime: longword;
    procedure upon;
    procedure upoff;
    procedure downon;
    procedure downoff;
    procedure lefton;
    procedure leftoff;
    procedure righton;
    procedure rightoff;

  public
    { Public-Deklarationen }
    buffer: array[0..64] of byte;

    procedure Guide;
  end;

var
  FControl: TFControl;

implementation

uses UMain;

{$R *.DFM}

procedure TFControl.sendbyte(b:byte);
var BytesToSend,BytesSent: Cardinal;
    pbuffer: ^byte;
begin
  pbuffer := pointer(b);
  BytesToSend := 1;
  if ComPortHandle=0 then Exit;
  if not WriteFile( ComPortHandle, pbuffer, BytesToSend, BytesSent, nil) then
    MessageBeep($FFFFFFFF);
  if BytesSent<BytesToSend then MessageBeep($FFFFFFFF);
  FlushFilebuffers(ComportHandle);
end;

procedure TFControl.sendstring(s: string);
var BytesToSend,BytesSent: Cardinal;
    ba: array of byte;
    pbuffer: ^byte;
    n: integer;
begin
  BytesToSend := length(s);
  SetLength(ba,BytesToSend);
  for n:=1 to BytesToSend do ba[n-1] := ord(s[n]);
  pbuffer := pointer(ba);
  if ComPortHandle=0 then Exit;
  if not WriteFile( ComPortHandle, pbuffer, BytesToSend, BytesSent, nil) then
    MessageBeep($FFFFFFFF);
  if BytesSent<BytesToSend then MessageBeep($FFFFFFFF);
  FlushFilebuffers(ComportHandle);
end;

function TFControl.receivebyte: byte;
var BytesToRead,BytesRead: Cardinal;
    pbuffer: pointer;
    l: longword;
    n: word;
begin
  l := 0;
  FillChar(buffer,sizeof(buffer),0);
  pbuffer := @buffer;
  BytesToRead := 1;
  BytesRead := 0;
  Result := 0;
  n := 0;
  if ComPortHandle=0 then Exit;
  repeat
    if not ReadFile( ComPortHandle, pbuffer, BytesToRead, BytesRead, nil) then
      MessageBeep($FFFFFFFF);
    while n<bytesread do
    begin
      l := (l*256) + buffer[n];
      inc(n);
    end;
  until BytesRead=0;
  Result := l;
end;

function TFControl.receiveLong: longword;
var BytesToRead,BytesRead: Cardinal;
    pbuffer: pointer;
    l: longword;
    n:word;
begin
  l := 0;
  FillChar(buffer,sizeof(buffer),0);
  pbuffer := @buffer;
  BytesToRead := 64;
  BytesRead := 0;
  Result := 0;
  n := 0;
  if ComPortHandle=0 then Exit;
  repeat
    if not ReadFile( ComPortHandle, pbuffer, BytesToRead, BytesRead, nil) then
      MessageBeep($FFFFFFFF);
    while n<bytesread do
    begin
      l := (l*256) + buffer[n];
      inc(n);
    end;
  until BytesRead=0;
  Result := l;
end;

procedure TFControl.waitready;
begin
  repeat
    sendbyte($A2);
  until receivebyte = 0;
end;

procedure TFControl.upon; //Mn#    :Ms#    :Me#    :Mw#
begin
  if MIMTS.Checked then
    sendbyte($A4)
  else
    sendstring('#:Mn#');
end;

procedure TFControl.upoff; //Qn#    :Qs#    :Qe#    :Qw#
begin
  if MIMTS.Checked then
    sendbyte($A5)
  else
    sendstring('#:Qn#');
end;

procedure TFControl.downon;
begin
  if MIMTS.Checked then
    sendbyte($A6)
  else
    sendstring('#:Ms#');
end;

procedure TFControl.downoff;
begin
  if MIMTS.Checked then
    sendbyte($A7)
  else
    sendstring('#:Qs#');
end;

procedure TFControl.lefton;
begin
  if MIMTS.Checked then
    sendbyte($A8)
  else
    sendstring('#:Mw#');
end;

procedure TFControl.leftoff;
begin
  if MIMTS.Checked then
    sendbyte($A9)
  else
    sendstring('#:Qw#');
end;

procedure TFControl.righton;
begin
  if MIMTS.Checked then
    sendbyte($AA)
  else
    sendstring('#:Me#');
end;

procedure TFControl.rightoff;
begin
  if MIMTS.Checked then
    sendbyte($AB)
  else
    sendstring('#:Qe#');
end;

function TFControl.readRA: longword;
begin
  sendbyte($B7);
  Result := receiveLong;
end;

function TFControl.readDE: longword;
begin
  sendbyte($B8);
  Result := receiveLong;
end;

function TFControl.readtime: longword;
begin
  sendbyte($B5);
  Result := receiveLong;
end;

procedure TFControl.FormCreate(Sender: TObject);
begin
  MIConnectClick(Sender);
  mode := '';
  with FMain.IniFIle do
  begin
    SERect.Value := StrToFloat(ReadString('Guide','TimeRA','0'));
    SEDecl.Value := StrToFloat(ReadString('Guide','TimeDe','0'));
  end;
end;

procedure TFControl.MIConnectClick(Sender: TObject);
var dcb: TDCB;
    tms: TCOMMTIMEOUTS;
begin
  ComPortInBufSize := 64;
  ComPortOutBufSize := 64;
  if MICOM1.Checked then
  ComPortHandle := CreateFile( PChar('COM1'+#0),
                               GENERIC_READ or GENERIC_WRITE,
                               0,
                               nil,
                               OPEN_EXISTING,
                               FILE_ATTRIBUTE_NORMAL,
                               0)
  else
  ComPortHandle := CreateFile( PChar('COM2'+#0),
                               GENERIC_READ or GENERIC_WRITE,
                               0,
                               nil,
                               OPEN_EXISTING,
                               FILE_ATTRIBUTE_NORMAL,
                               0);

  fillchar( dcb, sizeof(dcb), 0 );
  dcb.DCBLength := sizeof(dcb);
  dcb.BaudRate := CBR_9600;
  dcb.flags := $00000011; // binary mode and DTR on
  dcb.ByteSize := 8;
  dcb.Parity := NOPARITY;
  dcb.StopBits := ONESTOPBIT;
  dcb.XONChar := #17; // XON ASCII char
  dcb.XOFFChar := #19; // XOFF ASCII char
  SetCommState( ComPortHandle, dcb );
  SetupComm( ComPortHandle, ComPortInBufSize, ComPortOutBufSize );

  tms.ReadIntervalTimeout := 1;
  tms.ReadTotalTimeoutMultiplier := 0;
  tms.ReadTotalTimeoutConstant := 1;
  tms.WriteTotalTimeoutMultiplier := 0;
  tms.WriteTotalTimeoutConstant := 0;
  SetCommTimeOuts( ComPortHandle, tms );

  sendbyte($AE); //on
end;

procedure TFControl.MIDisconnectClick(Sender: TObject);
begin
  if ComPortHandle>0 then
    CloseHandle( ComPortHandle );
  ComPortHandle := 0;
end;

procedure TFControl.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  downoff;
  upoff;
  leftoff;
  rightoff;
  if ComPortHandle>0 then
    CloseHandle( ComPortHandle );
end;

procedure TFControl.BCalibrateClick(Sender: TObject);
begin
  CBGuide.Checked := False;
  if mode = '' then
  begin
    BCalibrate.Enabled := False;
    mode := 'CalDE';
    xpix[0] := FMain.center_x+FMain.x1;
    ypix[0] := FMain.center_y+FMain.y1;
    upon;
    Timer1.Interval := TBInterval.Position;
    Timer1.Enabled := True;
  end;
end;

procedure TFControl.Timer1Timer(Sender: TObject);
begin
  if mode = 'CalRABack' then
  begin
    leftoff;
    Timer1.Enabled := False;
    xpix[4] := FMain.center_x+FMain.x1;
    ypix[4] := FMain.center_y+FMain.y1;
    BCalibrate.Enabled := True;
    mode := '';
    Exit;
  end;
  if mode = 'CalDEBack' then
  begin
    downoff;
    Timer1.Enabled := False;
    xpix[2] := FMain.center_x+FMain.x1;
    ypix[2] := FMain.center_y+FMain.y1;
    righton;
    mode := 'CalRA';
    Timer1.Enabled := True;
    Exit;
  end;
  if mode = 'CalRA' then
  begin
    rightoff;
    Timer1.Enabled := False;
    xpix[3] := FMain.center_x+FMain.x1;
    ypix[3] := FMain.center_y+FMain.y1;
    SERect.Value := Timer1.Interval/(xpix[3]-xpix[2]);
    lefton;
    mode := 'CalRABack';
    Timer1.Enabled := True;
    Exit;
  end;
  if mode = 'CalDE' then
  begin
    upoff;
    Timer1.Enabled := False;
    xpix[1] := FMain.center_x+FMain.x1;
    ypix[1] := FMain.center_y+FMain.y1;
    SEDecl.Value := Timer1.Interval/(ypix[1]-ypix[0]);
    downon;
    mode := 'CalDEBack';
    Timer1.Enabled := True;
    Exit;
  end;
  if mode = 'GuideDE' then
  begin
    Timer1.Enabled := False;
    upoff;
    downoff;
    mode := '';
  end;
  if mode = 'GuideRA' then
  begin
    Timer1.Enabled := False;
    leftoff;
    rightoff;
    mode := '';
  end;
end;

procedure TFControl.TBIntervalChange(Sender: TObject);
begin
  TBInterval.Hint := IntToStr(TBInterval.Position)+' ms';
end;

function sgn(x: extended): integer;
begin
  if x<0 then result :=-1 else result := 1;
end;

procedure TFControl.Guide;
var delta_x,delta_y: double;
    corrtime: integer;
begin
  if not CBGuide.Checked then exit;
  if not (mode = '') then exit;
  delta_x := FMain.center_x+FMain.x1-x0;
  delta_y := FMain.center_y+FMain.y1-y0;
  if sqr(delta_x)+sqr(delta_y)>sqr(SEMax.Value) then Exit;
  if sqr(delta_x)+sqr(delta_y)<sqr(SEMin.Value) then Exit;
  if abs(delta_x)>abs(delta_y) then // guide in ra
  begin
    corrtime := Round(abs(delta_x*SERect.Value));
    if corrtime < 20 then exit;
    mode := 'GuideRA';
    Timer1.Interval := corrtime;
    if sgn(SERect.Value)*delta_x > 0 then lefton else righton;
    Timer1.Enabled := true;
  end
  else
  begin
    corrtime := Round(abs(delta_y*SEDecl.Value));
    if corrtime < 20 then exit;
    mode := 'GuideDE';
    Timer1.Interval := corrtime;
    if sgn(SEDecl.Value)*delta_y < 0 then upon else downon;
    Timer1.Enabled := true;
  end;
end;

procedure TFControl.CBGuideClick(Sender: TObject);
begin
  x0 := FMain.center_x+FMain.x1;
  y0 := FMain.center_y+FMain.y1;
  if not CBGuide.checked then
  begin
    downoff;
    upoff;
    leftoff;
    rightoff;
  end;
end;

procedure TFControl.SBUpClick(Sender: TObject);
begin
  upon;
end;

procedure TFControl.SBDownClick(Sender: TObject);
begin
  downon;
end;

procedure TFControl.SBLeftClick(Sender: TObject);
begin
  lefton;
end;

procedure TFControl.SBRightClick(Sender: TObject);
begin
  //SBRight.Down := not SBRight.Down;
  righton;
end;

procedure TFControl.SBStopClick(Sender: TObject);
begin
    downoff;
    upoff;
    leftoff;
    rightoff;
end;

procedure TFControl.SEMinMaxChange(Sender: TObject);
begin
  SEMin.MinValue := 0.02*max(abs(SEDecl.Value),abs(SERect.Value));
  SEMax.MaxValue := min(FMain.x2-FMain.x1,FMain.y2-FMain.y1)/2;
  SEMax.MinValue := SEMin.Value;
  SEMin.MaxValue := SEMax.Value;
end;

procedure TFControl.MICOM1Click(Sender: TObject);
begin
  CBGuide.Checked := False;
  MICOM1.Checked := true;
end;

procedure TFControl.MICOM2Click(Sender: TObject);
begin
  CBGuide.Checked := False;
  MICOM2.Checked := true;
end;

procedure TFControl.MIMTSClick(Sender: TObject);
begin
  CBGuide.Checked := False;
  MIMTS.Checked := true;
end;

procedure TFControl.MILX200Click(Sender: TObject);
begin
  CBGuide.Checked := False;
  MILX200.Checked := true;
end;

end.
