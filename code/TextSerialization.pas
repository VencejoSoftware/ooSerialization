unit TextSerialization;

interface

uses
  SysUtils, StrUtils, DateUtils,
  System.RTTI,
  XMLIntf, XMLDoc,
  IterableList,
  Serialization;

//type
//  TTextItemSerialize<T> = class(TInterfacedObject, IItemSerialize<T>)
//  strict private
//    _ItemSerialize: IItemSerialize<T>;
//  public
//    function Decompose(const Item: T): String;
//    function Compose(const Text: String): T;
//    constructor Create(const ItemSerialize: IItemSerialize<T>);
//    class function New(const ItemSerialize: IItemSerialize<T>): IItemSerialize<T>;
//  end;
//
//  TTextListSerialize<T> = class(TInterfacedObject, IListSerialize<T>)
//  strict private
//    _ItemSerialize: IItemSerialize<T>;
//  public
//    function Decompose(const List: IIterableList<T>): String;
//    function Compose(const Text: String): IIterableList<T>;
//    constructor Create(const ItemSerialize: IItemSerialize<T>);
//    class function New(const ItemSerialize: IItemSerialize<T>): IListSerialize<T>;
//  end;
//
//  TTextSerialization<T> = class(TInterfacedObject, ISerialization<T>)
//  strict private
//    _ItemSerialize: IItemSerialize<T>;
//    _ListSerialize: IListSerialize<T>;
//  public
//    function Serialize(const Item: T): String;
//    function Deserialize(const Text: String): T;
//    function ListSerialize(const List: IIterableList<T>): String;
//    function ListDeserialize(const Text: String): IIterableList<T>;
//    constructor Create(const ItemSerialize: IItemSerialize<T>);
//    class function New(const ItemSerialize: IItemSerialize<T>): ISerialization<T>;
//  end;
//
//  ITextDateTime = interface
//    ['{F551AB52-88FE-4BFB-98DF-ED7044C35633}']
//    function Serialize(const DateTime: TDateTime): String;
//    function Deserialize(const Value: String): TDateTime;
//  end;
//
//  TTextDateTime = class sealed(TInterfacedObject, ITextDateTime)
//  public
//    function Serialize(const DateTime: TDateTime): String;
//    function Deserialize(const Value: String): TDateTime;
//    class function New: ITextDateTime;
//  end;

implementation
//
//{ TTextListSerialize<T> }
//
//function TTextListSerialize<T>.Decompose(const List: IIterableList<T>): String;
//var
//  Item: T;
//begin
//  Result := EmptyStr;
//  for Item in List do
//    Result := Result + _ItemSerialize.Decompose(Item) + ',';
//  if RightStr(Result, 1) = ',' then
//    Result := Copy(Result, 1, Pred(Length(Result)));
//  Result := '[' + Result + ']';
//end;
//
//function TTextListSerialize<T>.Compose(const Text: String): IIterableList<T>;
//begin
//// TODO:
//end;
//
//constructor TTextListSerialize<T>.Create(const ItemSerialize: IItemSerialize<T>);
//begin
//  _ItemSerialize := ItemSerialize;
//end;
//
//class function TTextListSerialize<T>.New(const ItemSerialize: IItemSerialize<T>): IListSerialize<T>;
//begin
//  Result := TTextListSerialize<T>.Create(ItemSerialize);
//end;
//
//{ TTextSerialization<T> }
//
//function TTextSerialization<T>.Serialize(const Item: T): String;
//begin
//  Result := _ItemSerialize.Decompose(Item);
//end;
//
//function TTextSerialization<T>.Deserialize(const Text: String): T;
//begin
//  Result := _ItemSerialize.Compose(Text);
//end;
//
//function TTextSerialization<T>.ListSerialize(const List: IIterableList<T>): String;
//begin
//  Result := _ListSerialize.Decompose(List);
//end;
//
//// function TTextSerialization<T>.ListDeserializeGetArray(const XMLValue: TXMLValue): TXMLArray;
//// begin
//// Result := XMLValue as TXMLArray;
//// end;
//
//function TTextSerialization<T>.ListDeserialize(const Text: String): IIterableList<T>;
//// function TTextSerialization<T>.ListDeserialize(const Text: String; const List: IIterableList<T>): Boolean;
//// var
//// XMLDoc: IXMLDocument;
//// MainNode: IXMLNode;
//// XMLArray: TXMLArray;
//// ArrayElement: TXMLValue;
//begin
//// Result := False;
//// List.Clear;
//// XMLDoc := LoadXMLData(Text);
//// MainNode := XMLDoc.DocumentElement;
//// XMLArray := ListDeserializeGetArray(XMLValue);
//// for ArrayElement in XMLArray do
//// List.Add(Deserialize(ArrayElement.ToXML));
//// Result := List.Count > 0;
//end;
//
//constructor TTextSerialization<T>.Create(const ItemSerialize: IItemSerialize<T>);
//begin
//  _ItemSerialize := TTextItemSerialize<T>.New(ItemSerialize);
//  _ListSerialize := TTextListSerialize<T>.New(_ItemSerialize);
//end;
//
//class function TTextSerialization<T>.New(const ItemSerialize: IItemSerialize<T>): ISerialization<T>;
//begin
//  Result := TTextSerialization<T>.Create(ItemSerialize);
//end;
//
//{ TTextItemSerialize<T> }
//
//function TTextItemSerialize<T>.Decompose(const Item: T): String;
//begin
//  if TValue.From<T>(Item).IsEmpty then
//    Result := EmptyStr
//  else
//    Result := _ItemSerialize.Decompose(Item);
//end;
//
//function TTextItemSerialize<T>.Compose(const Text: String): T;
//begin
//  if Length(Trim(Text)) < 1 then
//    Result := Default (T)
//  else
//    Result := _ItemSerialize.Compose(Text);
//end;
//
//constructor TTextItemSerialize<T>.Create(const ItemSerialize: IItemSerialize<T>);
//begin
//  _ItemSerialize := ItemSerialize;
//end;
//
//class function TTextItemSerialize<T>.New(const ItemSerialize: IItemSerialize<T>): IItemSerialize<T>;
//begin
//  Result := TTextItemSerialize<T>.Create(ItemSerialize);
//end;
//
//{ TTextDateTime }
//
//function TTextDateTime.Deserialize(const Value: String): TDateTime;
//var
//  Year, Month, Day, Hour, Minute, Second: Word;
//begin
//  Year := StrToInt(Copy(Value, 1, 4));
//  Month := StrToInt(Copy(Value, 5, 2));
//  Day := StrToInt(Copy(Value, 7, 2));
//  Hour := StrToInt(Copy(Value, 12, 2));
//  Minute := StrToInt(Copy(Value, 16, 2));
//  Second := StrToInt(Copy(Value, 18, 2));
//  Result := EncodeDateTime(Year, Month, Day, Hour, Minute, Second, 0);
//end;
//
//function TTextDateTime.Serialize(const DateTime: TDateTime): String;
//begin
//  Result := FormatDateTime('yyyy-MM-dd hh:nn:ss', DateTime);
//end;
//
//class function TTextDateTime.New: ITextDateTime;
//begin
//  Result := TTextDateTime.Create;
//end;

end.
