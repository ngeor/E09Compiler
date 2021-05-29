program E09Compiler;

{$MODE Delphi}

uses
  Forms,
  Interfaces,
  MainForm in 'MainForm.pas' {Form1},
  Engine in 'Engine.pas',
  AboutForm in 'AboutForm.pas' {frmAbout},
  ExtLabelsForm in 'ExtLabelsForm.pas' {frmExtLabels},
  ExportHTMLForm in 'ExportHTMLForm.pas' {frmExportHTMLWizard},
  MsgViewer in 'MsgViewer.pas' {frmMsgView},
  OptionsForm in 'OptionsForm.pas' {frmOptions},
  OptionsPageForm in 'OptionsPageForm.pas' {OptionsPage},
  Intf in 'Intf.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'E09 Compiler';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmExportHTMLWizard, frmExportHTMLWizard);
  Application.CreateForm(TfrmMsgView, frmMsgView);
  Application.CreateForm(TfrmOptions, frmOptions);
  Application.Run;
end.
