{
  Copyright (c) 2019, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
program test;

uses
  RunTest,
  JSONSerialization in '..\..\code\JSONSerialization.pas',
  Serialization in '..\..\code\Serialization.pas',
  TextSerialization in '..\..\code\TextSerialization.pas',
  XMLSerialization in '..\..\code\XMLSerialization.pas',
  JSONDataTypeSerialization in '..\..\code\JSONDataTypeSerialization.pas',
  JSONDataTypeSerialization_test in '..\code\JSONDataTypeSerialization_test.pas',
  XMLDataTypeSerialization in '..\..\code\XMLDataTypeSerialization.pas',
  XMLDataTypeSerialization_test in '..\code\XMLDataTypeSerialization_test.pas',
  JSONSerialization_test in '..\code\JSONSerialization_test.pas',
  TestObject in '..\code\entity\TestObject.pas',
  TestObjectJSON in '..\code\entity\serialization\TestObjectJSON.pas';

{R *.RES}

begin
  Run;

end.
