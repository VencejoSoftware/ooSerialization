{
  Copyright (c) 2019, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit TestObjectJSON;

interface

uses
  SysUtils,
  JSON, JSONDataTypeSerialization,
  Serialization, JSONSerialization,
  TestObject;

type
  TTestObjectJSONItem = class sealed(TInterfacedObject, IItemSerialize<ITestObject>)
  strict private
    _JSONText: IJSONText;
    _JSONDateTime: IJSONDateTime;
    _JSONBoolean: IJSONBoolean;
  public
    function Decompose(const Item: ITestObject): String;
    function Compose(const Text: String): ITestObject;
    constructor Create;
    class function New: IItemSerialize<ITestObject>;
  end;

  ITestObjectSerialization = interface(ISerialization<ITestObject>)
    ['{033E8E93-193C-4B1F-BF7E-396BA7C536DB}']
  end;

  TTestObjectJSON = class sealed(TJSONSerialization<ITestObject>, ITestObjectSerialization)
  public
    class function New: ITestObjectSerialization;
  end;

implementation

function TTestObjectJSONItem.Decompose(const Item: ITestObject): String;
const
  ITEM_TEMPLATE = '{"id":%d,"name":"%s","dateTime":"%s","enabled":"%s"}';
begin
  Result := Format(ITEM_TEMPLATE, [Item.ID, _JSONText.Decompose(Item.Name), _JSONDateTime.Decompose(Item.DateTime),
    _JSONBoolean.Decompose(Item.Enabled)]);
end;

function TTestObjectJSONItem.Compose(const Text: String): ITestObject;
var
  JSonValue: TJSonValue;
  DateTime: TDateTime;
  Enabled: Boolean;
begin
  JSonValue := TJSonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Text), 0);
  try
    DateTime := _JSONDateTime.Compose(JSonValue.GetValue<string>('dateTime'));
    Enabled := _JSONBoolean.Compose(JSonValue.GetValue<string>('enabled'));
    Result := TTestObject.New(JSonValue.GetValue<integer>('id'), JSonValue.GetValue<string>('name'), DateTime, Enabled);
  finally
    JSonValue.Free;
  end;
end;

constructor TTestObjectJSONItem.Create;
begin
  _JSONText := TJSONText.New;
  _JSONDateTime := TJSONDateTimeISO8601.New;
  _JSONBoolean := TJSONBoolean.New;
end;

class function TTestObjectJSONItem.New: IItemSerialize<ITestObject>;
begin
  Result := TTestObjectJSONItem.Create;
end;

{ TTestObjectJSON }

class function TTestObjectJSON.New: ITestObjectSerialization;
begin
  Result := TTestObjectJSON.Create(TTestObjectJSONItem.New);
end;

end.
