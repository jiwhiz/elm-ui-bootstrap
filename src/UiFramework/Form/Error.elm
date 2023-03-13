module UiFramework.Form.Error exposing (Error(..))


type Error
    = RequiredFieldIsEmpty
    | ValidationFailed String
    | External String
