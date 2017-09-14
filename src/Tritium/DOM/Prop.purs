module Tritium.DOM.Prop
	( Prop(..)
	, PropValue
	, propFromBoolean
	, propFromInt
	, propFromNumber
	, propFromString
	) where

import DOM.Event.Types (EventType)
import Data.Maybe (Maybe)
import Tritium.Types (Namespace)
import Unsafe.Coerce (unsafeCoerce)

-- | A `Prop` represents three important elements of a DOM
-- | element:
-- | * `Attribute`: an `Attribute` is a regular attribute
-- | which you regular encounter when reading HTML.
-- | For example, the `src` attribute on an `img` tag. The
-- | `Attribute` constructor also allows you to define a
-- | namespace for the attribute. This constructor is only
-- | used for custom attributes or SVG attributes.
-- | * `Property`: a `Property` is defined as a key you can
-- | set on a JavaScript object. For the DOM, this means
-- | that you set a property on an HTML element.
data Prop a
	= Attribute (Maybe Namespace) String String
	| Property String PropValue
	| Handler EventType a

-- | An opaque type to allow more than one type of value to
-- | be used as a property value.
foreign import data PropValue :: Type

propFromBoolean :: Boolean -> PropValue
propFromBoolean = unsafeCoerce

propFromInt :: Int -> PropValue
propFromInt = unsafeCoerce

propFromNumber :: Number -> PropValue
propFromNumber = unsafeCoerce

propFromString :: String -> PropValue
propFromString = unsafeCoerce
