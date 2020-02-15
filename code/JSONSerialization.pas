{$REGION 'documentation'}
{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  JSON format serialization
  @created(20/06/2019)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit JSONSerialization;

interface

uses
  Classes, SysUtils, StrUtils,
{$IFDEF FPC}
// TODO:
{$ELSE}
  System.RTTI,
  JSON,
{$ENDIF}
  IterableList,
  PlainStream,
  Serialization;

const
  NULL_RESULT = 'null';
  EMPTY_OBJECT = '{}';

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IItemSerialize) for single item JSON serialization)
  @member(
    Decompose Checks if generic item is NULL to return empty WideString or call the specific item implementation
    @seealso(IItemSerialize.Decompose)
  )
  @member(
    Compose Checks if text is empty to return empty WideString or call the specific item implementation
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
    _NullValue: WideString;
  public
    function Decompose(const Item: T): WideString;
    function Compose(const Text: WideString): T;
    constructor Create(const ItemSerialize: IItemSerialize<T>; const NullValue: WideString);
    class function New(const ItemSerialize: IItemSerialize<T>; const NullValue: WideString = NULL_RESULT)
      : IItemSerialize<T>;
  end;

{$REGION 'documentation'}
{
  @abstract(Callback to find list node array)
}
{$ENDREGION}

  TJSONListFindNodeCallback = reference to function(const JSON: TJSonValue): TJSONArray;

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
    @param(FindNodeCallback Callback to returns the JSONarray object to list processing)
  )
  @member(
    New Create a new @classname as interface
    @param(ItemSerialize Specific JSON item serialization implementation)
    @param(FindNodeCallback Callback to returns the JSONarray object for list processing)
  )
}
{$ENDREGION}

  TJSONListSerialize<T> = class(TInterfacedObject, IListSerialize<T>)
  strict private
    _ItemSerialize: IItemSerialize<T>;
    _FindNodeCallback: TJSONListFindNodeCallback;
  public
    function Decompose(const List: IIterableList<T>): WideString;
    function Compose(const Text: WideString; const List: IIterableList<T>): Boolean;
    constructor Create(const ItemSerialize: IItemSerialize<T>; const FindNodeCallback: TJSONListFindNodeCallback);
    class function New(const ItemSerialize: IItemSerialize<T>; const FindNodeCallback: TJSONListFindNodeCallback)
      : IListSerialize<T>;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ISerialization) for object JSON serialization)
  @member(@seealso(ISerialization.Decompose))
  @member(@seealso(ISerialization.Compose))
  @member(
    FindNodeCallback Callback to returns the JSONarray object for list processing
    @param(JSON JSON master object)
    @return(JSON array object)
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

  TJSONSerialization<T> = class(TInterfacedObject, ISerialization<T>)
  strict private
    _ItemSerialize: IItemSerialize<T>;
    _ListSerialize: IListSerialize<T>;
  protected
    function FindNodeCallback(const JSON: TJSonValue): TJSONArray; virtual;
  public
    function Decompose(const Item: T): WideString;
    function Compose(const Text: WideString): T;
    function ComposeFromStream(const Stream: TStream): T;
    function ListDecompose(const List: IIterableList<T>): WideString;
    function ListCompose(const Text: WideString; const List: IIterableList<T>): Boolean;
    function ListComposeFromStream(const Stream: TStream; const List: IIterableList<T>): Boolean;
    constructor Create(const ItemSerialize: IItemSerialize<T>; const NullValue: WideString = NULL_RESULT);
    class function New(const ItemSerialize: IItemSerialize<T>; const NullValue: WideString = NULL_RESULT)
      : ISerialization<T>;
  end;

implementation

{ TJSONItemSerialize<T> }

function TJSONItemSerialize<T>.Decompose(const Item: T): WideString;
begin
  if TValue.From<T>(Item).IsEmpty then
    Result := _NullValue
  else
    Result := _ItemSerialize.Decompose(Item);
end;

function TJSONItemSerialize<T>.Compose(const Text: WideString): T;
begin
  if (Length(Trim(Text)) < 1) or (Text = EMPTY_OBJECT) then
    Result := Default (T)
  else
    Result := _ItemSerialize.Compose(Text);
end;

constructor TJSONItemSerialize<T>.Create(const ItemSerialize: IItemSerialize<T>; const NullValue: WideString);
begin
  _ItemSerialize := ItemSerialize;
  _NullValue := NullValue;
end;

class function TJSONItemSerialize<T>.New(const ItemSerialize: IItemSerialize<T>; const NullValue: WideString)
  : IItemSerialize<T>;
begin
  Result := TJSONItemSerialize<T>.Create(ItemSerialize, NullValue);
end;

{ TJSONListSerialize<T> }

function TJSONListSerialize<T>.Decompose(const List: IIterableList<T>): WideString;
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

function TJSONListSerialize<T>.Compose(const Text: WideString; const List: IIterableList<T>): Boolean;
var
  JSonValue: TJSonValue;
  JsonArray: TJSONArray;
  ArrayElement: TJSonValue;
begin
  Result := False;
  List.Clear;
  JSonValue := TJSonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Text), 0);
  try;
    JsonArray := _FindNodeCallback(JSonValue);
    for ArrayElement in JsonArray do
      List.Add(_ItemSerialize.Compose(ArrayElement.ToJSON));
    Result := not List.IsEmpty;
  finally
    JSonValue.Free;
  end;
end;

constructor TJSONListSerialize<T>.Create(const ItemSerialize: IItemSerialize<T>;
  const FindNodeCallback: TJSONListFindNodeCallback);
begin
  _ItemSerialize := ItemSerialize;
  _FindNodeCallback := FindNodeCallback;
end;

class function TJSONListSerialize<T>.New(const ItemSerialize: IItemSerialize<T>;
  const FindNodeCallback: TJSONListFindNodeCallback): IListSerialize<T>;
begin
  Result := TJSONListSerialize<T>.Create(ItemSerialize, FindNodeCallback);
end;

{ TJSONSerialization<T> }

function TJSONSerialization<T>.Decompose(const Item: T): WideString;
begin
  Result := _ItemSerialize.Decompose(Item);
end;

function TJSONSerialization<T>.Compose(const Text: WideString): T;
begin
  Result := _ItemSerialize.Compose(Text);
end;

function TJSONSerialization<T>.ComposeFromStream(const Stream: TStream): T;
begin
  Result := Compose(TPlainStream.New.Decode(Stream));
end;

function TJSONSerialization<T>.ListDecompose(const List: IIterableList<T>): WideString;
begin
  Result := _ListSerialize.Decompose(List);
end;

function TJSONSerialization<T>.ListCompose(const Text: WideString; const List: IIterableList<T>): Boolean;
begin
  Result := _ListSerialize.Compose(Text, List);
end;

function TJSONSerialization<T>.ListComposeFromStream(const Stream: TStream; const List: IIterableList<T>): Boolean;
begin
  Result := ListCompose(TPlainStream.New.Decode(Stream), List);
end;

function TJSONSerialization<T>.FindNodeCallback(const JSON: TJSonValue): TJSONArray;
begin
  Result := JSON as TJSONArray;
end;

constructor TJSONSerialization<T>.Create(const ItemSerialize: IItemSerialize<T>; const NullValue: WideString);
begin
  _ItemSerialize := TJSONItemSerialize<T>.New(ItemSerialize, NullValue);
  _ListSerialize := TJSONListSerialize<T>.New(_ItemSerialize, FindNodeCallback);
end;

class function TJSONSerialization<T>.New(const ItemSerialize: IItemSerialize<T>; const NullValue: WideString)
  : ISerialization<T>;
begin
  Result := TJSONSerialization<T>.Create(ItemSerialize, NullValue);
end;

end.
