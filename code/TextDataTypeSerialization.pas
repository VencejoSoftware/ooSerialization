{$REGION 'documentation'}
{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Plaint text data type serialization
  @created(20/06/2019)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit TextDataTypeSerialization;

interface

uses
  Classes, SysUtils, StrUtils,
  Serialization;

type
{$REGION 'documentation'}
{
  @abstract(Plain text date/time data type serialization interface)
}
{$ENDREGION}
  ITextDateTime = interface(IItemSerialize<TDateTime>)
    ['{2C8E9CF9-2FC2-41F2-B5B6-F263F73885BB}']
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IXMLDateTime))
  @member(
    Decompose Converts date/time data type to transportable WideString
    @param(DateTime Date/time)
    @return(WideString with data type decomposed)
  )
  @member(
    Compose Converts transportable WideString to formatted text data type
    @param(Value Transportable WideString)
    @return(Date/time data type)
  )
  @member(New Create a new @classname as interface)
}
{$ENDREGION}

  TTextDateTime = class sealed(TInterfacedObject, ITextDateTime)
  public
    function Decompose(const DateTime: TDateTime): WideString;
    function Compose(const Value: WideString): TDateTime;
    class function New: ITextDateTime;
  end;

implementation

function TTextDateTime.Decompose(const DateTime: TDateTime): WideString;
begin
  Result := FormatDateTime('yyyy-MM-dd hh:nn:ss', DateTime);
end;

function TTextDateTime.Compose(const Value: WideString): TDateTime;
var
  Year, Month, Day, Hour, Minute, Second: Word;
begin
  Year := StrToInt(Copy(Value, 1, 4));
  Month := StrToInt(Copy(Value, 5, 2));
  Day := StrToInt(Copy(Value, 7, 2));
  Hour := StrToInt(Copy(Value, 12, 2));
  Minute := StrToInt(Copy(Value, 16, 2));
  Second := StrToInt(Copy(Value, 18, 2));
  Result := EncodeDate(Year, Month, Day) + EncodeTime(Hour, Minute, Second, 0);
end;

class function TTextDateTime.New: ITextDateTime;
begin
  Result := TTextDateTime.Create;
end;

end.
