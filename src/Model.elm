module Model exposing (..)


type Msg
  = AddCard Int
  | Decrement


type alias Card =
  { name : String
  , inputs : List String
  , outputs : List String
  }


type alias Column =
  { index : Int
  , cards : List Card
  }

type alias Model =
  { columns : List Column
  }
