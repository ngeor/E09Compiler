unit MsgViewer;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,
  Buttons, ExtCtrls, ComCtrls, ImgList;

type
  TfrmMsgView = class(TForm)
    lvMessages: TListView;
    imgMessages: TImageList;
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMsgView: TfrmMsgView;

implementation

uses MainForm;

{$R *.lfm}

procedure TfrmMsgView.FormHide(Sender: TObject);
begin
  Form1.MsgViewHide;
end;

end.
