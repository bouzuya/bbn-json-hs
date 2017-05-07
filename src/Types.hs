{-# LANGUAGE OverloadedStrings #-}
module Types (parseEntryList) where

import           Data.Aeson       (FromJSON (..), Result (..), ToJSON (..),
                                   Value (Array, Object), fromJSON, object,
                                   (.:), (.=))
import           Data.Aeson.Types (emptyArray)
import           Data.Text        (Text)

data Entry = Entry Text Text

instance FromJSON Entry where
    parseJSON (Object v) = Entry <$> (v .: "date")
                                 <*> (v .: "title")
    parseJSON _ = fail "error"

instance ToJSON Entry where
    toJSON (Entry date title) = object [ "date" .= date,
                                         "title" .= title ]

parseEntryList :: Value -> Value
parseEntryList v@(Array _) =
    case (fromJSON v :: Result [Entry]) of
        Error _   -> emptyArray
        Success a -> toJSON a
parseEntryList _ = emptyArray
