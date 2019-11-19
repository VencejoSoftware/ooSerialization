{$REGION 'documentation'}
{
  Copyright (c) 2019, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  JSON objects serialization
  @created(20/06/2019)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit JSONSerialization;

interface

uses
  SysUtils, StrUtils,
{$IFDEF FPC}
// TODO:
{$ELSE}
  System.RTTI,
  JSON,
{$ENDIF}
  IterableList,
  Serialization;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IItemSerialize) for single item JSON serialization)
  @member(
    Decompose Checks if generic item is NULL to return empty string or call the specific item implementation
    @seealso(IItemSerialize.Decompose)
  )
  @member(
    Compose Checks if text is empty to return empty string or call the specific item implementation
    @seealso(IItemSerialize.Compose)
  )
  @member(
    Create Object constructor
    @param(ItemSerialize Specific JSON item serialization implementation)
  )
  @member(
    New Create a new @classname as interface
    @param(ItemSerialize Specific JSON item serialization implementation)
  )
}
{$ENDREGION}
  TJSONItemSerialize<T> = class(TInterfacedObject, IItemSerialize<T>)
  strict private
    _ItemSerialize: IItemSerialize<T>;
  public
    function Decompose(const Item: T): String;
    function Compose(const Text: String): T;
    constructor Create(const ItemSerialize: IItemSerialize<T>);
    class function New(const ItemSerialize: IItemSerialize<T>): IItemSerialize<T>;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IListSerialize) for item list JSON serialization)
  @member(
    Decompose Loop into list an serialize each item
    @seealso(IListSerialize.Decompose)
  )
  @member(
    Compose Parse JSON text as JSON array and call @link(item serialization factory IItemSerialize<T>) to build items
    @seealso(IListSerialize.Compose)
  )
  @member(
    Create Object constructor
    @param(ItemSerialize Specific JSON item serialization implementation)
  )
  @member(
    New Create a new @classname as interface
    @param(ItemSerialize Specific JSON item serialization implementation)
  )
}
{$ENDREGION}

  TJSONListSerialize<T> = class(TInterfacedObject, IListSerialize<T>)
  strict private
    _ItemSerialize: IItemSerialize<T>;
  public
    function Decompose(const List: IIterableList<T>): String;
    function Compose(const Text: String; const List: IIterableList<T>): Boolean;
    constructor Create(const ItemSerialize: IItemSerialize<T>);
    class function New(const ItemSerialize: IItemSerialize<T>): IListSerialize<T>;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ISerialization) for object JSON serialization)
  @member(@seealso(ISerialization.Decompose))
  @member(@seealso(ISerialization.Compose))
  @member(
    Create Object constructor
    @param(ItemSerialize Specific JSON item serialization implementation)
  )
  @member(
    New Create a new @classname as interface
    @param(ItemSerialize Specific JSON item serialization implementation)
  )
}
{$ENDREGION}

  TJSONSerialization<T> = class(TInterfacedObject, ISerialization<T>)
  strict private
    _ItemSerialize: IItemSerialize<T>;
    _ListSerialize: IListSerialize<T>;
  public
    function Serialize(const Item: T): String;
    function Deserialize(const Text: String): T;
    function ListSerialize(const List: IIterableList<T>): String;
    function ListDeserialize(const Text: String; const List: IIterableList<T>): Boolean;
    constructor Create(const ItemSerialize: IItemSerialize<T>);
    class function New(const ItemSerialize: IItemSerialize<T>): ISerialization<T>;
  end;

implementation

{ TJSONItemSerialize<T> }

function TJSONItemSerialize<T>.Decompose(const Item: T): String;
begin
  if TValue.From<T>(Item).IsEmpty then
    Result := '{}'
  else
    Result := _ItemSerialize.Decompose(Item);
end;

function TJSONItemSerialize<T>.Compose(const Text: String): T;
begin
  if Length(Trim(Text)) < 1 then
    Result := Default (T)
  else
    Result := _ItemSerialize.Compose(Text);
end;

constructor TJSONItemSerialize<T>.Create(const ItemSerialize: IItemSerialize<T>);
begin
  _ItemSerialize := ItemSerialize;
end;

class function TJSONItemSerialize<T>.New(const ItemSerialize: IItemSerialize<T>): IItemSerialize<T>;
begin
  Result := TJSONItemSerialize<T>.Create(ItemSerialize);
end;

{ TJSONListSerialize<T> }

function TJSONListSerialize<T>.Decompose(const List: IIterableList<T>): String;
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

function TJSONListSerialize<T>.Compose(const Text: String; const List: IIterableList<T>): Boolean;
var
  JSonValue: TJSonValue;
  JsonArray: TJSONArray;
  ArrayElement: TJSonValue;
begin
  Result := False;
  List.Clear;
  JSonValue := TJSonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Text), 0);
  try
    JsonArray := JSonValue as TJSONArray;
    for ArrayElement in JsonArray do
      List.Add(_ItemSerialize.Compose(ArrayElement.ToJSON));
    Result := not List.IsEmpty;
  finally
    JSonValue.Free;
  end;
end;

constructor TJSONListSerialize<T>.Create(const ItemSerialize: IItemSerialize<T>);
begin
  _ItemSerialize := ItemSerialize;
end;

class function TJSONListSerialize<T>.New(const ItemSerialize: IItemSerialize<T>): IListSerialize<T>;
begin
  Result := TJSONListSerialize<T>.Create(ItemSerialize);
end;

{ TJSONSerialization<T> }

function TJSONSerialization<T>.Serialize(const Item: T): String;
begin
  Result := _ItemSerialize.Decompose(Item);
end;

function TJSONSerialization<T>.Deserialize(const Text: String): T;
begin
  Result := _ItemSerialize.Compose(Text);
end;

function TJSONSerialization<T>.ListSerialize(const List: IIterableList<T>): String;
begin
  Result := _ListSerialize.Decompose(List);
end;

function TJSONSerialization<T>.ListDeserialize(const Text: String; const List: IIterableList<T>): Boolean;
begin
  Result := _ListSerialize.Compose(Text, List);
end;

constructor TJSONSerialization<T>.Create(const ItemSerialize: IItemSerialize<T>);
begin
  _ItemSerialize := TJSONItemSerialize<T>.New(ItemSerialize);
  _ListSerialize := TJSONListSerialize<T>.New(_ItemSerialize);
end;

class function TJSONSerialization<T>.New(const ItemSerialize: IItemSerialize<T>): ISerialization<T>;
begin
  Result := TJSONSerialization<T>.Create(ItemSerialize);
end;

end.
