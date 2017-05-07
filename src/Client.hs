{-# LANGUAGE OverloadedStrings #-}
module Client
    ( sendRequest
    ) where

import           Control.Monad.Trans.Resource (runResourceT)
import           Data.Aeson                   (Value)
import           Data.Aeson.Parser            (json)
import           Data.Conduit                 (($$+-))
import           Data.Conduit.Attoparsec      (sinkParser)
import           Network.HTTP.Client.TLS      (tlsManagerSettings)
import           Network.HTTP.Conduit         (Response (responseBody), http,
                                               newManager, parseRequest)

sendRequest :: String -> IO Value
sendRequest path = do
    request <- parseRequest $ "https://blog.bouzuya.net" ++ path
    manager <- newManager tlsManagerSettings
    body <- runResourceT $ do
        response <- http request manager
        responseBody response $$+- sinkParser json
    return $ body
