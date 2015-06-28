program AstroCap2;

uses
  Forms,
  UHaupt in 'UHaupt.pas' {FHaupt},
  UPreview in 'UPreview.pas' {FPreview},
  UFrame in 'UFrame.pas' {FFrame},
  USettings in 'USettings.pas' {FSettings},
  UInfo in 'UInfo.pas' {FInfo},
  UAbout in 'UAbout.pas' {FAbout},
  Videohdr in 'Videohdr.pas',
  UTimer in 'UTimer.pas' {FTimer};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'AstroCap2';
  Application.HelpFile := 'ASTROCAP.HLP';
  Application.CreateForm(TFHaupt, FHaupt);
  Application.CreateForm(TFPreview, FPreview);
  Application.CreateForm(TFFrame, FFrame);
  Application.CreateForm(TFSettings, FSettings);
  Application.CreateForm(TFInfo, FInfo);
  Application.CreateForm(TFAbout, FAbout);
  Application.CreateForm(TFTimer, FTimer);
  Application.Run;
end.
