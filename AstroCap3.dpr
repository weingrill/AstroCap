program AstroCap3;

uses
  Forms,
  UMain in 'UMain.pas' {FMain},
  USource in 'USource.pas' {FSource},
  UOutput in 'UOutput.pas' {FOutput},
  UInfo in 'UInfo.pas' {FInfo},
  UControl in 'UControl.pas' {FControl},
  UTimer in 'UTimer.pas' {FTimer};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'AstroCap3';
  Application.HelpFile := 'ASTROCAP.HLP';
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFSource, FSource);
  Application.CreateForm(TFOutput, FOutput);
  Application.CreateForm(TFInfo, FInfo);
  Application.CreateForm(TFControl, FControl);
  Application.CreateForm(TFTimer, FTimer);
  Application.Run;
end.
