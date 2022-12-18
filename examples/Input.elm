module Input exposing (..)

import Browser
import DatePicker
import Html.Styled as Styled exposing (Html)


type Msg
    = DatePickerMsg DatePicker.Msg


type alias Model =
    ()


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( (), Cmd.none )
        , view = view >> Styled.toUnstyled
        , update = \_ _ -> ( (), Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


view : Model -> Html Msg
view _ =
    Styled.map DatePickerMsg DatePicker.view
