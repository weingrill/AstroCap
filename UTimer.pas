unit UTimer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, RXSpin;

type
  TFTimer = class(TForm)
    Label1: TLabel;
    SEIntervall: TRxSpinEdit;
    Timer1: TTimer;
    BStart: TButton;
    procedure BStartClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FTimer: TFTimer;

implementation

uses UHaupt;

{$R *.DFM}

procedure TFTimer.BStartClick(Sender: TObject);
begin
  if Timer1.Enabled then
  begin
    BStart.Caption := 'Start';
    Timer1.Enabled := False;
  end
  else
  begin
    Timer1.Interval := SEIntervall.AsInteger*1000;
    BStart.Caption := 'Stop';
    Timer1.Enabled := True;
  end;
end;

procedure TFTimer.Timer1Timer(Sender: TObject);
begin
  FHaupt.MISingleframeClick(Sender);
  MessageBeep($FFFFFFFF);
end;

end.
