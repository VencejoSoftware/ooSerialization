unit MainForm;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,
  Bytes, BytesScale, ByteCast, BytesText;

type
  TMainForm = class(TForm)
    Timer1: TTimer;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    function FileNameTest: string;
  end;

var
  NewMainForm: TMainForm;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

procedure TMainForm.Button1Click(Sender: TObject);
begin
  Timer1.Enabled := not Timer1.Enabled;
end;

function FileSize(const Filename: string): int64;
var
  Info: TWin32FileAttributeData;
begin
  Result := - 1;
{$IFDEF FPC}
  if GetFileAttributesEx(PChar(Filename), GetFileExInfoStandard, @Info) then
    Result := int64(Info.nFileSizeLow) or int64(Info.nFileSizeHigh shl 32);
{$ELSE}
  if GetFileAttributesEx(PWideChar(Filename), GetFileExInfoStandard, @Info) then
    Result := int64(Info.nFileSizeLow) or int64(Info.nFileSizeHigh shl 32);
{$ENDIF}
end;

function TMainForm.FileNameTest: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  Result := Result + 'filetest.txt';
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if FileExists(FileNameTest) then
    DeleteFile(FileNameTest);
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
  StringList: TStringList;
  Bytes: IBytes;
  BytesScale: IBytesScale;
begin
  StringList := TStringList.Create;
  try
    if FileExists(FileNameTest) then
      StringList.LoadFromFile(FileNameTest);
    StringList.Append('Some loooooooooonnnnnnnggg text line! To increase file sizs');
    Bytes := TBytes.New(FileSize(FileNameTest));
    BytesScale := TBytesScale.New(Bytes);
    Caption := TBytesText.New(BytesScale).Build(BytesScale.FitScaleUnit) + '  ' + TBytesText.New(BytesScale).Build(MB);
    StringList.SaveToFile(FileNameTest);
  finally
    StringList.Free;
  end;
end;

end.
