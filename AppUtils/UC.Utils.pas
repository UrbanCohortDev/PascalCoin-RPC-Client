Unit UC.Utils;

Interface

Type
  TEnumHelper = Class

    Class Function IfThen<T { : enum } >(Const AValue: Boolean; Const ATrue: T; Const AFalse: T): T; Static;

  End;

Implementation

{ TucEnumHelpers }

Class Function TEnumHelper.IfThen<T>(Const AValue: Boolean; Const ATrue, AFalse: T): T;
Begin
  If AValue Then
    Result := ATrue
  Else
    Result := AFalse;
End;

End.
