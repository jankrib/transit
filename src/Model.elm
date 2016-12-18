module Model exposing (..)


type Msg
  = AddCard Int
  | Decrement


type alias Card =
  { name : String
  , inputs : List String
  , outputs : List String
  }

type alias Connection =
  { outputId : Address
  , inputId : Address
  }

type alias Column =
  { index : Int
  , cards : List Card
  }

type alias Model =
  { columns : List Column
  , connections : List Connection
  }

type alias Address =
  { columnId : Int
  , cardId : Int
  , connectorId : Int
  }
