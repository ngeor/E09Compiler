unit Intf;

{$MODE Delphi}

interface

type
  IE09CompilerEnvironment = dispinterface
    ['{AA401E61-C650-4002-812C-2412084CE7E6}']
    property ExternalLabelsCount: Integer dispid 0;
    property ExternalLabels[Index: Integer]: WideString dispid 1;
  end;

implementation

end.
