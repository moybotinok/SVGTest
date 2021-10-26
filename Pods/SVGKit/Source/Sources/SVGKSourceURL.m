#import "SVGKSourceURL.h"
#import "SVGKDefine_Private.h"

@implementation SVGKSourceURL

-(NSString *)keyForAppleDictionaries
{
	return [self.URL absoluteString];
}
+ (void)printTimeWithStartTime: (NSDate *) startDate string: (NSString *)string {
    NSTimeInterval tsp = [[NSDate date] timeIntervalSinceDate:startDate];
    NSString *str = [NSString stringWithFormat: @"lib_SVGKit %.3fs %@", tsp, string];
    NSLog(str);
}
+ (SVGKSource*)sourceFromURL:(NSURL*)u {
//    NSDate *d = [NSDate date];
    NSInputStream* stream = [self internalCreateInputStreamFromURL:u];
    if (!stream) {
        return nil;
    }
    
    SVGKSourceURL* s = [[SVGKSourceURL alloc] initWithInputSteam:stream];
    s.URL = u;
//    [self printTimeWithStartTime:d string: @" sourceFromURL"];
	
	return s;
}

+(nullable NSInputStream*) internalCreateInputStreamFromURL:(nullable NSURL*) u
{
    if (!u) {
        return nil;
    }
	NSInputStream* stream = [NSInputStream inputStreamWithURL:u];
	
	if( stream == nil )
	{
		/* Thanks, Apple, for not implementing your own method.
		 c.f. http://stackoverflow.com/questions/20571069/i-cannot-initialize-a-nsinputstream
		 
		 NB: current Apple docs don't seem to mention this - certainly not in the inputStreamWithURL: method? */
		NSError* errorWithNSData;
        NSDate *d = [NSDate date];
        NSData *tempData = [NSData dataWithContentsOfURL:u options:0 error:&errorWithNSData];
        [self printTimeWithStartTime:d string: @"dataWithContentsOfURL"];
		
		if( tempData == nil )
		{
            SVGKitLogError(@"Error internally in Apple's NSData trying to read from URL '%@'. Error = %@", u, errorWithNSData);
		}
		else
			stream = [[NSInputStream alloc] initWithData:tempData];
	}
	//DO NOT DO THIS: let the parser do it at last possible moment (Apple has threading problems otherwise!) [stream open];
	
	return stream;
}

-(id)copyWithZone:(NSZone *)zone
{
	id copy = [super copyWithZone:zone];
	
	if( copy )
	{	
		/** clone bits */
		[copy setURL:[self.URL copy]];
		
		/** Finally, manually intialize the input stream, as required by super class */
		[copy setStream:[[self class] internalCreateInputStreamFromURL:((SVGKSourceURL*)copy).URL]];
	}
	
	return copy;
}

- (SVGKSource *)sourceFromRelativePath:(NSString *)path {
	NSURL *url = [NSURL URLWithString:path relativeToURL:self.URL];
	return [SVGKSourceURL sourceFromURL:url];
}

-(NSString *)description
{
	return [NSString stringWithFormat:@"[SVGKSource: URL = \"%@\"]", self.URL ];
}


@end
