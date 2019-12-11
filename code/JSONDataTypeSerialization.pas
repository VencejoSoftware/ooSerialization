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
  Serialization,
  JSONSerialization;

type
{$REGION 'documentation'}
{
  @abstract(JSON text data type serialization interface)
}
{$ENDREGION}
  IJSONText = interface(IItemSerialize<WideString>)
    ['{F47F2BB4-6406-4822-9031-4F42F9E71FCE}']
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IJSONText))
  @member(
    Decompose Converts strig data type to JSON WideString
    @param(Text WideString value)
    @return(JSON representation WideString)
  )
  @member(
    Compose Converts JSON text data type to WideString
    @param(JSONText JSON WideString)
    @return(WideString data type)
  )
  @member(
    Create Object contructor
    @param(AddQuotes Add quotes to value)
    @param(EmptyAsNull If is an empty date then return null)
  )
  @member(
    New Create a new @classname as interface
    @param(AddQuotes Add quotes to value)
    @param(EmptyAsNull If is an empty date then return null)
  )
}
{$ENDREGION}

  TJSONText = class sealed(TInterfacedObject, IJSONText)
  strict private
    _AddQuotes, _EmptyAsNull: Boolean;
  public
    function Decompose(const Text: WideString): WideString;
    function Compose(const JSONText: WideString): WideString;
    constructor Create(const AddQuotes, EmptyAsNull: Boolean);
    class function New(const AddQuotes, EmptyAsNull: Boolean): IJSONText;
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
    @return(WideString with data type decomposed)
  )
  @member(
    Compose Converts JSON boolean WideString to WideString data type
    @param(JSONBoolean Transportable WideString)
    @return(Boolean data type)
  )
  @member(New Create a new @classname as interface)
}
{$ENDREGION}

  TJSONBoolean = class sealed(TInterfacedObject, IJSONBoolean)
  public
    function Decompose(const Bool: Boolean): WideString;
    function Compose(const JSONBoolean: WideString): Boolean;
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
    Decompose Converts date/time data type to JSON ISO8601 WideString
    @param(DateTime date/time value)
    @return(WideString with JSON data type decomposed)
  )
  @member(
    Compose Converts transportable WideString to JSON date/time data type
    @param(JSONDateTime JSON ISO8601 WideString)
    @return(Date/time data type)
  )
  @member(
    Create Object contructor
    @param(AddQuotes Add quotes to value)
    @param(EmptyAsNull If is an empty date then return null)
  )
  @member(
    New Create a new @classname as interface
    @param(AddQuotes Add quotes to value)
    @param(EmptyAsNull If is an empty date then return null)
  )
}
{$ENDREGION}

  TJSONDateTimeISO8601 = class sealed(TInterfacedObject, IJSONDateTime)
  strict private
    _AddQuotes, _EmptyAsNull: Boolean;
  public
    function Decompose(const DateTime: TDateTime): WideString;
    function Compose(const JSONDateTime: WideString): TDateTime;
    constructor Create(const AddQuotes, EmptyAsNull: Boolean);
    class function New(const AddQuotes, EmptyAsNull: Boolean): IJSONDateTime;
  end;

implementation

{ TJSONText }

function TJSONText.Decompose(const Text: WideString): WideString;
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

function TJSONText.Compose(const JSONText: WideString): WideString;
begin
  Result := JSONText;
  if (Length(Trim(Result)) < 1) and _EmptyAsNull then
    Exit(NULL_RESULT);
  Result := StringReplace(Result, '\', '\\', [rfReplaceAll]);
  Result := StringReplace(Result, #8, '\b', [rfReplaceAll]);
  Result := StringReplace(Result, #9, '\t', [rfReplaceAll]);
  Result := StringReplace(Result, #12, '\f', [rfReplaceAll]);
  Result := StringReplace(Result, #13, '\r', [rfReplaceAll]);
  Result := StringReplace(Result, #10, '\n', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '\"', [rfReplaceAll]);
  Result := StringReplace(Result, '/', '\/', [rfReplaceAll]);
  if _AddQuotes then
    Result := '"' + Result + '"';
end;

constructor TJSONText.Create(const AddQuotes, EmptyAsNull: Boolean);
begin
  _AddQuotes := AddQuotes;
  _EmptyAsNull := EmptyAsNull;
end;

class function TJSONText.New(const AddQuotes, EmptyAsNull: Boolean): IJSONText;
begin
  Result := TJSONText.Create(AddQuotes, EmptyAsNull);
end;

{ TJSONBoolean }

function TJSONBoolean.Decompose(const Bool: Boolean): WideString;
const
  BOOLEAN_TEXT: array [Boolean] of WideString = ('false', 'true');
begin
  Result := BOOLEAN_TEXT[Bool];
end;

function TJSONBoolean.Compose(const JSONBoolean: WideString): Boolean;
begin
  Result := SameText('true', JSONBoolean);
end;

class function TJSONBoolean.New: IJSONBoolean;
begin
  Result := TJSONBoolean.Create;
end;

{ TJSONDateTimeISO8601 }

function TJSONDateTimeISO8601.Decompose(const DateTime: TDateTime): WideString;
begin
  if (DateTime = 0) and _EmptyAsNull then
    Exit(NULL_RESULT);
  Result := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', DateTime);
  if _AddQuotes then
    Result := '"' + Result + '"';
end;

function TJSONDateTimeISO8601.Compose(const JSONDateTime: WideString): TDateTime;
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

constructor TJSONDateTimeISO8601.Create(const AddQuotes, EmptyAsNull: Boolean);
begin
  _AddQuotes := AddQuotes;
  _EmptyAsNull := EmptyAsNull;
end;

class function TJSONDateTimeISO8601.New(const AddQuotes, EmptyAsNull: Boolean): IJSONDateTime;
begin
  Result := TJSONDateTimeISO8601.Create(AddQuotes, EmptyAsNull);
end;

end.
