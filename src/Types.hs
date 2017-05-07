{-# LANGUAGE OverloadedStrings #-}
module Types (parseEntryDetail, parseEntryList) where

import           Data.Aeson       (FromJSON (..), Result (..), ToJSON (..),
                                   Value (Array, Object), fromJSON, object,
                                   (.:), (.=))
import           Data.Aeson.Types (emptyArray, emptyObject)
import           Data.Text        (Text)

data Entry = Entry Text Text

instance FromJSON Entry where
    parseJSON (Object v) = Entry <$> (v .: "date")
                                 <*> (v .: "title")
    parseJSON _ = fail "error"

instance ToJSON Entry where
    toJSON (Entry date title) = object [ "date" .= date,
                                         "title" .= title ]

data EntryDetail = EntryDetail Text Text Text

instance FromJSON EntryDetail where
    parseJSON (Object v) = EntryDetail <$> (v .: "date")
                                       <*> (v .: "title")
                                       <*> (v .: "html")
    parseJSON _ = fail "error"

instance ToJSON EntryDetail where
    toJSON (EntryDetail date title html) = object [ "date" .= date,
                                                    "title" .= title,
                                                    "html" .= html ]

parseEntryDetail :: Value -> Value
parseEntryDetail v@(Object _) =
    case (fromJSON v :: Result EntryDetail) of
        Error _   -> emptyObject
        Success o -> toJSON o
parseEntryDetail _ = emptyObject

parseEntryList :: Value -> Value
parseEntryList v@(Array _) =
    case (fromJSON v :: Result [Entry]) of
        Error _   -> emptyArray
        Success a -> toJSON a
parseEntryList _ = emptyArray
