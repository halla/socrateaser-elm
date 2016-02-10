module Questions (list, get) where


get : String -> List String
get id =
    let
        qs = (List.head (List.filter (\q -> q.id == id) list))
    in
        case qs of
            Just qs' -> qs'.questions
            Nothing -> []

defaultList =
    { id = "0"
    , title = "Select question set"
    , questions =
        [ "Are you ready to press <enter> to get the next question?"
        , "Have you tried selecting a question set?"
        ]
    }

list = [
    defaultList,
    { id = "1"
    , title = "Planning 1"
    , questions =
    [ "What is our timespan? (Year, month, week, day, other?)"
    , "What are all the things you should do? List all that's on your mind."
    , "What is special about this time period?"
    , "What special things could you do in this period?"
    , "What are you going to do for the first time?"
    , "What recurring tasks could you do differently this time?"
    , "What else is going on at the same time?"
    , "Which of your tasks would be better done later?"
    , "What are your three most important tasks?"
    , "What is the most important task? There is only one."
    , "Which of the things are you actually going to have done?"
    ]},
    { id = "2"
    , title = "Reflection 1"
    , questions = [ "Why?", "Who?"]}]
