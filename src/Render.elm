module Render exposing (drawCanvas)

import Html
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (..)
import Model exposing (..)
import Array
import Dict

drawCanvas : Model -> Html.Html Msg
drawCanvas  model =
    svg [ width "100%", height "100%"] (
      (List.map drawColumn model.columns)
      ++ (List.map (drawConnection model.columns) model.connections)
    )

drawColumn : Column -> Svg Msg
drawColumn column =
  let
    drawInfo =
      List.scanl drawCard (0, Nothing) column.cards

    cardResult =
      (List.filterMap (\(a, b) -> b) drawInfo)
      ++ [drawAddCardButton column.index (List.maximum (List.map (\(a, b) -> a) drawInfo))]
  in
    g [ transform ("translate(" ++ toString (column.index * 300) ++ ", 10)")]
    cardResult

drawCard : Card -> (Int, Maybe (Svg msg)) -> (Int, Maybe (Svg msg))
drawCard card (starty, svg) =
  let
    calculatedHeight =
      calculateCardHeight card
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

calculateCardHeight card =
  30 + 20 * (Basics.max (List.length card.inputs) (List.length card.outputs))

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

drawConnection : List Column -> Connection -> Svg Msg
drawConnection columns connection =
  let
    output =
      positionOutputAddress columns connection.outputId

    input =
      positionInputAddress columns connection.inputId
  in
    polyline [ fill "none", stroke "red", strokeWidth "10", points ((positionsToPoints output input)) ] [] --"200,40 240,40 300,120 320,120"

positionOutputAddress : List Column -> Address -> (Int, Int)
positionOutputAddress columns address =
  (address.columnId * 300 + 220, positionTopAddress columns address)

positionInputAddress : List Column -> Address -> (Int, Int)
positionInputAddress columns address =
  (address.columnId * 300 + 20, positionTopAddress columns address)

positionTopAddress : List Column -> Address -> Int
positionTopAddress columns address =
  let
    columnArray =
      Array.fromList columns

    column =
      Array.get address.columnId columnArray

    cards =
      case column of
        Just c -> c.cards
        Nothing -> []

    cardsIndexed =
      List.indexedMap (,) cards

    cardHeights =
      List.filterMap (someFunction address.cardId) cardsIndexed

    starty =
      List.sum cardHeights
  in
    5 + starty + address.connectorId * 20 + 35

someFunction : Int -> (Int, Card) -> Maybe Int
someFunction index (i, card) =
  if i < index then
    Just ((calculateCardHeight card) + 10)
  else
    Nothing

positionsToPoints : (Int, Int) -> (Int, Int) -> String
positionsToPoints (sx, sy) (ex, ey) =
  let
    opoints =
      [ (sx, sy)
      , (sx + 30, sy)
      , (ex - 30, ey)
      , (ex, ey)]
  in
    String.join " " (List.map (\(x, y) -> String.join "," [ toString x, toString y ]) opoints)
