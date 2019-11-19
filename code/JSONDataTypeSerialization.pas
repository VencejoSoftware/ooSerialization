{$REGION 'documentation'}
{
  Copyright (c) 2019, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  JSON data type serialization
  @created(20/06/2019)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit JSONDataTypeSerialization;

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
  IJSONText = interface(IItemSerialize<String>)
    ['{F47F2BB4-6406-4822-9031-4F42F9E71FCE}']
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IJSONText))
  @member(
    Decompose Converts strig data type to JSON string
    @param(Text String value)
    @return(JSON representation string)
  )
  @member(
    Compose Converts JSON text data type to string
    @param(JSONText JSON string)
    @return(String data type)
  )
  @member(New Create a new @classname as interface)
}
{$ENDREGION}

  TJSONText = class sealed(TInterfacedObject, IJSONText)
  public
    function Decompose(const Text: String): String;
    function Compose(const JSONText: String): String;
    class function New: IJSONText;
  end;

{$REGION 'documentation'}
{
  @abstract(JSON boolean data type serialization interface)
}
{$ENDREGION}

  IJSONBoolean = interface(IItemSerialize<Boolean>)
    ['{B91233FB-429D-4DB1-9F52-2A3AAD8E732F}']
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IJSONBoolean))
  @member(
    Decompose Converts boolean data type to JSON boolean represntation
    @param(Bool Boolean value)
    @return(String with data type decomposed)
  )
  @member(
    Compose Converts JSON boolean string to string data type
    @param(JSONBoolean Transportable string)
    @return(Boolean data type)
  )
  @member(New Create a new @classname as interface)
}
{$ENDREGION}

  TJSONBoolean = class sealed(TInterfacedObject, IJSONBoolean)
  public
    function Decompose(const Bool: Boolean): String;
    function Compose(const JSONBoolean: String): Boolean;
    class function New: IJSONBoolean;
  end;

{$REGION 'documentation'}
{
  @abstract(JSON date/time data type serialization interface)
}
{$ENDREGION}

  IJSONDateTime = interface(IItemSerialize<TDateTime>)
    ['{F23B486E-755C-406E-945C-7B3A1AD6C8DD}']
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IJSONDateTime))
  @member(
    Decompose Converts date/time data type to JSON ISO8601 string
    @param(DateTime date/time value)
    @return(String with JSON data type decomposed)
  )
  @member(
    Compose Converts transportable string to JSON date/time data type
    @param(JSONDateTime JSON ISO8601 string)
    @return(Date/time data type)
  )
  @member(New Create a new @classname as interface)
}
{$ENDREGION}

  TJSONDateTimeISO8601 = class sealed(TInterfacedObject, IJSONDateTime)
  public
    function Decompose(const DateTime: TDateTime): String;
    function Compose(const JSONDateTime: String): TDateTime;
    class function New: IJSONDateTime;
  end;

implementation

{ TJSONText }

function TJSONText.Decompose(const Text: String): String;
begin
  Result := Text;
  Result := StringReplace(Result, '\\', '\', [rfReplaceAll]);
  Result := StringReplace(Result, '\b', #8, [rfReplaceAll]);
  Result := StringReplace(Result, '\t', #9, [rfReplaceAll]);
  Result := StringReplace(Result, '\f', #12, [rfReplaceAll]);
  Result := StringReplace(Result, '\r', #13, [rfReplaceAll]);
  Result := StringReplace(Result, '\n', #10, [rfReplaceAll]);
  Result := StringReplace(Result, '\"', '"', [rfReplaceAll]);
  Result := StringReplace(Result, '\/', '/', [rfReplaceAll]);
end;

function TJSONText.Compose(const JSONText: String): String;
begin
  Result := JSONText;
  Result := StringReplace(Result, '\', '\\', [rfReplaceAll]);
  Result := StringReplace(Result, #8, '\b', [rfReplaceAll]);
  Result := StringReplace(Result, #9, '\t', [rfReplaceAll]);
  Result := StringReplace(Result, #12, '\f', [rfReplaceAll]);
  Result := StringReplace(Result, #13, '\r', [rfReplaceAll]);
  Result := StringReplace(Result, #10, '\n', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '\"', [rfReplaceAll]);
  Result := StringReplace(Result, '/', '\/', [rfReplaceAll]);
end;

class function TJSONText.New: IJSONText;
begin
  Result := TJSONText.Create;
end;

{ TJSONBoolean }

function TJSONBoolean.Decompose(const Bool: Boolean): String;
const
  BOOLEAN_TEXT: array [Boolean] of string = ('false', 'true');
begin
  Result := BOOLEAN_TEXT[Bool];
end;

function TJSONBoolean.Compose(const JSONBoolean: String): Boolean;
begin
  Result := SameText('true', JSONBoolean);
end;

class function TJSONBoolean.New: IJSONBoolean;
begin
  Result := TJSONBoolean.Create;
end;

{ TJSONDateTimeISO8601 }

function TJSONDateTimeISO8601.Decompose(const DateTime: TDateTime): String;
begin
  Result := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', DateTime);
end;

function TJSONDateTimeISO8601.Compose(const JSONDateTime: String): TDateTime;
var
  Year, Month, Day, Hour, Minute, Second, MSecond: Word;
begin
  Year := StrToInt(Copy(JSONDateTime, 1, 4));
  Month := StrToInt(Copy(JSONDateTime, 6, 2));
  Day := StrToInt(Copy(JSONDateTime, 9, 2));
  Hour := StrToInt(Copy(JSONDateTime, 12, 2));
  Minute := StrToInt(Copy(JSONDateTime, 15, 2));
  Second := StrToInt(Copy(JSONDateTime, 18, 2));
  MSecond := StrToInt(Copy(JSONDateTime, 21, 3));
  Result := EncodeDate(Year, Month, Day) + EncodeTime(Hour, Minute, Second, MSecond);
end;

class function TJSONDateTimeISO8601.New: IJSONDateTime;
begin
  Result := TJSONDateTimeISO8601.Create;
end;

end.
