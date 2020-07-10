{$REGION 'documentation'}
{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  XML format serialization
  @created(20/06/2019)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit XMLSerialization;

interface

uses
  Classes, SysUtils, StrUtils,
{$IFDEF FPC}
// TODO:
{$ELSE}
  System.RTTI,
  XMLIntf, XMLDoc,
{$ENDIF}
  IterableList,
  PlainStream,
  Serialization;

type
  TXMLItemSerialize<T> = class(TInterfacedObject, IItemSerialize<T>)
  strict private
    _ItemSerialize: IItemSerialize<T>;
  public
    function Decompose(const Item: T): WideString;
    function Compose(const Text: WideString): T;
    constructor Create(const ItemSerialize: IItemSerialize<T>);
    class function New(const ItemSerialize: IItemSerialize<T>): IItemSerialize<T>;
  end;

  TXMLListSerialize<T> = class(TInterfacedObject, IListSerialize<T>)
  type
    TFindNodeCallback = reference to function(const XMLNode: IXMLNode; const RootNode: WideString): IXMLNodeList;
    TRootNodeCallback = reference to function: WideString;
  strict private
    _FindNodeCallback: TFindNodeCallback;
    _RootNodeCallback: TRootNodeCallback;
    _ItemSerialize: IItemSerialize<T>;
  private
    function AddTagDelimiter(const TagName: WideString; const IsClosed: Boolean): WideString;
  public
    function Decompose(const List: IIterableList<T>): WideString;
    function Compose(const Text: WideString; const List: IIterableList<T>): Boolean;
    constructor Create(const ItemSerialize: IItemSerialize<T>; const FindNodeCallback: TFindNodeCallback;
      const RootNodeCallback: TRootNodeCallback);
    class function New(const ItemSerialize: IItemSerialize<T>; const FindNodeCallback: TFindNodeCallback = nil;
      const RootNodeCallback: TRootNodeCallback = nil): IListSerialize<T>;
  end;

  TXMLSerialization<T> = class(TInterfacedObject, ISerialization<T>)
  strict private
    _ItemSerialize: IItemSerialize<T>;
    _ListSerialize: IListSerialize<T>;
  protected
    function RootNodeCallback: WideString; virtual;
    function FindNodeCallback(const XMLNode: IXMLNode; const RootNode: WideString): IXMLNodeList; virtual;
  public
    function Decompose(const Item: T): WideString;
    function Compose(const Text: WideString): T;
    function ComposeFromStream(const Stream: TStream): T;
    function ListDecompose(const List: IIterableList<T>): WideString;
    function ListCompose(const Text: WideString; const List: IIterableList<T>): Boolean;
    function ListComposeFromStream(const Stream: TStream; const List: IIterableList<T>): Boolean;
    constructor Create(const ItemSerialize: IItemSerialize<T>; const ListSerialize: IListSerialize<T> = nil);
    class function New(const ItemSerialize: IItemSerialize<T>; const ListSerialize: IListSerialize<T> = nil)
      : ISerialization<T>;
  end;

implementation

{ TXMLItemSerialize<T> }

function TXMLItemSerialize<T>.Decompose(const Item: T): WideString;
begin
  if TValue.From<T>(Item).IsEmpty then
    Result := EmptyStr
  else
    Result := _ItemSerialize.Decompose(Item);
end;

function TXMLItemSerialize<T>.Compose(const Text: WideString): T;
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

{ TXMLListSerialize<T> }

function TXMLListSerialize<T>.AddTagDelimiter(const TagName: WideString; const IsClosed: Boolean): WideString;
begin
  Result := '<';
  if IsClosed then
    Result := Result + '/';
  Result := Result + TagName + '>';
end;

function TXMLListSerialize<T>.Decompose(const List: IIterableList<T>): WideString;
var
  Item: T;
begin
  if List.IsEmpty then
    Exit(EmptyWideStr);
  Result := AddTagDelimiter(_RootNodeCallback, False);
  for Item in List do
    Result := Result + _ItemSerialize.Decompose(Item);
  Result := Result + AddTagDelimiter(_RootNodeCallback, True);
end;

function TXMLListSerialize<T>.Compose(const Text: WideString; const List: IIterableList<T>): Boolean;
var
  XMLDoc: IXMLDocument;
  MainNode: IXMLNode;
  XMLArray: IXMLNodeList;
  ArrayElement: IXMLNode;
  i: NativeInt;
begin
  Result := False;
  List.Clear;
  XMLDoc := LoadXMLData(Text);
  MainNode := XMLDoc.DocumentElement;
  XMLArray := _FindNodeCallback(MainNode, _RootNodeCallback);
  for i := 0 to Pred(XMLArray.Count) do
  begin
    ArrayElement := XMLArray[i];
    List.Add(_ItemSerialize.Compose(ArrayElement.XML));
  end;
  Result := List.Count > 0;
end;

constructor TXMLListSerialize<T>.Create(const ItemSerialize: IItemSerialize<T>;
  const FindNodeCallback: TFindNodeCallback; const RootNodeCallback: TRootNodeCallback);
begin
  _ItemSerialize := ItemSerialize;
  _FindNodeCallback := FindNodeCallback;
  _RootNodeCallback := RootNodeCallback;
end;

class function TXMLListSerialize<T>.New(const ItemSerialize: IItemSerialize<T>;
  const FindNodeCallback: TFindNodeCallback; const RootNodeCallback: TRootNodeCallback): IListSerialize<T>;
begin
  Result := TXMLListSerialize<T>.Create(ItemSerialize, FindNodeCallback, RootNodeCallback);
end;

{ TXMLSerialization<T> }

function TXMLSerialization<T>.Decompose(const Item: T): WideString;
begin
  Result := _ItemSerialize.Decompose(Item);
end;

function TXMLSerialization<T>.Compose(const Text: WideString): T;
begin
  Result := _ItemSerialize.Compose(Text);
end;

function TXMLSerialization<T>.ListCompose(const Text: WideString; const List: IIterableList<T>): Boolean;
begin
  Result := _ListSerialize.Compose(Text, List);
end;

function TXMLSerialization<T>.ListComposeFromStream(const Stream: TStream; const List: IIterableList<T>): Boolean;
begin
  Result := ListCompose(TPlainStream.New.Decode(Stream), List);
end;

function TXMLSerialization<T>.ListDecompose(const List: IIterableList<T>): WideString;
begin
  Result := _ListSerialize.Decompose(List);
end;

function TXMLSerialization<T>.ComposeFromStream(const Stream: TStream): T;
begin
  Result := Compose(TPlainStream.New.Decode(Stream));
end;

function TXMLSerialization<T>.RootNodeCallback: WideString;
begin
  Result := EmptyWideStr;
end;

function TXMLSerialization<T>.FindNodeCallback(const XMLNode: IXMLNode; const RootNode: WideString): IXMLNodeList;
begin
  Result := XMLNode.ChildNodes;
end;

constructor TXMLSerialization<T>.Create(const ItemSerialize: IItemSerialize<T>; const ListSerialize: IListSerialize<T>);
begin
  _ItemSerialize := TXMLItemSerialize<T>.New(ItemSerialize);
  if Assigned(ListSerialize) then
    _ListSerialize := ListSerialize
  else
    _ListSerialize := TXMLListSerialize<T>.New(ItemSerialize, FindNodeCallback, RootNodeCallback);
end;

class function TXMLSerialization<T>.New(const ItemSerialize: IItemSerialize<T>; const ListSerialize: IListSerialize<T>)
  : ISerialization<T>;
begin
  Result := TXMLSerialization<T>.Create(ItemSerialize, ListSerialize);
end;

end.
