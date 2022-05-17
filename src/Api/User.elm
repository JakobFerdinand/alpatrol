module Api.User exposing (User, UserFull, UserId, toUser)


type alias UserId =
    Int


type alias User =
    { id : Int
    , email : Email
    , username : String
    }


type alias UserFull =
    { id : Int
    , email : Email
    , password : String
    , username : String
    }


toUser : UserFull -> User
toUser user =
    { id = user.id
    , email = user.email
    , username = user.username
    }


type alias Email =
    String
