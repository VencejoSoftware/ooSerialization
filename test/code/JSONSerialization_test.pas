{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit JSONSerialization_test;

interface

uses
  SysUtils,
  TestObject,
  JSONSerialization, TestObjectJSON,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TJSONItemSerializeTest = class sealed(TTestCase)
  const
    JSON_TEXT = '{"id":666,"name":"Named object","dateTime":"2019-06-12T13:14:15.016Z","enabled":"true"}';
  published
    procedure DecomposeObjectReturnText;
    procedure ComposeTextReturnObject;
  end;

implementation

{ TJSONItemSerializeTest }

procedure TJSONItemSerializeTest.ComposeTextReturnObject;
var
  Serialization: ITestObjectSerialization;
  Item: ITestObject;
  DateTime: TDateTime;
begin
  Serialization := TTestObjectJSON.New;
  Item := Serialization.Compose(JSON_TEXT);
  DateTime := EncodeDate(2019, 6, 12) + EncodeTime(13, 14, 15, 16);
  CheckEquals(666, Item.ID);
  CheckEquals('Named object', Item.Name);
  CheckEquals(DateTime, Item.DateTime);
  CheckTrue(Item.Enabled);
end;

procedure TJSONItemSerializeTest.DecomposeObjectReturnText;
var
  Serialization: ITestObjectSerialization;
  Item: ITestObject;
begin
  Serialization := TTestObjectJSON.New;
  Item := TTestObject.New(666, 'Named object', EncodeDate(2019, 6, 12) + EncodeTime(13, 14, 15, 16), True);
  CheckEquals(JSON_TEXT, Serialization.Decompose(Item));
end;

initialization

RegisterTest(TJSONItemSerializeTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
