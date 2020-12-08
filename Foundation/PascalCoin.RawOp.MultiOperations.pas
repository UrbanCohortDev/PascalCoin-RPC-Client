unit PascalCoin.RawOp.MultiOperations;

interface

uses System.Generics.Collections,
PascalCoin.RawOp.Interfaces;

Type

TPascalCoinMultiOperations = class(TInterfacedObject, IPascalCoinMultiOperations)
  private
    FList: TList<IPascalCoinRawOperation>;
  protected
    function GetRawOperation(const Index: integer): IPascalCoinRawOperation;
    function Count: Integer;
    function GetRawData: string;
    function AddRawOperation(Value: IPascalCoinRawOperation): integer;
  public
    constructor Create;
    destructor Destroy; override;
  end;


implementation

{ TRawOperations }

uses PascalCoin.Utils, PascalCoin.KeyUtils, clpConverters;

function TPascalCoinMultiOperations.AddRawOperation(Value: IPascalCoinRawOperation): integer;
begin
  Result := FList.Add(Value);
end;

function TPascalCoinMultiOperations.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TPascalCoinMultiOperations.Create;
begin
  Inherited Create;
  FList := TList<IPascalCoinRawOperation>.Create;
end;

destructor TPascalCoinMultiOperations.Destroy;
begin
  FList.Free;
  inherited;
end;

function TPascalCoinMultiOperations.GetRawData: string;
var
  I: integer;
begin
  Result := TKeyUtils.AsHex(TConverters.ReadUInt32AsBytesLE(FList.Count));
  for I := 0 to FList.Count - 1 do
    Result := Result + FList[I].RawOp;
end;

function TPascalCoinMultiOperations.GetRawOperation(const Index: integer): IPascalCoinRawOperation;
begin
  Result := FList[Index];
end;

end.
