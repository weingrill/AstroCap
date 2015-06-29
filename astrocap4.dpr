program AstroCap4;

uses
  Forms,
  UMain in 'UMain.pas' {FMain},
  UOutput in 'UOutput.pas' {FOutput},
  UInfo in 'UInfo.pas' {FInfo},
  UControl in 'UControl.pas' {FControl},
  UDXSource in 'UDXSource.pas' {FDXSource};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'AstroCap4';
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFOutput, FOutput);
  Application.CreateForm(TFInfo, FInfo);
  Application.CreateForm(TFControl, FControl);
  Application.CreateForm(TFDXSource, FDXSource);
  Application.Run;
end.
