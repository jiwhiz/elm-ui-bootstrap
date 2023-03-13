module UiFramework.Form.Field exposing (Field, mapValues)


type alias Field attributes value values =
    { value : value
    , update : value -> values
    , attributes : attributes
    }


{-| Transform the `values` of a `Field`.

It can be useful to build your own [`Form.mapValues`](Form#mapValues) function.

-}
mapValues : (a -> b) -> Field attributes value a -> Field attributes value b
mapValues fn { value, update, attributes } =
    { value = value
    , update = update >> fn
    , attributes = attributes
    }
