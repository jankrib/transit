module Render exposing (drawCanvas)

import Html
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Model exposing (..)

drawCanvas : Model -> Html.Html msg
drawCanvas  model =
    svg [ width "100%", height "100%"] (List.map drawColumn model.columns)

drawColumn : Column -> Svg msg
drawColumn column =
  g [ transform ("translate(" ++ toString (column.index * 300) ++ ", 10)")]
  (drawCards column.cards)

drawCards : List Card -> List (Svg msg)
drawCards cards =
  let
    drawInfo = List.scanl drawCard (0, Nothing) cards
  in
    List.filterMap (\(a, b) -> b) drawInfo

drawCard : Card -> (Int, Maybe (Svg msg)) -> (Int, Maybe (Svg msg))
drawCard card (starty, svg) =
  let
    calculatedHeight = 20 + 20 * (Basics.max (List.length card.inputs) (List.length card.outputs))
  in
  (starty + calculatedHeight + 10, Just (
    g [ transform ("translate(20," ++ toString (starty) ++ ")")]
    [ rect [ fill "#FFF", width "200", height (toString calculatedHeight), rx "5", ry "5" ] []
    , text_ [ x "100", y "15", Svg.Attributes.style "text-anchor:middle"] [text "hello2"]
    ]
    )
  )
