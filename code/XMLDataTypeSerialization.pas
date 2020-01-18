{$REGION 'documentation'}
{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  XML Data type serialization
  @created(20/06/2019)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit XMLDataTypeSerialization;

interface

uses
  SysUtils,
  Serialization;

type
{$REGION 'documentation'}
{
  @abstract(JSON text data type serialization interface)
}
{$ENDREGION}
  IXMLText = interface(IItemSerialize<WideString>)
    ['{5A2E68FD-A06F-44BB-B13D-D97BF150EBC3}']
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IXMLText))
  @member(
    Decompose Converts XML text data type to transportable WideString
    @param(Text XML text)
    @return(WideString with data type decomposed)
  )
  @member(
    Compose Converts transportable WideString to XML text data type
    @param(Value Transportable WideString)
    @return(XML WideString data type)
  )
  @member(New Create a new @classname as interface)
}
{$ENDREGION}

  TXMLText = class sealed(TInterfacedObject, IXMLText)
  public
    function Decompose(const Text: WideString): WideString;
    function Compose(const Value: WideString): WideString;
    class function New: IXMLText;
  end;

{$REGION 'documentation'}
{
  @abstract(XML date/time data type serialization interface)
}
{$ENDREGION}

  IXMLDateTime = interface(IItemSerialize<TDateTime>)
    ['{459EAA95-BED4-4BFB-AF85-8E2A0DBE11F8}']
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IXMLDateTime))
  @member(
    Decompose Converts XML date/time data type to transportable WideString
    @param(DateTime XML date/time)
    @return(WideString with data type decomposed)
  )
  @member(
    Compose Converts transportable WideString to XML date/time data type
    @param(Value Transportable WideString)
    @return(XML date/time data type)
  )
  @member(New Create a new @classname as interface)
}
{$ENDREGION}

  TXMLDateTime = class sealed(TInterfacedObject, IXMLDateTime)
  public
    function Decompose(const DateTime: TDateTime): WideString;
    function Compose(const Value: WideString): TDateTime;
    class function New: IXMLDateTime;
  end;

implementation

{ TXMLText }

function TXMLText.Decompose(const Text: WideString): WideString;
begin
  Result := Text;
  Result := StringReplace(Result, '&amp;', '&', [rfReplaceAll]);
  Result := StringReplace(Result, '&quot;', '"', [rfReplaceAll]);
  Result := StringReplace(Result, '&apos;', '''', [rfReplaceAll]);
  Result := StringReplace(Result, '&lt;', '<', [rfReplaceAll]);
  Result := StringReplace(Result, '&gt;', '>', [rfReplaceAll]);
  Result := StringReplace(Result, '&#13;', #13, [rfReplaceAll]);
  Result := StringReplace(Result, '&#10;', #10, [rfReplaceAll]);
end;

function TXMLText.Compose(const Value: WideString): WideString;
begin
  Result := Value;
  Result := StringReplace(Result, '&', '&amp;', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll]);
  Result := StringReplace(Result, '''', '&apos;', [rfReplaceAll]);
  Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll]);
  Result := StringReplace(Result, '>', '&gt;', [rfReplaceAll]);
  Result := StringReplace(Result, #13, '&#13;', [rfReplaceAll]);
  Result := StringReplace(Result, #10, '&#10;', [rfReplaceAll]);
end;

class function TXMLText.New: IXMLText;
begin
  Result := TXMLText.Create;
end;

{ TXMLDateTime }

function TXMLDateTime.Decompose(const DateTime: TDateTime): WideString;
begin
  Result := FormatDateTime('yyyy-MM-dd"T"hh:nn:ss', DateTime);
end;

function TXMLDateTime.Compose(const Value: WideString): TDateTime;
var
  Year, Month, Day, Hour, Minute, Second: Word;
begin
  Year := StrToInt(Copy(Value, 1, 4));
  Month := StrToInt(Copy(Value, 6, 2));
  Day := StrToInt(Copy(Value, 9, 2));
  Hour := StrToInt(Copy(Value, 12, 2));
  Minute := StrToInt(Copy(Value, 15, 2));
  Second := StrToInt(Copy(Value, 18, 2));
  Result := EncodeDate(Year, Month, Day) + EncodeTime(Hour, Minute, Second, 0);
end;

class function TXMLDateTime.New: IXMLDateTime;
begin
  Result := TXMLDateTime.Create;
end;

end.
