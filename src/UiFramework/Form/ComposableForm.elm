module UiFramework.Form.ComposableForm exposing (..)


import Form.Base as Base
import Form.Error exposing (Error)
import Form.Field as Field
import UiFramework.Form.CheckboxField as CheckboxField
import UiFramework.Form.NumberField as NumberField
import UiFramework.Form.RadioField as RadioField
import UiFramework.Form.RangeField as RangeField
import UiFramework.Form.SelectField as SelectField
import UiFramework.Form.TextField as TextField


type alias Form values output =
    Base.Form values output (Field values)


type Field values
    = Text TextType (TextField.TextField values) -- add more field
    | Checkbox (CheckboxField.CheckboxField values)
    | Select (SelectField.SelectField values)
    | Number (NumberField.NumberField values)
    | Range (RangeField.RangeField values)
    | Radio (RadioField.RadioField values)
    | Group (List (FilledField values))


type TextType
    = TextRaw
    | TextEmail
    | TextPassword
    | TextArea
    | TextSearch


type alias FilledField values =
    Base.FilledField (Field values)


fill :
    Form values output
    -> values
    ->
        { fields : List (FilledField values)
        , result : Result ( Error, List Error ) output
        , isEmpty : Bool
        }
fill =
    Base.fill


succeed : output -> Form values output
succeed =
    Base.succeed


append : Form values a -> Form values (a -> b) -> Form values b
append =
    Base.append


optional : Form values output -> Form values (Maybe output)
optional =
    Base.optional


disable : Form values output -> Form values output
disable =
    Base.disable


andThen : (a -> Form values b) -> Form values a -> Form values b
andThen =
    Base.andThen


meta : (values -> Form values output) -> Form values output
meta =
    Base.meta


map : (a -> b) -> Form values a -> Form values b
map =
    Base.map


mapValues : { value : a -> b, update : b -> a -> a } -> Form b output -> Form a output
mapValues { value, update } form =
    Base.meta
        (\values ->
            form
                |> Base.mapValues value
                |> Base.mapField (mapFieldValues update values)
        )


mapFieldValues : (a -> b -> b) -> b -> Field a -> Field b
mapFieldValues update values field =
    let
        newUpdate oldValues =
            update oldValues values
    in
    case field of
        Text textType field_ ->
            Text textType (Field.mapValues newUpdate field_)

        Number field_ ->
            Number (Field.mapValues newUpdate field_)

        Range field_ ->
            Range (Field.mapValues newUpdate field_)

        Checkbox field_ ->
            Checkbox (Field.mapValues newUpdate field_)

        Radio field_ ->
            Radio (Field.mapValues newUpdate field_)

        Select field_ ->
            Select (Field.mapValues newUpdate field_)

        Group fields ->
            Group
                (List.map
                    (\filledField ->
                        { state = mapFieldValues update values filledField.state
                        , error = filledField.error
                        , isDisabled = filledField.isDisabled
                        }
                    )
                    fields
                )


textField :
    { parser : String -> Result String output
    , value : values -> String
    , update : String -> values -> values
    , error : values -> Maybe String
    , attributes : TextField.Attributes
    }
    -> Form values output
textField =
    TextField.form (Text TextRaw)


emailField :
    { parser : String -> Result String output
    , value : values -> String
    , update : String -> values -> values
    , error : values -> Maybe String
    , attributes : TextField.Attributes
    }
    -> Form values output
emailField =
    TextField.form (Text TextEmail)


passwordField :
    { parser : String -> Result String output
    , value : values -> String
    , update : String -> values -> values
    , error : values -> Maybe String
    , attributes : TextField.Attributes
    }
    -> Form values output
passwordField =
    TextField.form (Text TextPassword)


textareaField :
    { parser : String -> Result String output
    , value : values -> String
    , update : String -> values -> values
    , error : values -> Maybe String
    , attributes : TextField.Attributes
    }
    -> Form values output
textareaField =
    TextField.form (Text TextArea)


searchField :
    { parser : String -> Result String output
    , value : values -> String
    , update : String -> values -> values
    , error : values -> Maybe String
    , attributes : TextField.Attributes
    }
    -> Form values output
searchField =
    TextField.form (Text TextSearch)


numberField :
    { parser : String -> Result String output
    , value : values -> String
    , update : String -> values -> values
    , error : values -> Maybe String
    , attributes : NumberField.Attributes
    }
    -> Form values output
numberField =
    NumberField.form Number


rangeField :
    { parser : Float -> Result String output
    , value : values -> Float
    , update : Float -> values -> values
    , error : values -> Maybe String
    , attributes : RangeField.Attributes
    }
    -> Form values output
rangeField =
    RangeField.form Range


checkboxField :
    { parser : Bool -> Result String output
    , value : values -> Bool
    , update : Bool -> values -> values
    , error : values -> Maybe String
    , attributes : CheckboxField.Attributes
    }
    -> Form values output
checkboxField =
    CheckboxField.form Checkbox


radioField :
    { parser : String -> Result String output
    , value : values -> String
    , update : String -> values -> values
    , error : values -> Maybe String
    , attributes : RadioField.Attributes
    }
    -> Form values output
radioField =
    RadioField.form Radio


selectField :
    { parser : String -> Result String output
    , value : values -> String
    , update : String -> values -> values
    , error : values -> Maybe String
    , attributes : SelectField.Attributes
    }
    -> Form values output
selectField =
    SelectField.form Select
