unit UFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, VideoDisp, Menus;

type
  TFFrame = class(TForm)
    Image1: TImage;
    PMFrame: TPopupMenu;
    MIAutosize: TMenuItem;
    MICenter: TMenuItem;
    MIStretch: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MIAutosizeClick(Sender: TObject);
    procedure MICenterClick(Sender: TObject);
    procedure MIStretchClick(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
  public
    { Public-Deklarationen }
    EraseBkgnd: Boolean;
  end;

var
  FFrame: TFFrame;

implementation

{$R *.DFM}

procedure TFFrame.FormShow(Sender: TObject);
begin
  FFrame.Top := 0;
  FFrame.Left := 0;
end;

procedure TFFrame.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin // avoid clearing the background (causes flickering and speed penalty)
{  if not EraseBkgnd then
    Message.Result:=0
  else }inherited;
end;

procedure TFFrame.FormCreate(Sender: TObject);
begin
  EraseBkgnd := True;
end;

procedure TFFrame.MIAutosizeClick(Sender: TObject);
begin
  MIAutosize.Checked := not MIAutosize.Checked;
  Image1.AutoSize := MIAutosize.Checked;
end;

procedure TFFrame.MICenterClick(Sender: TObject);
begin
  MICenter.Checked := not MICenter.Checked;
  Image1.Center := MICenter.Checked;
end;

procedure TFFrame.MIStretchClick(Sender: TObject);
begin
  MIStretch.Checked := not MIStretch.Checked;
  Image1.Stretch := MIStretch.Checked;
end;

end.
