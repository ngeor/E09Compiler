unit MainForm;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,
  ToolWin, ComCtrls, StdCtrls, ActnList, ImgList, Menus, Grids, contnrs,
  ExtCtrls, {AppEvnts,} Buttons;

{ Revision History
-=-=-=-=-==-=-=-=-==---=-
1.0.5
Enabled High DPI
-=-=-=-=-==-=-=-=-==---=-
1.0.4
XHTL fixed
Refresh goes smoother
-=-=-=-=-==-=-=-=-==---=-
1.0.3
--------
RRC command supported (RLC was in 07 and 0F)
Smart Tab introduced
}

type

  { TForm1 }

  TForm1 = class(TForm)
    lstCommands: TListBox;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    imgMain: TImageList;
    ActionList1: TActionList;
    actFileNew: TAction;
    actFileOpen: TAction;
    actFileSave: TAction;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    OpenDialog1: TOpenDialog;
    ToolButton4: TToolButton;
    actFileExport: TAction;
    ToolButton5: TToolButton;
    N5: TMenuItem;
    N6: TMenuItem;
    actFileExit: TAction;
    SaveDialog1: TSaveDialog;
    N7: TMenuItem;
    N8: TMenuItem;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    actHelpAbout: TAction;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    actEditSync: TAction;
    StatusBar1: TStatusBar;
    SaveDialog2: TSaveDialog;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    actEditUndo: TAction;
    actEditRedo: TAction;
    actEditCut: TAction;
    actEditCopy: TAction;
    actEditPaste: TAction;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    actViewMessages: TAction;
    N19: TMenuItem;
    panMain: TPanel;
    panAssembly: TPanel;
    panAssembly2: TPanel;
    Label1: TLabel;
    Splitter1: TSplitter;
    panBinary: TPanel;
    grid: TStringGrid;
    panBinary2: TPanel;
    Label2: TLabel;
    Splitter2: TSplitter;
    panDock: TPanel;
    actEditOptions: TAction;
    N20: TMenuItem;
    N21: TMenuItem;
    txtAssembly: TMemo;
    actEditFind: TAction;
    N22: TMenuItem;
    N23: TMenuItem;
    FindDialog1: TFindDialog;
    ReplaceDialog1: TReplaceDialog;
    actEditReplace: TAction;
    N24: TMenuItem;
    procedure actFileOpenExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actFileExportExecute(Sender: TObject);
    procedure actFileExitExecute(Sender: TObject);
    procedure actHelpAboutExecute(Sender: TObject);
    procedure actEditSyncExecute(Sender: TObject);
    procedure actFileNewExecute(Sender: TObject);
    procedure actFileSaveExecute(Sender: TObject);
    procedure ApplicationEvents1Hint(Sender: TObject);
    procedure txtAssemblyChange(Sender: TObject);
    procedure actViewMessagesExecute(Sender: TObject);
    procedure actViewMessagesUpdate(Sender: TObject);
    procedure panDockDockOver(Sender: TObject; Source: TDragDockObject;
      X, Y: integer; State: TDragState; var Accept: boolean);
    procedure panDockDockDrop(Sender: TObject; Source: TDragDockObject;
      X, Y: integer);
    procedure panDockUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: boolean);
    procedure FormShow(Sender: TObject);
    procedure actEditOptionsExecute(Sender: TObject);
    procedure txtAssemblyKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure txtAssemblyKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure actEditUndoExecute(Sender: TObject);
    procedure txtAssemblyMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure actEditFindExecute(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure actEditReplaceExecute(Sender: TObject);
    procedure ReplaceDialog1Replace(Sender: TObject);
  private
    procedure DoOpenFile(const FileName: string);
    procedure DoExportCSV(const FileName: string);
    procedure DoExportTXT(const FileName: string);
    procedure ParseSource;
    procedure PrepareCommands;
    procedure ShowCaretPos;
  public
    procedure MsgViewHide;
  end;

var
  Form1: TForm1;

implementation

uses Engine, AboutForm, ExportHTMLForm, ExtLabelsForm, MsgViewer,
  OptionsForm;

{$R *.lfm}

var
  cmdList: TObjectList;
  cmdHash: TStringList;
  KeywordsHash: TStringList;
  LabelsHash: TStringList;
  ExtLabelsHash: TStringList;

procedure TForm1.DoOpenFile(const FileName: string);
begin
  txtAssembly.Lines.LoadFromFile(FileName);
  ParseSource;
end;

procedure TForm1.ParseSource;
var
  i, j, k: integer;
  s, sComment: string;
  addr: integer;
  c: T8085Command;
  nIndex: integer;
  sLabel, sParam: string;
  addrLabel: integer;
  dblParam: integer;

  procedure SplitComment(s: string; var sCommand, sComment: string);
  var
    i: integer;
  begin
    i := Pos(';', s);
    if i > 0 then
    begin
      sComment := Copy(s, i + 1, Length(s) - i);
      sCommand := Copy(s, 1, i - 1);
    end
    else
    begin
      sComment := '';
      sCommand := s;
    end;
  end;

  procedure SplitLabel(s: string; var sCommand, sLabel: string);
  var
    i: integer;
  begin
    i := Pos(':', s);
    if i > 0 then
    begin
      sCommand := Trim(Copy(s, i + 1, Length(s) - i));
      sLabel := Trim(Copy(s, 1, i - 1));
    end
    else
    begin
      sLabel := '';
      sCommand := s;
    end;
  end;


  procedure NextAddr;
  begin
    grid.Cells[0, j] := IntToHex(addr, 4);
    Inc(addr);
    Inc(j);
    if (j >= grid.RowCount) then
      grid.RowCount := grid.RowCount + 1;
    grid.Objects[1, j] := nil;
    grid.Rows[j].Clear;
  end;

  function FindCommand(const s: string; var sParam: string): T8085Command;
  var
    i: integer;
    s1, s3: string;
    nKWIndex, nIndex: integer;
  begin
    Result := nil;
    s1 := s;
    sParam := '';
    SplitList(s1, s1, s3);
    s3 := s;
    if KeywordsHash.Find(s1, nKWIndex) then
    begin
      repeat
        if cmdHash.Find(s3, nIndex) then (* MOV A,B *)
          Result := cmdHash.Objects[nIndex] as T8085Command
        else
        begin
          i := LastDelimiter(' ,', s3);
          if i > 0 then
          begin  (* MVI A,param --> MVI A *)
            sParam := Copy(s3, i + 1, Length(s3) - i);
            s3 := Copy(s3, 1, i - 1);
          end
          else
            s3 := '';
        end;
      until (Result <> nil) or (s3 = '');
    end;
  end;

  procedure ShowMsg(const msg: string; Img: integer);
  begin
    with frmMsgView.lvMessages.Items.Add do
    begin
      Caption := msg;
      ImageIndex := Img;
    end;
  end;

  procedure ShowError(const msg: string; LineNumber: integer);
  begin
    ShowMsg('[Σφάλμα] ' + '(' + IntToStr(LineNumber) + '): ' + msg, 0);
  end;

  procedure ShowWarning(const msg: string; LineNumber: integer);
  begin
    ShowMsg('[Προειδοποίηση] ' + '(' + IntToStr(LineNumber) + '): ' + msg, 1);
  end;

begin
  frmMsgView.lvMessages.Items.Clear;
  //grid.RowCount := 2;
  //grid.Rows[1].Clear;
  i := 0; // assembly line
  j := 1; // grid row
  addr := $0800;
  LabelsHash.Clear;
  sLabel := '';

  while i < txtAssembly.Lines.Count do
  begin
    s := txtAssembly.Lines[i];
    s := SingleSpaces(Trim(s));
    SplitLabel(s, s, sLabel);
    SplitComment(s, s, sComment);

    if (Length(sLabel) > 0) and (Length(s) = 0) then (* LABEL: *)
      s := 'NOP';

    if Length(s) > 0 then
    begin
      c := FindCommand(s, sParam);
      if c <> nil then
      begin
        grid.Cells[1, j] := IntToHex(c.Code, 2);
        grid.Cells[2, j] := sLabel;
        if sLabel <> '' then
          LabelsHash.AddObject(sLabel, TObject(addr));
        grid.Cells[3, j] := c.Format(sParam);
        grid.Cells[4, j] := sComment;
        NextAddr;

        if c.Address then
        begin
          if sParam = '' then
            ShowError('Η εντολή ' + c.Name + ' απαιτεί διεύθυνση για όρισμα', i + 1)
          else if IsHexNumber(sParam, $FFFF, addrLabel) then
          begin
            grid.Cells[1, j] := IntToHex(Lo(addrLabel), 2);
            NextAddr;
            grid.Cells[1, j] := IntToHex(Hi(addrLabel), 2);
            NextAddr;
          end
          else
          begin
            grid.Cells[1, j] := sParam;
            grid.Objects[1, j] := c;
            NextAddr;
            grid.Cells[1, j] := sParam;
            NextAddr;
          end;
        end
        else if c.Bytes = 2 then (* one parameter *)
        begin
          grid.Cells[1, j] := sParam;
          NextAddr;
        end
        else if c.Bytes = 3 then (* two bytes of parameters, reverse order *)
        begin
          sParam := Trim(sParam);
          if sParam = '' then
            ShowError('Η εντολή ' + c.Name + ' απαιτεί αριθμό δύο bytes για όρισμα', i + 1)
          else if IsHexNumber(sParam, $FFFF, dblParam) then
          begin
            grid.Cells[1, j] := IntToHex(Lo(dblParam), 2);
            NextAddr;
            grid.Cells[1, j] := IntToHex(Hi(dblParam), 2);
            NextAddr;
          end
          else
            ShowError('Η εντολή ' + c.Name +
              ' απαιτεί αριθμό δύο bytes για όρισμα', i + 1);
        end;
      end
      else
        ShowError('Άγνωστη εντολή: ' + txtAssembly.Lines[i], i + 1);
    end;
    Inc(i);
  end;

  grid.RowCount := j + 1;

  (* parse labels *)
  for k := 1 to grid.RowCount - 1 do
    if grid.Objects[1, k] <> nil then
    begin
      if LabelsHash.Find(grid.Cells[1, k], nIndex) then
        addrLabel := integer(LabelsHash.Objects[nIndex])
      else if ExtLabelsHash.Find(grid.Cells[1, k], nIndex) then
        addrLabel := integer(ExtLabelsHash.Objects[nIndex])
      else
        nIndex := -1;
      if nIndex <> -1 then
      begin
        grid.Cells[1, k] := IntToHex(Lo(addrLabel), 2);
        grid.Cells[1, k + 1] := IntToHex(Hi(addrLabel), 2);
        grid.Objects[1, k] := nil;
      end
      else
        ShowWarning('Η ετικέτα ' + grid.Cells[1, k] + ' δεν έχει οριστεί', 0);
    end;

end;

procedure TForm1.actFileOpenExecute(Sender: TObject);
begin
  with OpenDialog1 do
    if Execute then
      DoOpenFile(FileName);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  grid.Cells[0, 0] := 'Διεύθυνση';
  grid.Cells[1, 0] := 'Περιεχόμενο';
  grid.Cells[2, 0] := 'Ετικέτα';
  grid.Cells[3, 0] := 'Εντολή';
  grid.Cells[4, 0] := 'Σχόλια';
  PrepareCommands;
end;

function CreateSortedStringList: TStringList;
begin
  Result := TStringList.Create;
  Result.Sorted := True;
  Result.Duplicates := dupIgnore;
end;

procedure TForm1.PrepareCommands;
var
  i: integer;
  c: T8085Command;
begin
  cmdList := TObjectList.Create;
  cmdHash := CreateSortedStringList;
  KeywordsHash := CreateSortedStringList;
  LabelsHash := CreateSortedStringList;
  ExtLabelsHash := CreateSortedStringList;
  ExtLabelsHash.AddObject('DELB', TObject($0430));

  for i := 0 to lstCommands.Items.Count - 1 do
  begin
    c := T8085Command.Create(lstCommands.Items[i], i);
    cmdList.Add(c);
    cmdHash.AddObject(c.Name, c);
    if Pos(' ', c.Name) = 0 then
      KeywordsHash.Add(c.Name)
    else
      KeywordsHash.Add(Copy(c.Name, 1, Pos(' ', c.Name) - 1));
  end;
  cmdHash.Sort;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  cmdHash.Free;
  cmdList.Free;
  KeywordsHash.Free;
  LabelsHash.Free;
  ExtLabelsHash.Free;
end;

procedure TForm1.actFileExportExecute(Sender: TObject);
begin
  with SaveDialog2 do
    if Execute then
      case FilterIndex of
        1:
        begin
          frmExportHTMLWizard.HTMLFile := FileName;
          frmExportHTMLWizard.Grid := grid;
          frmExportHTMLWizard.ShowModal;
        end;
        2: DoExportCSV(FileName);
        3: DoExportTXT(FileName);
      end;
end;

procedure TForm1.actFileExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TForm1.DoExportCSV(const FileName: string);
var
  f: TextFile;
  i, j: integer;
begin
  AssignFile(f, FileName);
  Rewrite(f);

  for i := 0 to grid.RowCount - 1 do
  begin
    for j := 0 to grid.ColCount - 2 do
      Write(f, grid.Cells[j, i] + #9);
    WriteLn(f, grid.Cells[grid.ColCount - 1, i]);
  end;
  CloseFile(f);
end;

procedure TForm1.DoExportTXT(const FileName: string);
var
  f: TextFile;
  i, j: integer;
begin
  AssignFile(f, FileName);
  Rewrite(f);

  for i := 0 to grid.RowCount - 1 do
  begin
    for j := 0 to grid.ColCount - 2 do
      Write(f, grid.Cells[j, i] + #9);
    WriteLn(f, grid.Cells[grid.ColCount - 1, i]);
  end;
  CloseFile(f);
end;

procedure TForm1.actHelpAboutExecute(Sender: TObject);
begin
  frmAbout.ShowModal;
end;

procedure TForm1.actEditSyncExecute(Sender: TObject);
begin
  ParseSource;
end;

procedure TForm1.actFileNewExecute(Sender: TObject);
begin
  txtAssembly.Lines.Clear;
  ParseSource;
end;

procedure TForm1.actFileSaveExecute(Sender: TObject);
begin
  with SaveDialog1 do
    if Execute then
      txtAssembly.Lines.SaveToFile(FileName);
end;

procedure TForm1.ApplicationEvents1Hint(Sender: TObject);
begin
  StatusBar1.Panels[2].Text := Application.Hint;
end;

procedure TForm1.txtAssemblyChange(Sender: TObject);
begin
  ParseSource;
end;

procedure TForm1.actViewMessagesExecute(Sender: TObject);
begin
  if frmMsgView.Visible then
    frmMsgView.Hide
  else
  begin
    if not frmMsgView.Floating then
    begin
      panDock.Height := frmMsgView.Height;
      Splitter2.Visible := True;
    end;
    frmMsgView.Show;
  end;

end;

procedure TForm1.actViewMessagesUpdate(Sender: TObject);
begin
  (Sender as TAction).Checked := frmMsgView.Visible;
end;

procedure TForm1.panDockDockOver(Sender: TObject; Source: TDragDockObject;
  X, Y: integer; State: TDragState; var Accept: boolean);
var
  ARect: TRect;
begin
  Accept := (Source.Control is TfrmMsgView);
  if Accept then
  begin
    ARect := Rect(0, -Source.Control.Height, panDock.Width, 0);
    //MapWindowPoints(panDock.Handle, 0, ARect, 2);
    Source.DockRect := ARect;
  end;
end;

procedure TForm1.panDockDockDrop(Sender: TObject; Source: TDragDockObject;
  X, Y: integer);
begin
  panDock.Height := Source.DockRect.Bottom - Source.DockRect.Top;
  Source.Control.Align := alRight;
  Splitter2.Visible := True;
  panDock.DockManager.ResetBounds(True);
end;

procedure TForm1.panDockUnDock(Sender: TObject; Client: TControl;
  NewTarget: TWinControl; var Allow: boolean);
begin
  Client.Align := alNone;
  panDock.Height := 0;
  Splitter2.Visible := False;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  frmMsgView.Show;
  frmMsgView.ManualDock(panDock, nil, alRight);
end;

procedure TForm1.MsgViewHide;
begin
  panDock.Height := 0;
  Splitter2.Visible := False;
end;

procedure TForm1.actEditOptionsExecute(Sender: TObject);
begin
  frmOptions.ShowModal;
end;

procedure TForm1.txtAssemblyKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
{var
  s: string;
  i: Integer;}
begin
{  if (Key = 13) and (txtAssembly.CaretPos.Y > 0) then begin
    s := txtAssembly.Lines[txtAssembly.CaretPos.Y - 1];
    i := 1;
    while (i <= Length(s)) and ( (s[i] = ' ') or (s[i] = #9) ) do Inc(i);
    if i > 1 then begin
      SetLength(s, i - 1);
      txtAssembly.Lines[txtAssembly.CaretPos.y] := s + txtAssembly.Lines[txtAssembly.CaretPos.y];
    end;
  end;}
  ShowCaretPos;
end;

procedure TForm1.ShowCaretPos;
begin
  StatusBar1.Panels[0].Text := IntToStr(txtAssembly.CaretPos.Y + 1) +
    ': ' + IntToStr(txtAssembly.CaretPos.X + 1);
end;

procedure TForm1.txtAssemblyKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  ShowCaretPos;
end;

procedure TForm1.actEditUndoExecute(Sender: TObject);
begin
  txtAssembly.Undo;
end;

procedure TForm1.txtAssemblyMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  ShowCaretPos;
end;

procedure TForm1.actEditFindExecute(Sender: TObject);
begin
  FindDialog1.Execute;
end;

procedure TForm1.FindDialog1Find(Sender: TObject);
var
  FoundAt: longint;
  StartPos, ToEnd: integer;
begin
  with txtAssembly do
  begin
    { begin the search after the current selection if there is one }
    { otherwise, begin at the start of the text }
    if SelLength <> 0 then

      StartPos := SelStart + SelLength
    else

      StartPos := 0;

    { ToEnd is the length from StartPos to the end of the text in the rich edit control }

    ToEnd := Length(Text) - StartPos;

    FoundAt := -1; //FindText(FindDialog1.FindText, StartPos, ToEnd, [stMatchCase]);
    if FoundAt <> -1 then
    begin
      SetFocus;
      SelStart := FoundAt;
      SelLength := Length(FindDialog1.FindText);
    end;
  end;

end;

procedure TForm1.actEditReplaceExecute(Sender: TObject);
begin
  ReplaceDialog1.Execute;
end;

procedure TForm1.ReplaceDialog1Replace(Sender: TObject);
var
  SelPos: integer;
begin
  with TReplaceDialog(Sender) do
  begin
    { Perform a global case-sensitive search for FindText in Memo1 }
    SelPos := Pos(FindText, txtAssembly.Lines.Text);
    if SelPos > 0 then
    begin
      txtAssembly.SelStart := SelPos - 1;
      txtAssembly.SelLength := Length(FindText);
      { Replace selected text with ReplaceText }
      txtAssembly.SelText := ReplaceText;
    end
    else
      MessageDlg(Concat('Could not find "', FindText, '" in txtAssembly.'),
        mtError, [mbOK], 0);

  end;
end;

end.
