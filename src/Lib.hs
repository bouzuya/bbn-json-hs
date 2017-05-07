{-# LANGUAGE OverloadedStrings #-}
module Lib
    ( runApp
    ) where

import           Control.Exception        (SomeException)
import           Control.Exception.Lifted (handle)
import           Data.Aeson               (encode, object, (.=))
import           Data.Text                (Text)
import qualified Data.Text                as T (append, intercalate, map, unpack)
import           Network.HTTP.Types       (status200, status400)
import           Network.Wai              (Application, Request, Response
                                          , pathInfo, responseLBS)
import           Network.Wai.Handler.Warp (run)

data Route =
    List |
    Detail Text

route :: Request -> Maybe Route
route request =
    case pathInfo request of
        [] -> Just List
        [yyyy, mm, dd, ""] -> Just $ Detail $ id yyyy mm dd
        _ -> Nothing
    where
        id yyyy mm dd = T.intercalate "-" $ [yyyy, mm, dd]

routeToPath :: Route -> Text
routeToPath List = "/posts.json"
routeToPath (Detail id) =
    "/" `T.append`
    (T.map (\c -> if c == '-' then '/' else c) id) `T.append`
    ".json"

runApp :: IO ()
runApp = run 3000 app

app :: Application
app request sendResponse = handle (sendResponse . invalidJson) $ do
    response <- validJson request
    sendResponse response

validJson :: Request -> IO Response
validJson request =
    case route request of
        Just route' -> do
            let path = routeToPath route'
            return $ responseLBS
                status200
                [("Content-Type", "application/json")]
                $ encode $ object [("message" .= T.unpack path)] -- FIXME: json
        Nothing -> fail "Not Found"

invalidJson :: SomeException -> Response
invalidJson _ = responseLBS
    status400
    [("Content-Type", "application/json")]
    $ encode $ object [("message" .= ("Error" :: String))]
