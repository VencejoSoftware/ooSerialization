{$REGION 'documentation'}
{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Plaint text serialization
  @created(20/06/2019)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit TextSerialization;

interface

uses
  Classes, SysUtils, StrUtils,
{$IFDEF FPC}
// TODO:
{$ELSE}
  System.RTTI,
{$ENDIF}
  IterableList,
  PlainStream,
  Serialization;

type
  TTextItemSerialize<T> = class(TInterfacedObject, IItemSerialize<T>)
  strict private
    _ItemSerialize: IItemSerialize<T>;
  public
    function Decompose(const Item: T): WideString;
    function Compose(const Text: WideString): T;
    constructor Create(const ItemSerialize: IItemSerialize<T>);
    class function New(const ItemSerialize: IItemSerialize<T>): IItemSerialize<T>;
  end;

  TTextListSerialize<T> = class(TInterfacedObject, IListSerialize<T>)
  strict private
    _ItemSerialize: IItemSerialize<T>;
  public
    function Decompose(const List: IIterableList<T>): WideString;
    function Compose(const Text: WideString; const List: IIterableList<T>): Boolean;
    constructor Create(const ItemSerialize: IItemSerialize<T>);
    class function New(const ItemSerialize: IItemSerialize<T>): IListSerialize<T>;
  end;

  TTextSerialization<T> = class(TInterfacedObject, ISerialization<T>)
  strict private
    _ItemSerialize: IItemSerialize<T>;
    _ListSerialize: IListSerialize<T>;
  public
    function Decompose(const Item: T): WideString;
    function Compose(const Text: WideString): T;
    function ComposeFromStream(const Stream: TStream): T;
    function ListDecompose(const List: IIterableList<T>): WideString;
    function ListCompose(const Text: WideString; const List: IIterableList<T>): Boolean;
    function ListComposeFromStream(const Stream: TStream; const List: IIterableList<T>): Boolean;
    constructor Create(const ItemSerialize: IItemSerialize<T>);
    class function New(const ItemSerialize: IItemSerialize<T>): ISerialization<T>;
  end;

implementation

{ TTextItemSerialize<T> }

function TTextItemSerialize<T>.Decompose(const Item: T): WideString;
begin
  if TValue.From<T>(Item).IsEmpty then
    Result := EmptyStr
  else
    Result := _ItemSerialize.Decompose(Item);
end;

function TTextItemSerialize<T>.Compose(const Text: WideString): T;
begin
  if Length(Trim(Text)) < 1 then
    Result := Default (T)
  else
    Result := _ItemSerialize.Compose(Text);
end;

constructor TTextItemSerialize<T>.Create(const ItemSerialize: IItemSerialize<T>);
begin
  _ItemSerialize := ItemSerialize;
end;

class function TTextItemSerialize<T>.New(const ItemSerialize: IItemSerialize<T>): IItemSerialize<T>;
begin
  Result := TTextItemSerialize<T>.Create(ItemSerialize);
end;

{ TTextListSerialize<T> }

function TTextListSerialize<T>.Decompose(const List: IIterableList<T>): WideString;
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

function TTextListSerialize<T>.Compose(const Text: WideString; const List: IIterableList<T>): Boolean;
begin
// TODO:
end;

constructor TTextListSerialize<T>.Create(const ItemSerialize: IItemSerialize<T>);
begin
  _ItemSerialize := ItemSerialize;
end;

class function TTextListSerialize<T>.New(const ItemSerialize: IItemSerialize<T>): IListSerialize<T>;
begin
  Result := TTextListSerialize<T>.Create(ItemSerialize);
end;

{ TTextSerialization<T> }

function TTextSerialization<T>.Decompose(const Item: T): WideString;
begin
  Result := _ItemSerialize.Decompose(Item);
end;

function TTextSerialization<T>.Compose(const Text: WideString): T;
begin
  Result := _ItemSerialize.Compose(Text);
end;

function TTextSerialization<T>.ComposeFromStream(const Stream: TStream): T;
begin
  Result := Compose(TPlainStream.New.Decode(Stream));
end;

function TTextSerialization<T>.ListDecompose(const List: IIterableList<T>): WideString;
begin
  Result := _ListSerialize.Decompose(List);
end;

function TTextSerialization<T>.ListCompose(const Text: WideString; const List: IIterableList<T>): Boolean;
begin
  // TODO:
end;

function TTextSerialization<T>.ListComposeFromStream(const Stream: TStream; const List: IIterableList<T>): Boolean;
begin
  Result := ListCompose(TPlainStream.New.Decode(Stream), List);
end;

constructor TTextSerialization<T>.Create(const ItemSerialize: IItemSerialize<T>);
begin
  _ItemSerialize := TTextItemSerialize<T>.New(ItemSerialize);
  _ListSerialize := TTextListSerialize<T>.New(_ItemSerialize);
end;

class function TTextSerialization<T>.New(const ItemSerialize: IItemSerialize<T>): ISerialization<T>;
begin
  Result := TTextSerialization<T>.Create(ItemSerialize);
end;

end.
