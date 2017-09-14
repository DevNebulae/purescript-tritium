module Tritium.Types
	( ElementName(..)
	, HTMLElement(..)
	, Namespace(..)
	, VDOM(..)
	) where

import Data.Foldable (foldl)
import Data.Maybe (Maybe(Nothing, Just), maybe)
import Data.Newtype (class Newtype, unwrap)
import Data.Tuple (Tuple(Tuple))
import Prelude (class Eq, class Functor, class Ord, class Show, show, (<>), (==))

-- | Defines the name of an HTML-based element or any other
-- | XML-based layout.
newtype ElementName = ElementName String

derive newtype instance eqElementName :: Eq ElementName
derive instance newtypeElementName :: Newtype ElementName _
derive newtype instance ordElementName :: Ord ElementName
instance showElementName :: Show ElementName where
	show = unwrap

-- | The specification for an HTML element is built with a
-- | namespace, the name of the element and its properties.
-- | See the following example of how it should be rendered
-- | in a static context:
-- |
-- | ```html
-- | <namespace:element-name properties></namespace:element-name>
-- | ```
-- |
-- | If the element is a self-closing element and it is not
-- | rendered as XHTML, it can be rendered as follows:
-- |
-- | ```html
-- | <namespace:element-name properties>
-- | ```
-- | If the element is rendered as XHTML, make sure it is
-- | rendered as a regular element or close it with a slash
-- | as follows:
-- |
-- | ```html
-- | <namespace:element-name properties/>
-- | ```
data HTMLElement a = HTMLElement (Maybe Namespace) ElementName a

instance eqHTMLElement :: Eq (HTMLElement a) where
	eq a b = case a, b of
		HTMLElement ns1 name1 _, HTMLElement ns2 name2 _ | name1 == name2 ->
			case ns1, ns2 of
				Just (Namespace ns1'), Just (Namespace ns2') | ns1' == ns2' -> true
				Nothing, Nothing -> true
				_, _ -> false

		_, _ -> false
instance functorHTMLElement :: Functor HTMLElement where
	map f (HTMLElement namespace name properties) = HTMLElement namespace name (f properties)
derive instance ordHTMLElement :: Ord a => Ord (HTMLElement a)
instance showHTMLElement :: Show a => Show (HTMLElement a) where
	show (HTMLElement namespace elementName props) = "(HTMLElement " <> maybe "" show namespace <> " " <> show elementName <> " " <> show props <> ")"

-- | Defines the namespace of both an HTML element as well
-- | as the namespace of a property of an HTML element.
newtype Namespace = Namespace String

derive newtype instance eqNamespace :: Eq Namespace
derive instance newtypeNamespace :: Newtype Namespace _
derive newtype instance ordNamespace :: Ord Namespace
instance showNamespace :: Show Namespace where
	show = unwrap

-- | The virtual DOM is composed of three native types in
-- | the DOM:
-- | * Node: a simple node which is defined by an HTML
-- | element which contains its attributes and properties
-- | and its children;
-- | * Comment: a comment node which is rendered inside the
-- | node, but it will not get rendered in the DOM. The
-- | main purpose of this node is debugging or tracking of
-- | your algorithms;
-- | * Text: text which is rendered inside the node;
-- |
-- | Next, there is a `KeyedNode` constructor, which allows
-- | to add a `String` key to each of its children. This
-- | will help speed up the diffing process.
data VDOM a
	= Node (HTMLElement a) (Array (VDOM a))
	| KeyedNode (HTMLElement a) (Array (Tuple String (VDOM a)))
	| Comment String
	| Text String

instance showVDOM :: Show a => Show (VDOM a) where
	show (Node htmlElement children) = "(Node " <> show htmlElement <> " " <> show children <> ")"
	show (KeyedNode htmlElement keyedChildren) = show "(KeyedNode" <> show htmlElement <> format keyedChildren <> ")"
		where
			format :: Array (Tuple String (VDOM a)) -> String
			format = foldl (\s (Tuple k ch) -> s <> " " <> k <> show ch) ""
	show (Comment text) = "(Comment " <> text <> ")"
	show (Text text) = "(Text " <> text <> ")"
