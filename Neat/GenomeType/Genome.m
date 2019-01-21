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
//#import "Network.h"
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

-(GenomeNode*) getNodeWithID: (int) nodeID {
    for (GenomeNode* nextNode in genoNodes) {
        if (nextNode.nodeID == nodeID) {
            return nextNode;
        }
    }
    return nil;
}

-(GenomeLink*) getLinkFromNodeID: (int) fNodeID toNodeID: (int) tNodeID {
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
    
    double positionXOffset = 0.8/(double)nInputs;
    
    for (int i = 0; i < nInputs; i++) {
        GenomeNode* inputNode = [[GenomeNode alloc] init];
        inputNode.nodeID = [InnovationDb getNextGenomeNodeID];
        inputNode.nodeType = INPUT;
        inputNode.nodePosition = CGPointMake(0.1+i*positionXOffset, 0.1);
        [newGenome.genoNodes addObject: inputNode];
        
        [[InnovationDb sharedDb] insertNewNode:inputNode fromNode:0 toNode:0];
    }
    
    GenomeNode* biasNode = [[GenomeNode alloc] init];
    biasNode.nodeID = [InnovationDb getNextGenomeNodeID];
    biasNode.nodeType = BIAS;
    biasNode.nodePosition = CGPointMake(0.9, 0.1);
    [newGenome.genoNodes addObject: biasNode];
    nInputs++;
    
    positionXOffset = 1/(double)(nOutputs+1);
    
    for (int i = 0; i < nOutputs; i++) {
        GenomeNode* outputNode = [[GenomeNode alloc] init];
        outputNode.nodeID = [InnovationDb getNextGenomeNodeID];
        outputNode.nodeType = OUTPUT;
        outputNode.nodePosition = CGPointMake((i+1)*positionXOffset, 0.9);
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

-(void) saveGenome: (NSString*) filename {
    for (int i = 0; i < [genoNodes count]; i++) {
        GenomeNode* gn = [genoNodes objectAtIndex:i];
        NSString* nodeType;
        switch (gn.nodeType) {
            case 0:
                nodeType = @"UNKNOWN";
                break;
            case 1:
                nodeType = @"INPUT";
                break;
            case 2:
                nodeType = @"HIDDEN";
                break;
            case 3:
                nodeType = @"OUTPUT";
                break;
            case 4:
                nodeType = @"BIAS";
                break;
            default:
                nodeType = @"UNKNOWN";
                break;
        }
        NSLog(@"Id: %d - %@", gn.nodeID, nodeType);
        for(int l = 0; l < [genoLinks count]; l++) {
            GenomeLink* gl = [genoLinks objectAtIndex:l];
            if(gl.fromNode == gn.nodeID) {
                NSLog(@"LinkId: %d (%@)- %d --[%1.3f]--> %d ", gl.linkID, (gl.isEnabled ? @"ON" : @"OFF"), gl.fromNode, gl.weight, gl.toNode);
            }
        }
    }
}

-(void) dealloc {
    if (genoNodes != nil) {
        genoNodes = nil;
    }
    if (genoLinks != nil) {
        genoLinks = nil;
    }
}

double gaussrand() {
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
    GenomeLink* randomLink = [genoLinks objectAtIndex:rand() % genoLinks.count];
    if (randomDouble() < [Parameters mutationProbabilityReplaceWeight]) {
        randomLink.weight = gaussrand();
    }
    else {
        randomLink.weight += gaussrand() * [Parameters mutationMaximumPerturbation];
    }
}

-(void) perturbAllLinkWeights {
    for (GenomeLink* nextLink in genoLinks) {
        if (randomDouble() < [Parameters mutationProbabilityReplaceWeight]) {
            nextLink.weight = gaussrand();
        }
        else {
            nextLink.weight += gaussrand() * [Parameters mutationMaximumPerturbation];
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
        GenomeLink* randomLink = [disabledLinks objectAtIndex:rand() % disabledLinks.count];
        randomLink.isEnabled = true;
    }
}

-(void) toggleRandomLink {
    GenomeLink* randomLink = [genoLinks objectAtIndex:rand() % genoLinks.count];
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
        randomLink = [genoLinks objectAtIndex:rand() % [genoLinks count]];
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
        newNode.nodePosition = CGPointMake(fromNode.nodePosition.x + ((toNode.nodePosition.x - fromNode.nodePosition.x) / 2),
                                           fromNode.nodePosition.y + ((toNode.nodePosition.y - fromNode.nodePosition.y) / 2));
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
    GenomeNode* randomFromNode = [genoNodes objectAtIndex:rand() % [genoNodes count]];
    GenomeNode* randomToNode = [genoNodes objectAtIndex:rand() % [genoNodes count]];
    
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
    if ([self getLinkFromNodeID:randomFromNode.nodeID toNodeID:randomToNode.nodeID] != nil) {
        return;
    }
    // do not link if links backwards in the network
    if (randomFromNode.nodePosition.y > randomToNode.nodePosition.y) {
        return;
    }
    // cannot create a link where there is a reverse link existing
    if ([self getLinkFromNodeID:randomToNode.nodeID toNodeID:randomFromNode.nodeID] != nil) {
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
        [self addNode];
    } else if (randomDouble() < [Parameters chanceAddLink]) {
        [self addLink];
    } else if (randomDouble() < [Parameters chanceMutateWeight]) {
        [self perturbAllLinkWeights];
    } else if (randomDouble() < [Parameters chanceToggleLinks]) {
        [self toggleRandomLink];
    } else if (randomDouble() < [Parameters changeReenableLinks]) {
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
            weightDifference += fabs(myNextLink.weight - otherNextLink.weight);
            
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
        excessLinks++;
        myIndex++;
        if (myIndex >= genoLinks.count) {
            iHaveLinksLeft = false;
        }
    }
    if (otherHasLinksLeft) {
        excessLinks++;
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

@end
