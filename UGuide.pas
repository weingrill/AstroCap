unit UGuide;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Placemnt;

type
  TFGuiding = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    CBinvert: TCheckBox;
    TBlevel: TTrackBar;
    FormPlacement1: TFormPlacement;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FGuiding: TFGuiding;

implementation

{$R *.DFM}

end.
