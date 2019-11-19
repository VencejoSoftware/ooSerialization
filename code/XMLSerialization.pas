unit XMLSerialization;

interface

uses
  SysUtils, StrUtils, DateUtils,
  System.RTTI,
  XMLIntf, XMLDoc,
  IterableList,
  Serialization;

type
  TXMLItemSerialize<T> = class(TInterfacedObject, IItemSerialize<T>)
  strict private
    _ItemSerialize: IItemSerialize<T>;
  public
    function Decompose(const Item: T): String;
    function Compose(const Text: String): T;
    constructor Create(const ItemSerialize: IItemSerialize<T>);
    class function New(const ItemSerialize: IItemSerialize<T>): IItemSerialize<T>;
  end;

  TXMLListSerialize<T> = class(TInterfacedObject, IListSerialize<T>)
  strict private
    _ItemSerialize: IItemSerialize<T>;
  public
    function Decompose(const List: IIterableList<T>): String;
    function Compose(const Text: String; const List: IIterableList<T>): Boolean;
    constructor Create(const ItemSerialize: IItemSerialize<T>);
    class function New(const ItemSerialize: IItemSerialize<T>): IListSerialize<T>;
  end;

  TXMLSerialization<T> = class(TInterfacedObject, ISerialization<T>)
  strict private
    _ItemSerialize: IItemSerialize<T>;
    _ListSerialize: IListSerialize<T>;
// protected
// function ListDeserializeGetArray(const XMLValue: TXMLValue): TXMLArray; virtual;
  public
    function Serialize(const Item: T): String;
    function Deserialize(const Text: String): T;
    function ListSerialize(const List: IIterableList<T>): String;
    function ListDeserialize(const Text: String; const List: IIterableList<T>): Boolean;
    constructor Create(const ItemSerialize: IItemSerialize<T>);
    class function New(const ItemSerialize: IItemSerialize<T>): ISerialization<T>;
  end;

implementation

{ TXMLListSerialize<T> }

function TXMLListSerialize<T>.Decompose(const List: IIterableList<T>): String;
var
  Item: T;
begin
  Result := EmptyStr;
  for Item in List do
    Result := Result + _ItemSerialize.Decompose(Item) + ',';
  if RightStr(Result, 1) = ',' then
    Result := Copy(Result, 1, Pred(Length(Result)));
  Result := '[' + Result + ']';
end;

function TXMLListSerialize<T>.Compose(const Text: String; const List: IIterableList<T>): Boolean;
begin
// TODO:
end;

constructor TXMLListSerialize<T>.Create(const ItemSerialize: IItemSerialize<T>);
begin
  _ItemSerialize := ItemSerialize;
end;

class function TXMLListSerialize<T>.New(const ItemSerialize: IItemSerialize<T>): IListSerialize<T>;
begin
  Result := TXMLListSerialize<T>.Create(ItemSerialize);
end;

{ TXMLSerialization<T> }

function TXMLSerialization<T>.Serialize(const Item: T): String;
begin
  Result := _ItemSerialize.Decompose(Item);
end;

function TXMLSerialization<T>.Deserialize(const Text: String): T;
begin
  Result := _ItemSerialize.Compose(Text);
end;

function TXMLSerialization<T>.ListSerialize(const List: IIterableList<T>): String;
begin
  Result := _ListSerialize.Decompose(List);
end;

// function TXMLSerialization<T>.ListDeserializeGetArray(const XMLValue: TXMLValue): TXMLArray;
// begin
// Result := XMLValue as TXMLArray;
// end;

function TXMLSerialization<T>.ListDeserialize(const Text: String; const List: IIterableList<T>): Boolean;
// function TXMLSerialization<T>.ListDeserialize(const Text: String; const List: IIterableList<T>): Boolean;
// var
// XMLDoc: IXMLDocument;
// MainNode: IXMLNode;
// XMLArray: TXMLArray;
// ArrayElement: TXMLValue;
begin
// Result := False;
// List.Clear;
// XMLDoc := LoadXMLData(Text);
// MainNode := XMLDoc.DocumentElement;
// XMLArray := ListDeserializeGetArray(XMLValue);
// for ArrayElement in XMLArray do
// List.Add(Deserialize(ArrayElement.ToXML));
// Result := List.Count > 0;
end;

constructor TXMLSerialization<T>.Create(const ItemSerialize: IItemSerialize<T>);
begin
  _ItemSerialize := TXMLItemSerialize<T>.New(ItemSerialize);
  _ListSerialize := TXMLListSerialize<T>.New(_ItemSerialize);
end;

class function TXMLSerialization<T>.New(const ItemSerialize: IItemSerialize<T>): ISerialization<T>;
begin
  Result := TXMLSerialization<T>.Create(ItemSerialize);
end;

{ TXMLItemSerialize<T> }

function TXMLItemSerialize<T>.Decompose(const Item: T): String;
begin
  if TValue.From<T>(Item).IsEmpty then
    Result := EmptyStr
  else
    Result := _ItemSerialize.Decompose(Item);
end;

function TXMLItemSerialize<T>.Compose(const Text: String): T;
begin
  if Length(Trim(Text)) < 1 then
    Result := Default (T)
  else
    Result := _ItemSerialize.Compose(Text);
end;

constructor TXMLItemSerialize<T>.Create(const ItemSerialize: IItemSerialize<T>);
begin
  _ItemSerialize := ItemSerialize;
end;

class function TXMLItemSerialize<T>.New(const ItemSerialize: IItemSerialize<T>): IItemSerialize<T>;
begin
  Result := TXMLItemSerialize<T>.Create(ItemSerialize);
end;

end.
