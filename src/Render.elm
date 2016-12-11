module Render exposing (drawCanvas)

import Html
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (..)
import Model exposing (..)


drawCanvas : Model -> Html.Html Msg
drawCanvas  model =
    svg [ width "100%", height "100%"] (
      (List.map drawColumn model.columns)
      ++ [drawTest]
    )

drawColumn : Column -> Svg Msg
drawColumn column =
  g [ transform ("translate(" ++ toString (column.index * 300) ++ ", 10)")]
  (drawCards column)

drawCards : Column -> List (Svg Msg)
drawCards column =
  let
    drawInfo = List.scanl drawCard (0, Nothing) column.cards
  in
    (List.filterMap (\(a, b) -> b) drawInfo)
    ++ [drawAddCardButton column.index (List.maximum (List.map (\(a, b) -> a) drawInfo))]

drawCard : Card -> (Int, Maybe (Svg msg)) -> (Int, Maybe (Svg msg))
drawCard card (starty, svg) =
  let
    calculatedHeight = 30 + 20 * (Basics.max (List.length card.inputs) (List.length card.outputs))
  in
  (starty + calculatedHeight + 10, Just (
    g [ transform ("translate(20," ++ toString (starty) ++ ")")]
    ([ rect [ fill "#FFF", width "200", height (toString calculatedHeight), rx "5", ry "5" ] []
    , drawTextField (100, 15) "middle" card.name
    ]
    ++ List.indexedMap (drawCardConnector (10, 35) "start") card.inputs
    ++ List.indexedMap (drawCardConnector (190, 35) "end") card.outputs
    )
    )
  )

drawAddCardButton columnIndex maybeStarty =
  let
    starty = case maybeStarty of
      Just s -> s
      Nothing -> 20
  in
    g [ transform ("translate(20," ++ toString (starty) ++ ")"), onClick (AddCard columnIndex)]
    ([ rect [ fill "#FFF", width "200", height "30", rx "5", ry "5" ] []
    , drawTextField (100, 20) "middle" "Add card"
    ])

drawCardConnector : (Int, Int) -> String -> Int -> String -> Svg msg
drawCardConnector (posX, posY) alignment index connector =
  drawTextField (posX, (posY + index * 20)) alignment connector

drawTextField : (Int, Int) -> String -> String -> Svg msg
drawTextField (posX, posY) alignment caption =
  text_ [ x (toString posX), y (toString posY), textAnchor alignment, fontFamily "Courier New"] [text caption]

drawTest =
  polyline [ fill "none", stroke "red", strokeWidth "10", points "220,40 240,40 300,120 320,120" ] []
