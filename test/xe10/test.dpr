{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
program test;

uses
  RunTest,
  JSONDataTypeSerialization in '..\..\code\JSONDataTypeSerialization.pas',
  JSONSerialization in '..\..\code\JSONSerialization.pas',
  Serialization in '..\..\code\Serialization.pas',
  XMLDataTypeSerialization in '..\..\code\XMLDataTypeSerialization.pas',
  XMLSerialization in '..\..\code\XMLSerialization.pas',
  JSONDataTypeSerialization_test in '..\code\JSONDataTypeSerialization_test.pas',
  JSONSerialization_test in '..\code\JSONSerialization_test.pas',
  XMLDataTypeSerialization_test in '..\code\XMLDataTypeSerialization_test.pas',
  TestObject in '..\code\entity\TestObject.pas',
  TestObjectJSON in '..\code\entity\serialization\TestObjectJSON.pas';

{ R *.RES }

begin
  Run;

end.
