unit OptionsForm;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, OptionsPageForm;

type
  TfrmOptions = class(TForm)
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    tvOptions: TTreeView;
    panCon: TScrollBox;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure tvOptionsDeletion(Sender: TObject; Node: TTreeNode);
    procedure tvOptionsChange(Sender: TObject; Node: TTreeNode);
  private
    curForm: TOptionsPage;
    procedure SelectForm(f: TOptionsPage);
  public
    { Public declarations }
  end;

var
  frmOptions: TfrmOptions;

implementation

{$R *.lfm}

uses ExtLabelsForm;

procedure TfrmOptions.FormShow(Sender: TObject);
var
  f1: TOptionsPage;
begin
  curForm := nil;

  f1 := TfrmExtLabels.Create(Application);
  f1.Parent := panCon;
  f1.Left := 0;
  f1.Top := 0;

  with tvOptions.Items.AddChild(nil, f1.LogicalPath) do
    Data := f1;
end;

procedure TfrmOptions.FormHide(Sender: TObject);
begin
  tvOptions.Items.Clear;
  curForm := nil;
end;

procedure TfrmOptions.SelectForm(f: TOptionsPage);
begin
  if Assigned(curForm) then
    curForm.Visible := False;
  curForm := f;
  if Assigned(curForm) then
  begin
    f.Visible := True;
    //lblShortDesc.Caption := f.Caption;
    //lblLongDesc.Caption := f.Hint;
  end;
end;

procedure TfrmOptions.tvOptionsDeletion(Sender: TObject; Node: TTreeNode);
begin
  if Node.Data <> nil then
    TOptionsPage(Node.Data).Free;
end;

procedure TfrmOptions.tvOptionsChange(Sender: TObject; Node: TTreeNode);
begin
  SelectForm(Node.Data);
end;

end.
