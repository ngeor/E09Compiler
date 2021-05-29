unit ExtLabelsForm;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, OptionsPageForm;

type
  TfrmExtLabels = class(TOptionsPage)
    grid: TStringGrid;
    cmdAdd: TBitBtn;
    cmdDelete: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmExtLabels: TfrmExtLabels;

implementation

{$R *.lfm}


end.
