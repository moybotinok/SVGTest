/*
 From SVG-DOM, via Core-DOM:
 
 http://www.w3.org/TR/DOM-Level-2-Core/core.html#ID-1780488922
 
 interface NamedSVGKNodeMap {
 SVGKNode               getNamedItem(in DOMString name);
 SVGKNode               setNamedItem(in SVGKNode arg)
 raises(DOMException);
 SVGKNode               removeNamedItem(in DOMString name)
 raises(DOMException);
 SVGKNode               item(in unsigned long index);
 readonly attribute unsigned long    length;
 // Introduced in DOM Level 2:
 SVGKNode               getNamedItemNS(in DOMString namespaceURI,
 in DOMString localName);
 // Introduced in DOM Level 2:
 SVGKNode               setNamedItemNS(in SVGKNode arg)
 raises(DOMException);
 // Introduced in DOM Level 2:
 SVGKNode               removeNamedItemNS(in DOMString namespaceURI,
 in DOMString localName)
 raises(DOMException);
 };

 */

#import <Foundation/Foundation.h>

@class SVGKNode;
#import "Node.h"

@interface NamedNodeMap : NSObject </** needed so we can output SVG text in the [SVGKNode appendToXML:..] methods */ NSCopying>

-(SVGKNode*) getNamedItem:(NSString*) name;
-(SVGKNode*) setNamedItem:(SVGKNode*) arg;
-(SVGKNode*) removeNamedItem:(NSString*) name;
-(SVGKNode*) item:(unsigned long) index;

@property(readonly) unsigned long length;

// Introduced in DOM Level 2:
-(SVGKNode*) getNamedItemNS:(NSString*) namespaceURI localName:(NSString*) localName;

// Introduced in DOM Level 2:
-(SVGKNode*) setNamedItemNS:(SVGKNode*) arg;

// Introduced in DOM Level 2:
-(SVGKNode*) removeNamedItemNS:(NSString*) namespaceURI localName:(NSString*) localName;

#pragma mark - MISSING METHOD FROM SVG Spec, without which you cannot parse documents (don't understand how they intended you to fulfil the spec without this method)

-(SVGKNode*) setNamedItemNS:(SVGKNode*) arg inNodeNamespace:(NSString*) nodesNamespace;

@end
