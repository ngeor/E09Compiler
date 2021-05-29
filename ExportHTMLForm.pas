unit ExportHTMLForm;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,
  {OleCtrls, SHDocVw,} ExtCtrls, StdCtrls, Buttons, Grids;

type
  TfrmExportHTMLWizard = class(TForm)
    btnOK: TBitBtn;
    BitBtn2: TBitBtn;
    Panel1: TPanel;
    Label1: TLabel;
    cmbFontFace: TComboBox;
    Label2: TLabel;
    txtFontSize: TEdit;
    txtBorder: TEdit;
    Label3: TLabel;
    Timer1: TTimer;
    procedure btnOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmbFontFaceChange(Sender: TObject);
    procedure txtFontSizeChange(Sender: TObject);
    procedure txtBorderChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FHTMLFile: string;
    FGrid: TStringGrid;
    procedure DoExportHTML(const FileName: string);
    procedure DoExportTemp;
  public
    property HTMLFile: string read FHTMLFile write FHTMLFile;
    property Grid: TStringGrid read FGrid write FGrid;
  end;

var
  frmExportHTMLWizard: TfrmExportHTMLWizard;

implementation

{$R *.lfm}

procedure TfrmExportHTMLWizard.DoExportHTML(const FileName: string);
var
  f: TextFile;
  i, j: integer;
begin
  AssignFile(f, FileName);
  Rewrite(f);
  WriteLn(f, '<html><head>');
  WriteLn(f, '<meta HTTP-EQUIV="Content-Type" Content="text/html; charset=iso-8859-7">');
  WriteLn(f, '</head>');
  WriteLn(f, '<body><p><table border="' + txtBorder.Text +
    '" cellspacing="0" cellpadding="2" bordercolor="#000000">');
  for i := 0 to grid.RowCount - 1 do
  begin
    WriteLn(f, #9'<tr>');
    for j := 0 to grid.ColCount - 1 do
      if grid.Cells[j, i] = '' then
        WriteLn(f, #9#9'<td bordercolor="#000000">&nbsp;</td>')
      else
        WriteLn(f, #9#9'<td bordercolor="#000000"><font face="' +
          cmbFontFace.Text + '" size="' + txtFontSize.Text + '">' + grid.Cells[j, i] +
          '</font></td>');
    WriteLn(f, #9'</tr>');
  end;
  WriteLn(f, '</table></p></body></html>');
  CloseFile(f);
end;

procedure TfrmExportHTMLWizard.btnOKClick(Sender: TObject);
begin
  DoExportHTML(FHTMLFile);
end;

procedure TfrmExportHTMLWizard.DoExportTemp;
begin
  DoExportHtml('C:\E09_preview.html');
  //WebBrowser1.Navigate('C:\E09_preview.html');
end;

procedure TfrmExportHTMLWizard.FormDestroy(Sender: TObject);
begin
  DeleteFile('C:\E09_preview.html');
end;

procedure TfrmExportHTMLWizard.FormCreate(Sender: TObject);
begin
  cmbFontFace.Items.Assign(Screen.Fonts);

end;

procedure TfrmExportHTMLWizard.cmbFontFaceChange(Sender: TObject);
begin
  Timer1.Enabled := False;
  Timer1.Enabled := True;
end;

procedure TfrmExportHTMLWizard.txtFontSizeChange(Sender: TObject);
begin
  Timer1.Enabled := False;
  Timer1.Enabled := True;
end;

procedure TfrmExportHTMLWizard.txtBorderChange(Sender: TObject);
begin
  Timer1.Enabled := False;
  Timer1.Enabled := True;
end;

procedure TfrmExportHTMLWizard.Timer1Timer(Sender: TObject);
begin
  DoExportTemp;
  Timer1.Enabled := False;
end;

procedure TfrmExportHTMLWizard.FormShow(Sender: TObject);
begin
  Timer1.Enabled := False;
  Timer1.Enabled := True;
end;

end.
