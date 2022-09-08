unit OptionsPageForm;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs;

type
  TOptionsPage = class(TForm)
  protected
    function GetLogicalPath: String; virtual;
  public
    property LogicalPath: String read GetLogicalPath;
  end;

implementation

{$R *.lfm}

function TOptionsPage.GetLogicalPath: String;
begin
  Result := '';
end;

end.
