/* 
 Boxer is copyright 2009 Alun Bestor and contributors.
 Boxer is released under the GNU General Public License 2.0. A full copy of this license can be
 found in this XCode project at Resources/English.lproj/GNU General Public License.txt, or read
 online at [http://www.gnu.org/licenses/gpl-2.0.txt].
 */


#import "BXGeometry.h"

NSInteger fitToPowerOfTwo(NSInteger value)
{
    int log = 0;
    while ((value >>= 1) != 0) log++;
    return 2 << log;
}

CGFloat aspectRatioOfSize(NSSize size)
{
	return (size.height) ? (size.width / size.height) : 0;
}

BOOL sizeFitsWithinSize(NSSize innerSize, NSSize outerSize)
{
	return (innerSize.width <= outerSize.width) && (innerSize.height <= outerSize.height);
}

NSSize sizeToFitSize(NSSize innerSize, NSSize outerSize)
{
	NSSize finalSize = outerSize;
	CGFloat ratioW = outerSize.width / innerSize.width;
	CGFloat ratioH = outerSize.height / innerSize.height;
	
	if (ratioW < ratioH)	finalSize.height	= (innerSize.height * ratioW);
	else					finalSize.width		= (innerSize.width * ratioH);
	return finalSize;
}

NSSize constrainToFitSize(NSSize innerSize, NSSize outerSize)
{
	if (sizeFitsWithinSize(innerSize, outerSize)) return innerSize;
	else return sizeToFitSize(innerSize, outerSize);
}

NSRect resizeRectFromPoint(NSRect theRect, NSSize newSize, NSPoint anchor)
{	
	CGFloat widthDiff	= newSize.width		- theRect.size.width;
	CGFloat heightDiff	= newSize.height	- theRect.size.height;
	
	NSRect newRect		= theRect;
	newRect.size		= newSize;
	newRect.origin.x	-= ceil(widthDiff	* anchor.x);
	newRect.origin.y	-= ceil(heightDiff	* anchor.y);
	
	return newRect;
}

NSPoint pointRelativeToRect(NSPoint thePoint, NSRect theRect)
{
	NSPoint anchorPoint;
	anchorPoint.x = (theRect.size.width > 0)	? ((thePoint.x - theRect.origin.x) / theRect.size.width)	: 0;
	anchorPoint.y = (theRect.size.height > 0)	? ((thePoint.y - theRect.origin.y) / theRect.size.height)	: 0;
	return anchorPoint;
}

NSRect alignInRectWithAnchor(NSRect innerRect, NSRect outerRect, NSPoint anchor)
{
	NSRect alignedRect = innerRect;
	alignedRect.origin.x = anchor.x * (NSMaxX(outerRect) - innerRect.size.width);
	alignedRect.origin.y = anchor.y * (NSMaxY(outerRect) - innerRect.size.height);
	return alignedRect;	
}

NSRect centerInRect(NSRect innerRect, NSRect outerRect)
{
	return alignInRectWithAnchor(innerRect, outerRect, NSMakePoint(0.5, 0.5));
}

NSRect fitInRect(NSRect innerRect, NSRect outerRect, NSPoint anchor)
{
	NSRect fittedRect;
	fittedRect.size = sizeToFitSize(innerRect.size, outerRect.size);
	return alignInRectWithAnchor(fittedRect, outerRect, anchor);
}

NSRect constrainToRect(NSRect innerRect, NSRect outerRect, NSPoint anchor)
{
	NSRect fittedRect;
	if (NSContainsRect(outerRect, innerRect))
		return alignInRectWithAnchor(fittedRect, outerRect, anchor);
	else return fitInRect(innerRect, outerRect, anchor);
}

NSPoint clampPointToRect(NSPoint point, NSRect rect)
{
	NSPoint clampedPoint;
	clampedPoint.x = MAX(MIN(point.x, NSMaxX(rect)), NSMinX(rect));
	clampedPoint.y = MAX(MIN(point.y, NSMaxY(rect)), NSMinY(rect));
	return clampedPoint;
}

NSPoint deltaFromPointToPoint(NSPoint pointA, NSPoint pointB)
{
	return NSMakePoint(pointB.x - pointA.x,
					   pointB.y - pointA.y);
}

NSPoint pointWithDelta(NSPoint point, NSPoint delta)
{
	return NSMakePoint(point.x + delta.x,
					   point.y + delta.y);
}
NSPoint pointWithoutDelta(NSPoint point, NSPoint delta)
{
	return NSMakePoint(point.x - delta.x,
					   point.y - delta.y);
}


#pragma mark -
#pragma mark CG functions

BOOL BXCGSizeFitsWithinSize(CGSize innerSize, CGSize outerSize)
{
	return (innerSize.width <= outerSize.width) && (innerSize.height <= outerSize.height);	
}

CGSize BXCGSizeToFitSize(CGSize innerSize, CGSize outerSize)
{
	CGSize finalSize = outerSize;
	CGFloat ratioW = outerSize.width / innerSize.width;
	CGFloat ratioH = outerSize.height / innerSize.height;
	
	if (ratioW < ratioH)	finalSize.height	= (innerSize.height * ratioW);
	else					finalSize.width		= (innerSize.width * ratioH);
	return finalSize;
}

CGSize BXCGSmallerSize(CGSize size1, CGSize size2)
{
	return BXCGSizeFitsWithinSize(size1, size2) ? size1 : size2;
}

CGSize BXCGLargerSize(CGSize size1, CGSize size2)
{
	return BXCGSizeFitsWithinSize(size1, size2) ? size2 : size1;
}

