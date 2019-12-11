{$REGION 'documentation'}
{
  Copyright (c) 2019, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Interfaces for objects serialization
  @created(20/06/2019)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit Serialization;

interface

uses
  IterableList;

type
{$REGION 'documentation'}
{
  @abstract(Generic interface for single item serialization)
  @member(
    Decompose Converts generic item to transportable string
    @param(Item Generic item)
    @return(String with generic item decomposed)
  )
  @member(
    Compose Converts transportable string to generic item
    @param(Text Transportable string)
    @return(Builded object)
  )
}
{$ENDREGION}
  IItemSerialize<T> = interface
    ['{7049511F-9979-4731-89FA-45581293CFC8}']
    function Decompose(const Item: T): WideString;
    function Compose(const Text: WideString): T;
  end;

{$REGION 'documentation'}
{
  @abstract(Generic interface for object list serialization)
  @member(
    Decompose Converts objects list to transportable WideString
    @param(Item Generic objects list)
    @return(WideString with objects list decomposed)
  )
  @member(
    Compose Converts transportable WideString to objects list
    @param(Text Transportable WideString)
    @param(List objects list to populate)
    @return(@true if list is populated, @false if not)
  )
}
{$ENDREGION}

  IListSerialize<T> = interface
    ['{12C3E341-2FC5-4171-A389-32E4AC70BDA5}']
    function Decompose(const List: IIterableList<T>): WideString;
    function Compose(const Text: WideString; const List: IIterableList<T>): Boolean;
  end;

{$REGION 'documentation'}
{
  @abstract(Generic interface for objects serialization)
  @member(
    Serialize Converts generic item to transportable WideString implementing an @link(item serialization factory IItemSerialize<T>)
    @param(Item Generic item)
    @return(WideString with generic item decomposed)
  )
  @member(
    Deserialize Converts transportable WideString to generic item implementing an @link(item serialization factory IItemSerialize<T>)
    @param(Value Transportable WideString)
    @return(Builded object)
  )
  @member(
    ListSerialize Converts objects list to transportable WideString implementing an @link(item list serialization factory IListSerialize<T>)
    @param(Item Generic objects list)
    @return(WideString with objects list decomposed)
  )
  @member(
    ListDeserialize Converts transportable WideString to objects list
    @param(Text Transportable WideString)
    @param(List objects list to populate)
    @return(@true if list is populated, @false if not)
  )
}
{$ENDREGION}

  ISerialization<T> = interface
    ['{8B09F10B-7C1D-4FAA-B9E9-19A56E9C8E41}']
    function Serialize(const Item: T): WideString;
    function Deserialize(const Text: WideString): T;
    function ListSerialize(const List: IIterableList<T>): WideString;
    function ListDeserialize(const Text: WideString; const List: IIterableList<T>): Boolean;
  end;

implementation

end.
