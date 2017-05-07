{-# LANGUAGE OverloadedStrings #-}
module Lib
    ( runApp
    ) where

import Control.Exception        (SomeException)
import Control.Exception.Lifted (handle)
import Network.HTTP.Types       (status200, status400)
import Network.Wai              (Application, Request, Response, responseLBS)
import Network.Wai.Handler.Warp (run)

runApp :: IO ()
runApp = run 3000 app

app :: Application
app request sendResponse = handle (sendResponse . invalidJson) $ do
    response <- validJson request
    sendResponse response

validJson :: Request -> IO Response
validJson _ = do
    return $ responseLBS
        status200
        [("Content-Type", "application/json")]
        $ "{\"message\":\"Success\"}"

invalidJson :: SomeException -> Response
invalidJson _ = responseLBS
    status400
    [("Content-Type", "application/json")]
    $ "{\"message\":\"Error\"}"
