unit UTimer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RXSpin, Mask, ExtCtrls, Placemnt;

type
  TFTimer = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    CBTimer: TCheckBox;
    FPTimer: TFormPlacement;
    Timer: TTimer;
    MEStart: TMaskEdit;
    MEStop: TMaskEdit;
    SEFreq: TRxSpinEdit;
    procedure CBTimerClick(Sender: TObject);
    procedure SEFreqChange(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure MEStartStopChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    start,stop: TDateTime;
    dostop: Boolean;
  public
    { Public-Deklarationen }
  end;

var
  FTimer: TFTimer;

implementation

uses UMain;

{$R *.DFM}

procedure TFTimer.CBTimerClick(Sender: TObject);
begin
  start := StrToTime('00:00:00');
  stop  := StrToTime('23:59:59');
  dostop := true;
  try
    start := StrToTime(MEStart.Text);
    stop := StrToTime(MEStop.Text);
  except on EconvertError do
    dostop := false;
  end;
  if start=stop then dostop := false;
  Timer.Enabled := CBTimer.Checked;
end;

procedure TFTimer.SEFreqChange(Sender: TObject);
begin
  Timer.Interval := SEFreq.AsInteger*1000;
end;

procedure TFTimer.TimerTimer(Sender: TObject);
begin
  if dostop and (now>stop) then
  begin
    Timer.Enabled := False;
    CBTimer.Checked := False;
  end;
  if (dostop and (now>=start) and (now<=stop)) or
     (not dostop) then
    FMain.SBRecordClick(Sender);
end;

procedure TFTimer.MEStartStopChange(Sender: TObject);
begin
  try
    start := StrToTime(MEStart.Text);
    stop := StrToTime(MEStop.Text);
  except on EconvertError do
    dostop := false;
  end;
end;

procedure TFTimer.FormCreate(Sender: TObject);
begin
  dostop := true;
  Timer.Enabled := False;
end;

end.
