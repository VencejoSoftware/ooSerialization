[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![Build Status](https://travis-ci.org/VencejoSoftware/ooBytes.svg?branch=master)](https://travis-ci.org/VencejoSoftware/ooBytes)

# ooSerialization - Object pascal serialization library
Library to objects serialization

### Example of a set, scale and format
```pascal
var
  Bytes: IBytes;
  BytesScale: IBytesScale;
begin
  Bytes := TBytes.New(1024);
  BytesScale := TBytesScale.New(Bytes);
  ShowMessage(TBytesText.New(BytesScale).Build(BytesScale.FitScaleUnit));
end;
```

### Documentation
If not exists folder "code-documentation" then run the batch "build_doc". The main entry is ./doc/index.html

### Demo
Before all, run the batch "build_demo" to build proyect. Then go to the folder "demo\build\release\" and run the executable.

## Built With
* [Delphi&reg;](https://www.embarcadero.com/products/rad-studio) - Embarcadero&trade; commercial IDE
* [Lazarus](https://www.lazarus-ide.org/) - The Lazarus project

## Contribute
This are an open-source project, and they need your help to go on growing and improving.
You can even fork the project on GitHub, maintain your own version and send us pull requests periodically to merge your work.

## Authors
* **Alejandro Polti** (Vencejo Software team lead) - *Initial work*