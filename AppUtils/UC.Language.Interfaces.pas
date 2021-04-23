unit UC.Language.Interfaces;

interface

Type

TLanguageData = record
  Code: String;
  Name: String;
  constructor Create(const AName, ACode: string);
end;

ILanguageManager = Interface
['{7C9DDBF2-8575-4907-A323-1281D2393C71}']
 Function GetLanguagePath: String;
  procedure LoadLanguage(const ALanguageCode: String);
  function GetText(const AKey: String): String;
  property LanguagePath: String Read GetLanguagePath;
End;

ILanguagesSupported = Interface
  ['{D7502A5E-2929-4513-B0CC-9E2D9D570A96}']
function GetLanguages(const Index: Integer): TLanguageData;
  Procedure Load;
  function Count: Integer;
  property Languages[const Index: Integer]: TLanguageData read GetLanguages; Default;
End;

implementation

{ TLanguageData }

constructor TLanguageData.Create(const AName, ACode: string);
begin
  Code := ACode;
  Name := AName;
end;

end.
