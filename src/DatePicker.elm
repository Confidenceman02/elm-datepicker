module DatePicker exposing (Msg, view)

import Html.Styled exposing (Html)
import Internal.SelectInput as SelectInput


type Msg
    = InputChanged (Maybe Int)


update : Msg -> Cmd Msg
update _ =
    Cmd.none


view : Html Msg
view =
    SelectInput.view SelectInput.default "someId"
