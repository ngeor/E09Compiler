unit Engine;

{$MODE Delphi}

interface

uses SysUtils, Classes;

type
  T8085Command = class
  private
    FName: String;
    FBytes: Integer;
    FCode: Byte;
    FAddress: Boolean;
    FComma: Boolean;
  public
    constructor Create(const sName: String; nBytes: Integer; nCode: Byte;
      bAddress, bComma: Boolean); overload;
    constructor Create(const sSyntax: String; nCode: Byte); overload;
    property Name: String read FName;
    property Bytes: Integer read FBytes;
    property Code: Byte read FCode;
    property Address: Boolean read FAddress;
    property Comma: Boolean read FComma;
    class function SortByName(i1, i2: T8085Command): Integer;
    function Format(const sParam: String): String;
  end;

procedure SplitStringToList(const s: String; list: TStrings);
function SingleSpaces(const s: String): String;
procedure SplitList(s: String; var s1, s2: String);
function IsHexNumber(const s: String; maxVal: Integer; var num: Integer): Boolean;

implementation

function IsHexNumber(const s: String; maxVal: Integer; var num: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;
  try
    i := StrToInt('$' + s);
    if i <= maxVal then
      num := i
    else
      Result := False;
  except
    Result := False;
  end;
end;

procedure SplitList(s: String; var s1, s2: String);
var
  i: Integer;
begin
  i := Pos(' ', s);
  if i > 0 then
  begin
    s1 := Copy(s, 1, i - 1);
    s2 := Copy(s, i + 1, Length(s) - i);
  end
  else
  begin
    s1 := s;
    s2 := '';
  end;
end;

procedure SplitStringToList(const s: String; list: TStrings);
var
  i: Integer;
  j: Integer;
begin
  i := 1;
  list.Clear;
  repeat
    while (i <= Length(s)) and ((s[i] = ' ') or (s[i] = #9)) do
      Inc(i);
    if i <= Length(s) then
    begin
      j := i;
      Inc(i);
      while (i <= Length(s)) and (s[i] <> ' ') and (s[i] <> #9) do
        Inc(i);
      list.Add(Copy(s, j, i - j));
    end;
  until i > Length(s);
end;

function SingleSpaces(const s: String): String;
var
  i: Integer;
  j: Integer;
begin
  i := 1;
  Result := '';

  repeat
    while (i <= Length(s)) and ((s[i] = ' ') or (s[i] = #9)) do
      Inc(i);
    if i <= Length(s) then
    begin
      j := i;
      Inc(i);
      while (i <= Length(s)) and (s[i] <> ' ') and (s[i] <> #9) do
        Inc(i);
      Result := Result + Copy(s, j, i - j) + ' ';
    end;
  until i > Length(s);
  Result := Trim(Result);
end;

constructor T8085Command.Create(const sName: String; nBytes: Integer;
  nCode: Byte; bAddress, bComma: Boolean);
begin
  inherited Create;
  FName := sName;
  FBytes := nBytes;
  FCode := nCode;
  FAddress := bAddress;
  FComma := bComma;
end;

constructor T8085Command.Create(const sSyntax: String; nCode: Byte);
var
  i: Integer;
begin
  inherited Create;
  FCode := nCode;

  i := Pos('adr', sSyntax);
  if i > 0 then (* address *)
  begin
    FAddress := True;
    FBytes := 3;
    FName := Trim(Copy(sSyntax, 1, i - 1));
  end
  else
  begin
    i := Pos('dble', sSyntax);
    if i > 0 then (* double *)
    begin
      FAddress := False;
      FBytes := 3;
      FName := Trim(Copy(sSyntax, 1, i - 1));
    end
    else
    begin
      i := Pos('byte', sSyntax);
      if i > 0 then (* byte *)
      begin
        FAddress := False;
        FBytes := 2;
        FName := Trim(Copy(sSyntax, 1, i - 1));
      end
      else (* simple command *)
      begin
        FAddress := False;
        FBytes := 1;
        FName := sSyntax;
      end;
    end;
  end;
  if FName[Length(FName)] = ',' then
  begin
    FComma := True;
    FName := Copy(FName, 1, Length(FName) - 1);
  end
  else
    FComma := False;
end;

class function T8085Command.SortByName(i1, i2: T8085Command): Integer;
begin
  SortByName := CompareStr(i1.Name, i2.Name);
end;

function T8085Command.Format(const sParam: String): String;
begin
  if FComma then
    Result := FName + ',' + sParam
  else
    Result := FName + ' ' + sParam;
end;

end.
