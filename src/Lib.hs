{-# LANGUAGE OverloadedStrings #-}
module Lib
    ( runApp
    ) where

import           Control.Exception        (SomeException)
import           Control.Exception.Lifted (handle)
import           Data.Text                (Text)
import qualified Data.Text                as T (intercalate)
import qualified Data.Text.Lazy           as T (fromStrict)
import qualified Data.Text.Lazy.Encoding  as T (encodeUtf8)
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
routeToPath List = "/"
routeToPath (Detail id) = id

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
                $ T.encodeUtf8 $ T.fromStrict path -- FIXME: to json
        Nothing -> fail "Not Found"

invalidJson :: SomeException -> Response
invalidJson _ = responseLBS
    status400
    [("Content-Type", "application/json")]
    $ "{\"message\":\"Error\"}"
