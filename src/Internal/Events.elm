module Internal.Events exposing
    ( isDownArrow
    , isEnter
    , isEscape
    , isSpace
    , isTab
    , isTabWithShift
    , isUpArrow
    , onInputAt
    , onInputAtInt
    )

import Html.Styled exposing (Attribute)
import Html.Styled.Events exposing (keyCode, on, stopPropagationOn)
import Json.Decode as Decode


type Key
    = Escape
    | UpArrow
    | DownArrow
    | Enter
    | Backspace
    | Space
    | Shift
    | Tab
    | Other


decoder : Int -> Key
decoder =
    keyCodeToKey


backspace : Int
backspace =
    8


tab : Int
tab =
    9


enter : Int
enter =
    13


escape : Int
escape =
    27


upArrow : Int
upArrow =
    38


downArrow : Int
downArrow =
    40


space : Int
space =
    32


shift : Int
shift =
    16


stringAt : List String -> Decode.Decoder String
stringAt path =
    Decode.at path Decode.string


intAt : List String -> Decode.Decoder Int
intAt path =
    Decode.at path Decode.int


mapAt : List String -> (String -> msg) -> Decode.Decoder msg
mapAt path msg =
    Decode.map msg (stringAt path)


mapAtInt : List String -> (Int -> msg) -> Decode.Decoder msg
mapAtInt path msg =
    Decode.map msg (intAt path)


mapAtIntFromString : List String -> (Maybe Int -> msg) -> Decode.Decoder msg
mapAtIntFromString path msg =
    Decode.andThen
        (\val ->
            if String.isEmpty val then
                Decode.succeed (msg Nothing)

            else
                case String.toInt val of
                    Just f ->
                        Decode.succeed (msg (Just f))

                    _ ->
                        Decode.fail "Must be string"
        )
        (stringAt path)


keyCodeToKey : Int -> Key
keyCodeToKey keyCode =
    if keyCode == escape then
        Escape

    else if keyCode == backspace then
        Backspace

    else if keyCode == upArrow then
        UpArrow

    else if keyCode == downArrow then
        DownArrow

    else if keyCode == enter then
        Enter

    else if keyCode == space then
        Space

    else if keyCode == shift then
        Shift

    else if keyCode == tab then
        Tab

    else
        Other


onInputAt : List String -> (String -> msg) -> Attribute msg
onInputAt path msg =
    on "input" <| mapAt path msg


onInputAtInt : List String -> (Maybe Int -> msg) -> Attribute msg
onInputAtInt path msg =
    stopPropagationOn "input" <|
        Decode.map (\m -> ( m, True ))
            (mapAtIntFromString
                path
                msg
            )


isCode : Key -> msg -> Int -> Decode.Decoder msg
isCode key msg code =
    if decoder code == key then
        Decode.succeed msg

    else
        Decode.fail "not the right key"


isEnter : msg -> Decode.Decoder msg
isEnter msg =
    keyCode |> Decode.andThen (isCode Enter msg)


isSpace : msg -> Decode.Decoder msg
isSpace msg =
    keyCode |> Decode.andThen (isCode Space msg)


isEscape : msg -> Decode.Decoder msg
isEscape msg =
    keyCode |> Decode.andThen (isCode Escape msg)


isTabWithShift : (Bool -> msg) -> Decode.Decoder msg
isTabWithShift msg =
    Decode.field "shiftKey" Decode.bool
        |> Decode.map2
            (\_ isShift ->
                msg isShift
            )
            (keyCode |> Decode.andThen (isCode Tab (msg True)))


isTab : msg -> Decode.Decoder msg
isTab msg =
    keyCode |> Decode.andThen (isCode Tab msg)


isDownArrow : msg -> Decode.Decoder msg
isDownArrow msg =
    keyCode |> Decode.andThen (isCode DownArrow msg)


isUpArrow : msg -> Decode.Decoder msg
isUpArrow msg =
    keyCode |> Decode.andThen (isCode UpArrow msg)
