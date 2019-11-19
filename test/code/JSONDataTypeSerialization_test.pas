{
  Copyright (c) 2019, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit JSONDataTypeSerialization_test;

interface

uses
  SysUtils,
  JSONDataTypeSerialization,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TJSONTextTest = class sealed(TTestCase)
  published
    procedure ComposeSomethingReturnSomething;
    procedure DecomposeComplexReturnText;
  end;

  TJSONBooleanTest = class sealed(TTestCase)
  published
    procedure ComposeTrueReturnTrueString;
    procedure ComposeFalseReturnFalseString;
    procedure DecomposeTrueReturnTrueString;
    procedure DecomposeFalseReturnFalseString;
  end;

  TJSONDateTimeISO8601Test = class sealed(TTestCase)
  published
    procedure Compose2019_11_10T13_14_15_016ZReturn1011201913141516;
    procedure Decompose1011201913141516Return2019_11_10T13_14_15_016Z;
  end;

implementation

{ TJSONTextTest }

procedure TJSONTextTest.ComposeSomethingReturnSomething;
begin
  CheckEquals('Something\r', TJSONText.New.Compose('Something' + #13));
end;

procedure TJSONTextTest.DecomposeComplexReturnText;
begin
  CheckEquals('"This text / has scape'#9'chars \ end of line"'#13#10,
    TJSONText.New.Decompose('\"This text \/ has scape\tchars \\ end of line\"\r\n'));
end;

{ TJSONBooleanTest }

procedure TJSONBooleanTest.ComposeTrueReturnTrueString;
begin
  CheckEquals(True, TJSONBoolean.New.Compose('True'));
end;

procedure TJSONBooleanTest.ComposeFalseReturnFalseString;
begin
  CheckEquals(False, TJSONBoolean.New.Compose('False'));
end;

procedure TJSONBooleanTest.DecomposeTrueReturnTrueString;
begin
  CheckEquals('true', TJSONBoolean.New.Decompose(True));
end;

procedure TJSONBooleanTest.DecomposeFalseReturnFalseString;
begin
  CheckEquals('false', TJSONBoolean.New.Decompose(False));
end;

{ TJSONDateTimeISO8601Test }

procedure TJSONDateTimeISO8601Test.Compose2019_11_10T13_14_15_016ZReturn1011201913141516;
var
  DateTime: TDateTime;
begin
  DateTime := EncodeDate(2019, 11, 10) + EncodeTime(13, 14, 15, 16);
  CheckEquals(DateTime, TJSONDateTimeISO8601.New.Compose('2019-11-10T13:14:15.016Z'));
end;

procedure TJSONDateTimeISO8601Test.Decompose1011201913141516Return2019_11_10T13_14_15_016Z;
var
  DateTime: TDateTime;
begin
  DateTime := EncodeDate(2019, 11, 10) + EncodeTime(13, 14, 15, 16);
  CheckEquals('2019-11-10T13:14:15.016Z', TJSONDateTimeISO8601.New.Decompose(DateTime));
end;

initialization

RegisterTest(TJSONTextTest {$IFNDEF FPC}.Suite {$ENDIF});
RegisterTest(TJSONBooleanTest {$IFNDEF FPC}.Suite {$ENDIF});
RegisterTest(TJSONDateTimeISO8601Test{$IFNDEF FPC}.Suite {$ENDIF});

end.
