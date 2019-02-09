//
//  Organism.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Organism.h"
#import "Genome.h"
#import "Network.h"

@implementation Organism
@synthesize network, genome, fitness, speciesAdjustedFitness;

-(NSString*) description {
    return [NSString stringWithFormat: @"Organism with fitness: %1.3f", fitness];
}

-(id) initWithGenome: (Genome*) dna
{
    self = [super init];
    if (self) {
        genome = dna;
        fitness = 0;
        speciesAdjustedFitness = 0;
    }
    return self;
}

-(id) initWithCoder:(NSCoder*) coder {
    self = [super init];
    if (self) {
        fitness = [coder decodeDoubleForKey:@"fitness"];
        speciesAdjustedFitness = [coder decodeDoubleForKey:@"speciesAdjustedFitness"];
        genome = [coder decodeObjectOfClass:[Genome class] forKey:@"genome"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder*) coder {
    [coder encodeDouble:fitness forKey:@"fitness"];
    [coder encodeDouble:speciesAdjustedFitness forKey:@"speciesAdjustedFitness"];
    [coder encodeObject:genome forKey:@"genome"];
}

+(BOOL) supportsSecureCoding {
    return YES;
}

-(void) developNetwork {
    NSAssert(genome != nil, @"This organisms genome has not been set - cannot develop network without a genome");
    network = [[Network alloc] initWithGenome:genome];
}

-(NSArray*) predict: (NSArray*) inputValuesArray {
    [network flushNetwork];
    [network updateSensors:inputValuesArray];
    return [network activateNetwork];
}

+(void) saveToHtml: (Organism*) organism directory: (NSString*) directory organismId: (NSString*) organismId {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    
    NSString* newDirectory = [NSString stringWithFormat:@"%@", directory];
    
    if (![fileManager fileExistsAtPath:newDirectory]) {
        [fileManager createDirectoryAtPath:newDirectory withIntermediateDirectories:TRUE attributes:nil error:&error];
        if(error != nil) {
            NSLog(@"%@", [error debugDescription]);
            return;
        }
    }
    
    NSMutableString* str = [[NSMutableString alloc] init];
    [str appendString:@"<html>\n"];
    [str appendString:@"\t<head>\n"];
    [str appendString:@"\t\t<title>Organism</title>\n"];
    [str appendString:@"\t\t<style>\n"];
    [str appendString:@"\t\t\t.invisible { visibility: hidden; }\n"];
    [str appendString:@"\t\t</style>\n"];
    [str appendString:@"\t\t<script src=\"https://code.jquery.com/jquery-3.3.1.min.js\" integrity=\"sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=\" crossorigin=\"anonymous\"></script>\n"];
    [str appendString:@"\t\t<script type=\"text/javascript\">\n"];
    [str appendString:@"\t\t\tfunction click(el) {\n"];
    [str appendString:@"\t\t\t\tid = el.getAttribute(\"id\");\n"];
    
    [str appendString:@"\t\t\t\t$('path[id^=\"line-'+id+'-\"').each(function() {\n"];
    [str appendString:@"\t\t\t\t\t$(this).toggleClass(\"invisible\");\n"];
    [str appendString:@"\t\t\t\t});\n"];
    
    [str appendString:@"\t\t\t\t$('text[id^=\"text-'+id+'-\"').each(function() {\n"];
    [str appendString:@"\t\t\t\t\t$(this).toggleClass(\"invisible\");\n"];
    [str appendString:@"\t\t\t\t});\n"];
    
    [str appendString:@"\t\t\t\t$('path[id$=\"-'+id+'\"').each(function() {\n"];
    [str appendString:@"\t\t\t\t\t$(this).toggleClass(\"invisible\");\n"];
    [str appendString:@"\t\t\t\t});\n"];
    
    [str appendString:@"\t\t\t\t$('text[id$=\"-'+id+'\"').each(function() {\n"];
    [str appendString:@"\t\t\t\t\t$(this).toggleClass(\"invisible\");\n"];
    [str appendString:@"\t\t\t\t});\n"];
    
    [str appendString:@"\t\t\t}\n"];
    [str appendString:@"\t\t</script>\n"];
    [str appendString:@"\t</head>\n"];
    [str appendString:@"\t<body style=\"font-family:'Verdana'\">\n"];
    [str appendString:[NSString stringWithFormat:@"\t\t<div>Fitness: %1.0f</div>\n", organism.fitness]];
    [str appendString:[NSString stringWithFormat:@"\t\t<div>Species Adjusted Fitness: %1.3f</div>\n", organism.speciesAdjustedFitness]];
    
    [str appendString:@"\t<div style=\"width: 100%; height: 650px; overflow-y: scroll;\">\n"];
    [str appendString:[Genome saveGenomeToSvg:organism.genome]];
    [str appendString:@"\t</div>\n"];
    
    [str appendString:@"\t</body>\n"];
    [str appendString:@"</html>\n"];
    
    NSString* html = [NSString stringWithFormat:@"%@/organism-%@.html", newDirectory, organismId];
    [str writeToFile:html atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(void) saveToFile: (Organism*) organism filename: (NSString*) filename {
    NSError* error;
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:organism requiringSecureCoding:YES error:&error];
    
    if(error != nil) {
        NSLog(@"%@", [error debugDescription]);
        return;
    }
    [data writeToFile:filename atomically:YES];
}

+(Organism*) loadFromFile:(NSString*) filename {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filename]) {
        return nil;
    }
    
    NSData* data = [NSData dataWithContentsOfFile:filename];
    NSError* error;
    
    Organism* organism = [NSKeyedUnarchiver unarchivedObjectOfClass:[Organism class] fromData:data error:&error];
    if(error != nil) {
        NSLog(@"%@", [error debugDescription]);
        return nil;
    }
    return organism;
}

-(void) destroyNetwork {
    network = nil;
}

-(Organism*) reproduceChildOrganism {
    Genome* childGenome = [genome copy];
    [childGenome mutateGenome];
    Organism* childOrganism = [[Organism alloc] initWithGenome:childGenome];
    return childOrganism;
}

-(Organism*) reproduceChildOrganismWithOrganism: (Organism*) lessFitMate {
    Genome* childGenome = [genome offspringWithGenome: lessFitMate.genome];
    [childGenome mutateGenome];
    Organism* childOrganism = [[Organism alloc] initWithGenome:childGenome];
    return childOrganism;
}

-(NSComparisonResult) compareFitnessWith: (Organism*) anotherOrganism {
    if (self.fitness < anotherOrganism.fitness) {
        return NSOrderedDescending;
    }
    if (self.fitness == anotherOrganism.fitness) {
        return NSOrderedSame;
    }
    return NSOrderedAscending;
}

-(BOOL) isEqual:(Organism*) organism {
    if(fitness != organism.fitness) {
        return FALSE;
    }
    
    if(speciesAdjustedFitness != organism.speciesAdjustedFitness) {
        return FALSE;
    }
    
    if (![genome isEqual:organism.genome]) {
        return FALSE;
    }
    
    return TRUE;
}

-(Organism*) copyWithZone: (NSZone*) zone {
    Organism* copiedOrganism = [[Organism alloc] init];
    copiedOrganism.genome = [genome copy];
    copiedOrganism.fitness = fitness;
    return copiedOrganism;
}

@end
