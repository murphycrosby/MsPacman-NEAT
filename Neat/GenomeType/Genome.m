//
//  Genome.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utilities.h"
#import "Genome.h"
#import "GenomeLink.h"
#import "GenomeNode.h"
#import "InnovationDb.h"
#import "Parameters.h"


@implementation Genome

@synthesize genomeID, genoNodes, genoLinks;

static int genomeCounter = 0;
static bool genesisOccurred = false;

- (id)init
{
    self = [super init];
    if (self) {
        genoNodes = [[NSMutableArray alloc] init];
        genoLinks = [[NSMutableArray alloc] init];
        genomeID = genomeCounter++;
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone*) zone {
    Genome* copyGenome = [[Genome alloc] init];
    copyGenome.genomeID = self.genomeID;
    copyGenome->genoNodes = [[NSMutableArray alloc] initWithArray:self.genoNodes copyItems:YES];
    copyGenome->genoLinks = [[NSMutableArray alloc] initWithArray:self.genoLinks copyItems:YES];
    
    return copyGenome;
}

-(id) initWithCoder:(NSCoder*) coder {
    self = [super init];
    if (self) {
        genomeID = [coder decodeIntForKey:@"genomeID"];
        genomeCounter++;
        
        NSSet *nodeSet = [NSSet setWithArray:@[[NSMutableArray class],
                                           [GenomeNode class]
                                           ]];
        genoNodes = [coder decodeObjectOfClasses:nodeSet forKey:@"genoNodes"];
        
        NSSet *linkSet = [NSSet setWithArray:@[[NSMutableArray class],
                                               [GenomeLink class]
                                               ]];
        genoLinks = [coder decodeObjectOfClasses:linkSet forKey:@"genoLinks"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder*) coder {
    [coder encodeInt:genomeID forKey:@"genomeID"];
    [coder encodeObject:genoNodes forKey:@"genoNodes"];
    [coder encodeObject:genoLinks forKey:@"genoLinks"];
}

+(BOOL) supportsSecureCoding {
    return YES;
}

-(GenomeNode*) getNodeWithID: (int) nodeID {
    for (GenomeNode* nextNode in genoNodes) {
        if (nextNode.nodeID == nodeID) {
            return nextNode;
        }
    }
    return nil;
}

-(GenomeLink*) getLinkFromToNodeID: (int) fNodeID toNodeID: (int) tNodeID {
    for (GenomeLink* nextLink in genoLinks) {
        if (nextLink.fromNode == fNodeID &&
            nextLink.toNode == tNodeID) {
            return nextLink;
        }
    }
    return nil;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"\nGenome %d\nNodes: %@\nGenes: %@",
            genomeID,
            genoNodes,
            genoLinks];
}

+(Genome*) createGenome: (int) nInputs outputs: (int) nOutputs {
    NSAssert (!genesisOccurred, @"Genesis cannot occur more than once! "
              "This would really screw up the innovation database. "
              "Instead create once and duplicate");
    genesisOccurred = true;
    
    Genome* newGenome = [[Genome alloc] init];
    
    for (int i = 0; i < nInputs; i++) {
        GenomeNode* inputNode = [[GenomeNode alloc] init];
        inputNode.nodeID = [InnovationDb getNextGenomeNodeID];
        inputNode.nodeType = INPUT;
        [newGenome.genoNodes addObject: inputNode];
        
        [[InnovationDb sharedDb] insertNewNode:inputNode fromNode:0 toNode:0];
    }
    
    GenomeNode* biasNode = [[GenomeNode alloc] init];
    biasNode.nodeID = [InnovationDb getNextGenomeNodeID];
    biasNode.nodeType = BIAS;
    [newGenome.genoNodes addObject: biasNode];
    [[InnovationDb sharedDb] insertNewNode:biasNode fromNode:0 toNode:0];
    nInputs++;

    for (int i = 0; i < nOutputs; i++) {
        GenomeNode* outputNode = [[GenomeNode alloc] init];
        outputNode.nodeID = [InnovationDb getNextGenomeNodeID];
        outputNode.nodeType = OUTPUT;
        [newGenome.genoNodes addObject: outputNode];
        
        [[InnovationDb sharedDb] insertNewNode:outputNode fromNode:0 toNode:0];
    }
    
    for (int i = 0; i < nInputs; i++) {
        for (int j = 0; j < nOutputs; j++) {
            GenomeNode* fNode = [newGenome.genoNodes objectAtIndex:i];
            GenomeNode* tNode = [newGenome.genoNodes objectAtIndex:nInputs + j];
            
            double d = randomClampedDouble();
            GenomeLink* newGenoLink = [[GenomeLink alloc] initNewlyInnovatedLinkFromNode: fNode.nodeID
                                                                                   toNode: tNode.nodeID
                                                                        withWeight:d];
            
            [newGenome.genoLinks addObject:newGenoLink];
            [[InnovationDb sharedDb] insertNewLink:newGenoLink fromNode:fNode.nodeID toNode:tNode.nodeID];
        }
    }
    
    return newGenome;
}

-(Genome*) randomiseWeights {
    for (GenomeLink* nextLink in genoLinks) {
        nextLink.weight = randomClampedDouble();
    }
    return self;
}

+(void) balanceGenome:(Genome*) genome {
    GenomeNode* fromNode;
    GenomeNode* toNode;
    NSMutableArray* links = [[NSMutableArray alloc] init];
    
    for (GenomeLink* link in genome.genoLinks) {
        fromNode = [genome getNodeWithID:link.fromNode];
        toNode = [genome getNodeWithID:link.toNode];
        if(fromNode.nodeType == INPUT || fromNode.nodeType == BIAS) {
            fromNode.nodeLayer = 0;
            toNode.nodeLayer = 1;
            continue;
        }
        
        [links addObject:link];
    }
    
    int layerCount = 1;
    while (links.count > 0) {
        NSMutableArray* l2 = [[NSMutableArray alloc] init];
        
        for (GenomeLink* link in links) {
            fromNode = [genome getNodeWithID:link.fromNode];
            toNode = [genome getNodeWithID:link.toNode];
            
            if (fromNode.nodeLayer > 0) {
                toNode.nodeLayer = fromNode.nodeLayer + 1;
                if (toNode.nodeLayer + 1 > layerCount) {
                    layerCount = toNode.nodeLayer + 1;
                }
                continue;
            }
            
            [l2 addObject:link];
        }
        
        links = l2;
    }
    
    int x = 50;
    int y = 80;
    int xPlus = 1000 / layerCount;
    int yPlus = 100;
    NSMutableDictionary* layerDict = [[NSMutableDictionary alloc] init];
    
    for(GenomeNode* node in genome.genoNodes) {
        CGPoint point;
        NSValue* v = [layerDict valueForKey:[NSString stringWithFormat:@"%i",node.nodeLayer]];
        if(v == nil) {
            point = CGPointMake((xPlus * node.nodeLayer) + x, y);
        } else {
            point = NSPointToCGPoint(v.pointValue);
            point.y += yPlus;
        }
        [layerDict setObject:[NSValue valueWithPoint:NSPointFromCGPoint(point)] forKey:[NSString stringWithFormat:@"%i", node.nodeLayer]];
        node.nodePosition = point;
    }
}

+(NSString*) saveGenomeToSvg:(Genome*) genome {
    NSMutableString* str = [[NSMutableString alloc] init];
    
    [Genome balanceGenome:genome];
    
    NSString* color = @"";
    [str appendString:@"<svg viewBox=\"0 0 1300 60000\">\n"];
    
    for (int i = 0; i < [genome.genoNodes count]; i++) {
        GenomeNode* gn = [genome.genoNodes objectAtIndex:i];
        
        if(gn.nodeType == INPUT || gn.nodeType == BIAS) {
            color = @"steelblue";
        } else if(gn.nodeType == HIDDEN) {
            color = @"royalblue";
        } else if(gn.nodeType == OUTPUT) {
            color = @"navy";
        }
        
        [str appendString:[NSString stringWithFormat:@"<circle id=\"%d\" onclick=\"click(this)\" cx=\"%1.3f\" cy=\"%1.3f\" r=\"30\" style=\"fill:%@;\"></circle>\n", gn.nodeID, gn.nodePosition.x, gn.nodePosition.y, color]];
        [str appendString:[NSString stringWithFormat:@"<text x=\"%1.3f\" y=\"%1.3f\" style=\"fill:white;font-size:16;\" text-anchor=\"middle\" alignment-baseline=\"middle\">%i</text>\n",gn.nodePosition.x, gn.nodePosition.y, i]];
        [str appendString:[NSString stringWithFormat:@"<text x=\"%1.3f\" y=\"%1.3f\" style=\"fill:%@;font-size:16;\" text-anchor=\"middle\" alignment-baseline=\"hanging\">%@</text>\n",gn.nodePosition.x, gn.nodePosition.y+30, color, [GenomeNode NodeTypeString:gn.nodeType]]];
    }
    
    for (int i = 0; i < [genome.genoLinks count]; i++) {
        GenomeLink* gl = [genome.genoLinks objectAtIndex:i];
        GenomeNode* fromNode = [genome getNodeWithID:gl.fromNode];
        GenomeNode* toNode = [genome getNodeWithID:gl.toNode];
        
        if(gl.isEnabled) {
            color = @"black";
        } else {
            color = @"gray";
        }
        
        [str appendString:[NSString stringWithFormat:@"<path id=\"line-%i-%i\" d=\"M%1.0f,%1.0f L%1.0f,%1.0f\" style=\"stroke:%@;stroke-width:2;\" class=\"invisible\"/>\n", fromNode.nodeID, toNode.nodeID, fromNode.nodePosition.x + 30, fromNode.nodePosition.y, toNode.nodePosition.x - 30, toNode.nodePosition.y, color]];
        
        [str appendString:[NSString stringWithFormat:@"<text id=\"text-%i-%i\" style=\"fill:%@;font-size:16;\" text-anchor=\"middle\" transform=\"translate(0,-3)\" class=\"invisible\"><textPath xlink:href=\"#line-%i-%i\" startOffset=\"50%%\">w: %1.3f</textPath></text>\n", fromNode.nodeID, toNode.nodeID, color, fromNode.nodeID, toNode.nodeID, gl.weight]];
    }
    
    /*
     <path id="line32" d="M80,80 L170,100" style="stroke:black;stroke-width:2" />
     <text style="fill:black;font-size:16;" text-anchor="middle" transform="translate(0,-3)">
     <textPath xlink:href="#line32" startOffset="50%">
     w: -1.13
     </textPath>
     </text>
     <text style="fill:black;font-size:16;" text-anchor="middle" transform="translate(0,15)">
     <textPath xlink:href="#line32" startOffset="50%">
     id: 1321
     </textPath>
     </text>
    */
    [str appendString:@"</svg>\n"];
    
    return [NSString stringWithString:str];
}

-(void) dealloc {
    if (genoNodes != nil) {
        genoNodes = nil;
    }
    if (genoLinks != nil) {
        genoLinks = nil;
    }
}

+(double) gaussrand {
    static int iset=0;
    static double gset;
    double fac,rsq,v1,v2;
    
    if (iset==0) {
        do {
            v1=2.0*(randomDouble())-1.0;
            v2=2.0*(randomDouble())-1.0;
            rsq=v1*v1+v2*v2;
        } while (rsq>=1.0 || rsq==0.0);
        fac=sqrt(-2.0*log(rsq)/rsq);
        gset=v1*fac;
        iset=1;
        return v2*fac;
    }
    else {
        iset=0;
        return gset;
    }
}

-(void) perturbSingleLinkWeight {
    GenomeLink* randomLink = [genoLinks objectAtIndex:arc4random() % genoLinks.count];
    if (randomDouble() < [Parameters mutationProbabilityReplaceWeight]) {
        randomLink.weight = [Genome gaussrand];
    }
    else {
        randomLink.weight += [Genome gaussrand] * [Parameters mutationMaximumPerturbation];
    }
}

-(void) perturbAllLinkWeights {
    for (GenomeLink* nextLink in genoLinks) {
        if (randomDouble() > [Parameters mutationProbabilityUpdateWeight]) {
            continue;
        }
        
        if (randomDouble() < [Parameters mutationProbabilityReplaceWeight]) {
            nextLink.weight = [Genome gaussrand];
        }
        else {
            nextLink.weight += [Genome gaussrand] * [Parameters mutationMaximumPerturbation];
        }
    }
}

-(void) reEnableRandomLink {
    NSMutableArray* disabledLinks = [[NSMutableArray alloc] init];
    for (GenomeLink* nextLink in genoLinks) {
        if (!nextLink.isEnabled) {
            [disabledLinks addObject: nextLink];
        }
    }
    if (disabledLinks.count > 0) {
        GenomeLink* randomLink = [disabledLinks objectAtIndex:arc4random() % disabledLinks.count];
        randomLink.isEnabled = true;
    }
}

-(void) toggleRandomLink {
    GenomeLink* randomLink = [genoLinks objectAtIndex:arc4random() % genoLinks.count];
    if (randomLink.isEnabled) {
        randomLink.isEnabled = false;
    }
    else {
        randomLink.isEnabled = true;
    }
}

-(void) addNode {
    // select link at random
    GenomeLink* randomLink = nil;
    do {
        randomLink = [genoLinks objectAtIndex:arc4random() % [genoLinks count]];
    } while (!randomLink.isEnabled);
    
    GenomeNode* fromNode = [self getNodeWithID:randomLink.fromNode];
    GenomeNode* toNode = [self getNodeWithID:randomLink.toNode];
    
    // find out if a neuron already exists between the from and to nodes
    GenomeNode* existingNode = [[InnovationDb sharedDb] possibleNodeExistsFromNode:randomLink.fromNode toNode:randomLink.toNode];
    
    if (existingNode == nil) {
        // if not, create a new one
        GenomeNode* newNode = [[GenomeNode alloc] init];
        newNode.nodeID = [InnovationDb getNextGenomeNodeID];
        newNode.nodeType = HIDDEN;
        //newNode.nodePosition = CGPointMake(fromNode.nodePosition.x + ((toNode.nodePosition.x - fromNode.nodePosition.x) / 2),
        //                                   fromNode.nodePosition.y + ((toNode.nodePosition.y - fromNode.nodePosition.y) / 2));
        [genoNodes addObject: newNode];
        // we can be sure this is a new node so add to innovation database
        [[InnovationDb sharedDb] insertNewNode:newNode fromNode:fromNode.nodeID toNode:toNode.nodeID];
        
        // now create two new links
        GenomeLink* newPrecursorLink = [[GenomeLink alloc] initNewlyInnovatedLinkFromNode: fromNode.nodeID
                                                                                   toNode: newNode.nodeID
                                                                               withWeight:1.0];
        [genoLinks addObject:newPrecursorLink];
        // we can be sure this is a new link so add to innovation database
        [[InnovationDb sharedDb] insertNewLink:newPrecursorLink fromNode:fromNode.nodeID toNode:newNode.nodeID];
        
        GenomeLink* newSuccessorLink = [[GenomeLink alloc] initNewlyInnovatedLinkFromNode: newNode.nodeID
                                                                                   toNode: toNode.nodeID
                                                                               withWeight: randomLink.weight];
        [genoLinks addObject:newSuccessorLink];
        // we can be sure this is a new link so add to innovation database
        [[InnovationDb sharedDb] insertNewLink:newSuccessorLink fromNode:newNode.nodeID toNode:toNode.nodeID];
        
        // and finally deactivate the old link
        randomLink.isEnabled = false;
    }
    else {
        // in some cases this already exists - make sure it doesn't
        if ([self getNodeWithID:existingNode.nodeID] == nil) {
            
            [genoNodes addObject:existingNode];
            
            GenomeLink* precursorLink = [[InnovationDb sharedDb] possibleLinkExistsFromNode:fromNode.nodeID toNode:existingNode.nodeID];
            NSAssert(precursorLink != nil, @"Have picked up an existing node from innovations DB without an existing link");
            precursorLink.weight = 1.0;
            [genoLinks addObject:precursorLink];
            
            GenomeLink* successorLink = [[InnovationDb sharedDb] possibleLinkExistsFromNode:existingNode.nodeID toNode:toNode.nodeID];
            NSAssert(successorLink != nil, @"Have picked up an existing node from innovations DB without an existing link");
            successorLink.weight = randomLink.weight;
            [genoLinks addObject:successorLink];
            
            randomLink.isEnabled = false;
        }
    }
}

-(void) addLink {
    // select 2 nodes at random
    GenomeNode* randomFromNode = [genoNodes objectAtIndex:arc4random() % [genoNodes count]];
    GenomeNode* randomToNode = [genoNodes objectAtIndex:arc4random() % [genoNodes count]];
    
    // make sure the link is valid
    
    // cannot link to itself
    if (randomFromNode == randomToNode) {
        return;
    }
    // cannot link to an input or bias
    if (randomToNode.nodeType == INPUT || randomToNode.nodeType == BIAS) {
        return;
    }
    // do not link if already linked
    if ([self getLinkFromToNodeID:randomFromNode.nodeID toNodeID:randomToNode.nodeID] != nil) {
        return;
    }
    // do not link if links backwards in the network
    //if (randomFromNode.nodePosition.y > randomToNode.nodePosition.y) {
    //    return;
    //}
    // cannot create a link where there is a reverse link existing
    if ([self getLinkFromToNodeID:randomToNode.nodeID toNodeID:randomFromNode.nodeID] != nil) {
        return;
    }
    
    // all clear - we can link these nodes
    
    // check to see if the link already exists in the innovation DB
    GenomeLink* existingLink = [[InnovationDb sharedDb]
                                 possibleLinkExistsFromNode:randomFromNode.nodeID
                                 toNode:randomToNode.nodeID];
    if (existingLink == nil) {
        //create a new link
        GenomeLink* newGenoLink = [[GenomeLink alloc] initNewlyInnovatedLinkFromNode: randomFromNode.nodeID
                                                                               toNode: randomToNode.nodeID
                                                                           withWeight:randomClampedDouble()];
        [genoLinks addObject:newGenoLink];
 
        // we can be sure this is a new link so add to innovation database
        [[InnovationDb sharedDb] insertNewLink:newGenoLink fromNode:randomFromNode.nodeID toNode:randomToNode.nodeID];
    }
    else {
        [genoLinks addObject:existingLink];
    }
}

-(Genome*) mutateGenome {
    if (genoNodes.count < [Parameters maximumNeurons] &&
        randomDouble() < [Parameters chanceAddNode]) {
        NSLog(@"Genome :: mutateGenome :: addNode");
        int count = arc4random_uniform(5);
        while(count == 0) {
            count = arc4random_uniform(5);
        }
        NSLog(@"Genome :: mutateGenome :: addNode :: %d", count);
        for(int i = 0; i < count; i++) {
            [self addNode];
        }
    } else if (randomDouble() < [Parameters chanceAddLink]) {
        NSLog(@"Genome :: mutateGenome :: addLink");
        [self addLink];
    } else if (randomDouble() < [Parameters chanceMutateWeight]) {
        NSLog(@"Genome :: mutateGenome :: perturbAllLinkWeights :: %lu", (unsigned long)[self.genoLinks count]);
        [self perturbAllLinkWeights];
    } else if (randomDouble() < [Parameters chanceToggleLinks]) {
        NSLog(@"Genome :: mutateGenome :: toggleRandomLink");
        [self toggleRandomLink];
    } else if (randomDouble() < [Parameters changeReenableLinks]) {
        NSLog(@"Genome :: mutateGenome :: reEnableRandomLink");
        [self reEnableRandomLink];
    }
    return self;
}

-(Genome*) offspringWithGenome: (Genome*) mumGenome {
    Genome* childGenome = [[Genome alloc] init];
    
    [genoLinks sortUsingSelector:@selector(compareIDWith:)];
    [mumGenome.genoLinks sortUsingSelector:@selector(compareIDWith:)];
    
    int dadIndex = 0;
    int mumIndex = 0;
    
    bool dadHasLinksLeft = true;
    bool mumHasLinksLeft = true;
    
    GenomeLink* dadNextLink = [genoLinks objectAtIndex:dadIndex];
    GenomeLink* mumNextLink = [mumGenome.genoLinks objectAtIndex:mumIndex];
    
    while (dadHasLinksLeft && mumHasLinksLeft) {
        if (dadNextLink.linkID == mumNextLink.linkID) {
            // shared gene, choose one at random
            if (randomDouble() < 0.5) {
                GenomeLink* dadLink = [dadNextLink copy];
                [childGenome.genoLinks addObject:dadLink];
            }
            else {
                GenomeLink* mumLink = [mumNextLink copy];
                [childGenome.genoLinks addObject:mumLink];
            }
            dadIndex++;
            if (dadIndex == genoLinks.count) {
                dadHasLinksLeft = false;
            }
            else {
                dadNextLink = [genoLinks objectAtIndex:dadIndex];
            }
            mumIndex++;
            if (mumIndex == mumGenome.genoLinks.count) {
                mumHasLinksLeft = false;
            }
            else {
                mumNextLink = [mumGenome.genoLinks objectAtIndex:mumIndex];
            }
        }
        // disjoint gene
        else if (dadNextLink.linkID < mumNextLink.linkID) {
            GenomeLink* dadLink = [dadNextLink copy];
            for(GenomeLink* gn in childGenome.genoLinks) {
                if (gn.linkID == dadLink.linkID) {
                    NSLog(@"Genome :: offspringWithGenome :: dadNextLink.linkID < mumNextLink.linkID :: Already Added");
                }
            }
            [childGenome.genoLinks addObject:dadLink];
            dadIndex++;
            if (dadIndex == genoLinks.count) {
                dadHasLinksLeft = false;
            }
            else {
                dadNextLink = [genoLinks objectAtIndex:dadIndex];
            }
        }
        // disjoint gene
        else if (mumNextLink.linkID < dadNextLink.linkID) {
            // don't do anything - we ignore the less fit link
            GenomeLink* mumLink = [mumNextLink copy];
            for(GenomeLink* gn in childGenome.genoLinks) {
                if (gn.linkID == mumLink.linkID) {
                    NSLog(@"Genome :: offspringWithGenome :: mumNextLink.linkID < dadNextLink.linkID :: Already Added");
                }
            }
            [childGenome.genoLinks addObject:mumLink];  // should do this but it seems to get good results
            mumIndex++;
            if (mumIndex == mumGenome.genoLinks.count) {
                mumHasLinksLeft = false;
            }
            else {
                mumNextLink = [mumGenome.genoLinks objectAtIndex:mumIndex];
            }
        }
    }
    
    while (dadHasLinksLeft) {
        GenomeLink* dadLink = [dadNextLink copy];
        for(GenomeLink* gn in childGenome.genoLinks) {
            if (gn.linkID == dadLink.linkID) {
                NSLog(@"Genome :: offspringWithGenome :: dadHasLinksLeft :: Already Added");
            }
        }
        [childGenome.genoLinks addObject:dadLink];
        dadIndex++;
        if (dadIndex == genoLinks.count) {
            dadHasLinksLeft = false;
        }
        else {
            dadNextLink = [genoLinks objectAtIndex:dadIndex];
        }
    }
 
    for (GenomeLink* nextLink in childGenome.genoLinks) {
        if ([childGenome getNodeWithID: nextLink.fromNode] == nil) {
            GenomeNode* nodeToAdd = [[InnovationDb sharedDb] getNodeWithID:nextLink.fromNode];
            NSAssert(nodeToAdd != nil, @"Error - have created a link with a node that does not exist in the Innovation DB");
            [childGenome.genoNodes addObject: nodeToAdd];
        }
        if ([childGenome getNodeWithID: nextLink.toNode] == nil) {
            GenomeNode* nodeToAdd = [[InnovationDb sharedDb] getNodeWithID:nextLink.toNode];
            NSAssert(nodeToAdd != nil, @"Error - have created a link with a node that does not exist in the Innovation DB");
            [childGenome.genoNodes addObject: nodeToAdd];
        }
    }
    [childGenome.genoLinks sortUsingSelector:@selector(compareIDWith:)];
    
    [childGenome verifyGenome];
    
    return childGenome;
}

-(double) similarityScoreWithGenome: (Genome*) otherGenome {
    int disjointLinks = 0;
    int excessLinks = 0;
    int matchingLinks = 0;
    double weightDifference = 0.0;
    
    int myIndex = 0;
    int otherIndex = 0;
    
    bool iHaveLinksLeft = true;
    bool otherHasLinksLeft = true;
    
    GenomeLink* myNextLink = [genoLinks objectAtIndex:myIndex];
    GenomeLink* otherNextLink = [otherGenome.genoLinks objectAtIndex:otherIndex];
    
    while (iHaveLinksLeft && otherHasLinksLeft) {
        if (myNextLink.linkID == otherNextLink.linkID) {
            matchingLinks++;
            
            if(myNextLink.isEnabled && !otherNextLink.isEnabled) {
                weightDifference += fabs(myNextLink.weight);
            } else if (!myNextLink.isEnabled && otherNextLink.isEnabled) {
                weightDifference += fabs(otherNextLink.weight);
            } else {
                weightDifference += fabs(myNextLink.weight - otherNextLink.weight);
            }
            
            myIndex++;
            if (myIndex >= genoLinks.count) {
                iHaveLinksLeft = false;
            }
            else {
                myNextLink = [genoLinks objectAtIndex:myIndex];
            }
            
            otherIndex++;
            if (otherIndex >= otherGenome.genoLinks.count) {
                otherHasLinksLeft = false;
            }
            else {
                otherNextLink = [otherGenome.genoLinks objectAtIndex:otherIndex];
            }
        }
        else if (myNextLink.linkID < otherNextLink.linkID) {
            disjointLinks++;
            myIndex++;
            if (myIndex >= genoLinks.count) {
                iHaveLinksLeft = false;
            }
            else {
                myNextLink = [genoLinks objectAtIndex:myIndex];
            }
        }
        else if (otherNextLink.linkID < myNextLink.linkID) {
            disjointLinks++;
            otherIndex++;
            if (otherIndex >= otherGenome.genoLinks.count) {
                otherHasLinksLeft = false;
            }
            else {
                otherNextLink = [otherGenome.genoLinks objectAtIndex:otherIndex];
            }
        }
    }
    if (iHaveLinksLeft) {
        //excessLinks++;
        excessLinks = (int)[genoLinks count] - (int)[otherGenome.genoLinks count];
        myIndex++;
        if (myIndex >= genoLinks.count) {
            iHaveLinksLeft = false;
        }
    }
    if (otherHasLinksLeft) {
        //excessLinks++;
        excessLinks = (int)[otherGenome.genoLinks count] - (int)[genoLinks count];
        otherIndex++;
        if (otherIndex >= otherGenome.genoLinks.count) {
            otherHasLinksLeft = false;
        }
    }
    
    double longest = MAX([genoLinks count], [otherGenome.genoLinks count]);
    
    double excessScore = ([Parameters c1ExcessCoefficient] * excessLinks) / longest;
    double disjointScore = ([Parameters c2DisjointCoefficient] * disjointLinks) / longest;
    double weightScore = ([Parameters c3weightCoefficient] * weightDifference) / matchingLinks;
    
    double score = excessScore + disjointScore + weightScore;
    return score;
}

-(void) verifyGenome {
    NSMutableArray* checkedInnovations = [[NSMutableArray alloc] init];
    
    for (GenomeLink* nextLink in genoLinks) {
        bool foundMatch = false;
        for (GenomeLink* nextCheckedLink in checkedInnovations) {
            if (nextLink.linkID == nextCheckedLink.linkID) {
                foundMatch = true;
                NSAssert(false, @"Error - the same link has been added twice");
            }
        }
        if (!foundMatch) {
            [checkedInnovations addObject:nextLink];
        }
    }
}

-(BOOL) isEqual:(Genome*) genome {
    if(genomeID != genome.genomeID) {
        return FALSE;
    }
    
    BOOL nodeSame = FALSE;
    for(GenomeNode* gn1 in genoNodes) {
        nodeSame = FALSE;
        for(GenomeNode* gn2 in genome.genoNodes) {
            if ([gn1 isEqual:gn2]) {
                nodeSame = TRUE;
                break;
            }
        }
        if(!nodeSame) {
            return FALSE;
        }
    }
    
    for(GenomeNode* gn1 in genome.genoNodes) {
        nodeSame = FALSE;
        for(GenomeNode* gn2 in genoNodes) {
            if ([gn1 isEqual:gn2]) {
                nodeSame = TRUE;
                break;
            }
        }
        if(!nodeSame) {
            return FALSE;
        }
    }
    
    for(GenomeLink* gl1 in genoLinks) {
        nodeSame = FALSE;
        for(GenomeLink* gl2 in genome.genoLinks) {
            if ([gl1 isEqual:gl2]) {
                nodeSame = TRUE;
                break;
            }
        }
        if(!nodeSame) {
            return FALSE;
        }
    }
    
    for(GenomeLink* gl1 in genome.genoLinks) {
        nodeSame = FALSE;
        for(GenomeLink* gl2 in genoLinks) {
            if ([gl1 isEqual:gl2]) {
                nodeSame = TRUE;
                break;
            }
        }
        if(!nodeSame) {
            return FALSE;
        }
    }
    
    return TRUE;
}

@end
