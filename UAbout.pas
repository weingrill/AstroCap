unit UAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RxVerInf;

type
  TFAbout = class(TForm)
    BOk: TButton;
    Label1: TLabel;
    Label2: TLabel;
    LVersion: TLabel;
    procedure FormShow(Sender: TObject);
    procedure BOkClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FAbout: TFAbout;

implementation

{$R *.DFM}

procedure TFAbout.FormShow(Sender: TObject);
//var AppVerInfo: TVersionInfo;
begin
 With AppVerInfo do
  try
   LVersion.caption := 'Version: '+FileVersion;
   if not (LegalCopyright[2]='ö') then
     MessageDlg('Copyright Violation',mtError,[mbOK],0);
  finally
   free;
  end;
end;

procedure TFAbout.BOkClick(Sender: TObject);
begin
  Close;
end;

end.
