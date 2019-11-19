{
  Copyright (c) 2019, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit XMLDataTypeSerialization_test;

interface

uses
  SysUtils,
  XMLDataTypeSerialization,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TXMLTextTest = class sealed(TTestCase)
  published
    procedure ComposeSomethingReturnSomething;
    procedure DecomposeComplexReturnText;
  end;

  TXMLDateTimeTest = class sealed(TTestCase)
  published
    procedure Compose2019_11_10T13_14_15Return10112019131415;
    procedure Decompose10112019131415Return2019_11_10T13_14_15;
  end;

implementation

{ TXMLTextTest }

procedure TXMLTextTest.ComposeSomethingReturnSomething;
begin
  CheckEquals('&lt;This text &quot; has scape&apos;chars&amp;end of line&quot;&#13;&#10;',
    TXMLText.New.Compose('<This text " has scape''chars&end of line"'#13#10));
end;

procedure TXMLTextTest.DecomposeComplexReturnText;
begin
  CheckEquals('<This text " has scape''chars&end of line"'#13#10,
    TXMLText.New.Decompose
    ('&amp;lt;This text &amp;quot; has scape&amp;apos;chars&amp;end of line&amp;quot;&#13;&#10;'));
end;

{ TXMLDateTimeTest }

procedure TXMLDateTimeTest.Compose2019_11_10T13_14_15Return10112019131415;
var
  DateTime: TDateTime;
begin
  DateTime := EncodeDate(2019, 11, 10) + EncodeTime(13, 14, 15, 0);
  CheckEquals(DateTime, TXMLDateTime.New.Compose('2019-11-10T13:14:15'));
end;

procedure TXMLDateTimeTest.Decompose10112019131415Return2019_11_10T13_14_15;
var
  DateTime: TDateTime;
begin
  DateTime := EncodeDate(2019, 11, 10) + EncodeTime(13, 14, 15, 0);
  CheckEquals('2019-11-10T13:14:15', TXMLDateTime.New.Decompose(DateTime));
end;

initialization

RegisterTest(TXMLTextTest {$IFNDEF FPC}.Suite {$ENDIF});
RegisterTest(TXMLDateTimeTest{$IFNDEF FPC}.Suite {$ENDIF});

end.
