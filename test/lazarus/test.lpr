{
  Copyright (c) 2018 Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
program test;

uses
  RunTest,
  ByteCast in '..\..\code\ByteCast.pas',
  BytesText in '..\..\code\BytesText.pas',
  Bytes in '..\..\code\Bytes.pas',
  BytesScale in '..\..\code\BytesScale.pas',
  BytesByteFromInteger_test in '..\code\BytesByteFromInteger_test.pas',
  BytesScale_test in '..\code\BytesScale_test.pas',
  BytesText_test in '..\code\BytesText_test.pas';

{R *.RES}

begin
  Run;

end.
