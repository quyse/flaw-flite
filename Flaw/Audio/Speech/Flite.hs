{-|
Module: Flaw.Audio.Speech.Flite
Description: Text-to-speech with Flite.
License: MIT
-}

module Flaw.Audio.Speech.Flite
	( fliteInit
	, FliteVoice
	, fliteInitVoice
	, fliteSpeak
	) where

import Control.Monad
import qualified Data.ByteString as B
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import Foreign.C.String
import Foreign.C.Types
import Foreign.Ptr

fliteInit :: IO ()
fliteInit = flite_init

newtype FliteVoice = FliteVoice (Ptr Cst_Voice)

fliteInitVoice :: IO FliteVoice
fliteInitVoice = liftM FliteVoice $ register_cmu_us_slt nullPtr

fliteSpeak :: FliteVoice -> T.Text -> IO ()
fliteSpeak (FliteVoice voicePtr) text = B.useAsCString (T.encodeUtf8 text) $ \textPtr -> do
	_ <- withCAString "play" $ flite_text_to_speech textPtr voicePtr
	return ()

data Cst_Voice

foreign import ccall safe flite_init :: IO ()
foreign import ccall safe register_cmu_us_slt :: Ptr CChar -> IO (Ptr Cst_Voice)
foreign import ccall safe flite_voice_select :: Ptr CChar -> IO (Ptr Cst_Voice)
foreign import ccall safe flite_text_to_speech :: Ptr CChar -> Ptr Cst_Voice -> Ptr CChar -> IO CFloat
