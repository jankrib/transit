module Model exposing (..)

import Array exposing (Array)
import Dict exposing (Dict)
import Svg exposing (Svg)

type Msg
  = AddCard Int
  | Decrement


type alias Model =
  { columns : List Column
  , connections : List Connection
  }

type alias Column =
  { index : Int
  , cards : List Card
  }

type alias Card =
  { name : String
  , inputs : List String
  , outputs : List String
  }

type alias DrawPosition =
  { x : Int
  , y : Int
  }

type alias DrawInfo msg =
  { positions : Dict Address DrawPosition
  , svg : Svg msg
  }

type alias Connection =
  { outputId : Address
  , inputId : Address
  }

type alias Address =
  { columnId : Int
  , cardId : Int
  , connectorId : Int
  }
