{-| B9 is a library and build tool with primitive operations to run a
    build script inside a virtual machine and to create and convert
    virtual machine image files as well as related ISO and VFAT disk images
    for e.g. cloud-init configuration sources.

    This module re-exports the modules needed to build a tool around the
    library, e.g. see @src\/cli\/Main.hs@ as an example.

    "B9.ArtifactGenerator" is the module containing the basic data structure
    used to describe a B9 build.

-}

module B9
       ( module B9.Builder
       , module System.Exit
       , module System.FilePath
       , module Control.Applicative
       , module Control.Monad
       , module Control.Monad.IO.Class
       , module Data.Monoid
       , module Data.List
       , module Data.Maybe
       , module Text.Printf
       , module Text.Show.Pretty
       , module Data.Version
       , configure
       , b9_version
       ) where

import Control.Applicative
import Control.Monad
import Control.Monad.IO.Class
import Data.Monoid
import Data.List
import Data.Maybe
import Text.Show.Pretty (ppShow)
import System.Exit ( exitWith
                   , ExitCode (..) )
import System.FilePath ( takeDirectory
                       , takeFileName
                       , replaceExtension
                       , (</>)
                       , (<.>) )
import Text.Printf ( printf )
import Paths_b9 (version)
import Data.Version

import B9.Builder
import qualified B9.LibVirtLXC as LibVirtLXC

-- | Merge 'existingConfig' with the configuration from the main b9 config
-- file. If the file does not exists, a new config file with the given
-- configuration will be written. The return value is a parser for the config
-- file. Returning the raw config file parser allows modules unkown to
-- 'B9.B9Config' to add their own values to the shared config file.
configure :: MonadIO m => Maybe SystemPath -> B9Config -> m ConfigParser
configure b9ConfigPath existingConfig = do
  writeInitialB9Config b9ConfigPath existingConfig LibVirtLXC.setDefaultConfig
  readB9Config b9ConfigPath

-- | Return the cabal package version of the B9 library.
b9_version :: Version
b9_version = version
