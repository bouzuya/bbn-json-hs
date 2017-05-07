{-# LANGUAGE OverloadedStrings #-}
module Lib
    ( runApp
    ) where

import           Client                   (sendRequest)
import           Control.Exception        (SomeException)
import           Control.Exception.Lifted (handle)
import           Data.Aeson               (Value, encode, object, (.=))
import           Data.Text                (Text)
import qualified Data.Text                as T (append, intercalate, map,
                                                unpack)
import           Network.HTTP.Types       (status200, status400)
import           Network.Wai              (Application, Request, Response,
                                           pathInfo, responseLBS)
import           Network.Wai.Handler.Warp (run)
import           Types                    (parseEntryDetail, parseEntryList)

data Route =
    List |
    Detail Text

route :: Request -> Maybe Route
route request =
    case pathInfo request of
        []                 -> Just List
        [yyyy, mm, dd, ""] -> Just $ Detail $ entryId yyyy mm dd
        _                  -> Nothing
    where
        entryId yyyy mm dd = T.intercalate "-" $ [yyyy, mm, dd]

routeToPath :: Route -> Text
routeToPath List = "/posts.json"
routeToPath (Detail entryId) =
    "/" `T.append`
    (T.map (\c -> if c == '-' then '/' else c) entryId) `T.append`
    ".json"

parseByRoute :: Route -> Value -> Value
parseByRoute List v       = parseEntryList v
parseByRoute (Detail _) v = parseEntryDetail v

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
            value <- sendRequest $ T.unpack path
            return $ responseLBS
                status200
                [("Content-Type", "application/json")]
                $ encode $ parseByRoute route' value
        Nothing -> fail "Not Found"

invalidJson :: SomeException -> Response
invalidJson _ = responseLBS
    status400
    [("Content-Type", "application/json")]
    $ encode $ object [("message" .= ("Error" :: String))]
