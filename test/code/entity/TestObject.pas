{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit TestObject;

interface

uses
  SysUtils,
  IterableList;

type
  ITestObject = interface
    ['{5E0E69CF-D1FB-450A-8DFE-BBFD948AB1C8}']
    function ID: NativeUInt;
    function Name: String;
    function DateTime: TDateTime;
    function Enabled: Boolean;
  end;

  TTestObject = class sealed(TInterfacedObject, ITestObject)
  strict private
    _ID: NativeUInt;
    _Name: String;
    _DateTime: TDateTime;
    _Enabled: Boolean;
  public
    function ID: NativeUInt;
    function Name: String;
    function DateTime: TDateTime;
    function Enabled: Boolean;
    constructor Create(const ID: NativeUInt; const Name: String; const DateTime: TDateTime; const Enabled: Boolean);
    class function New(const ID: NativeUInt; const Name: String; const DateTime: TDateTime; const Enabled: Boolean)
      : ITestObject;
  end;

  ITestObjectList = interface(IIterableList<ITestObject>)
    ['{7BE0D9E7-D971-4511-8EE3-0693D3ECB9CD}']
  end;

  TTestObjectList = class sealed(TIterableList<ITestObject>, ITestObjectList)
  public
    class function New: ITestObjectList;
  end;

implementation

{ TTestObject }

function TTestObject.ID: NativeUInt;
begin
  Result := _ID;
end;

function TTestObject.Name: String;
begin
  Result := _Name;
end;

function TTestObject.DateTime: TDateTime;
begin
  Result := _DateTime;
end;

function TTestObject.Enabled: Boolean;
begin
  Result := _Enabled;
end;

constructor TTestObject.Create(const ID: NativeUInt; const Name: String; const DateTime: TDateTime;
  const Enabled: Boolean);
begin
  _ID := ID;
  _Name := Name;
  _DateTime := DateTime;
  _Enabled := Enabled;
end;

class function TTestObject.New(const ID: NativeUInt; const Name: String; const DateTime: TDateTime;
  const Enabled: Boolean): ITestObject;
begin
  Result := TTestObject.Create(ID, Name, DateTime, Enabled);
end;

{ TTestObjectList }

class function TTestObjectList.New: ITestObjectList;
begin
  Result := TTestObjectList.Create;
end;

end.
